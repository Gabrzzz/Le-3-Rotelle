package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Videogioco;
import model.dao.VideogiocoDAO;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Mostra il carrello
        request.getRequestDispatcher("carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<Videogioco> carrello = (List<Videogioco>) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new ArrayList<>();
            session.setAttribute("carrello", carrello);
        }

        String azione = request.getParameter("azione");

        if ("aggiungi".equals(azione)) {
            String idStr = request.getParameter("idVideogioco");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    // Check if already in cart
                    boolean found = false;
                    for (Videogioco v : carrello) {
                        if (v.getIdVideogioco() == id) {
                            found = true;
                            break;
                        }
                    }
                    if (!found) {
                        VideogiocoDAO dao = new VideogiocoDAO();
                        Videogioco gioco = dao.doRetrieveById(id);
                        if (gioco != null) {
                            carrello.add(gioco);
                        }
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        } else if ("rimuovi".equals(azione)) {
            String idStr = request.getParameter("idVideogioco");
            if (idStr != null) {
                try {
                    int id = Integer.parseInt(idStr);
                    carrello.removeIf(v -> v.getIdVideogioco() == id);
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }
        }

        response.sendRedirect("carrello.jsp");
    }
}
