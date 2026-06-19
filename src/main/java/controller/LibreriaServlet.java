package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.Videogioco;
import model.dao.LibreriaDAO;

@WebServlet("/LibreriaServlet")
public class LibreriaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        LibreriaDAO dao = new LibreriaDAO();
        List<Videogioco> libreriaGiochi = dao.doRetrieveByUtente(utenteLoggato.getIdUtente());

        request.setAttribute("libreriaGiochi", libreriaGiochi);
        request.getRequestDispatcher("libreria.jsp").forward(request, response);
    }
}
