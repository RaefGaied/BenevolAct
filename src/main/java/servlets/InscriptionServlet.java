package servlets;

import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.IUserDAO;
import dao.UserDAO;
import entities.Role;
import entities.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/InscriptionServlet")
public class InscriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private IUserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Récupération des paramètres du formulaire d'inscription
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String telephone = request.getParameter("telephone");

        // Vérification de la correspondance des mots de passe
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas !");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Validation de l'email (expression régulière)
        if (!email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("error", "Email invalide !");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Vérification si le nom d'utilisateur ou l'email existe déjà
        if (userDAO.findByNom(username) != null) {
            request.setAttribute("error", "Nom d'utilisateur déjà pris !");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (userDAO.findByEmail(email) != null) {
            request.setAttribute("error", "Email déjà utilisé !");
            request.getRequestDispatcher("inscription.jsp").forward(request, response);
            return;
        }

        // Hachage du mot de passe avant de l'enregistrer dans la base de données
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        // Création d'un nouvel utilisateur avec le rôle par défaut (USER) et la date d'inscription
        User user = new User(username, email, hashedPassword, new Date(), Role.USER, telephone);

        // Enregistrement de l'utilisateur dans la base de données
        userDAO.create(user);

        // Redirection vers la page de connexion avec un message de succès
        response.sendRedirect("login.jsp?message=Inscription réussie ! Vous pouvez maintenant vous connecter.");
    }

    @Override
    public void destroy() {
        UserDAO.close();
    }
}
