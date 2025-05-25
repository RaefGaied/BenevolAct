package servlets;

import dao.GestionCategorieJPA;
import dao.IGestionCategorie;
import entities.Categorie;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/categories", "/searchCategorie", "/deleteCategorie", "/editCategorie", "/updateCategorie", "/addCategorie"})
public class CategorieServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private IGestionCategorie gestion;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        gestion = new GestionCategorieJPA();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        try {
            switch (path) {
                case "/categories":
                    listCategories(request, response);
                    break;
                case "/searchCategorie":
                    searchCategorie(request, response);
                    break;
                case "/deleteCategorie":
                    deleteCategorie(request, response);
                    break;
                case "/editCategorie":
                    editCategorie(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            handleError(request, response, "Erreur lors du traitement GET", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();

        try {
            switch (path) {
                case "/addCategorie":
                    addCategorie(request, response);
                    break;
                case "/updateCategorie":
                    updateCategorie(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            handleError(request, response, "Erreur lors du traitement POST", e);
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Categorie> categories = gestion.listerToutesLesCategories();
        
        // Debug
        System.out.println("=== CATEGORIES DANS SERVLET ===");
        categories.forEach(c -> System.out.println(
            "ID: " + c.getId() + " | Nom: " + c.getNom() + 
            " | Activités: " + (c.getActivites() != null ? c.getActivites().size() : 0)));
        
        request.setAttribute("categories", categories);
        request.setAttribute("isEditing", false);
        request.getRequestDispatcher("/listeCategories.jsp").forward(request, response);
    }

    private void searchCategorie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String mc = request.getParameter("r");
        List<Categorie> categories = gestion.listerToutesLesCategories(); // Vous pouvez implémenter une méthode de recherche spécifique dans le DAO
        request.setAttribute("categories", categories);
        request.setAttribute("isEditing", false);
        request.getRequestDispatcher("/listeCategories.jsp").forward(request, response);
    }

    private void deleteCategorie(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            gestion.supprimerCategorie(id);
            request.getSession().setAttribute("success", "Catégorie supprimée avec succès");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors de la suppression : " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/categories");
    }

    private void editCategorie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Categorie categorie = gestion.trouverCategorieParId(id);
            
            if (categorie == null) {
                request.getSession().setAttribute("error", "Catégorie introuvable");
                response.sendRedirect(request.getContextPath() + "/categories");
                return;
            }
            
            request.setAttribute("editingCategory", categorie);
            request.setAttribute("isEditing", true);
            
            List<Categorie> categories = gestion.listerToutesLesCategories();
            request.setAttribute("categories", categories);
            
            request.getRequestDispatcher("/listeCategories.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Erreur lors de l'édition de la catégorie", e);
        }
    }

    private void addCategorie(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");

        try {
            if (nom == null || nom.trim().isEmpty()) {
                throw new IllegalArgumentException("Le nom de la catégorie est obligatoire");
            }

            Categorie c = new Categorie();
            c.setNom(nom.trim());
            c.setDescription(description != null ? description.trim() : null);

            gestion.ajouterCategorie(c);
            request.getSession().setAttribute("success", "Catégorie ajoutée avec succès");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors de l'ajout : " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/categories");
    }

    private void updateCategorie(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String idStr = request.getParameter("id");
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");

        try {
            if (idStr == null || !idStr.matches("\\d+")) {
                throw new IllegalArgumentException("ID de catégorie invalide");
            }
            if (nom == null || nom.trim().isEmpty()) {
                throw new IllegalArgumentException("Le nom de la catégorie est obligatoire");
            }

            Long id = Long.parseLong(idStr);
            Categorie c = gestion.trouverCategorieParId(id);
            
            if (c == null) {
                throw new IllegalArgumentException("Catégorie introuvable");
            }

            c.setNom(nom.trim());
            c.setDescription(description != null ? description.trim() : null);

            gestion.modifierCategorie(c);
            request.getSession().setAttribute("success", "Catégorie modifiée avec succès");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Erreur lors de la modification : " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/categories");
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String message, Exception e)
            throws ServletException, IOException {
        e.printStackTrace();
        request.getSession().setAttribute("error", message + " : " + e.getMessage());
        listCategories(request, response);
    }
}