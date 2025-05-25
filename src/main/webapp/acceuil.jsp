<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="java.util.Objects" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="entities.User, entities.Role" %> 

<%-- Paramètres de pagination --%>
<c:set var="pageSize" value="10" />
<c:set var="totalItems" value="${fn:length(activites)}" />
<c:set var="totalPages" value="${(totalItems + pageSize - 1) div pageSize}" />

<c:set var="currentPage" value="${empty param.page ? 1 : param.page}" />
<c:if test="${currentPage < 1}">
    <c:set var="currentPage" value="1" />
</c:if>
<c:if test="${currentPage > totalPages}">
    <c:set var="currentPage" value="${totalPages}" />
</c:if>


<c:set var="startIndex" value="${(currentPage - 1) * pageSize}" />
<c:set var="endIndex" value="${currentPage * pageSize - 1}" />
<c:if test="${endIndex >= totalItems}">
    <c:set var="endIndex" value="${totalItems - 1}" />
</c:if>

<%-- DEBUG : Afficher si la liste est bien transmise --%>
<c:if test="${not empty activites}">
    <p style="color:green;">DEBUG : ${activites.size()} activité(s) chargée(s) - Page ${currentPage}/${totalPages}</p>
</c:if>
<c:if test="${empty activites}">
    <p style="color:red;">DEBUG : Aucune activité chargée</p>
</c:if>

<%
    HttpSession sessionUser = request.getSession(false);
    User user = (sessionUser != null) ? (User) sessionUser.getAttribute("user") : null;
    String username = (user != null) ? user.getNom() : null;

    Role role = Role.USER;
    if (sessionUser != null && sessionUser.getAttribute("role") != null) {
        try {
            role = Role.valueOf((String) sessionUser.getAttribute("role"));
        } catch (IllegalArgumentException e) {
            role = Role.USER;
        }
    }

    String cacheBuster = "?v=" + System.currentTimeMillis();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Plateforme Bénévole - <c:out value="${role == 'ORGANISATEUR' ? 'Organisateur' : 'Bénévole'}"/></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/volunteer.jpg">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/acceuil.css">
    <style>
        .truncate-text {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 150px;
            display: inline-block;
        }

        .activity-row:hover {
            background-color: rgba(0, 0, 0, 0.02);
        }

        .progress {
            min-width: 50px;
            max-width: 80px;
        }

        .welcome-container {
            border-left: 4px solid #28a745;
            transition: all 0.3s ease;
        }
        .welcome-container:hover {
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
        }
        #clock {
            font-family: 'Courier New', monospace;
            background: rgba(40, 167, 69, 0.1);
            padding: 5px 10px;
            border-radius: 4px;
        }
        .activity-row:hover {
            background-color: #f8f9fa !important;
        }
        .organisateur-badge {
            background-color: #6f42c1;
        }
        .container-main {
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .img-thumbnail {
            border-radius: 5px !important;
        }
        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }
        .table {
            min-width: 992px;
        }
        .table th {
            white-space: nowrap;
            position: sticky;
            top: 0;
            background: white;
        }
        .activity-image {
            width: 80px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }
        .text-truncate-custom {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            max-width: 200px;
        }
        .badge-urgent {
            position: absolute;
            top: -5px;
            right: -5px;
        }
        
        /* Styles pour la pagination */
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .page-item.active .page-link {
            background-color: #28a745;
            border-color: #28a745;
        }
        .page-link {
            color: #28a745;
        }
        .page-item.disabled .page-link {
            color: #6c757d;
        }
    </style>
</head>
<body class="${role == 'ORGANISATEUR' ? 'organisateur-view' : 'user-view'}">

    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm mb-4 border-bottom">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
                <i class="fas fa-hands-helping me-2"></i>Bénévol'Action
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/home">
                            <i class="fas fa-home me-1"></i> Accueil
                        </a>
                    </li>
                    
                    <c:if test="${role == 'ORGANISATEUR'}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/add-activity">
                                <i class="fas fa-plus-circle me-1"></i> Créer Activité
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link fw-semibold px-3" href="${pageContext.request.contextPath}/categories">
                                <i class="fas fa-tags"></i> Catégories
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                <i class="fas fa-chart-bar me-1"></i> Statistiques
                            </a>
                        </li>
                    </c:if>
                </ul>
                
                <form class="d-flex me-3" action="${pageContext.request.contextPath}/search-activities" method="get">
                    <div class="input-group">
                        <input type="search" class="form-control" name="q" placeholder="Rechercher une activité..." required>
                        <button class="btn btn-light" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/my-activities">
                            <i class="fas fa-calendar-check me-1"></i> Mes Participations
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user-circle me-1"></i> <%= username %>
                           <c:if test="${user.role.name() eq 'ORGANISATEUR'}">
                                <span class="badge organisateur-badge rounded-pill ms-1">ORG</span>
                            </c:if>
                            <span class="badge bg-success rounded-pill">${user.participationCount}</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user me-2"></i>Profil</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/badges"><i class="fas fa-award me-2"></i>Mes Badges</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Déconnexion</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-3">
        <div class="alert alert-success d-flex justify-content-between align-items-center" role="alert">
            <div>
                <i class="fas fa-hands-helping me-2 fs-4"></i>
                Bienvenue, <strong>${not empty user.nom ? user.nom : user.email}</strong> !
                <c:choose>
                    <c:when test="${user.role.name() eq 'ORGANISATEUR'}">
                        <span class="ms-2">Vous êtes <span class="badge bg-primary">Organisateur</span></span>
                    </c:when>
                    <c:otherwise>
                        <span class="ms-2">Participation(s): 
                            <span class="badge bg-info">${user.participationCount}</span>
                        </span>
                    </c:otherwise>
                </c:choose>
                
                <c:if test="${user.role.name() ne 'ORGANISATEUR'}">
                    <span class="ms-2">Prochain badge: 
                        <span class="badge bg-warning text-dark">${user.nextBadge}</span>
                        <c:if test="${user.remainingForNextBadge > 0}">
                            (${user.remainingForNextBadge} participation(s) restante(s))
                        </c:if>
                    </span>
                </c:if>
            </div>
            <div class="text-end">
                <i class="fas fa-clock me-1"></i>
                <span id="clock" class="fw-bold">
                    <script>
                        function updateClock() {
                            const now = new Date();
                            document.getElementById('clock').textContent = 
                                now.toLocaleTimeString() + ' - ' + now.toLocaleDateString();
                        }
                        setInterval(updateClock, 1000);
                        updateClock();
                    </script>
                </span>
            </div>
        </div>
    </div>

    <%-- Message Flash amélioré --%>
    <c:if test="${not empty param.message}">
        <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
            <div class="d-flex align-items-center">
                <i class="fas fa-check-circle me-2 fs-4"></i>
                <div>
                    ${fn:escapeXml(param.message)}
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <script>
            $(document).ready(function() {
                setTimeout(function() {
                    $('.alert').fadeOut('slow', function() {
                        $(this).remove();
                    });
                }, 5000);
            });
        </script>
    </c:if>

    <div class="container container-main mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-0">
                    <i class="fas fa-calendar-alt me-2"></i>Activités Disponibles
                    <small class="text-muted fs-6">
                        (${user.role.name() eq 'ORGANISATEUR' ? 'Vue Organisateur' : 'Vue Bénévole'})
                    </small>
                </h2>
                <p class="text-muted mb-0 mt-1">
                    <small>
                        <i class="fas fa-info-circle me-1"></i>
                        ${totalItems} activité(s) trouvée(s) - Page ${currentPage}/${totalPages}
                    </small>
                </p>
            </div>
            
            <c:if test="${user.role.name() eq 'ORGANISATEUR'}">
                <a href="${pageContext.request.contextPath}/add-activity" class="btn btn-success btn-lg">
                    <i class="fas fa-plus-circle me-2"></i>Nouvelle activité
                </a>
            </c:if>
        </div>

        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-light">
                    <tr>
                        <th class="text-center" style="width: 5%;">ID</th>
                        <th class="text-center" style="width: 10%;">Image</th>
                        <th style="width: 15%;">Titre</th>
                        <th style="width: 15%;">Date/Lieu</th>
                        <th style="width: 20%;">Description</th>
                        <th style="width: 10%;">Catégorie</th>
                        <th class="text-center" style="width: 10%;">Participants</th>
                        <th class="text-center" style="width: 15%;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty activites}">
                            <tr>
                                <td colspan="8" class="text-center alert alert-warning py-3">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    Aucune activité disponible pour le moment
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${activites}" var="a" begin="${startIndex}" end="${endIndex}">
                                <tr class="activity-row ${a.urgent ? 'table-warning' : ''}">
                                    <td class="text-center align-middle">${a.id}</td>
                                    <td class="text-center align-middle p-1">
                                        <div class="position-relative mx-auto" style="width: 80px; height: 60px;">
                                            <c:choose>
                                                <c:when test="${not empty a.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}/images/volunteer.jpg"
                                                         alt="Image ${a.titre}"
                                                         class="activity-image"
                                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default.jpg'">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-light d-flex align-items-center justify-content-center h-100 rounded">
                                                        <i class="fas fa-calendar-day text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <c:if test="${a.urgent}">
                                                <span class="badge bg-danger badge-urgent">
                                                    <i class="fas fa-exclamation"></i>
                                                </span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        <strong class="text-truncate d-block" style="max-width: 150px;">${a.titre}</strong>
                                    </td>
                                    <td class="align-middle">
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty a.dateActivite}">
                                                    <i class="fas fa-calendar-day me-1"></i> 
                                                    <fmt:formatDate value="${a.dateActivite}" pattern="EEE dd/MM HH:mm"/><br>
                                                    <i class="fas fa-map-marker-alt me-1"></i> 
                                                    ${not empty a.lieu ? a.lieu : 'Non précisé'}
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-calendar-day me-1"></i> 
                                                    Date non définie<br>
                                                    <i class="fas fa-map-marker-alt me-1"></i> 
                                                    ${not empty a.lieu ? a.lieu : 'Non précisé'}
                                                </c:otherwise>
                                            </c:choose>
                                        </small>
                                    </td>
                                    <td class="align-middle">
                                        <div class="position-relative">
                                            <small class="text-truncate-custom">
                                                ${a.description}
                                            </small>
                                            <button class="btn btn-link p-0 ms-1" 
                                                    style="font-size: 0.8rem; vertical-align: top;"
                                                    data-bs-toggle="tooltip" 
                                                    title="${a.description}">
                                                <i class="fas fa-info-circle"></i>
                                            </button>
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        <span class="badge bg-primary text-truncate d-inline-block" style="max-width: 100px;">
                                            ${a.categorie.nom}
                                        </span>
                                    </td>
                                    <td class="text-center align-middle">
                                        <span class="badge ${a.participants.size() >= a.capacite ? 'bg-danger' : 'bg-success'}">
                                            <i class="fas fa-users me-1"></i> 
                                            ${a.participants.size()}/${a.capacite}
                                        </span>
                                        <c:if test="${!empty a.listeAttente}">
                                            <div class="small text-muted mt-1">
                                                <i class="fas fa-clock"></i> ${fn:length(a.listeAttente)} en attente
                                            </div>
                                        </c:if>
                                    </td>
                                   <td class="text-center align-middle p-2">
    <div class="d-flex justify-content-center gap-2">
      
        <c:if test="${not empty user}">
            <c:choose>
                
                <c:when test="${(not empty a.organisateur and a.organisateur.id eq user.id) or user.role.name() eq 'ORGANISATEUR'}">
                   
                    <a href="${pageContext.request.contextPath}/AjouterActiviteServlet?action=edit&activiteId=${a.id}" 
                       class="btn btn-sm btn-warning" 
                       title="Modifier">
                        <i class="fas fa-edit"></i>
                    </a>
                    
                   
                    <a href="${pageContext.request.contextPath}/delete-activity?id=${a.id}" 
                       class="btn btn-sm btn-danger" 
                       title="Supprimer"
                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette activité ?');">
                        <i class="fas fa-trash-alt"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <c:choose>
                        <c:when test="${a.dejaInscrit}">
                            <button class="btn btn-sm btn-success" disabled 
                                    data-bs-toggle="tooltip" title="Vous êtes inscrit">
                                <i class="fas fa-check"></i>
                            </button>
                            <a href="${pageContext.request.contextPath}/participation?action=annuler&id=${a.id}&redirect=${pageContext.request.servletPath}" 
                               class="btn btn-sm btn-outline-danger"
                               data-bs-toggle="tooltip" title="Annuler participation"
                               onclick="return confirm('Annuler votre participation ?');">
                                <i class="fas fa-times"></i>
                            </a>
                        </c:when>
                        <c:when test="${a.enListeAttente}">
                            <button class="btn btn-sm btn-warning" disabled
                                    data-bs-toggle="tooltip" title="En liste d'attente">
                                <i class="fas fa-clock"></i>
                            </button>
                            <a href="${pageContext.request.contextPath}/participation?action=quitterListeAttente&id=${a.id}&redirect=${pageContext.request.servletPath}" 
                               class="btn btn-sm btn-outline-danger"
                               data-bs-toggle="tooltip" title="Quitter liste d'attente"
                               onclick="return confirm('Quitter la liste d\'attente ?');">
                                <i class="fas fa-times"></i>
                            </a>
                        </c:when>
                        
                        <c:when test="${a.capacite > 0 && a.participants.size() >= a.capacite}">
                            <button class="btn btn-sm btn-secondary" disabled 
                                    data-bs-toggle="tooltip" title="Activité complète">
                                <i class="fas fa-times-circle"></i>
                            </button>
                            <c:if test="${a.dateCloture == null || !a.isCloturee()}">
                                <a href="${pageContext.request.contextPath}/participation?action=rejoindreListeAttente&id=${a.id}&redirect=${pageContext.request.servletPath}" 
                                   class="btn btn-sm btn-outline-warning"
                                   data-bs-toggle="tooltip" title="Rejoindre liste d'attente"
                                   onclick="return confirm('Rejoindre la liste d\'attente ?');">
                                    <i class="fas fa-clock"></i>
                                </a>
                            </c:if>
                        </c:when>
                        
  
                        <c:when test="${a.isCloturee()}">
                            <button class="btn btn-sm btn-secondary" disabled 
                                    data-bs-toggle="tooltip" title="Inscriptions closes">
                                <i class="fas fa-lock"></i>
                            </button>
                        </c:when>
                        
                        <%-- Case 5: Available for registration --%>
                        <c:otherwise>
                            <c:choose>
                                <c:when test="${a.capacite > 0}">
                                  <a href="${pageContext.request.contextPath}/participation?action=participer&id=${a.id}&redirect=participation.jsp" 
                                       class="btn btn-sm btn-success" 
                                       data-bs-toggle="tooltip" title="S'inscrire"
                                       onclick="return confirm('Confirmez votre participation ?');">
                                        <i class="fas fa-hand-holding-heart"></i>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <%-- Unlimited capacity activity --%>
                                    <a href="${pageContext.request.contextPath}/participation?action=participer&id=${a.id}&redirect=${pageContext.request.servletPath}" 
                                       class="btn btn-sm btn-info" 
                                       data-bs-toggle="tooltip" title="S'inscrire (capacité illimitée)"
                                       onclick="return confirm('Confirmez votre participation ?');">
                                        <i class="fas fa-hand-holding-heart"></i>
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>
</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
            
            <%-- Pagination --%>
            <c:if test="${totalPages > 1}">
                <div class="pagination-container">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <%-- Bouton Précédent --%>
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                            
                            <%-- Afficher les numéros de page --%>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <%-- Bouton Suivant --%>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });
    // Combined and optimized JavaScript
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize Bootstrap tooltips (both methods combined)
        const initTooltips = () => {
            // Vanilla JS method
            const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltipTriggerList.forEach(tooltipTriggerEl => {
                new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // jQuery method (if needed for other functionality)
            $('[data-bs-toggle="tooltip"]').tooltip();
        };
        
        // Responsive handling
        const checkScreenSize = () => {
            if (window.innerWidth < 992) {
                document.querySelectorAll('.activity-description').forEach(el => {
                    el.classList.add('truncate-text');
                });
            } else {
                document.querySelectorAll('.activity-description').forEach(el => {
                    el.classList.remove('truncate-text');
                });
            }
        };
        
        // Clock function
        const updateClock = () => {
            const now = new Date();
            const clockElement = document.getElementById('clock');
            if (clockElement) {
                clockElement.textContent = 
                    now.toLocaleTimeString('fr-FR', { 
                        hour: '2-digit', 
                        minute: '2-digit', 
                        second: '2-digit',
                        hour12: false 
                    }) + ' - ' + now.toLocaleDateString('fr-FR');
            }
        };
        
        // Debugging logs
        const logDebugInfo = () => {
            console.log("Données de session:", {
                user: "${user}",
                role: "${role}",
                activitesCount: "${fn:length(activites)}"
            });
            
            document.querySelectorAll('[data-activity-id]').forEach(btn => {
                console.log(`Bouton activité ${btn.dataset.activityId}:`, btn.outerHTML);
            });
        };
        
        // Initialize everything
        initTooltips();
        checkScreenSize();
        updateClock();
        setInterval(updateClock, 1000);
        window.addEventListener('resize', checkScreenSize);
        
        // Only log debug info in development
        if (window.location.hostname === "localhost" || window.location.hostname === "127.0.0.1") {
            logDebugInfo();
        }
    });
    //Initialisation des tooltips Bootstrap
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
    document.getElementById('current-year').textContent = new Date().getFullYear();
    </script>

    <footer class="bg-dark text-white py-3 mt-4">
        <div class="container text-center">
            <p class="mb-0">
                &copy; <span id="current-year"></span>
                Bénévol'Action - Tous droits réservés
            </p>
        </div>
    </footer>
</body>
</html>