package dao;

import entities.User;
import entities.Activite;
import javax.persistence.*;
import java.util.*;
import java.util.stream.Collectors;

public class UserDAO implements IUserDAO {

    private static final EntityManagerFactory emf = Persistence.createEntityManagerFactory("benevolactPU");
    private String lastError;

    @Override
    public boolean create(User user) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = null;
        try {
            tx = em.getTransaction();
            tx.begin();
            em.persist(user);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            lastError = "Erreur création utilisateur: " + e.getMessage();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public User findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(User.class, id);
        } catch (Exception e) {
            lastError = "Erreur recherche utilisateur: " + e.getMessage();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public List<User> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u ORDER BY u.nom", User.class)
                   .getResultList();
        } catch (Exception e) {
            lastError = "Erreur recherche utilisateurs: " + e.getMessage();
            return Collections.emptyList();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean update(User user) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = null;
        try {
            tx = em.getTransaction();
            tx.begin();
            em.merge(user);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            lastError = "Erreur mise à jour utilisateur: " + e.getMessage();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean delete(Long id) {
        EntityManager em = emf.createEntityManager();
        EntityTransaction tx = null;
        try {
            tx = em.getTransaction();
            tx.begin();
            
            User user = em.find(User.class, id);
            if (user != null) {
                // Retirer l'utilisateur de toutes ses activités
                for (Activite activite : user.getActivites()) {
                    activite.getParticipants().remove(user);
                    em.merge(activite);
                }
                em.remove(user);
            }
            
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            lastError = "Erreur suppression utilisateur: " + e.getMessage();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public User findByEmail(String email) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE LOWER(u.email) = LOWER(:email)", User.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            lastError = "Erreur recherche par email: " + e.getMessage();
            return null;
        } finally {
            em.close();
        }
    }
    
    @Override
    public User findByNom(String nom) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.createQuery("SELECT u FROM User u WHERE LOWER(u.nom) = LOWER(:nom)", User.class)
                    .setParameter("nom", nom)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        } catch (Exception e) {
            lastError = "Erreur recherche par nom: " + e.getMessage();
            return null;
        } finally {
            em.close();
        }
    }

    @Override
    public Set<Activite> getUserParticipations(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            User user = em.find(User.class, userId);
            if (user != null) {
                // Force le chargement de la collection
                user.getActivites().size(); 
                return user.getActivites();
            }
            return Collections.emptySet();
        } catch (Exception e) {
            lastError = "Erreur récupération participations: " + e.getMessage();
            return Collections.emptySet();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean isUserParticipating(Long userId, Long activiteId) {
        EntityManager em = emf.createEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(a) FROM Activite a JOIN a.participants u " +
                "WHERE u.id = :userId AND a.id = :activiteId", 
                Long.class)
                .setParameter("userId", userId)
                .setParameter("activiteId", activiteId)
                .getSingleResult();
            return count > 0;
        } catch (Exception e) {
            lastError = "Erreur vérification participation: " + e.getMessage();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public boolean isUserInWaitingList(Long userId, Long activiteId) {
        EntityManager em = emf.createEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(a) FROM Activite a JOIN a.listeAttente u " +
                "WHERE u.id = :userId AND a.id = :activiteId", 
                Long.class)
                .setParameter("userId", userId)
                .setParameter("activiteId", activiteId)
                .getSingleResult();
            return count > 0;
        } catch (Exception e) {
            lastError = "Erreur vérification liste d'attente: " + e.getMessage();
            return false;
        } finally {
            em.close();
        }
    }

    @Override
    public int getParticipationCount(Long userId) {
        EntityManager em = emf.createEntityManager();
        try {
            Long count = em.createQuery(
                "SELECT COUNT(a) FROM Activite a JOIN a.participants u " +
                "WHERE u.id = :userId", 
                Long.class)
                .setParameter("userId", userId)
                .getSingleResult();
            return count.intValue();
        } catch (Exception e) {
            lastError = "Erreur comptage participations: " + e.getMessage();
            return 0;
        } finally {
            em.close();
        }
    }

    @Override
    public String getLastError() {
        return lastError;
    }

    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}