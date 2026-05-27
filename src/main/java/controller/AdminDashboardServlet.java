package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.*;
import model.dao.*;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null || !"AMMINISTRATORE".equals(utenteLoggato.getRuolo())) {
            response.sendRedirect("login.jsp");
            return;
        }

        String tab = request.getParameter("tab");
        if (tab == null) tab = "statistiche";
        request.setAttribute("activeTab", tab);

        // Caricamento dati in base al ruolo dell'utente (admin, registrato oppure sviluppatore)
        if ("utenti".equals(tab)) {
            request.setAttribute("listaUtenti", new UtenteDAO().doRetrieveAll());
        } else if ("catalogo".equals(tab)) {
            // Filtro dei dati in base al ruolo dell'utente
            request.setAttribute("listaVideogiochi", new VideogiocoDAO().doRetrieveAllForAdmin());
        } else if ("ordini".equals(tab)) {
            request.setAttribute("listaOrdini", new OrdineDAO().doRetrieveAllForAdmin());
        } else if ("statistiche".equals(tab)) {
            request.setAttribute("totaleGiochi", new VideogiocoDAO().doRetrieveAll().size());
            request.setAttribute("totaleUtenti", new UtenteDAO().doRetrieveAll().size());
        }

        request.getRequestDispatcher("admin_dashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null || !"AMMINISTRATORE".equals(utenteLoggato.getRuolo())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String azione = request.getParameter("azione");
        String tabDiRitorno = "statistiche";

        try {
            if ("aggiungiGioco".equals(azione)) {
                // Inserimento piattaforma che supporta il gioco
                String[] piazze = request.getParameterValues("piattaforme");
                String piattaformeUnite = (piazze != null) ? String.join(", ", piazze) : "PC";

                // Inserimento campi dei requisiti di sistema richiesti per il gioco
                String os = request.getParameter("reqOS");
                String cpu = request.getParameter("reqCPU");
                String ram = request.getParameter("reqRAM");
                String gpu = request.getParameter("reqGPU");
                String requisitiFormattati = "OS: " + os + " | CPU: " + cpu + " | RAM: " + ram + " GB | GPU: " + gpu;

                // Inserimento gioco (ogetto)
                Videogioco nuovo = new Videogioco();
                nuovo.setTitolo(request.getParameter("titolo"));
                nuovo.setDescrizione(request.getParameter("descrizione"));
                nuovo.setPrezzoBase(Double.parseDouble(request.getParameter("prezzoBase")));
                nuovo.setScontoAttivo(Integer.parseInt(request.getParameter("scontoAttivo")));
                nuovo.setPiattaforma(piattaformeUnite);
                nuovo.setRequisitiSistema(requisitiFormattati);
             // Legge lo stato dal form impostato dall'amministratore
                String statoSelezionato = request.getParameter("statoApprovazione");
                nuovo.setStatoApprovazione(statoSelezionato != null ? statoSelezionato : "APPROVATO");

                VideogiocoDAO videogiocoDAO = new VideogiocoDAO();
                videogiocoDAO.doSave(nuovo);
                tabDiRitorno = "catalogo";

            } else if ("eliminaGioco".equals(azione)) {
                int id = Integer.parseInt(request.getParameter("idVideogioco"));
                new VideogiocoDAO().doDelete(id);
                tabDiRitorno = "catalogo";
            } else if ("approvaGioco".equals(azione)) {
                int id = Integer.parseInt(request.getParameter("idVideogioco"));
                new VideogiocoDAO().doUpdateStatus(id, "APPROVATO");
                tabDiRitorno = "catalogo";    
            } else if ("eliminaUtente".equals(azione)) {
                int id = Integer.parseInt(request.getParameter("idUtente"));
                if (id != utenteLoggato.getIdUtente()) {
                    new UtenteDAO().doDelete(id);
                }
                tabDiRitorno = "utenti";
            }
        } catch (Exception e) {
            // Stampa l'errore per individuare falle
            System.err.println("❌ Errore durante l'operazione amministrativa:");
            e.printStackTrace();
        }

        response.sendRedirect("AdminDashboardServlet?tab=" + tabDiRitorno);
    }
}