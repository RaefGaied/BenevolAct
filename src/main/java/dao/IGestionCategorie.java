package dao;

import java.util.List;
import entities.Categorie;

public interface IGestionCategorie {

    // Ajouter une catégorie
    void ajouterCategorie(Categorie categorie);

    // Modifier une catégorie existante
    void modifierCategorie(Categorie categorie);

    // Supprimer une catégorie par son ID
    void supprimerCategorie(Long id);

    // Trouver une catégorie par son ID
    Categorie trouverCategorieParId(Long id);

    // Lister toutes les catégories
    List<Categorie> listerToutesLesCategories();

	boolean isEntityManagerOpen();
}
