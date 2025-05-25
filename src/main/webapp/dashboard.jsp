<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Tableau de Bord – Bénévol'Action</title>
  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <!-- Google Font Poppins -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Poppins', sans-serif;
      background: linear-gradient(120deg, #0f2027, #203a43, #2c5364);
      color: #fff;
      min-height: 100vh;
    }
    .navbar {
      background: rgba(255,255,255,0.05);
      backdrop-filter: blur(8px);
      box-shadow: 0 2px 10px rgba(0,0,0,0.3);
    }
    .navbar .navbar-brand {
      color: #00e6e6;
      font-weight: 600;
    }
    .glass-card {
      background: rgba(255,255,255,0.08);
      border: 1px solid rgba(255,255,255,0.15);
      backdrop-filter: blur(15px);
      border-radius: 15px;
      padding: 30px;
      transition: transform 0.2s ease-in-out;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
      color: #fff;
    }
    .glass-card:hover {
      transform: scale(1.02);
    }
    .glass-card .card-icon {
      font-size: 2.5rem;
      margin-bottom: 15px;
      color: #00c6ff;
    }
    .glass-card h3 {
      font-size: 2rem;
      margin-bottom: 10px;
    }
    .glass-card p {
      font-size: 1rem;
      margin-bottom: 20px;
      color: #ddd;
    }
    .glass-card .btn {
      border-radius: 12px;
      padding: 8px 20px;
      font-weight: 500;
    }
  </style>
</head>
<body>

  <!-- Navbar -->
  <nav class="navbar navbar-expand-lg navbar-dark mb-4">
    <div class="container-fluid">
      <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
        <i class="fas fa-hands-helping me-2"></i>Bénévol'Action
      </a>
    </div>
  </nav>

  <!-- Dashboard -->
  <div class="container">
    <h2 class="text-center mb-5">Tableau de bord</h2>
    <div class="row g-4">
      <!-- Carte Utilisateurs -->
      <div class="col-md-4">
        <div class="glass-card text-center">
          <i class="fas fa-users card-icon"></i>
          <h3><c:out value="${usersCount}" default="0"/></h3>
          <p>Utilisateurs inscrits</p>
          <a href="${pageContext.request.contextPath}/users" class="btn btn-outline-light">Gérer</a>
        </div>
      </div>
      <!-- Carte Activités -->
      <div class="col-md-4">
        <div class="glass-card text-center">
          <i class="fas fa-calendar-week card-icon"></i>
          <h3><c:out value="${activitiesCount}" default="0"/></h3>
          <p>Activités créées</p>
          <a href="${pageContext.request.contextPath}/activities" class="btn btn-outline-light">Voir</a>
        </div>
      </div>
      <!-- Carte Catégories -->
      <div class="col-md-4">
        <div class="glass-card text-center">
          <i class="fas fa-tags card-icon"></i>
          <h3><c:out value="${categoriesCount}" default="0"/></h3>
          <p>Catégories disponibles</p>
          <a href="${pageContext.request.contextPath}/categories" class="btn btn-outline-light">Gérer</a>
        </div>
      </div>
    </div>

    <div class="row g-4 mt-4">
      <!-- Carte Mes Participations -->
      <div class="col-md-6">
        <div class="glass-card text-center">
          <i class="fas fa-calendar-check card-icon"></i>
          <h3><c:out value="${sessionScope.user.participationCount}" default="0"/></h3>
          <p>Mes participations</p>
          <a href="${pageContext.request.contextPath}/my-activities" class="btn btn-outline-light">Voir</a>
        </div>
      </div>
      <!-- Carte Statistiques -->
      <div class="col-md-6">
        <div class="glass-card text-center">
          <i class="fas fa-chart-line card-icon"></i>
          <h3><c:out value="${statistics.totalParticipations}" default="0"/></h3>
          <p>Total de participations</p>
          <a href="${pageContext.request.contextPath}/dashboard-stats" class="btn btn-outline-light">Détails</a>
        </div>
      </div>
    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
