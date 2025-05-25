package dao;

import java.util.List;
import entities.Activite;
import entities.Categorie;

public interface IGestionActivite {

    // ✅ Créer une nouvelle activité
    void ajouterActivite(Activite activite);

    // ✅ Récupérer une activité par son ID
    Activite getActiviteById(Long id);

    // ✅ Mettre à jour une activité
    boolean updateActivite(Activite activite);

    // ✅ Supprimer une activité par son ID
    void deleteActivite(Long id);
    List<Activite> getAllActivites();
    List<Activite> rechercherActivites(String keyword);
    List<Activite> getActivitesByCategorie(Long categorieId);
   
    List<Activite> getActivitesByUser(Long userId);
    
 
    void dissocierActivitesDeCategorie(Categorie categorie);

	List<Activite> getActivitesByParticipant(Long userId);

	List<Activite> getActivitesEnAttente(Long userId);

	boolean leaveWaitingList(Long userId, Long activiteId);

	String getLastError();

	boolean addParticipation(Long userId, Long activiteId);

	List<UserDAO> getUserParticipations(Long userId);

	boolean cancelParticipation(Long userId, Long activiteId);

	boolean joinWaitingList(Long userId, Long activiteId);

}
