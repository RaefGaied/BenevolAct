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

## 💡 Contexte
Solution de gestion d'activités associatives permettant :
- ✅ Inscription à des actions bénévoles
- 📊 Suivi des participations
- 🏆 Attribution de badges selon l'engagement

**Valeur ajoutée** :
- 👥 Valorisation des actions sociales
- 🔗 Modèle relationnel complexe (bon exercice JEE)
- 💼 Projet présentable en portfolio

## ✨ Fonctionnalités
### Espace Bénévole
- 📅 Consultation des activités disponibles
- ➕ Inscription aux événements
- 📊 Historique des participations

### Espace Organisateur
- 🆕 Création d'activités
- 👥 Gestion des participants
- ✏️ Modification des informations

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
## 📐 Modèle de données

### Entités principales

| Entité        | Attributs                          | Relations               |
|---------------|------------------------------------|-------------------------|
| **User**      | `id`, `nom`, `email`, `motDePasse`, `dateInscription` | ManyToMany → Activite   |
| **Activite**  | `id`, `titre`, `description`, `date`, `lieu` | ManyToMany → User<br>ManyToOne → Organisateur |
| **Organisateur** | `id`, `nom`, `email`, `telephone` | OneToMany → Activite    |

# BénévolAct - Plateforme de gestion d'activités bénévoles

## 📐 Schéma relationnel

<div align="center">
  <img src="https://github.com/user-attachments/assets/2d4fef5f-42ce-4489-a612-887292e95534" alt="Diagramme de relations Mermaid" width="700">
  <br>
  <em>Diagramme des relations entre entités</em>
</div>

## 🚀 Installation

### 📋 Prérequis
- [JDK 11+](https://adoptium.net/)
- [MySQL 8.0+](https://dev.mysql.com/downloads/)
- IDE au choix :
  - [Eclipse](https://www.eclipse.org/downloads/)
  - [IntelliJ IDEA](https://www.jetbrains.com/idea/download/)
  - [VS Code](https://code.visualstudio.com/)

### 🔧 Étapes d'installation

1. **Cloner le dépôt** :
   ```bash
   git clone https://github.com/votre-utilisateur/benevolact.git
   cd benevolact
   ```

2. **Configurer la base de données** :
   ```sql
   CREATE DATABASE benevolact;
   USE benevolact;
   ```

3. **Configuration JPA** :
   Modifier `src/main/resources/META-INF/persistence.xml` :
   ```xml
   <property name="javax.persistence.jdbc.url" value="jdbc:mysql://localhost:3306/benevolact?useSSL=false"/>
   <property name="javax.persistence.jdbc.user" value="root"/>
   <property name="javax.persistence.jdbc.password" value="votre_mot_de_passe"/>
   ```

4. **Démarrer l'application** :
   - Importer le projet dans votre IDE
   - Configurer Tomcat 9+
   - Lancer le serveur
   - Accéder à : [http://localhost:8080/benevolact](http://localhost:8080/benevolact)

## 👨‍💻 Auteur
**Raef Gaied**  
Étudiant en informatique  

[![Portfolio](https://img.shields.io/badge/🌐-Portfolio-blue)](https://votre-portfolio.com)  
[![LinkedIn](https://img.shields.io/badge/🔗-LinkedIn-0077B5)](https://linkedin.com/in/votre-profil)  
[![Email](https://img.shields.io/badge/✉️-Contact-D14836)](mailto:votre.email@domain.com)
