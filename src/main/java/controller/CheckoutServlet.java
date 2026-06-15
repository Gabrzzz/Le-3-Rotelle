package controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Ordine;
import model.Utente;
import model.Videogioco;
import model.dao.OrdineDAO;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<Videogioco> carrello = (List<Videogioco>) session.getAttribute("carrello");

        if (carrello == null || carrello.isEmpty()) {
            response.sendRedirect("carrello.jsp");
            return;
        }

        double totale = 0.0;
        for (Videogioco v : carrello) {
            double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            totale += prezzoScontato;
        }

        Ordine ordine = new Ordine();
        ordine.setIdUtente(utenteLoggato.getIdUtente());
        ordine.setTotaleOrdine(totale);
        ordine.setDataOrdine(new java.sql.Timestamp(new Date().getTime()));

        OrdineDAO dao = new OrdineDAO();
        dao.doSave(ordine, carrello);

        // Svuota carrello
        session.removeAttribute("carrello");

        // Reindirizza allo storico ordini o homepage
        response.sendRedirect("index.jsp");
    }
}
