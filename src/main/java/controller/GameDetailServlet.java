package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Videogioco;
import model.dao.VideogiocoDAO;

@WebServlet("/GameDetailServlet")
public class GameDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int id = Integer.parseInt(idParam);
                
                // recupero gioco dal database
                VideogiocoDAO daoGioco = new VideogiocoDAO();
                Videogioco gioco = daoGioco.doRetrieveById(id);
                
                if (gioco != null) {
                    // recupero recensioni legate al gioco
                    model.dao.RecensioneDAO daoRecensioni = new model.dao.RecensioneDAO();
                    java.util.List<model.Recensione> recensioni = daoRecensioni.doRetrieveByVideogioco(id);
                    
                    request.setAttribute("giocoDettaglio", gioco);
                    request.setAttribute("listaRecensioni", recensioni);
                    
                    request.getRequestDispatcher("game_detail.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("index.jsp");
    }
}