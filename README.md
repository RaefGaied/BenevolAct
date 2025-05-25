# 🌱 BénévolAct - Plateforme de gestion d’activités bénévoles

## 💡 Contexte

Ce projet propose une solution pour gérer les activités proposées par une association bénévole (ramassage de déchets, visites en maison de retraite, soutien scolaire...). Il permet aux utilisateurs de :

- S'inscrire à des activités
- Suivre leur participation
- Gagner des badges symboliques selon leur engagement

## ✅ Pourquoi ce projet ?

- 👥 Valorise les actions sociales et solidaires
- 🔗 Contient plusieurs entités avec relations complexes
- 📚 Parfait pour pratiquer les technologies JEE (JSP, Servlet, JPA)
- 💼 Présentable dans un portfolio professionnel

---

## 🧱 Structure du projet

### ⚙️ Technologies utilisées

- Java EE (Servlets, JSP, JSTL)
- JPA (Java Persistence API)
- MySQL
- Bootstrap (optionnel pour le style)

### 🗃️ Base de données

- Nom : `benevolact`
- Configuration JDBC :

```xml
<property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/benevolact"/>
<property name="javax.persistence.jdbc.user" value="root"/>
<property name="javax.persistence.jdbc.password" value=""/>

📐 Entités
👤 User
id

nom

email

motDePasse

dateInscription

🔗 Relation ManyToMany avec Activite

🎯 Activite
id

titre

description

date

lieu

🔗 Relation ManyToMany avec User

🔗 Relation ManyToOne avec Organisateur

🧑‍💼 Organisateur
id

nom

email

telephone

🔗 Relation OneToMany vers Activite

🔄 Relations entre entités
User ⇄ Activite : ManyToMany

Organisateur → Activite : OneToMany / ManyToOne

🚀 Comment exécuter le projet
Importer le projet dans Eclipse/NetBeans.

Démarrer MySQL et importer le fichier SQL dans une base appelée benevolact.

Configurer les identifiants dans le fichier persistence.xml.

Lancer le serveur (Tomcat par exemple).

Accéder à l'application via http://localhost:8080/benevolact.

👨‍🎓 Auteur
Raef Gaied (étudiant en informatique)
```
