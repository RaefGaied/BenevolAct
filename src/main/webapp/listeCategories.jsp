<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des Catégories</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/categorie.css">
</head>

<body>

<nav class="navbar navbar-expand-lg fixed-top px-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/categories">
            <i class="fas fa-hands-helping"></i> Bénévol'Action
        </a>
        <div class="collapse navbar-collapse justify-content-end">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="acceuil.jsp">
                        <i class="fas fa-home"></i> Accueil
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="ajouterActivite.jsp">
                        <i class="fas fa-plus-circle"></i> Ajouter Activité
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="content-wrapper">
    <div class="container">
        <div class="card-glass">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-tags me-2"></i> Liste des Catégories</h2>
                <button id="toggleFormBtn" class="btn-neon btn-add" <c:if test="${isEditing}">disabled</c:if>>
                    <i class="fas fa-plus rotate-icon"></i> 
                    <span id="btnText">Nouvelle Catégorie</span>
                </button>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="fas fa-check-circle me-2"></i> <c:out value="${success}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="fas fa-exclamation-triangle me-2"></i> <c:out value="${error}" />
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <div id="formContainer" class="form-container <c:if test='${isEditing}'>show</c:if>">
                <form action="${pageContext.request.contextPath}/<c:out value='${isEditing ? "updateCategorie" : "addCategorie"}'/>" method="post">
                    <c:if test="${isEditing}">
                        <input type="hidden" name="id" value="${editingCategory.id}" />
                    </c:if>

                    <h5 class="form-title">
                        <i class="fas <c:out value='${isEditing ? "fa-edit" : "fa-plus-circle"}' /> me-2"></i>
                        <c:out value='${isEditing ? "Modifier la catégorie" : "Ajouter une nouvelle catégorie"}' />
                    </h5>

                    <div class="mb-3">
                        <label for="nom" class="form-label">Nom</label>
                        <input type="text" class="form-control" id="nom" name="nom"
                               value="<c:out value='${isEditing ? editingCategory.nom : ""}' />" required />
                    </div>

                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3"
                                  required><c:out value='${isEditing ? editingCategory.description : ""}' /></textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-neon">
                            <i class="fas fa-save me-1"></i> Enregistrer
                        </button>
                        <c:choose>
                            <c:when test="${isEditing}">
                                <a href="${pageContext.request.contextPath}/categories" class="btn-neon btn-red">
                                    <i class="fas fa-times me-1"></i> Annuler
                                </a>
                            </c:when>
                            <c:otherwise>
                                <button type="button" id="cancelBtn" class="btn-neon btn-red">
                                    <i class="fas fa-times me-1"></i> Annuler
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </div>

            <div class="table-responsive" style="overflow: visible;">
                <table class="table table-hover align-middle" style="opacity: 1 !important; visibility: visible !important;">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Description</th>
                            <th>Nombre d'activités</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty categories}">
                                <tr>
                                    <td colspan="5" class="text-center py-4">
                                        <i class="fas fa-inbox fa-2x mb-3 text-muted"></i><br>
                                        <span class="text-muted">Aucune catégorie disponible</span>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                               <c:forEach items="${categories}" var="categorie">
    <c:if test="${categorie.id != lastId}">
        <tr>
            <td>${categorie.id}</td>
            <td><strong>${categorie.nom}</strong></td>
            <td>
                <small class="text-muted">
                    ${empty categorie.description ? 'Aucune description' : categorie.description}
                </small>
            </td>
            <td>
                <span class="badge bg-primary rounded-pill">
                    ${categorie.activites != null ? fn:length(categorie.activites) : 0} activités
                </span>
            </td>
            <td>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/editCategorie?id=${categorie.id}" 
                       class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                    <a href="${pageContext.request.contextPath}/deleteCategorie?id=${categorie.id}" 
                       class="btn btn-sm btn-outline-danger"
                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette catégorie ? Les activités associées seront dissociées.');">
                        <i class="fas fa-trash-alt"></i> Supprimer
                    </a>
                </div>
            </td>
        </tr>
        <c:set var="lastId" value="${categorie.id}" />
    </c:if>
</c:forEach>

                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const formContainer = document.getElementById('formContainer');
        const toggleBtn = document.getElementById('toggleFormBtn');
        const cancelBtn = document.getElementById('cancelBtn');
        const btnText = document.getElementById('btnText');
        const plusIcon = document.querySelector('.rotate-icon');

        const isEditing = ${isEditing ? 'true' : 'false'};

        if (toggleBtn && !isEditing) {
            toggleBtn.addEventListener('click', function () {
                formContainer.classList.toggle('show');
                plusIcon.classList.toggle('rotated');
                btnText.textContent = formContainer.classList.contains('show') ? 'Annuler' : 'Nouvelle Catégorie';
                toggleBtn.classList.toggle('btn-add');
                toggleBtn.classList.toggle('btn-red');
            });
        }

        if (cancelBtn) {
            cancelBtn.addEventListener('click', function () {
                formContainer.classList.remove('show');
                plusIcon.classList.remove('rotated');
                btnText.textContent = 'Nouvelle Catégorie';
                toggleBtn.classList.remove('btn-red');
                toggleBtn.classList.add('btn-add');
            });
        }

        document.querySelectorAll('.alert').forEach(alert => {
            setTimeout(() => {
                alert.classList.add('fade');
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });

        document.querySelectorAll('tbody tr').forEach(row => {
            row.addEventListener('mouseenter', () => row.style.transform = 'translateX(5px)');
            row.addEventListener('mouseleave', () => row.style.transform = '');
        });
    });
</script>
</body>
</html>