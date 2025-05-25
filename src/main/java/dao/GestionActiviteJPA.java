package dao;

import entities.Activite;
import entities.Categorie;
import entities.User;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;

public class GestionActiviteJPA implements IGestionActivite {

    private EntityManager em;
    private String lastError;

    public GestionActiviteJPA() {
        em = Persistence.createEntityManagerFactory("benevolactPU").createEntityManager();
    }
    
    public GestionActiviteJPA(EntityManager em) {
        this.em = em;
    }

    @Override
    public void ajouterActivite(Activite activite) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(activite);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            lastError = "Erreur ajout activité: " + e.getMessage();
            throw new RuntimeException("Erreur lors de l'ajout de l'activité", e);
        }
    }

    @Override
    public Activite getActiviteById(Long id) {
        try {
            return em.find(Activite.class, id);
        } catch (Exception e) {
            lastError = "Erreur recherche activité: " + e.getMessage();
            return null;
        }
    }

    @Override
    public boolean updateActivite(Activite activite) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            // Récupérer l'instance managée existante
            Activite existingActivite = em.find(Activite.class, activite.getId());
            if (existingActivite != null) {
                // Mettre à jour les propriétés
                existingActivite.setTitre(activite.getTitre());
                existingActivite.setDescription(activite.getDescription());
                existingActivite.setLieu(activite.getLieu());
                existingActivite.setDateActivite(activite.getDateActivite());
                existingActivite.setDateCloture(activite.getDateCloture());
                existingActivite.setCapacite(activite.getCapacite());
                existingActivite.setUrgent(activite.isUrgent());
                existingActivite.setCategorie(activite.getCategorie());
                if (activite.getImageUrl() != null) {
                    existingActivite.setImageUrl(activite.getImageUrl());
                }
            }
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            lastError = "Erreur mise à jour activité: " + e.getMessage();
            return false;
        }
    }

    @Override
    public void deleteActivite(Long id) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Activite activite = em.find(Activite.class, id);
            if (activite != null) {
                // Nettoyer les références avant suppression
                activite.getParticipants().clear();
                activite.getListeAttente().clear();
                em.merge(activite);
                em.remove(activite);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            lastError = "Erreur suppression activité: " + e.getMessage();
            throw new RuntimeException("Erreur lors de la suppression de l'activité", e);
        }
    }

    @Override
    public List<Activite> getAllActivites() {
        try {
            TypedQuery<Activite> query = em.createQuery(
                "SELECT a FROM Activite a ORDER BY a.dateActivite DESC", Activite.class);
            return query.getResultList();
        } catch (Exception e) {
            lastError = "Erreur récupération activités: " + e.getMessage();
            return new ArrayList<>();
        }
    }

    @Override
    public List<Activite> rechercherActivites(String keyword) {
        try {
            TypedQuery<Activite> query = em.createQuery(
                "SELECT a FROM Activite a WHERE LOWER(a.titre) LIKE LOWER(:kw) OR LOWER(a.description) LIKE LOWER(:kw)", 
                Activite.class);
            query.setParameter("kw", "%" + keyword + "%");
            return query.getResultList();
        } catch (Exception e) {
            lastError = "Erreur recherche activités: " + e.getMessage();
            return new ArrayList<>();
        }
    }

    @Override
    public List<Activite> getActivitesByCategorie(Long categorieId) {
        try {
            TypedQuery<Activite> query = em.createQuery(
                "SELECT a FROM Activite a WHERE a.categorie.id = :catId ORDER BY a.dateActivite DESC", 
                Activite.class);
            query.setParameter("catId", categorieId);
            return query.getResultList();
        } catch (Exception e) {
            lastError = "Erreur activités par catégorie: " + e.getMessage();
            return new ArrayList<>();
        }
    }

    @Override
    public List<Activite> getActivitesByUser(Long userId) {
        try {
            TypedQuery<Activite> query = em.createQuery(
                "SELECT a FROM Activite a WHERE a.organisateur.id = :userId ORDER BY a.dateActivite DESC", 
                Activite.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            lastError = "Erreur activités organisateur: " + e.getMessage();
            return new ArrayList<>();
        }
    }

    @Override
    public void dissocierActivitesDeCategorie(Categorie categorie) {
        try {
            
            Categorie c = em.createQuery(
                "SELECT c FROM Categorie c LEFT JOIN FETCH c.activites WHERE c.id = :id", 
                Categorie.class)
                .setParameter("id", categorie.getId())
                .getSingleResult();

            if (c != null) {
                List<Activite> activites = new ArrayList<>(c.getActivites());

                for (Activite activite : activites) {
                    activite.setCategorie(null);
                    em.merge(activite);
                }

                c.getActivites().clear();
                em.merge(c);
            }

        } catch (Exception e) {
            throw new RuntimeException("Erreur lors de la dissociation des activités", e);
        }
    }


    @Override
    public List<Activite> getActivitesByParticipant(Long userId) {
        try {
            TypedQuery<Activite> query = em.createQuery(
                "SELECT DISTINCT a FROM Activite a JOIN a.participants p WHERE p.id = :userId ORDER BY a.dateActivite DESC", 
                Activite.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            lastError = "Erreur activités participant: " + e.getMessage();
            return new ArrayList<>();
        }
    }

    @Override
    public List<Activite> getActivitesEnAttente(Long userId) {
        try {
            TypedQuery<Activite> query = em.createQuery(
                "SELECT DISTINCT a FROM Activite a JOIN a.listeAttente l WHERE l.id = :userId ORDER BY a.dateActivite DESC", 
                Activite.class);
            query.setParameter("userId", userId);
            return query.getResultList();
        } catch (Exception e) {
            lastError = "Erreur activités en attente: " + e.getMessage();
            return new ArrayList<>();
        }
    }

    @Override
    public boolean leaveWaitingList(Long userId, Long activiteId) {
        EntityTransaction tx = em.getTransaction();
        try {
            Activite activite = em.find(Activite.class, activiteId);
            User user = em.find(User.class, userId);
            
            if (activite == null || user == null) {
                lastError = "Activité ou utilisateur non trouvé";
                return false;
            }
            
            tx.begin();
            activite.getListeAttente().remove(user);
            em.merge(activite);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            lastError = "Erreur retrait liste attente: " + e.getMessage();
            return false;
        }
    }

    @Override
    public String getLastError() {
        return lastError;
    }

    @Override
    public boolean addParticipation(Long userId, Long activiteId) {
        EntityTransaction tx = em.getTransaction();
        try {
            Activite activite = em.find(Activite.class, activiteId);
            User user = em.find(User.class, userId);
            
            if (activite == null || user == null) {
                lastError = "Activité ou utilisateur non trouvé";
                return false;
            }
            
            tx.begin();
            activite.getParticipants().add(user);
            em.merge(activite);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            lastError = "Erreur ajout participation: " + e.getMessage();
            return false;
        }
    }

    @Override
    public List<UserDAO> getUserParticipations(Long userId) {
        // Note: UserDAO n'est pas défini dans votre code, vous devrez peut-être créer cette classe
        // ou utiliser directement l'entité User
        try {
            TypedQuery<User> query = em.createQuery(
                "SELECT u FROM User u WHERE u.id = :userId", User.class);
            query.setParameter("userId", userId);
            List<User> users = query.getResultList();
            
            // Convertir les User en UserDAO si nécessaire
            List<UserDAO> result = new ArrayList<>();
            for (User user : users) {
                // Ici vous devrez créer une instance de UserDAO à partir de User
                // result.add(new UserDAO(user));
            }
            return result;
        } catch (Exception e) {
            lastError = "Erreur récupération participations: " + e.getMessage();
            return new ArrayList<>();
        }
    }

    @Override
    public boolean cancelParticipation(Long userId, Long activiteId) {
        EntityTransaction tx = em.getTransaction();
        try {
            Activite activite = em.find(Activite.class, activiteId);
            User user = em.find(User.class, userId);
            
            if (activite == null || user == null) {
                lastError = "Activité ou utilisateur non trouvé";
                return false;
            }
            
            tx.begin();
            activite.getParticipants().remove(user);
            em.merge(activite);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            lastError = "Erreur annulation participation: " + e.getMessage();
            return false;
        }
    }

    @Override
    public boolean joinWaitingList(Long userId, Long activiteId) {
        EntityTransaction tx = em.getTransaction();
        try {
            Activite activite = em.find(Activite.class, activiteId);
            User user = em.find(User.class, userId);
            
            if (activite == null || user == null) {
                lastError = "Activité ou utilisateur non trouvé";
                return false;
            }
            
            tx.begin();
            activite.getListeAttente().add(user);
            em.merge(activite);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            lastError = "Erreur ajout liste attente: " + e.getMessage();
            return false;
        }
    }
}