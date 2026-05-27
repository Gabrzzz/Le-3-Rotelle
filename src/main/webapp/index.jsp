<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="model.dao.VideogiocoDAO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");

    List<Videogioco> vetrina = (List<Videogioco>) request.getAttribute("listaGiochiHome");
    if (vetrina == null) {
        vetrina = new VideogiocoDAO().doRetrieveAll(); 
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>RotaGames - Il tuo negozio di videogiochi</title>
<link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>

<header>
    <h1 style="margin: 0; color: #fff;">RotaGames 🎮</h1>
    <div class="user-info">
        <% if (utenteLoggato != null) { %>
            <span>Bentornato, <strong><%= utenteLoggato.getNickname() %></strong></span> |
            <span style="color: #FFD700; font-weight: bold;">🪙 <%= utenteLoggato.getSaldoRotelline() %> Rotelline</span> |
            
            <% if ("AMMINISTRATORE".equals(utenteLoggato.getRuolo())) { %>
                <a href="AdminDashboardServlet" style="color: #00FF7F; text-decoration: none; margin-left: 15px; font-weight:bold;">⚙️ Pannello Admin</a> |
            <% } %>
            
            <a href="LogoutServlet" style="color: #FF4444; text-decoration: none; font-weight: bold; margin-left: 15px;">Esci</a>
        <% } else { %>
            <span style="color: #A0B0C8; margin-right: 10px; font-style: italic;">Esplora il catalogo come Visitatore</span>
            <a href="login.jsp" class="btn-guest">Accedi</a>
            <a href="registrazione.jsp" class="btn-guest solid">Registrati</a>
        <% } %>
    </div>
</header>

<div class="store-container">
    <h2 style="color: #00E5FF; border-bottom: 2px solid #112A54; padding-bottom: 10px; text-transform: uppercase; letter-spacing: 1px;">Vetrina Giochi in Evidenza</h2>
    
	<div class="games-grid">
        <% 
            if (vetrina != null && !vetrina.isEmpty()) {
                for (Videogioco g : vetrina) {
        %>
<div class="game-card">
            
                <%-- INIZIO DEL LINK --%>
                <a href="GameDetailServlet?id=<%= g.getIdVideogioco() %>" class="game-card-link">
                    
                    <div class="cover-container">
                        <% if (g.getBase64Copertina() != null && !g.getBase64Copertina().isEmpty()) { %>
                            <img src="data:image/jpeg;base64,<%= g.getBase64Copertina() %>" alt="Copertina <%= g.getTitolo() %>" class="game-cover">
                        <% } else { %>
                            <div class="game-cover empty-cover">
                                <span>Nessuna Copertina</span>
                            </div>
                        <% } %>
                    </div>

                    <div class="game-info game-title-box">
                        <h3><%= g.getTitolo() %></h3>
                    </div>
                    
                </a> 
                <%-- FINE DEL LINK --%>
                
                
                <div class="game-info game-desc-box">
                    <p><%= g.getDescrizione() %></p>
                </div>
                
                <div>
                    <div class="game-meta">
                        <div class="price-container">
                            <% if (g.getScontoAttivo() > 0) { 
                                double prezzoScontato = g.getPrezzoBase() - (g.getPrezzoBase() * g.getScontoAttivo() / 100.0);
                            %>
                                <span class="discount-badge">-<%= g.getScontoAttivo() %>%</span>
                                <div class="price-column">
                                    <span class="old-price"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                                    <span class="price-tag discounted-price"><%= String.format("%.2f", prezzoScontato) %>€</span>
                                </div>
                            <% } else { %>
                                <span class="price-tag"><%= String.format("%.2f", g.getPrezzoBase()) %>€</span>
                            <% } %>
                        </div>
                        <span class="platform-tag"><%= g.getPiattaforma() %></span>
                    </div>
                    
                    <form action="CartServlet" method="post" class="cart-form">
                        <input type="hidden" name="azione" value="aggiungi">
                        <input type="hidden" name="idVideogioco" value="<%= g.getIdVideogioco() %>">
                        <button type="submit" class="btn-cart">
                            Aggiungi al Carrello 🛒
                        </button>
                    </form>
                </div>
                
            </div> <%-- Fine della .game-card --%>
        <% 
                }
            } else {
        %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 40px; background-color: #112A54; border-radius: 8px;">
                <h3 style="color: #00E5FF;">Nessun gioco al momento disponibile</h3>
                <p style="color: #A0B0C8;">Il catalogo è attualmente in fase di aggiornamento. Torna a trovarci presto!</p>
            </div>
        <% 
            } 
        %>
    </div>
</div>

</body>
</html>