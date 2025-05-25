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
### Espace Bénévole  
- 📅 Consultation des activités disponibles  
- ➕ Inscription aux événements  
- 📊 Historique des participations  

### Espace Organisateur  
- 🆕 Création d'activités  
- 👥 Gestion des participants  
- ✏️ Modification des informations  

---

## 🛠️ Technologies utilisées  
### Backend  
<p align="left">
  <img src="https://img.shields.io/badge/Java%20EE-8-ED8B00?logo=java&logoColor=white" alt="Java EE">
  <img src="https://img.shields.io/badge/JPA-2.2-59666C?logo=hibernate&logoColor=white" alt="JPA">
  <img src="https://img.shields.io/badge/Tomcat-9.0-F8DC75?logo=apache-tomcat&logoColor=black" alt="Tomcat">
</p>

### Frontend  
<p align="left">
  <img src="https://img.shields.io/badge/HTML5-E34F26?logo=html5&logoColor=white" alt="HTML5">
  <img src="https://img.shields.io/badge/CSS3-1572B6?logo=css3&logoColor=white" alt="CSS3">
  <img src="https://img.shields.io/badge/Bootstrap-5-7952B3?logo=bootstrap&logoColor=white" alt="Bootstrap">
</p>

### Base de données  
<p align="left">
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql&logoColor=white" alt="MySQL">
</p>

---

## 🗃️ Base de données  
**Configuration** :  
```properties
Nom : benevolact  
Port : 3306  
User : root  
Password : [vide par défaut]  

```xml
<property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/benevolact"/>
<property name="javax.persistence.jdbc.user" value="root"/>
<property name="javax.persistence.jdbc.password" value=""/>
```
📐 Modèle de données
Entités principales
Entité	Attributs	Relations
User	id, nom, email, motDePasse, date	ManyToMany → Activite
Activite	id, titre, description, date, lieu	ManyToMany → User
Organisateur	id, nom, email, telephone	OneToMany → Activite


🚀 Comment exécuter le projet
Importer le projet dans Eclipse/NetBeans.

Démarrer MySQL et importer le fichier SQL dans une base appelée benevolact.

Configurer les identifiants dans le fichier persistence.xml.

Lancer le serveur (Tomcat par exemple).

Accéder à l'application via http://localhost:8080/benevolact.

👨‍🎓 Auteur
Raef Gaied (étudiant en informatique)
```
