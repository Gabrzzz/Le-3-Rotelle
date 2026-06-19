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
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout - RotaGames</title>
<link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>

<header>
    <a href="index.jsp" style="text-decoration: none;"><h1 style="margin: 0; color: #fff;">RotaGames 🎮</h1></a>
    <div class="user-info">
        <span>Bentornato, <strong><%= utenteLoggato.getNickname() %></strong></span> |
        <a href="carrello.jsp" style="color: #A0B0C8; text-decoration: none; margin-left: 15px; font-weight:bold;">Torna al Carrello</a>
    </div>
</header>

<div class="checkout-container">

    <div class="checkout-form-section">
        <h2 class="checkout-section-title">Dettagli di Pagamento</h2>

        <form action="CheckoutServlet" method="post">
            <div class="form-group">
                <label>Intestatario Carta</label>
                <input type="text" name="titolare" placeholder="Nome Cognome" required value="<%= utenteLoggato.getNome() != null ? utenteLoggato.getNome() + " " + utenteLoggato.getCognome() : "" %>">
            </div>

            <div class="form-group">
                <label>Numero Carta</label>
                <input type="text" name="numeroCarta" placeholder="0000 0000 0000 0000" required pattern="\d{16}" title="Inserisci 16 numeri" maxlength="16">
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 1;">
                    <label>Scadenza (MM/AA)</label>
                    <input type="text" name="scadenza" placeholder="MM/AA" required pattern="\d{2}/\d{2}" maxlength="5">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>CVV</label>
                    <input type="text" name="cvv" placeholder="123" required pattern="\d{3}" maxlength="3">
                </div>
            </div>

            <h2 class="checkout-section-title" style="margin-top: 30px;">Indirizzo di Fatturazione</h2>

            <div class="form-group">
                <label>Via</label>
                <input type="text" name="via" required value="<%= utenteLoggato.getVia() != null ? utenteLoggato.getVia() : "" %>">
            </div>

            <div style="display: flex; gap: 20px;">
                <div class="form-group" style="flex: 2;">
                    <label>Città</label>
                    <input type="text" name="citta" required value="<%= utenteLoggato.getCitta() != null ? utenteLoggato.getCitta() : "" %>">
                </div>
                <div class="form-group" style="flex: 1;">
                    <label>CAP</label>
                    <input type="text" name="cap" required value="<%= utenteLoggato.getCap() != null ? utenteLoggato.getCap() : "" %>">
                </div>
            </div>

            <button type="submit" class="btn-pay">Paga <%= String.format("%.2f", totale) %>€</button>
        </form>
    </div>

    <div class="checkout-summary-section">
        <h2 class="checkout-section-title">Riepilogo Ordine</h2>

        <% for (Videogioco v : carrello) {
            double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
        %>
            <div class="summary-item">
                <span style="flex: 1; margin-right: 15px;"><%= v.getTitolo() %></span>
                <span style="color: #7FFFD4; font-weight: bold;"><%= String.format("%.2f", prezzoScontato) %>€</span>
            </div>
        <% } %>

        <div class="summary-total">
            <span>TOTALE</span>
            <span style="color: #00E5FF;"><%= String.format("%.2f", totale) %>€</span>
        </div>
    </div>

</div>

</body>
</html>
