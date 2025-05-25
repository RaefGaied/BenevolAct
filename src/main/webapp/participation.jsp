<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Participations</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4285f4;
            --secondary-color: #34a853;
            --accent-color: #ea4335;
            --warning-color: #fbbc05;
            --light-gray: #f5f5f5;
            --dark-gray: #333;
            --white: #ffffff;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            line-height: 1.6;
            color: var(--dark-gray);
            background-color: var(--light-gray);
            padding: 0;
            margin: 0;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            background-color: var(--white);
            box-shadow: var(--box-shadow);
            padding: 20px 0;
            margin-bottom: 30px;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
        }
        
        .nav-links a {
            margin-left: 20px;
            text-decoration: none;
            color: var(--dark-gray);
            font-weight: 500;
            transition: color 0.3s;
        }
        
        .nav-links a:hover {
            color: var(--primary-color);
        }
        
        .main-title {
            text-align: center;
            margin-bottom: 40px;
            color: var(--primary-color);
        }
        
        .participation-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .participation-card {
            background-color: var(--white);
            border-radius: 8px;
            box-shadow: var(--box-shadow);
            padding: 25px;
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
        }
        
        .participation-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .event-title {
            font-size: 18px;
            font-weight: 500;
            color: var(--primary-color);
        }
        
        .event-date {
            font-size: 14px;
            color: #666;
            background-color: #f0f0f0;
            padding: 3px 8px;
            border-radius: 12px;
        }
        
        .event-description {
            margin-bottom: 15px;
            color: #555;
        }
        
        .event-details {
            margin-bottom: 15px;
            font-size: 14px;
        }
        
        .event-details span {
            display: block;
            margin-bottom: 5px;
        }
        
        .event-details i {
            margin-right: 8px;
            color: var(--primary-color);
            width: 20px;
            text-align: center;
        }
        
        .participation-status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 15px;
        }
        
        .status-pending {
            background-color: var(--warning-color);
            color: #fff;
        }
        
        .status-confirmed {
            background-color: var(--secondary-color);
            color: #fff;
        }
        
        .status-canceled {
            background-color: var(--accent-color);
            color: #fff;
        }
        
        .status-waiting {
            background-color: #9e9e9e;
            color: #fff;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            text-align: center;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #3367d6;
        }
        
        .btn-secondary {
            background-color: #f1f1f1;
            color: var(--dark-gray);
            border: 1px solid #ddd;
        }
        
        .btn-secondary:hover {
            background-color: #e0e0e0;
        }
        
        .btn-danger {
            background-color: var(--accent-color);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #d33426;
        }
        
        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn-full-width {
            width: 100%;
        }
        
        .urgent-badge {
            position: absolute;
            top: -10px;
            right: -10px;
            background-color: var(--accent-color);
            color: white;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
        }
        
        footer {
            background-color: var(--dark-gray);
            color: var(--white);
            padding: 30px 0;
            text-align: center;
            margin-top: 50px;
        }
        
        .footer-content {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        @media (max-width: 768px) {
            .participation-container {
                grid-template-columns: 1fr;
            }
            
            .header-content {
                flex-direction: column;
                text-align: center;
            }
            
            .nav-links {
                margin-top: 15px;
            }
            
            .nav-links a {
                margin: 0 10px;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <div class="logo">EventHub</div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/activities">Activités</a>
                <a href="${pageContext.request.contextPath}/participation">Mes Participations</a>
                <a href="${pageContext.request.contextPath}/profile">Profil</a>
                <a href="${pageContext.request.contextPath}/logout">Déconnexion</a>
            </div>
        </div>
    </header>
    
    <main class="container">
        <h1 class="main-title">Mes Participations</h1>
        
        <%-- Messages de succès/erreur --%>
        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${success}
            </div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <div class="participation-container">
            <c:choose>
                <c:when test="${empty participations}">
                    <div class="participation-card" style="grid-column: 1 / -1; text-align: center;">
                        <p>Vous n'êtes inscrit à aucune activité pour le moment.</p>
                        <a href="${pageContext.request.contextPath}/activities" class="btn btn-primary">
                            <i class="fas fa-search"></i> Trouver une activité
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${participations}" var="activite">
                        <div class="participation-card">
                            <c:if test="${activite.urgent}">
                                <div class="urgent-badge" title="Urgent">
                                    <i class="fas fa-exclamation"></i>
                                </div>
                            </c:if>
                            
                            <div class="card-header">
                                <h3 class="event-title">${activite.titre}</h3>
                                <span class="event-date">
                                    <fmt:formatDate value="${activite.dateActivite}" pattern="dd/MM/yyyy HH:mm" />
                                </span>
                            </div>
                            
                            <p class="event-description">
                                ${activite.description}
                            </p>
                            
                            <div class="event-details">
                                <span><i class="fas fa-map-marker-alt"></i> ${activite.lieu}</span>
                                <span><i class="fas fa-users"></i> 
                                    <c:out value="${activite.participants != null ? activite.participants.size() : 0}"/>
                                    /${activite.capacite} participants
                                </span>
                                <span><i class="fas fa-tag"></i> ${activite.categorie.nom}</span>
                            </div>
                            
                            <div>
                                <c:choose>
                                    <c:when test="${activite.enListeAttente}">
                                        <span class="participation-status status-waiting">
                                            <i class="fas fa-clock"></i> En liste d'attente
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="participation-status status-confirmed">
                                            <i class="fas fa-check"></i> Confirmé
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            
                            <div class="btn-group">
                                <a href="${pageContext.request.contextPath}/activite-details?id=${activite.id}" 
                                   class="btn btn-secondary btn-full-width">
                                    <i class="fas fa-info-circle"></i> Détails
                                </a>
                                
                                <c:choose>
                                    <c:when test="${activite.enListeAttente}">
                                        <a href="${pageContext.request.contextPath}/participation?action=quitterlisteattente&id=${activite.id}" 
                                           class="btn btn-danger btn-full-width"
                                           onclick="return confirm('Voulez-vous vraiment quitter la liste d\\'attente ?');">
                                            <i class="fas fa-sign-out-alt"></i> Quitter
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/participation?action=annuler&id=${activite.id}" 
                                           class="btn btn-danger btn-full-width"
                                           onclick="return confirm('Voulez-vous vraiment annuler votre participation ?');">
                                            <i class="fas fa-times"></i> Annuler
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
    
    <footer>
        <div class="footer-content">
            <p>© 2023 EventHub. Tous droits réservés.</p>
            <p style="margin-top: 10px;">
                <a href="#" style="color: white; margin: 0 10px;">Confidentialité</a>
                <a href="#" style="color: white; margin: 0 10px;">Conditions</a>
                <a href="#" style="color: white; margin: 0 10px;">Contact</a>
            </p>
        </div>
    </footer>
    
    <script>
        // Confirmation pour les actions d'annulation
        function confirmAction(message) {
            return confirm(message);
        }

        // Confirmation for cancel/leave actions
        function confirmAction(message) {
            return confirm(message);
        }
        
        // Initialize tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
    </script>
</body>
</html>