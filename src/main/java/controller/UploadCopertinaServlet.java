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
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) 
public class UploadCopertinaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        // 1. Recupero l'ID del gioco digitato dall'admin
        int idVideogioco = Integer.parseInt(request.getParameter("idVideogioco"));
        
        // 2. Recupero il file della copertina del gioco
        Part filePart = request.getPart("copertina_file");
        
        if (filePart != null && filePart.getSize() > 0) {
            
            InputStream fileStream = filePart.getInputStream();
            
            VideogiocoDAO dao = new VideogiocoDAO();
            dao.aggiornaCopertina(idVideogioco, fileStream);
        }
        
        response.sendRedirect("AdminDashboardServlet");
    }
}