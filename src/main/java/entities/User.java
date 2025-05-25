package entities;

import javax.persistence.*;

import org.hibernate.LazyInitializationException;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nom;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String motDePasse;

    @Temporal(TemporalType.DATE)
    private Date dateInscription;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    @Column(length = 20)
    private String telephone;

    @ManyToMany(mappedBy = "participants", fetch = FetchType.LAZY)
    private Set<Activite> activites = new HashSet<>();

    
    public User() {}

    public User(String nom, String email, String motDePasse, Date dateInscription, Role role, String telephone) {
        this.nom = nom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.dateInscription = dateInscription;
        this.role = role;
        this.telephone = telephone;
    }

  

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }

    public Date getDateInscription() {
        return dateInscription;
    }

    public void setDateInscription(Date dateInscription) {
        this.dateInscription = dateInscription;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public Set<Activite> getActivites() {
        return activites;
    }

    public void setActivites(Set<Activite> activites) {
        this.activites = activites;
    }

@Transient
public int getParticipationCount() {
    try {
        return this.activites.size();
    } catch (LazyInitializationException e) {
        // Return 0 or fetch count from database
        return 0;
    }
}

    @Transient
    public String getNextBadge() {
        // Exemple simple
        int count = getParticipationCount();
        if (count < 5) return "Bronze";
        if (count < 10) return "Argent";
        return "Or";
    }

    @Transient
    public int getRemainingForNextBadge() {
        int count = getParticipationCount();
        if (count < 5) return 5 - count;
        if (count < 10) return 10 - count;
        return 0;
    }



}
