<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Recupero la sessione e l'oggetto gioco passato dalla Servlet
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    Videogioco gioco = (Videogioco) request.getAttribute("giocoDettaglio");
    
    // Sicurezza: se uno digita l'URL a mano senza passare dalla Servlet, lo rimbalziamo alla home
    if (gioco == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= gioco.getTitolo() %> - RotaGames</title>
<link rel="stylesheet" type="text/css" href="css/style.css?v=3">
</head>
<body>

<header>
    <a href="index.jsp" style="text-decoration: none;"><h1 style="margin: 0; color: #00E5FF;">RotaGames 🎮</h1></a>
    <div class="user-info">
        <% if (utenteLoggato != null) { %>
            <span>Bentornato, <strong><%= utenteLoggato.getNickname() %></strong></span> |
            <span class="rotelline">🪙 <%= utenteLoggato.getSaldoRotelline() %> Rotelline</span> |
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
    
    <a href="index.jsp" class="btn-guest" style="margin-bottom: 20px; display: inline-block; border: none; padding-left: 0;">&larr; Torna al Catalogo</a>

    <div class="game-detail-layout">
        
        <div class="detail-cover-col">
            <% if (gioco.getBase64Copertina() != null && !gioco.getBase64Copertina().isEmpty()) { %>
                <img src="data:image/jpeg;base64,<%= gioco.getBase64Copertina() %>" alt="Copertina <%= gioco.getTitolo() %>" class="detail-cover">
            <% } else { %>
                <div class="detail-cover empty-cover" style="height: 450px;">
                    <span>Nessuna Copertina</span>
                </div>
            <% } %>
        </div>

        <div class="detail-info-col">
            <h1 class="detail-title"><%= gioco.getTitolo() %></h1>
            
            <div style="margin-bottom: 20px;">
                <span class="platform-tag" style="font-size: 1em; padding: 8px 15px;"><%= gioco.getPiattaforma() %></span>
            </div>
            
            <p class="detail-desc"><%= gioco.getDescrizione() %></p>
            
            <div class="detail-buy-box">
                <div class="detail-price-area">
                    <% if (gioco.getScontoAttivo() > 0) { 
                        double prezzoScontato = gioco.getPrezzoBase() - (gioco.getPrezzoBase() * gioco.getScontoAttivo() / 100.0);
                    %>
                        <span class="discount-badge" style="display: inline-block; width: fit-content; margin-bottom: 5px;">-<%= gioco.getScontoAttivo() %>% SCONTO SPECIALE</span>
                        <div>
                            <span class="old-price" style="font-size: 1.2em;"><%= String.format("%.2f", gioco.getPrezzoBase()) %>€</span>
                            <span class="price-tag discounted-price" style="font-size: 2.2em; margin-left: 10px;"><%= String.format("%.2f", prezzoScontato) %>€</span>
                        </div>
                    <% } else { %>
                        <span class="price-tag" style="font-size: 2.2em;"><%= String.format("%.2f", gioco.getPrezzoBase()) %>€</span>
                    <% } %>
                </div>
                
                <div style="width: 250px;">
                    <form action="CartServlet" method="post" class="cart-form">
                        <input type="hidden" name="azione" value="aggiungi">
                        <input type="hidden" name="idVideogioco" value="<%= gioco.getIdVideogioco() %>">
                        <button type="submit" class="btn-cart" style="padding: 20px; font-size: 1.2em;">
                            AGGIUNGI 🛒
                        </button>
                    </form>
                </div>
            </div>
            
        </div>
    </div>
    
    <div class="detail-extra-section">
        <h3 class="detail-extra-title">Requisiti di Sistema</h3>
        <div class="req-grid">
            <div class="req-box">
                <h4>Minimi</h4>
                <ul class="req-list">
                    <li><strong>OS:</strong> Windows 10 (64-bit)</li>
                    <li><strong>Processore:</strong> (Da collegare al DB)</li>
                    <li><strong>Memoria:</strong> (Da collegare al DB)</li>
                    <li><strong>Scheda Video:</strong> (Da collegare al DB)</li>
                </ul>
            </div>
            <div class="req-box">
                <h4>Consigliati</h4>
                <ul class="req-list">
                    <li><strong>OS:</strong> Windows 10/11 (64-bit)</li>
                    <li><strong>Processore:</strong> (Da collegare al DB)</li>
                    <li><strong>Memoria:</strong> (Da collegare al DB)</li>
                    <li><strong>Scheda Video:</strong> (Da collegare al DB)</li>
                </ul>
            </div>
        </div>
    </div>

<div class="detail-extra-section" style="border-top-color: #00FF7F;">
        <h3 class="detail-extra-title" style="color: #00FF7F; border-bottom-color: rgba(0, 255, 127, 0.2);">Recensioni Utenti</h3>
        
        <% 
            java.util.List<model.Recensione> recensioni = (java.util.List<model.Recensione>) request.getAttribute("listaRecensioni");
            
            if (recensioni != null && !recensioni.isEmpty()) {
                for (model.Recensione rec : recensioni) {
        %>
            <div class="review-card">
                <div class="review-header">
                    <span class="review-author">👤 <%= rec.getNicknameUtente() %></span>
                    <span class="review-score">
                        <%-- Stampa le stelline in base al voto (es. da 1 a 5) --%>
                        Voto: <%= rec.getVoto() %>/5 ⭐
                    </span>
                </div>
                <div class="review-text">
                    "<%= rec.getTesto() %>"
                </div>
                <div style="font-size: 0.8em; color: #5C6F8E; margin-top: 10px; text-align: right;">
                    Pubblicata il: <%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(rec.getDataCreazione()) %>
                </div>
            </div>
        <% 
                }
            } else { 
        %>
            <div style="text-align: center; padding: 20px; color: #5C6F8E; font-style: italic;">
                Nessuna recensione presente. Gioca e sii il primo a lasciare un'opinione!
            </div>
        <% 
            } 
        %>
    </div>
    
</div>

</body>
</html>