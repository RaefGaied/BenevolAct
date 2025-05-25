-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : dim. 25 mai 2025 à 17:55
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `benevolact`
--

-- --------------------------------------------------------

--
-- Structure de la table `activites`
--

CREATE TABLE `activites` (
  `id` bigint(20) NOT NULL,
  `date` date DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  `lieu` varchar(255) DEFAULT NULL,
  `titre` varchar(255) DEFAULT NULL,
  `categorie_id` bigint(20) DEFAULT NULL,
  `is_urgent` tinyint(1) DEFAULT 0,
  `capacite` bigint(20) NOT NULL,
  `date_activite` datetime DEFAULT NULL,
  `date_cloture` datetime DEFAULT NULL,
  `organisateur_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `activites`
--

INSERT INTO `activites` (`id`, `date`, `description`, `imageUrl`, `lieu`, `titre`, `categorie_id`, `is_urgent`, `capacite`, `date_activite`, `date_cloture`, `organisateur_id`) VALUES
(31, '2025-06-20', 'Distribution alimentaire', '/assets/images/food-distribution.jpg', 'Place de la République', 'Epicerie solidaire', 17, 1, 30, '2024-06-20 00:00:00', '2024-06-19 00:00:00', 3),
(32, '2024-06-22', 'Atelier de prévention santé', '/assets/images/health-workshop.jpg', 'Centre médical', 'Bien-être au quotidien', 19, 0, 25, '2024-06-22 00:00:00', '2024-06-21 00:00:00', 4),
(33, '2024-06-25', 'Concert caritatif', '/assets/images/charity-concert.jpg', 'Salle des fêtes', 'Soirée musicale', 20, 0, 100, '2024-06-25 00:00:00', '2024-06-24 00:00:00', 5),
(36, '2024-07-05', 'Préparation au baccalauréat', '/assets/images/bac-prep.jpg', 'Lycée Henri IV', 'Stage intensif', 18, 1, 20, '2024-07-05 00:00:00', '2024-07-04 00:00:00', 3),
(37, '2024-07-10', 'Collecte de vêtements d\'hiver', '/assets/images/winter-clothes.jpg', 'Centre ville', 'Urgence hivernale', 17, 1, 0, '2024-07-10 00:00:00', '2024-07-09 00:00:00', 4),
(38, '2024-07-15', 'Atelier peinture intergénérationnel', '/assets/images/painting-workshop.jpg', 'Maison de quartier', 'Création collective', 20, 0, 12, '2024-07-15 00:00:00', '2024-07-14 00:00:00', 5),
(40, '2024-06-18', 'Aide aux devoirs', '/assets/images/volunteer.jpg', 'École Primaire', 'Soutien scolaire', 18, 0, 15, '2024-06-18 00:00:00', '2024-06-17 00:00:00', 2),
(41, '2025-06-20', 'Visite aux personnes âgées', '/assets/images/volunteer.jpg', 'EHPAD Les Roses', 'Visite sociale', 17, 0, 10, '2024-06-20 00:00:00', '2024-06-19 00:00:00', 3),
(90, '2025-06-05', 'Nettoyage des berges de la rivière', '/assets/images/river-cleanup.jpg', 'Berges de la Seine', 'Protection des cours d\'eau', 23, 0, 30, '2025-06-05 00:00:00', '2025-06-04 00:00:00', 1),
(91, '2025-06-07', 'Distribution de kits hygiéniques', '/assets/images/hygiene-kits.jpg', 'Centre ville', 'Hygiène pour tous', 17, 1, 0, '2025-06-07 00:00:00', '2025-06-06 00:00:00', 2),
(92, '2025-06-10', 'Cours de français langue étrangère', '/assets/images/french-class.jpg', 'École Jules Ferry', 'Apprendre le français', 18, 0, 15, '2025-06-10 00:00:00', '2025-06-09 00:00:00', 3),
(93, '2025-06-12', 'Tournoi de foot caritatif', '/assets/images/charity-football.jpg', 'Stade municipal', 'Foot solidaire', 24, 0, 50, '2025-06-12 00:00:00', '2025-06-11 00:00:00', 4),
(94, '2025-06-15', 'Dépistage gratuit des troubles visuels', '/assets/images/eye-test.jpg', 'Centre médical', 'Santé visuelle', 19, 0, 40, '2025-06-15 00:00:00', '2025-06-14 00:00:00', 1),
(95, '2025-06-18', 'Collecte de denrées alimentaires', '/assets/images/food-drive.jpg', 'Supermarché', 'Banque alimentaire', 25, 1, 0, '2025-06-18 00:00:00', '2025-06-17 00:00:00', 2),
(96, '2025-06-20', 'Spectacle de danse caritatif', '/assets/images/dance-show.jpg', 'Théâtre', 'Danse solidaire', 20, 0, 120, '2025-06-20 00:00:00', '2025-06-19 00:00:00', 3),
(97, '2025-06-22', 'Atelier d\'initiation au braille', '/assets/images/braille-workshop.jpg', 'Centre Handi-Solidarité', 'Découverte du braille', 26, 0, 12, '2025-06-22 00:00:00', '2025-06-21 00:00:00', 4),
(98, '2025-06-25', 'Soirée de collecte pour crise humanitaire', '/assets/images/international-aid.jpg', 'Salle des fêtes', 'Urgence internationale', 27, 1, 200, '2025-06-25 00:00:00', '2025-06-24 00:00:00', 1),
(101, '2025-06-01', 'Test système d\'inscription bénévoles', '/assets/images/test-system.jpg', 'Labo informatique', 'Test Inscription', NULL, 0, 5, '2025-06-01 00:00:00', '2025-05-31 00:00:00', 1),
(102, '2025-06-03', 'Validation des flux de participation', '/assets/images/test-workflow.jpg', 'Salle de tests', 'Test Workflow', NULL, 0, 3, '2025-06-03 00:00:00', '2025-06-02 00:00:00', 2),
(103, '2025-06-05', 'Test d\'urgence système12', '/assets/images/test-alert.jpg', 'Centre de contrôle', 'Test Urgence', 20, 1, 2, '2025-06-05 00:00:00', '2025-06-04 00:00:00', 3),
(108, NULL, 'fdfsf', 'uploads/1748040752931_téléchargement (3).jpeg', 'fsdfd', 'Urgence internationale', 20, 1, 10, NULL, '2025-05-31 23:52:00', 8);

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `nom` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`id`, `description`, `nom`) VALUES
(17, 'Aide aux personnes en difficulté', 'Social'),
(18, 'Soutien scolaire et formations', 'Éducation'),
(19, 'Actions liées au bien-être', 'Santé'),
(20, 'Événements artistiques et culturels', 'Culture'),
(23, 'Activités de protection de la nature et développement durable', 'Environnement'),
(24, 'Activités sportives et événements sportifs solidaires', 'Sport'),
(25, 'Aide alimentaire et distribution de repas', 'Alimentation'),
(26, 'Activités d\'accompagnement pour personnes handicapées', 'Handicap'),
(27, 'Aide humanitaire et projets internationaux', 'International');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `dateInscription` date DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `motDePasse` varchar(255) NOT NULL,
  `nom` varchar(255) DEFAULT NULL,
  `role` varchar(255) NOT NULL,
  `telephone` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `dateInscription`, `email`, `motDePasse`, `nom`, `role`, `telephone`) VALUES
(1, '2025-05-02', 'cc@gmail.com', '$2a$10$EVyAVZgK/uDkfOAsoOA0uO90yRYguTZNkVwrhpLhp3rA7DzyBVIQ2', 'cc', 'USER', '99586293'),
(2, '2025-05-03', 'org1@benevol.org', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrYV7Z1r09D7Wm6Q7XrQ2TkUwJQ1qWm', 'Jean Dupont', 'ORGANISATEUR', '0612345678'),
(3, '2025-05-03', 'org2@benevol.org', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrYV7Z1r09D7Wm6Q7XrQ2TkUwJQ1qWm', 'Marie Martin', 'ORGANISATEUR', '0698765432'),
(4, '2025-05-03', 'org3@benevol.org', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrYV7Z1r09D7Wm6Q7XrQ2TkUwJQ1qWm', 'Pierre Durand', 'ORGANISATEUR', '0687654321'),
(5, '2025-05-03', 'org4@benevol.org', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrYV7Z1r09D7Wm6Q7XrQ2TkUwJQ1qWm', 'Sophie Lambert', 'ORGANISATEUR', '0678945612'),
(6, '2025-05-03', 'org5@benevol.org', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MrYV7Z1r09D7Wm6Q7XrQ2TkUwJQ1qWm', 'Thomas Leroy', 'ORGANISATEUR', '0632145698'),
(7, '2025-05-03', 'chouchene@gmail.com', '$2a$10$ACpVmHYwxuEz7ncHgp/81OnDC5KDJnUOgP.PQe7b.ASYL.xoS4pqW', 'gg', 'USER', '5874123236'),
(8, NULL, 'admin@example.com', '$2a$10$wdhTM4HN2qStCdFYHRgU4.a2oAmYx5kOt6XLYC/yuGcE.FxUZ2uTa', 'admin', 'ORGANISATEUR', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `user_activite`
--

CREATE TABLE `user_activite` (
  `activite_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `user_liste_attente`
--

CREATE TABLE `user_liste_attente` (
  `activite_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `activites`
--
ALTER TABLE `activites`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK44010on1n2849ly9mxwmyabe7` (`categorie_id`),
  ADD KEY `FK6un654wrcv6te28brb4bhkqj4` (`organisateur_id`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_l15ogrfsiv1ijo5bi874gbgr5` (`nom`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UK_6dotkott2kjsp8vw4d0m25fb7` (`email`);

--
-- Index pour la table `user_activite`
--
ALTER TABLE `user_activite`
  ADD PRIMARY KEY (`activite_id`,`user_id`),
  ADD KEY `FKja4hhvr8snqolv8mm34hfqfpj` (`user_id`);

--
-- Index pour la table `user_liste_attente`
--
ALTER TABLE `user_liste_attente`
  ADD PRIMARY KEY (`activite_id`,`user_id`),
  ADD KEY `FKn4m1cj4b63fms7c5v49qgdbyl` (`user_id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `activites`
--
ALTER TABLE `activites`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=113;

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `activites`
--
ALTER TABLE `activites`
  ADD CONSTRAINT `FK44010on1n2849ly9mxwmyabe7` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `FK6un654wrcv6te28brb4bhkqj4` FOREIGN KEY (`organisateur_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `user_activite`
--
ALTER TABLE `user_activite`
  ADD CONSTRAINT `FK4waaalxap93ncyt9phhklwo3s` FOREIGN KEY (`activite_id`) REFERENCES `activites` (`id`),
  ADD CONSTRAINT `FKja4hhvr8snqolv8mm34hfqfpj` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `user_liste_attente`
--
ALTER TABLE `user_liste_attente`
  ADD CONSTRAINT `FK33m1u6eth7vken1qogocgjdpe` FOREIGN KEY (`activite_id`) REFERENCES `activites` (`id`),
  ADD CONSTRAINT `FKn4m1cj4b63fms7c5v49qgdbyl` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
