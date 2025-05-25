<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Google Fonts - Roboto -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Roboto', sans-serif;
            height: 100vh;
            background: linear-gradient(120deg, #0f2027, #203a43, #2c5364);
            display: flex;
            justify-content: center;
            align-items: center;
            color: white;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            backdrop-filter: blur(15px);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.5);
        }

        .login-card h3 {
            text-align: center;
            margin-bottom: 30px;
            font-weight: 700;
            color: white;
        }

        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: none;
            color: white;
            border-radius: 12px;
            padding-left: 40px;
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 12px rgba(0, 191, 255, 0.7);
            color: white;
        }

        .input-group {
            position: relative;
        }

        .input-group i {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: rgba(255, 255, 255, 0.7);
            font-size: 16px;
        }

        .btn-login {
            background: linear-gradient(90deg, #00c6ff, #0072ff);
            border: none;
            color: white;
            font-weight: 600;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            background: linear-gradient(90deg, #0072ff, #00c6ff);
            box-shadow: 0 0 15px rgba(0, 191, 255, 0.8);
        }

        .signup-link {
            margin-top: 15px;
            display: block;
            text-align: center;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-weight: 500;
        }

        .signup-link:hover {
            color: #00c6ff;
            text-decoration: underline;
        }

        .alert {
            background-color: rgba(255, 0, 0, 0.2);
            border: none;
            color: #ff4d4d;
            border-radius: 10px;
            padding: 10px;
            text-align: center;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

<div class="login-card">
    <h3><i class="fas fa-user-circle me-2"></i> Connexion</h3>

    <% String error = request.getParameter("error"); %>
    <% if (error != null) { %>
    <div class="alert">
        <i class="fas fa-exclamation-triangle me-1"></i> Nom d'utilisateur ou mot de passe incorrect.
    </div>
    <% } %>

   <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
    <div class="mb-3 input-group">
        <i class="fas fa-user"></i>
        <input type="text" name="nom" class="form-control" placeholder="Nom d'utilisateur" required>
    </div>

    <div class="mb-3 input-group">
        <i class="fas fa-lock"></i>
        <input type="password" name="motDePasse" class="form-control" placeholder="Mot de passe" required>
    </div>

    <button type="submit" class="btn btn-login w-100 mt-3">
        <i class="fas fa-sign-in-alt me-2"></i> Se connecter
    </button>
</form>

    <a href="register.jsp" class="signup-link">
        <i class="fas fa-user-plus me-1"></i> Créer un compte
    </a>
</div>

</body>
</html>
