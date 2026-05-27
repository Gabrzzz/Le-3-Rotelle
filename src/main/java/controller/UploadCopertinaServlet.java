package controller;

import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import model.dao.VideogiocoDAO;

@WebServlet("/UploadCopertinaServlet")
// QUESTA ANNOTAZIONE È LA CHIAVE DELLA LEZIONE (limite a 5 MB)
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) 
public class UploadCopertinaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Recupero l'ID del gioco digitato dall'admin
        int idVideogioco = Integer.parseInt(request.getParameter("idVideogioco"));
        
        // 2. Recupero il file (Part)
        Part filePart = request.getPart("copertina_file");
        
        if (filePart != null && filePart.getSize() > 0) {
            // 3. Trasformo la Part in uno stream di dati
            InputStream fileStream = filePart.getInputStream();
            
            // 4. Chiamo il DAO e gli passo lo stream da ficcare nel DB
            VideogiocoDAO dao = new VideogiocoDAO();
            dao.aggiornaCopertina(idVideogioco, fileStream);
        }
        
        // 5. Ritorno alla dashboard admin
        response.sendRedirect("AdminDashboardServlet");
    }
}