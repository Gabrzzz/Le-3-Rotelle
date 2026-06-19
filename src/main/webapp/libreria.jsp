<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    if (utenteLoggato == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Videogioco> libreria = (List<Videogioco>) request.getAttribute("libreriaGiochi");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>La mia Libreria - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css?v=2.0">
</head>
<body>

<header>
    <a href="index.jsp" style="text-decoration: none;"><h1 style="margin: 0; color: #fff;">RotaGames 🎮</h1></a>
    <div class="user-info">
        <span>Bentornato, <strong><%= utenteLoggato.getNickname() %></strong></span> |
        <span style="color: #FFD700; font-weight: bold;">🪙 <%= utenteLoggato.getSaldoRotelline() %> Rotelline</span> |
        <a href="LogoutServlet" style="color: #FF4444; text-decoration: none; font-weight: bold; margin-left: 15px;">Esci</a>
    </div>
</header>

<div class="library-header">
    <h2>La mia Libreria</h2>
</div>

<% if (libreria != null && !libreria.isEmpty()) { %>
    <div class="library-grid">
        <% for (Videogioco v : libreria) { %>
            <div class="library-card">
                <% if (v.getBase64Copertina() != null && !v.getBase64Copertina().isEmpty()) { %>
                    <img src="data:image/jpeg;base64,<%= v.getBase64Copertina() %>" alt="Copertina" class="library-cover">
                <% } else { %>
                    <div class="library-cover" style="background-color: #04142C; display: flex; align-items: center; justify-content: center; color: #5C6F8E;">
                        Nessuna Immagine
                    </div>
                <% } %>

                <div class="library-info">
                    <h3 class="library-title"><%= v.getTitolo() %></h3>
                    <p style="color: #A0B0C8; font-size: 0.9em; margin-bottom: 15px;"><%= v.getPiattaforma() %></p>

                    <div class="library-status">
                        <!-- Qui, per ora, simuliamo lo stato. In futuro si potrebbe leggere da v.getStatoAvanzamento() se aggiunto al model -->
                        <span class="status-badge">Da Giocare</span>
                        <a href="#" class="btn-play">Gioca</a>
                    </div>
                </div>
            </div>
        <% } %>
    </div>
<% } else { %>
    <div class="empty-library">
        <h3>Non hai ancora giochi nella tua libreria.</h3>
        <p>Visita lo store e scopri i nostri titoli migliori!</p>
        <a href="index.jsp" class="btn-checkout" style="width: auto; display: inline-block;">Esplora il Catalogo</a>
    </div>
<% } %>

</body>
</html>
