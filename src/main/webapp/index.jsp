<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="model.dao.VideogiocoDAO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Controllo Sessione
    Utente utente = (Utente) session.getAttribute("utenteLoggato");
    if (utente == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Istanziamo il DAO e recuperiamo la lista dei videogiochi attivi
    VideogiocoDAO giocoDAO = new VideogiocoDAO();
    List<Videogioco> catalogo = giocoDAO.doRetrieveAll();
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/style.css">

<meta charset="UTF-8">
<title>RotaGames - Vetrina Digitale</title>
</head>
<body>

<header>
    <h1>RotaGames 🕹️</h1>
    <div class="user-info">
        <span>Benvenuto, <strong><%= utente.getNickname() %></strong></span> | 
        <span class="rotelline">🪙 <%= utente.getSaldoRotelline() %> Rotelline</span> |
        <a href="LogoutServlet" style="color: #FF4444; text-decoration: none; font-weight: bold; margin-left: 15px;">Esci</a>
    </div>
</header>

<div class="container">
    <h2>I Giochi del Momento</h2>
    
    <div class="catalog-grid">
        <% 
            if(catalogo != null && !catalogo.isEmpty()) {
                for(Videogioco gioco : catalogo) { 
        %>
                <div class="game-card">
                    <div>
                        <div class="game-title"><%= gioco.getTitolo() %></div>
                        <div class="game-platform">💻 Piattaforme: <%= gioco.getPiattaforma() %></div>
                        <div class="game-desc"><%= gioco.getDescrizione() %></div>
                    </div>
                    
                    <div>
                        <div class="price-box">
                            <% if(gioco.getScontoAttivo() > 0) { %>
                                <span class="original-price"><%= String.format("%.2f", gioco.getPrezzoBase()) %>€</span>
                                <span class="final-price"><%= String.format("%.2f", gioco.getPrezzoFinale()) %>€</span>
                                <span class="sconto-tag">-<%= gioco.getScontoAttivo() %>%</span>
                            <% } else { %>
                                <span class="final-price"><%= String.format("%.2f", gioco.getPrezzoBase()) %>€</span>
                            <% } %>
                        </div>
                        <a href="#" class="btn-buy">Aggiungi al Carrello</a>
                    </div>
                </div>
        <% 
                }
            } else { 
        %>
            <p style="color: #A0B0C8;">Nessun videogioco disponibile nel catalogo al momento.</p>
        <% } %>
    </div>
</div>

</body>
</html>