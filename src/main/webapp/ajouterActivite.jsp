<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>${activite != null ? 'Modifier' : 'Ajouter'} une Activité</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/volunteer.jpg">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: white;
            margin: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .navbar {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(8px);
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.1);
        }
        .navbar .navbar-brand {
            color: #00e6e6;
            font-weight: bold;
            font-size: 22px;
        }
        .navbar .nav-link {
            color: #ffffff !important;
            transition: 0.3s ease-in-out;
        }
        .navbar .nav-link:hover {
            color: #00ffff !important;
        }
        .form-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .card-glass {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 35px;
            backdrop-filter: blur(20px);
            box-shadow: 0 8px 32px rgba(0, 255, 255, 0.3);
            width: 100%;
            max-width: 700px;
            animation: fadeIn 1s ease;
        }
        .card-glass h2 {
            color: #00ffff;
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 25px;
            text-align: center;
        }
        label {
            font-weight: 500;
            color: #ffffff;
        }
        input, textarea, select {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 10px;
            padding: 10px;
            color: #fff;
            width: 100%;
        }
        input:focus, textarea:focus, select:focus {
            background: rgba(0, 255, 255, 0.1);
            border-color: #00ffff;
            box-shadow: 0 0 10px #00ffff;
            color: #fff;
        }
        .btn-neon {
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: bold;
            color: white;
            background: linear-gradient(90deg, #00ffff, #00e6e6);
            box-shadow: 0 0 15px rgba(0, 255, 255, 0.6);
            transition: 0.3s;
        }
        .btn-neon:hover {
            background: linear-gradient(90deg, #00e6e6, #00ffff);
            box-shadow: 0 0 25px rgba(0, 255, 255, 0.9);
            color: white;
        }
        .btn-red {
            background: linear-gradient(90deg, #ff4d4d, #ff0000);
            box-shadow: 0 0 15px rgba(255, 0, 0, 0.6);
        }
        .btn-red:hover {
            box-shadow: 0 0 25px rgba(255, 0, 0, 0.9);
        }
        img.preview-img {
            max-height: 220px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.3);
            transition: transform 0.3s ease;
        }
        img.preview-img:hover {
            transform: scale(1.05);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        /* Custom checkbox styling */
        .form-check-input {
            width: 1.2em;
            height: 1.2em;
            margin-top: 0.2em;
            background-color: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.5);
        }
        .form-check-input:checked {
            background-color: #00ffff;
            border-color: #00ffff;
        }
        .form-check-input:focus {
            box-shadow: 0 0 0 0.25rem rgba(0, 255, 255, 0.25);
        }
        .form-check-label {
            margin-left: 0.5em;
            cursor: pointer;
        }
    </style>
</head>

<body>
<nav class="navbar navbar-expand-lg fixed-top px-4">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home"><i class="fas fa-hands-helping"></i> Bénévol'Action</a>
        <div class="collapse navbar-collapse justify-content-end">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home"><i class="fas fa-home"></i> Accueil</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="form-wrapper">
    <div class="card-glass">
        <h2>
            <i class="fas fa-${activite != null ? 'edit' : 'plus-circle'} me-2"></i>
            ${activite != null ? 'Modifier' : 'Ajouter'} une Activité
        </h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><i class="fas fa-exclamation-triangle me-2"></i> ${error}</div>
        </c:if>
<form method="post" action="${pageContext.request.contextPath}/add-activity" enctype="multipart/form-data" novalidate>
    <c:if test="${activite != null}">
        <input type="hidden" name="action" value="update" />
        <input type="hidden" name="activiteId" value="${activite.id}" />
    </c:if>

    <div class="mb-3">
        <label for="titre" class="form-label">Titre <span class="text-danger" aria-hidden="true">*</span><span class="visually-hidden">requis</span></label>
        <c:set var="escapedTitre" value="${fn:escapeXml(activite.titre)}" />
        <input type="text" class="form-control" id="titre" name="titre" 
               value="${activite != null ? escapedTitre : ''}" 
               required aria-required="true"
               aria-describedby="titreHelp">
        <div id="titreHelp" class="form-text text-light">Donnez un titre clair et concis à votre activité</div>
    </div>

    <div class="mb-3">
        <label for="description" class="form-label">Description <span class="text-danger">*</span></label>
        <textarea class="form-control" id="description" name="description" rows="3" required aria-required="true">${activite != null ? activite.description : ''}</textarea>
    </div>

    <div class="row">
        <div class="col-md-6 mb-3">
            <label for="lieu" class="form-label">Lieu <span class="text-danger">*</span></label>
            <input type="text" class="form-control" id="lieu" name="lieu" value="${activite != null ? activite.lieu : ''}" required>
        </div>
        <div class="col-md-6 mb-3">
            <label for="date" class="form-label">Date de clôture <span class="text-danger">*</span></label>
            <input type="datetime-local" class="form-control" id="date" name="date" 
                   value="${activite != null ? activite.dateCloture : ''}" 
                   min="${LocalDate.now()}" 
                   required>
            <div class="form-text text-light">
                Sélectionnez la date et l'heure de clôture de l'activité
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-6 mb-3">
            <label for="capacite" class="form-label">Capacité <span class="text-danger">*</span></label>
            <input type="number" class="form-control" id="capacite" name="capacite" min="1" value="${activite != null ? activite.capacite : 10}" required>
        </div>
        <div class="col-md-6 mb-3">
            <label for="categorie" class="form-label">Catégorie <span class="text-danger">*</span></label>
            <select class="form-control" id="categorie" name="categorie" required>
                <option value="" disabled ${activite == null ? 'selected' : ''}>Choisir une catégorie</option>
                <c:forEach var="categorie" items="${categories}">
                    <option value="${categorie.id}" ${activite != null && activite.categorie.id == categorie.id ? 'selected' : ''}>${categorie.nom}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="mb-3">
        <div class="form-check">
            <input class="form-check-input" type="checkbox" id="urgent" name="urgent" ${activite != null && activite.urgent ? 'checked' : ''}>
            <label class="form-check-label" for="urgent">Activité urgente</label>
        </div>
    </div>

    <div class="mb-3">
        <label for="image" class="form-label">Image illustrative</label>
        <input type="file" class="form-control" id="image" name="image" accept="image/*">
        <small class="text-muted">Formats acceptés: JPG, PNG (max 5MB)</small>
    </div>

    <div id="imagePreview" class="text-center" style="display: ${activite != null && not empty activite.imageUrl ? 'block' : 'none'};">
        <img id="previewImage" class="preview-img img-fluid" 
             src="${activite != null && not empty activite.imageUrl ? pageContext.request.contextPath.concat('/assets/images/').concat(activite.imageUrl) : ''}" 
             alt="Image prévisualisée">
        <c:if test="${activite != null && not empty activite.imageUrl}">
            <div class="mt-2">
                <button type="button" class="btn btn-sm btn-outline-danger" id="removeImage">
                    <i class="fas fa-trash-alt me-1"></i> Supprimer l'image
                </button>
                <input type="hidden" id="currentImage" name="currentImage" value="${activite.imageUrl}">
            </div>
        </c:if>
    </div>

    <div class="d-flex justify-content-between mt-4">
        <button type="submit" class="btn-neon">
            <i class="fas fa-save me-2"></i>
            <c:choose>
                <c:when test="${not empty activite}">Modifier</c:when>
                <c:otherwise>Ajouter</c:otherwise>
            </c:choose>
        </button>
        <a href="${pageContext.request.contextPath}/home" class="btn-neon btn-red">
            <i class="fas fa-times me-2"></i> Annuler
        </a>
    </div>
</form>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('image').addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(event) {
                const preview = document.getElementById('previewImage');
                preview.src = event.target.result;
                document.getElementById('imagePreview').style.display = 'block';
            };
            reader.readAsDataURL(file);
        }
    });

    document.getElementById('removeImage')?.addEventListener('click', function() {
        document.getElementById('imagePreview').style.display = 'none';
        document.getElementById('image').value = '';
        document.getElementById('currentImage').value = '';
    });

    document.querySelector('form').addEventListener('submit', function(e) {
        // Validation du titre
        const titre = document.getElementById('titre').value.trim();
        if (!titre) {
            e.preventDefault();
            alert('Le titre est obligatoire');
            document.getElementById('titre').focus();
            return false;
        }

        // Validation de la description
        const description = document.getElementById('description').value.trim();
        if (!description) {
            e.preventDefault();
            alert('La description est obligatoire');
            document.getElementById('description').focus();
            return false;
        }

        // Validation du lieu
        const lieu = document.getElementById('lieu').value.trim();
        if (!lieu) {
            e.preventDefault();
            alert('Le lieu est obligatoire');
            document.getElementById('lieu').focus();
            return false;
        }

        // Validation de la date
        const dateInput = document.getElementById('date');
        const dateValue = dateInput.value;
        if (!dateValue || dateValue.trim() === '') {
            e.preventDefault();
            alert('La date de clôture est obligatoire');
            dateInput.focus();
            return false;
        }
        
        const selectedDate = new Date(dateValue);
        const now = new Date();
        if (selectedDate <= now) {
            e.preventDefault();
            alert('La date de clôture doit être dans le futur');
            dateInput.focus();
            return false;
        }

        // Validation de la capacité
        const capacite = document.getElementById('capacite').value;
        if (!capacite || capacite < 1) {
            e.preventDefault();
            alert('La capacité doit être supérieure à 0');
            document.getElementById('capacite').focus();
            return false;
        }

        // Validation de la catégorie
        const categorie = document.getElementById('categorie').value;
        if (!categorie) {
            e.preventDefault();
            alert('Veuillez sélectionner une catégorie');
            document.getElementById('categorie').focus();
            return false;
        }

        // Validation de l'image
        const imageInput = document.getElementById('image');
        if (imageInput.files.length > 0) {
            const file = imageInput.files[0];
            const maxSize = 5 * 1024 * 1024; // 5MB
            if (file.size > maxSize) {
                e.preventDefault();
                alert('L\'image ne doit pas dépasser 5MB');
                return false;
            }
            
            const validTypes = ['image/jpeg', 'image/png'];
            if (!validTypes.includes(file.type)) {
                e.preventDefault();
                alert('Format d\'image invalide. Utilisez JPG ou PNG');
                return false;
            }
        }
    });
</script>

</body>
</html>