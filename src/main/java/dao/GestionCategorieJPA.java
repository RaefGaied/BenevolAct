package dao;

import entities.Categorie;
import javax.persistence.EntityManager;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;
import javax.persistence.TypedQuery;
import java.util.List;

public class GestionCategorieJPA implements IGestionCategorie {
    private EntityManager em;

    public GestionCategorieJPA() {
        em = Persistence.createEntityManagerFactory("benevolactPU").createEntityManager();
    }
    

    @Override
    public void ajouterCategorie(Categorie categorie) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(categorie);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        }
    }

    @Override
    public void modifierCategorie(Categorie categorie) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(categorie);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        }
    }
    @Override
    public void supprimerCategorie(Long id) {
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Categorie categorie = em.find(Categorie.class, id);
            if (categorie == null) {
                throw new IllegalArgumentException("Catégorie introuvable avec l'ID: " + id);
            }

            // Utilisation du même EntityManager
            GestionActiviteJPA activiteDao = new GestionActiviteJPA(em);
            activiteDao.dissocierActivitesDeCategorie(categorie);

            // Recharger et supprimer
            categorie = em.merge(categorie);
            em.remove(categorie);

            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace(); 
            throw new RuntimeException("Échec de la suppression de la catégorie ID: " + id, e);
        }

    }

    @Override
    public Categorie trouverCategorieParId(Long id) {
        return em.find(Categorie.class, id);
    }
    @Override
    public List<Categorie> listerToutesLesCategories() {
        // Version optimisée avec fetch join et count
        TypedQuery<Categorie> query = em.createQuery(
            "SELECT c FROM Categorie c LEFT JOIN FETCH c.activites", 
            Categorie.class
        );
        return query.getResultList();
    }
    
    @Override
    public boolean isEntityManagerOpen() {
        return em != null && em.isOpen();
    }
}