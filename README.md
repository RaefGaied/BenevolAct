# 🌱 BénévolAct - Plateforme de gestion d'activités bénévoles  

[![Java](https://img.shields.io/badge/Java-EE%208+-orange?logo=java)](https://java.com)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)](https://mysql.com)
[![License](https://img.shields.io/badge/License-MIT-green)](https://opensource.org/licenses/MIT)

## 📖 Table des matières  
- [Contexte](#-contexte)  
- [Fonctionnalités](#-fonctionnalités)  
- [Technologies](#-technologies-utilisées)  
- [Base de données](#-base-de-données)  
- [Modèle de données](#-modèle-de-données)  
- [Installation](#-installation)  
- [Auteur](#-auteur)  

---

## 💡 Contexte  
Solution de gestion d'activités associatives permettant :  
- ✅ Inscription à des actions bénévoles  
- 📊 Suivi des participations  
- 🏆 Attribution de badges selon l'engagement  

**Valeur ajoutée** :  
- 👥 Valorisation des actions sociales  
- 🔗 Modèle relationnel complexe (bon exercice JEE)  
- 💼 Projet présentable en portfolio  

---

## ✨ Fonctionnalités  
**Espace Bénévole** :  
- 📅 Voir les activités disponibles  
- ➕ S'inscrire à des événements  
- 📊 Consulter son historique  

**Espace Organisateur** :  
- 🆕 Créer de nouvelles activités  
- 👥 Gérer les participants  
- 📝 Modifier les informations  

---

## 🧱 Technologies utilisées  
### Backend  
- **Java EE 8** (Servlets, JSP, JSTL)  
- **JPA/Hibernate** (ORM)  
- **Apache Tomcat 9** (Serveur)  

### Frontend  
- **HTML5/CSS3**  
- **Bootstrap 5** (Optionnel)  

### Base de données  
- **MySQL 8.0**  

---

## 🗃️ Base de données  
**Configuration** :  
```properties
Nom : benevolact  
Port : 3306  
User : root  
Password : [vide par défaut]  
### 🗃️ Base de données

- Nom : `benevolact`
- Configuration JDBC :

```xml
<property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/benevolact"/>
<property name="javax.persistence.jdbc.user" value="root"/>
<property name="javax.persistence.jdbc.password" value=""/>
```
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
