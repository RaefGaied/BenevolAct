package servlets;

import dao.GestionActiviteJPA;
import dao.GestionCategorieJPA;
import dao.IGestionActivite;
import dao.IGestionCategorie;
import entities.Activite;
import entities.Categorie;
import entities.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@WebServlet("/AjouterActiviteServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 Mo
    maxFileSize       = 5 * 1024 * 1024,    // 5 Mo
    maxRequestSize    = 10 * 1024 * 1024    // 10 Mo
)
public class AjouterActiviteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final SimpleDateFormat DATE_FMT = new SimpleDateFormat("yyyy-MM-dd");

    private IGestionActivite   gestionActivite;
    private IGestionCategorie  gestionCategorie;

    @Override
    public void init() throws ServletException {
        this.gestionActivite  = new GestionActiviteJPA();
        this.gestionCategorie = new GestionCategorieJPA();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession sess = req.getSession(false);
        if (sess == null || sess.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String activiteIdStr = req.getParameter("activiteId");

        // Charger les catégories pour le select toujours
        List<Categorie> cats = gestionCategorie.listerToutesLesCategories();
        req.setAttribute("categories", cats);

        if ("edit".equals(action) && activiteIdStr != null) {
            try {
                long activiteId = Long.parseLong(activiteIdStr);
                Activite activite = gestionActivite.getActiviteById(activiteId);
                if (activite != null) {
                    req.setAttribute("activite", activite);
                } else {
                    sess.setAttribute("error", "Activité introuvable pour modification.");
                    resp.sendRedirect(req.getContextPath() + "/ListeActivitesServlet");
                    return;
                }
            } catch (Exception e) {
                sess.setAttribute("error", "Erreur lors du chargement de l'activité.");
                resp.sendRedirect(req.getContextPath() + "/ListeActivitesServlet");
                return;
            }
        }

        // Toujours forward vers la même JSP (elle gère le mode ajout ou édition)
        req.getRequestDispatcher("/ajouterActivite.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession sess = req.getSession(false);
        if (sess == null || sess.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String activiteIdStr = req.getParameter("activiteId");

        // --- Traitement suppression ---
        if ("delete".equals(action) && activiteIdStr != null) {
            try {
                long activiteId = Long.parseLong(activiteIdStr);
                gestionActivite.deleteActivite(activiteId);
                sess.setAttribute("success", "Activité supprimée avec succès.");
            } catch (Exception e) {
                sess.setAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/ListeActivitesServlet");
            return;
        }

        try {
            // --- Lecture des champs ---
            String titre = req.getParameter("titre").trim();
            String desc  = req.getParameter("description").trim();
            String lieu  = req.getParameter("lieu").trim();
            String dateStr = req.getParameter("date");
            String capStr  = req.getParameter("capacite");
            String catStr  = req.getParameter("categorie");

            // --- Validation rapide ---
            if (titre.isEmpty() || desc.isEmpty() || lieu.isEmpty()
                    || dateStr == null || dateStr.isEmpty()
                    || capStr == null || catStr == null) {
                throw new IllegalArgumentException("Tous les champs obligatoires doivent être remplis.");
            }

            // --- Parsing ---
            Date   date = DATE_FMT.parse(dateStr);
            long   capa = Long.parseLong(capStr);
            long   catId= Long.parseLong(catStr);

            Categorie categorie = gestionCategorie.trouverCategorieParId(catId);
            if (categorie == null) {
                throw new IllegalArgumentException("Catégorie introuvable.");
            }

            // --- Gestion de l'image (optionnelle) ---
            Part part = req.getPart("image");
            String fileName = null;
            if (part != null && part.getSize() > 0) {
                String imagesDir = getServletContext().getRealPath("") + "assets" + File.separator + "images";
                File uploadDir = new File(imagesDir);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                String orig = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String ext  = orig.contains(".") ? orig.substring(orig.lastIndexOf(".")) : "";
                fileName    = System.currentTimeMillis() + "_" + UUID.randomUUID() + ext;
                part.write(imagesDir + File.separator + fileName);
            }

            // --- Traitement édition ---
            if ("update".equals(action) && activiteIdStr != null) {
                long activiteId = Long.parseLong(activiteIdStr);
                Activite activite = gestionActivite.getActiviteById(activiteId);

                if (activite == null) {
                    throw new IllegalArgumentException("Activité introuvable pour mise à jour.");
                }

                activite.setTitre(titre);
                activite.setDescription(desc);
                activite.setLieu(lieu);
                activite.setDateCloture(date);
                activite.setCapacite(capa);
                activite.setCategorie(categorie);

                if (fileName != null) {
                    activite.setImageUrl(fileName);
                }

                gestionActivite.updateActivite(activite);
                sess.setAttribute("success", "Activité mise à jour avec succès !");
                resp.sendRedirect(req.getContextPath() + "/ListeActivitesServlet");
                return;
            }

            // --- Traitement ajout ---
            Activite act = new Activite();
            act.setTitre(titre);
            act.setDescription(desc);
            act.setLieu(lieu);
            act.setDateCloture(date);
            act.setCapacite(capa);
            act.setCategorie(categorie);
            if (fileName != null) {
                act.setImageUrl(fileName);
            }
            User current = (User) sess.getAttribute("user");
            act.getParticipants().add(current);

            gestionActivite.ajouterActivite(act);
            sess.setAttribute("success", "Activité créée avec succès !");
            resp.sendRedirect(req.getContextPath() + "/ListeActivitesServlet");

        } catch (Exception e) {
            e.printStackTrace();
            sess.setAttribute("error", "Erreur : " + e.getMessage());

            if ("update".equals(action) && activiteIdStr != null) {
                resp.sendRedirect(req.getContextPath() + "/AjouterActiviteServlet?action=edit&activiteId=" + activiteIdStr);
            } else {
                resp.sendRedirect(req.getContextPath() + "/AjouterActiviteServlet");
            }
        }
    }
}
