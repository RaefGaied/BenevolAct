package entities;

import javax.persistence.*;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "activites")
public class Activite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String titre;
    private String description;
    private String lieu;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_activite")
    private Date dateActivite;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "date_cloture")
    private Date dateCloture;

    private String imageUrl;
    
    @Column(nullable = false)
    private Long capacite;
    
    @Column(name = "is_urgent", columnDefinition = "boolean default false")
    private boolean urgent = false;
    
    @Transient
    private boolean dejaInscrit;
    
    @Transient
    private boolean enListeAttente;
    
    @ManyToOne(cascade = {CascadeType.MERGE})
    @JoinColumn(name = "organisateur_id", nullable = true) 
    private User organisateur;


    @ManyToMany
    @JoinTable(
        name = "user_activite",
        joinColumns = @JoinColumn(name = "activite_id"),
        inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private Set<User> participants = new HashSet<>();

    @ManyToMany
    @JoinTable(
        name = "user_liste_attente",
        joinColumns = @JoinColumn(name = "activite_id"),
        inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private Set<User> listeAttente = new HashSet<>();

    @ManyToOne
    @JoinColumn(name = "categorie_id")
    private Categorie categorie;

   
  
    public Activite() {
        this.dateActivite = new Date(); 
        this.dateCloture = new Date();  
    }

    public Activite(String titre, String description, String lieu, Date dateActivite, 
                   Date dateCloture, String imageUrl, Long capacite, 
                   Categorie categorie, boolean urgent) {
        this.titre = titre;
        this.description = description;
        this.lieu = lieu;
        this.dateActivite = dateActivite;
        this.dateCloture = dateCloture;
        this.imageUrl = imageUrl;
        this.capacite = capacite;
        this.categorie = categorie;
        this.urgent = urgent;
        
    }

    
    public boolean isComplete() {
        return participants.size() >= capacite;
    }
    
    public boolean isCloturee() {
        if (dateCloture == null) {
        
            return false;
        }
        return new Date().after(dateCloture);
    }
    
    public int getPlacesRestantes() {
        return (int) (capacite - participants.size());
    }

 
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLieu() {
        return lieu;
    }

    public void setLieu(String lieu) {
        this.lieu = lieu;
    }

    public Date getDateActivite() {
        return dateActivite;
    }

    public void setDateActivite(Date dateActivite) {
        this.dateActivite = dateActivite;
    }

    public Date getDateCloture() {
        return dateCloture;
    }

    public void setDateCloture(Date dateCloture) {
        if (dateCloture == null) {
            throw new IllegalArgumentException("Date de clôture ne peut pas être null");
        }
        this.dateCloture = dateCloture;
    }
    public boolean isInscriptionOuverte() {
        if (dateCloture == null) {
            return true; 
        }
        return !isCloturee() && !isComplete();
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Long getCapacite() {
        return capacite;
    }

    public void setCapacite(long capa) {
        this.capacite = capa;
    }

    public boolean isUrgent() {
        return urgent;
    }

    public void setUrgent(boolean urgent) {
        this.urgent = urgent;
    }

    public boolean isDejaInscrit() {
        return dejaInscrit;
    }

    public void setDejaInscrit(boolean dejaInscrit) {
        this.dejaInscrit = dejaInscrit;
    }

    public boolean isEnListeAttente() {
        return enListeAttente;
    }

    public void setEnListeAttente(boolean enListeAttente) {
        this.enListeAttente = enListeAttente;
    }

    public Set<User> getParticipants() {
        return participants;
    }

    public void setParticipants(Set<User> participants) {
        this.participants = participants;
    }

    public Set<User> getListeAttente() {
        return listeAttente;
    }

    public void setListeAttente(Set<User> listeAttente) {
        this.listeAttente = listeAttente;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }

	

	public void setCapacite(Long capacite) {
		this.capacite = capacite;
	}
	public User getOrganisateur() {
	    return organisateur;
	}

	public void setOrganisateur(User organisateur) {
	    this.organisateur = organisateur;
	}

    
    
}