package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;
import model.dao.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Se qualcuno prova ad accedere alla servlet digitando l'URL (metodo GET), lo rimandiamo al form
        response.sendRedirect("login.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Recuperiamo i parametri dal form HTML
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. Chiamiamo il DAO per interrogare il DB
        UtenteDAO utenteDAO = new UtenteDAO();
        Utente utente = utenteDAO.doRetrieveByEmailAndPassword(email, password);

        if (utente != null) {
            // LOGIN RIUSCITO: Salviamo l'oggetto Utente nella sessione
            HttpSession session = request.getSession();
            session.setAttribute("utenteLoggato", utente);
            
            // Controllo del ruolo per il reindirizzamento automatico
            if ("AMMINISTRATORE".equals(utente.getRuolo())) {
                // L'amministratore va direttamente al pannello di controllo dedicato
                response.sendRedirect("AdminDashboardServlet");
            } else {
                // I clienti normali e gli sviluppatori vanno alla homepage del negozio
                response.sendRedirect("index.jsp"); 
            }
        }
    }
}