package servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;
import dao.UserDAO;
import entities.Role;
import entities.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Définir les credentials admin de manière sécurisée
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PLAIN_PASSWORD = "admin";
    private static final String ADMIN_HASHED_PASSWORD = BCrypt.hashpw(ADMIN_PLAIN_PASSWORD, BCrypt.gensalt());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	String username = request.getParameter("nom");
    	String password = request.getParameter("motDePasse");


        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("login.jsp?error=empty");
            return;
        }

        HttpSession session = request.getSession();

        try {
            // 1. Vérification admin
            if (ADMIN_USERNAME.equals(username)) {
                if (BCrypt.checkpw(password, ADMIN_HASHED_PASSWORD)) {
                    User adminUser = createAdminUser();
                    setupUserSession(session, adminUser);
                    response.sendRedirect("acceuil.jsp");
                    return;
                }
                response.sendRedirect("login.jsp?error=invalid");
                return;
            }

            // 2. Vérification utilisateur normal
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByNom(username);

            if (user != null && BCrypt.checkpw(password, user.getMotDePasse())) {
                setupUserSession(session, user);
                response.sendRedirect("acceuil.jsp");
            } else {
                response.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=system");
        }
    }

    private User createAdminUser() {
        User admin = new User();
        admin.setNom(ADMIN_USERNAME);
        admin.setEmail("admin@example.com");
        admin.setRole(Role.ORGANISATEUR);
        admin.setMotDePasse(ADMIN_HASHED_PASSWORD);
        return admin;
    }

    private void setupUserSession(HttpSession session, User user) {
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole().toString());
        session.setAttribute("userId", user.getId());
        session.setMaxInactiveInterval(30 * 60);
    }

}