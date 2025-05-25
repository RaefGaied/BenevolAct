package servlets;

import dao.GestionActiviteJPA;
import dao.GestionCategorieJPA;
import dao.IGestionActivite;
import dao.IGestionCategorie;
import dao.IUserDAO;
import dao.UserDAO;
import entities.Activite;
import entities.Categorie;
import utils.FileUploadUtil;
import utils.DateTimeUtil;
import entities.Role;
import entities.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import org.apache.taglibs.standard.lang.jstl.parser.ParseException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@WebServlet(urlPatterns = {
    "/", "/home",
    "/activities", "/search-activities", "/my-activities",
    "/delete-activity", "/add-activity", "/edit-activity"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1MB
    maxFileSize = 1024 * 1024 * 10,     // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class ListeActivitesServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IGestionActivite gestionActivite;
    private IGestionCategorie gestionCategorie;
    private IUserDAO userDAO;

    @Override
    public void init() throws ServletException {
        this.gestionActivite = new GestionActiviteJPA();
        this.gestionCategorie = new GestionCategorieJPA();
        this.userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        String path = request.getServletPath();
        boolean publicPath = path.equals("/");

        if (!publicPath && (session == null || session.getAttribute("user") == null)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            switch (path) {
                case "/":
                case "/home":
                    handleHome(request, response);
                    break;
                case "/activities":
                    handleActivities(request, response);
                    break;
                case "/search-activities":
                    handleSearch(request, response);
                    break;
                case "/my-activities":
                    handleMyActivities(request, response);
                    break;
                case "/delete-activity":
                    handleDeleteActivity(request, response);
                    break;
                case "/add-activity":  // Nouveau cas pour l'ajout
                    handleAddActivityForm(request, response);
                    break;
                case "/edit-activity": // Nouveau cas pour la modification
                    handleEditActivity(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("error", "Une erreur est survenue: " + e.getMessage());
            }
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String path = request.getServletPath();
        try {
            switch (path) {
                case "/add-activity":
                    handleAddActivity(request, response);
                    break;
                case "/edit-activity":
                    handleEditActivity(request, response);
                    break;
                case "/delete-activity":
                    handleDeleteActivity(request, response);
                    break;
                default:
                    doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du traitement: " + e.getMessage());
            response.sendRedirect(getRedirectUrl(request));
        }
    }

    private void handleAddActivityForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole() != Role.ORGANISATEUR) {
            session.setAttribute("error", "Accès réservé aux organisateurs");
            response.sendRedirect(request.getContextPath() + "/activities");
            return;
        }

        List<Categorie> categories = gestionCategorie.listerToutesLesCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/ajouterActivite.jsp").forward(request, response);
    }

    private void handleAddActivity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole() != Role.ORGANISATEUR) {
            session.setAttribute("error", "Accès réservé aux organisateurs");
            response.sendRedirect(request.getContextPath() + "/activities");
            return;
        }

        try {
            String titre = request.getParameter("titre");
            String description = request.getParameter("description");
            String lieu = request.getParameter("lieu");
            String dateActiviteStr = request.getParameter("dateActivite");
            String dateClotureStr = request.getParameter("dateCloture"); // Correction du nom du paramètre
            int capacite = Integer.parseInt(request.getParameter("capacite"));
            Long categorieId = Long.parseLong(request.getParameter("categorie"));
            boolean urgent = request.getParameter("urgent") != null;
            
            if (titre == null || titre.isEmpty() || description == null || description.isEmpty()) {
                throw new IllegalArgumentException("Titre et description sont obligatoires");
            }

            // Traitement des dates
            Date dateActivite = null;
            Date dateCloture = null;
            
            if (dateActiviteStr != null && !dateActiviteStr.isEmpty()) {
                dateActivite = DateTimeUtil.parseDateTime(dateActiviteStr);
            }
            if (dateClotureStr != null && !dateClotureStr.isEmpty()) {
                dateCloture = DateTimeUtil.parseDateTime(dateClotureStr);
            }

            // Traitement de l'image
            Part filePart = request.getPart("image");
            String imageUrl = null;
            if (filePart != null && filePart.getSize() > 0) {
                imageUrl = FileUploadUtil.processUpload(filePart, getServletContext());
                if (imageUrl != null && imageUrl.startsWith(getServletContext().getRealPath("/"))) {
                    imageUrl = imageUrl.substring(getServletContext().getRealPath("/").length());
                }
            }

            // Création de l'activité
            Activite activite = new Activite();
            activite.setTitre(titre);
            activite.setDescription(description);
            activite.setLieu(lieu);
            activite.setDateActivite(dateActivite);
            if (dateCloture != null) { // Vérification de la date de clôture
                activite.setDateCloture(dateCloture);
            }
            activite.setCapacite(capacite);
            activite.setUrgent(urgent);
            activite.setImageUrl(imageUrl);

            // Association directe de l'utilisateur à l'activité
            activite.setOrganisateur(user);

            // Association de la catégorie
            Categorie categorie = gestionCategorie.trouverCategorieParId(categorieId);
            if (categorie == null) {
                throw new IllegalStateException("Catégorie non trouvée");
            }
            activite.setCategorie(categorie);

            // Sauvegarde
            gestionActivite.ajouterActivite(activite);

            session.setAttribute("success", "Activité ajoutée avec succès");
            response.sendRedirect(request.getContextPath() + "/activities");
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de l'ajout: " + e.getMessage());
            
            List<Categorie> categories = gestionCategorie.listerToutesLesCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("formData", request.getParameterMap());
            request.getRequestDispatcher("/ajouterActivite.jsp").forward(request, response);
        }
    }

    private void handleEditActivity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole() != Role.ORGANISATEUR) {
            session.setAttribute("error", "Accès réservé aux organisateurs");
            response.sendRedirect(request.getContextPath() + "/activities");
            return;
        }

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Activite activite = gestionActivite.getActiviteById(id);

            if (activite == null) {
                session.setAttribute("error", "Activité introuvable");
                response.sendRedirect(request.getContextPath() + "/activities");
                return;
            }

            if (!activite.getOrganisateur().equals(user)) {
                session.setAttribute("error", "Vous n'êtes pas l'organisateur de cette activité");
                response.sendRedirect(request.getContextPath() + "/activities");
                return;
            }

            // Récupération des paramètres
            String titre = request.getParameter("titre");
            String description = request.getParameter("description");
            String lieu = request.getParameter("lieu");
            String dateStr = request.getParameter("dateActivite");
            String dateClotureStr = request.getParameter("dateCloture");
            int capacite = Integer.parseInt(request.getParameter("capacite"));
            Long categorieId = Long.parseLong(request.getParameter("categorie"));
            boolean urgent = request.getParameter("urgent") != null;
            
            // Traitement des dates
            Date dateActivite = DateTimeUtil.parseDateTime(dateStr);
            Date dateCloture = null;
            if (dateClotureStr != null && !dateClotureStr.isEmpty()) {
                dateCloture = DateTimeUtil.parseDateTime(dateClotureStr);
            }

            // Traitement de l'image
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String imageUrl = FileUploadUtil.processUpload(filePart, getServletContext());
                if (imageUrl != null && imageUrl.startsWith(getServletContext().getRealPath("/"))) {
                    imageUrl = imageUrl.substring(getServletContext().getRealPath("/").length());
                }
                activite.setImageUrl(imageUrl);
            }

            // Mise à jour des propriétés
            activite.setTitre(titre);
            activite.setDescription(description);
            activite.setLieu(lieu);
            activite.setDateActivite(dateActivite);
            activite.setDateCloture(dateCloture); // Peut être null
            activite.setCapacite(capacite);
            activite.setUrgent(urgent);

            // Mise à jour de la catégorie
            Categorie categorie = gestionCategorie.trouverCategorieParId(categorieId);
            activite.setCategorie(categorie);

            // Sauvegarde
            gestionActivite.updateActivite(activite);

            session.setAttribute("success", "Activité modifiée avec succès");
            response.sendRedirect(request.getContextPath() + "/activities");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors de la modification: " + e.getMessage());
            
            
            List<Categorie> categories = gestionCategorie.listerToutesLesCategories();
            request.setAttribute("categories", categories);
            request.setAttribute("formData", request.getParameterMap());
            request.setAttribute("activite", gestionActivite.getActiviteById(Long.parseLong(request.getParameter("id"))));
            request.getRequestDispatcher("/ajouterActivite.jsp").forward(request, response);
        }
    }
    private void handleDeleteActivity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("error", "Vous devez être connecté pour supprimer une activité");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            session.setAttribute("error", "ID d'activité manquant");
            response.sendRedirect(getRedirectUrl(request));
            return;
        }

        try {
            long id = Long.parseLong(idStr);
            Activite activite = gestionActivite.getActiviteById(id);

            if (activite == null) {
                session.setAttribute("error", "Activité introuvable");
            } else {
                // Si plus d'organisateur, on ne vérifie que le rôle
                if (user.getRole() == Role.ORGANISATEUR) {
                    gestionActivite.deleteActivite(id);
                    session.setAttribute("success", "Activité supprimée avec succès");
                } else {
                    session.setAttribute("error", "Vous n'avez pas les droits pour supprimer cette activité");
                }
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "ID d'activité invalide");
        } catch (Exception e) {
            session.setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }

        response.sendRedirect(getRedirectUrl(request));
    }


    private String getRedirectUrl(HttpServletRequest request) {
        // Retourne à la page précédente ou à la page d'accueil par défaut
        String referer = request.getHeader("referer");
        return referer != null ? referer : request.getContextPath() + "/";
    }

    private void handleHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Categorie> categories = gestionCategorie.listerToutesLesCategories();
        List<Activite> activites = gestionActivite.getAllActivites();
        User user = (User) request.getSession().getAttribute("user");

        activites.forEach(a -> {
            if (user != null) {
                a.setDejaInscrit(a.getParticipants().contains(user));
                a.setEnListeAttente(a.getListeAttente().contains(user));
            }
        });

        request.setAttribute("categories", categories);
        request.setAttribute("activites", activites);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/acceuil.jsp").forward(request, response);
    }

    private void handleActivities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Activite> activites = gestionActivite.getAllActivites();
        User user = (User) request.getSession().getAttribute("user");

        activites.forEach(a -> {
            if (user != null) {
                a.setDejaInscrit(a.getParticipants().contains(user));
                a.setEnListeAttente(a.getListeAttente().contains(user));
            }
        });

        request.setAttribute("activites", activites);
        request.getRequestDispatcher("/acceuil.jsp").forward(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String recherche = request.getParameter("q");
        List<Activite> activites = gestionActivite.rechercherActivites(recherche);
        User user = (User) request.getSession().getAttribute("user");

        activites.forEach(a -> {
            if (user != null) {
                a.setDejaInscrit(a.getParticipants().contains(user));
                a.setEnListeAttente(a.getListeAttente().contains(user));
            }
        });

        request.setAttribute("activites", activites);
        request.setAttribute("searchTerm", recherche);
        request.getRequestDispatcher("/acceuil.jsp").forward(request, response);
    }

    private void handleMyActivities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("error", "Vous devez être connecté pour voir vos participations");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Utilisez la même logique que ParticipationServlet
            List<Activite> participations = gestionActivite.getActivitesByParticipant(user.getId());
            List<Activite> enAttente = gestionActivite.getActivitesEnAttente(user.getId());
            
            participations.forEach(a -> {
                a.setDejaInscrit(true);
                a.setEnListeAttente(false);
            });
            
            enAttente.forEach(a -> {
                a.setDejaInscrit(false);
                a.setEnListeAttente(true);
            });
            
            List<Activite> toutesParticipations = new ArrayList<>();
            toutesParticipations.addAll(participations);
            toutesParticipations.addAll(enAttente);
            
            toutesParticipations.sort(Comparator.comparing(Activite::getDateActivite).reversed());
            
            request.setAttribute("participations", toutesParticipations);
            request.getRequestDispatcher("/participation.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Erreur lors du chargement des participations");
            response.sendRedirect(request.getContextPath() + "/activities");
        }
    }
}