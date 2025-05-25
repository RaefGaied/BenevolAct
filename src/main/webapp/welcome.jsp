<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Bienvenue - Plateforme Bénévole</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="icon" href="${pageContext.request.contextPath}/images/volunteer.jpg">
    <style>
        body {
            margin: 0;
            padding: 0;
            height: 100vh;
            background: linear-gradient(120deg, #1e3c72, #2a5298);
            display: flex;
            justify-content: center;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            perspective: 1000px;
        }

        .welcome-box {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            text-align: center;
            padding: 50px 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
            color: white;
            transform: translateY(30px) rotateY(10deg);
            opacity: 0;
            animation: fadeInUp 1.2s forwards;
            transition: transform 0.5s ease;
            max-width: 500px;
        }

        .welcome-box:hover {
            transform: rotateY(0deg) translateY(-5px);
        }

        .welcome-box i {
            font-size: 60px;
            margin-bottom: 20px;
            color: #4CAF50;
            animation: pulse 2s infinite;
            transition: transform 0.3s ease;
        }

        .welcome-box i:hover {
            transform: scale(1.2) rotate(10deg);
        }

        .welcome-box h1 {
            font-size: 2.2rem;
            margin-bottom: 15px;
        }

        .welcome-box p {
            margin-bottom: 30px;
            font-size: 1rem;
            line-height: 1.6;
        }

        .btn-custom {
            width: 180px;
            margin: 10px;
            font-size: 17px;
            padding: 12px;
            border-radius: 30px;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .btn-primary {
            background-color: #3a7bd5;
            border-color: #3a7bd5;
        }

        .btn-success {
            background-color: #4CAF50;
            border-color: #4CAF50;
        }

        .btn-custom:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        }

        @keyframes fadeInUp {
            to {
                transform: rotateY(0deg) translateY(0);
                opacity: 1;
            }
        }

        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.15);
            }
        }

        .features {
            display: flex;
            justify-content: space-around;
            margin-top: 30px;
            flex-wrap: wrap;
        }

        .feature {
            margin: 10px;
            font-size: 0.9rem;
        }

        .feature i {
            font-size: 24px;
            margin-bottom: 8px;
            color: #FFD700;
        }
    </style>
</head>
<body>

    <div class="welcome-box">
        <i class="fas fa-hands-helping"></i>
        <h1>Engagez-vous pour la communauté</h1>
        <p>Rejoignez notre plateforme de bénévolat et participez à des activités enrichissantes. Suivez vos engagements et obtenez des badges pour votre contribution.</p>
        
        <div class="features">
            <div class="feature">
                <i class="fas fa-calendar-check"></i>
                <div>Inscription aux activités</div>
            </div>
            <div class="feature">
                <i class="fas fa-chart-line"></i>
                <div>Suivi de participation</div>
            </div>
            <div class="feature">
                <i class="fas fa-award"></i>
                <div>Badges de reconnaissance</div>
            </div>
        </div>
        
        <a href="login.jsp" class="btn btn-primary btn-custom">Se connecter</a>
        <a href="register.jsp" class="btn btn-success btn-custom">S'inscrire</a>
    </div>

</body>
</html>