package servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.GestionActiviteJPA;
import dao.IGestionActivite;
import entities.Activite;
import entities.User;

@WebServlet(name = "ParticipationServlet", urlPatterns = {"/participation", "/participer"})
public class ParticiperActiviteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IGestionActivite gestionActivite;

    @Override
    public void init() throws ServletException {
        this.gestionActivite = new GestionActiviteJPA();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            session.setAttribute("error", "Vous devez être connecté pour voir vos participations");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Récupérer les activités où l'utilisateur participe
            List<Activite> activitesParticipantes = gestionActivite.getActivitesByParticipant(user.getId());
            
            // Récupérer les activités où l'utilisateur est en liste d'attente
            List<Activite> activitesEnAttente = gestionActivite.getActivitesEnAttente(user.getId());
            
            // Créer une liste de maps pour transférer les données à la JSP
            List<Map<String, Object>> participations = new ArrayList<>();
            
            // Ajouter les participations confirmées
            for (Activite activite : activitesParticipantes) {
                Map<String, Object> participation = new HashMap<>();
                participation.put("activite", activite);
                participation.put("confirme", true);
                participation.put("enAttente", false);
                participations.add(participation);
            }
            
            // Ajouter les participations en attente
            for (Activite activite : activitesEnAttente) {
                Map<String, Object> participation = new HashMap<>();
                participation.put("activite", activite);
                participation.put("confirme", false);
                participation.put("enAttente", true);
                participations.add(participation);
            }
            
            // Trier par date d'activité (du plus récent au plus ancien)
            participations.sort((p1, p2) -> {
                Date date1 = ((Activite)p1.get("activite")).getDateActivite();
                Date date2 = ((Activite)p2.get("activite")).getDateActivite();
                return date2.compareTo(date1);
            });
            
            request.setAttribute("participations", participations);
            transferSessionMessagesToRequest(session, request);
            request.getRequestDispatcher("/participation.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du chargement des participations: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/activities");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String referer = request.getHeader("referer");
        
        try {
            // Vérifier que l'utilisateur est connecté
            User user = (User) session.getAttribute("user");
            if (user == null) {
                session.setAttribute("error", "Vous devez être connecté pour participer");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            // Récupérer les paramètres
            String action = request.getParameter("action");
            String idParam = request.getParameter("id");
            
            // Validation des paramètres
            if (action == null || idParam == null || !idParam.matches("\\d+")) {
                session.setAttribute("error", "Paramètres de requête invalides");
                response.sendRedirect(getFallbackRedirect(referer, request));
                return;
            }
            
            Long activiteId = Long.parseLong(idParam);
            
            // Traitement selon l'action
            String message = "";
            boolean success = false;
            
            switch(action.toLowerCase()) {
                case "participer":
                    success = gestionActivite.addParticipation(user.getId(), activiteId);
                    message = success ? "Inscription confirmée!" : "Impossible de participer";
                    break;
                    
                case "annuler":
                    success = gestionActivite.cancelParticipation(user.getId(), activiteId);
                    message = success ? "Participation annulée avec succès" : "Annulation impossible";
                    break;
                    
                case "rejoindrelisteattente":
                    success = gestionActivite.joinWaitingList(user.getId(), activiteId);
                    message = success ? "Ajouté à la liste d'attente" : "Impossible de rejoindre la liste";
                    break;
                    
                case "quitterlisteattente":
                    success = gestionActivite.leaveWaitingList(user.getId(), activiteId);
                    message = success ? "Retiré de la liste d'attente" : "Impossible de quitter la liste";
                    break;
                    
                default:
                    message = "Action non reconnue";
            }
            
            // Gestion du résultat
            if (success) {
                session.setAttribute("success", message);
                if ("participer".equalsIgnoreCase(action)) {
                    session.setAttribute("lastParticipation", gestionActivite.getActiviteById(activiteId));
                }
            } else {
                String errorDetail = gestionActivite.getLastError();
                session.setAttribute("error", message + (errorDetail != null ? ": " + errorDetail : ""));
            }
            
            // Redirection
            response.sendRedirect("participer".equalsIgnoreCase(action) && success 
                ? request.getContextPath() + "/participation" 
                : getFallbackRedirect(referer, request));
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID d'activité invalide");
            response.sendRedirect(getFallbackRedirect(referer, request));
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur système: " + e.getMessage());
            response.sendRedirect(getFallbackRedirect(referer, request));
        }
    }
    
    private String getFallbackRedirect(String referer, HttpServletRequest request) {
        return referer != null && !referer.contains("participation") 
            ? referer 
            : request.getContextPath() + "/activities";
    }
    
    private void transferSessionMessagesToRequest(HttpSession session, HttpServletRequest request) {
        String[] attributes = {"success", "error", "errorDetail", "lastParticipation"};
        for (String attr : attributes) {
            if (session.getAttribute(attr) != null) {
                request.setAttribute(attr, session.getAttribute(attr));
                session.removeAttribute(attr);
            }
        }
    }
}