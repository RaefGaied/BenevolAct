package servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/static/*")
public class StaticResourceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resourcePath = request.getPathInfo(); // Ex: /css/acceuil.css ou /js/favorisadminjs.js

        if (resourcePath == null || resourcePath.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Fichier non spécifié");
            return;
        }

        // On construit le chemin réel vers les fichiers dans assets/
        String fullPath = getServletContext().getRealPath("/assets" + resourcePath);
        File file = new File(fullPath);

        if (!file.exists() || file.isDirectory()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fichier introuvable");
            return;
        }

        String mimeType = getServletContext().getMimeType(file.getName());
        if (mimeType == null) {
            // Fallback MIME types
            if (resourcePath.endsWith(".css")) {
                mimeType = "text/css";
            } else if (resourcePath.endsWith(".js")) {
                mimeType = "application/javascript";
            } else {
                mimeType = "application/octet-stream";
            }
        }

        response.setContentType(mimeType);
        response.setContentLength((int) file.length());
        response.setHeader("Cache-Control", "public, max-age=604800"); // Cache d'une semaine

        Files.copy(file.toPath(), response.getOutputStream());
    }
}
