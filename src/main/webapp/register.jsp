<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Inscription</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: white;
            margin: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .card-glass {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 500px;
            backdrop-filter: blur(20px);
            box-shadow: 0 8px 32px rgba(0, 255, 255, 0.3);
            animation: fadeIn 1s ease;
        }
        
        .card-glass h2 {
            color: #00ffff;
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: none;
            color: white;
            border-radius: 12px;
            padding: 12px 20px 12px 45px;
        }
        
        .form-control:focus {
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 12px rgba(0, 191, 255, 0.7);
            color: white;
        }
        
        .input-group {
            position: relative;
            margin-bottom: 20px;
        }
        
        .input-group i {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            font-size: 16px;
            z-index: 5;
        }
        
        .btn-neon {
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-weight: bold;
            color: white;
            background: linear-gradient(90deg, #00ffff, #00e6e6);
            box-shadow: 0 0 10px rgba(0, 255, 255, 0.6);
            transition: all 0.3s;
            width: 100%;
            margin-top: 10px;
        }
        
        .btn-neon:hover {
            background: linear-gradient(90deg, #00e6e6, #00ffff);
            box-shadow: 0 0 20px rgba(0, 255, 255, 0.9);
            transform: translateY(-2px);
        }
        
        .login-link {
            margin-top: 20px;
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
        }
        
        .login-link a {
            color: #00ffff;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
        }
        
        .login-link a:hover {
            text-decoration: underline;
            color: #00e6e6;
        }
        
        .alert {
            background-color: rgba(255, 0, 0, 0.2);
            border: none;
            color: #ff4d4d;
            border-radius: 10px;
            padding: 12px;
            text-align: center;
            margin-bottom: 20px;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="card-glass">
    <h2><i class="fas fa-user-plus me-2"></i> Créer un Compte</h2>
    
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert">
            <i class="fas fa-exclamation-triangle me-2"></i> ${error}
        </div>
    <% } %>
    
    <form action="InscriptionServlet" method="post">
        <div class="input-group">
            <i class="fas fa-user"></i>
            <input type="text" class="form-control" id="username" name="username" 
                   placeholder="Nom d'utilisateur" required>
        </div>
        
        <div class="input-group">
            <i class="fas fa-envelope"></i>
            <input type="email" class="form-control" id="email" name="email" 
                   placeholder="Email" required>
        </div>
        
        <div class="input-group">
            <i class="fas fa-lock"></i>
            <input type="password" class="form-control" id="password" name="password" 
                   placeholder="Mot de passe" required>
        </div>
        
        <div class="input-group">
            <i class="fas fa-lock"></i>
            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                   placeholder="Confirmer le mot de passe" required>
        </div>
        
        <div class="input-group">
            <i class="fas fa-phone"></i>
            <input type="tel" class="form-control" id="telephone" name="telephone" 
                   placeholder="Téléphone">
        </div>
        
        <button type="submit" class="btn-neon">
            <i class="fas fa-user-check me-2"></i> S'inscrire
        </button>
    </form>
    
    <p class="login-link">
        Déjà un compte ? <a href="login.jsp"><i class="fas fa-sign-in-alt me-1"></i> Se connecter</a>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-dismiss alert after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        const alert = document.querySelector('.alert');
        if (alert) {
            setTimeout(() => {
                alert.classList.add('fade');
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        }
    });
</script>
</body>
</html>