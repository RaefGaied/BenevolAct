package servlets;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1️⃣ Récupère le chemin réel du dossier images déployé
            String imageDir = getServletContext().getRealPath("/assets/images");
            System.out.println("Dossier image réel : " + imageDir);

            // 2️⃣ Récupération du nom demandé
            String requestedName = request.getPathInfo();
            
            if (requestedName == null || requestedName.isEmpty() || requestedName.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nom d'image requis");
                return;
            }

            // 3️⃣ Nettoyage et transformation
            requestedName = requestedName.substring(1); // enlève le slash initial
            String sanitizedName = sanitizeFileName(requestedName);
            String physicalName = transformFileName(sanitizedName);
            System.out.println("Nom demandé : " + sanitizedName + " → Physique : " + physicalName);

            // 4️⃣ Chemin complet + sécurisation
            Path imagePath = Paths.get(imageDir, physicalName).normalize();
            System.out.println("Chemin image : " + imagePath);

            if (!imagePath.startsWith(Paths.get(imageDir).normalize())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès non autorisé");
                return;
            }

            // 5️⃣ Vérifie l'existence
            if (!Files.exists(imagePath)) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Image non trouvée : " + physicalName);
                return;
            }

            // 6️⃣ Type MIME + envoi
            String mimeType = Files.probeContentType(imagePath);
            response.setContentType(mimeType != null ? mimeType : "application/octet-stream");
            response.setHeader("Cache-Control", "public, max-age=86400"); // 1 jour de cache
            response.setContentLengthLong(Files.size(imagePath));

            Files.copy(imagePath, response.getOutputStream());
            System.out.println("Image envoyée ✅ : " + physicalName);

        } catch (Exception e) {
            e.printStackTrace(); // utile pour debug !
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Erreur lors du traitement de l'image: " + e.getMessage());
        }
    }

    private String sanitizeFileName(String fileName) {
        return fileName.replaceAll("\\.\\.", "").replaceAll("/", "");
    }

    private String transformFileName(String fileName) {
        return fileName.replaceAll("^\\d+_", "").replace("_", " ");
    }
}
