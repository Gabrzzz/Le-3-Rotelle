<%@ page import="model.Utente" %>
<%@ page import="model.Videogioco" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    @SuppressWarnings("unchecked")
    List<Videogioco> carrello = (List<Videogioco>) session.getAttribute("carrello");

    double totale = 0.0;
    if (carrello != null) {
        for (Videogioco v : carrello) {
            double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
            totale += prezzoScontato;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Carrello - RotaGames</title>
<link rel="stylesheet" type="text/css" href="css/style.css">
<style>
    .cart-container {
        max-width: 800px;
        margin: 40px auto;
        background-color: #09172E;
        padding: 30px;
        border-radius: 8px;
        border: 1px solid rgba(0, 229, 255, 0.2);
        box-shadow: 0 10px 25px rgba(0,0,0,0.5);
    }
    .cart-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: #112A54;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 15px;
    }
    .cart-item-info h3 {
        margin: 0 0 5px 0;
        color: #FFFFFF;
    }
    .cart-item-price {
        color: #7FFFD4;
        font-weight: bold;
        font-size: 1.2em;
    }
    .cart-total {
        text-align: right;
        font-size: 1.5em;
        color: #FFFFFF;
        margin-top: 20px;
        padding-top: 20px;
        border-top: 1px solid rgba(0, 229, 255, 0.2);
    }
    .btn-remove {
        background-color: #FF4444;
        color: #FFFFFF;
        border: none;
        padding: 8px 12px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
    }
    .btn-remove:hover {
        background-color: #CC0000;
    }
    .btn-checkout {
        background-color: #00E5FF;
        color: #030D1A;
        border: none;
        padding: 15px 30px;
        border-radius: 4px;
        font-weight: bold;
        font-size: 1.1em;
        cursor: pointer;
        text-transform: uppercase;
        width: 100%;
        margin-top: 20px;
        text-align: center;
        display: block;
        text-decoration: none;
    }
    .btn-checkout:hover {
        background-color: #7FFFD4;
    }
    .empty-cart {
        text-align: center;
        color: #A0B0C8;
        padding: 40px;
    }
</style>
</head>
<body>

<header>
    <a href="index.jsp" style="text-decoration: none;"><h1 style="margin: 0; color: #fff;">RotaGames 🎮</h1></a>
    <div class="user-info">
        <% if (utenteLoggato != null) { %>
            <span>Bentornato, <strong><%= utenteLoggato.getNickname() %></strong></span> |
            <span style="color: #FFD700; font-weight: bold;">🪙 <%= utenteLoggato.getSaldoRotelline() %> Rotelline</span> |
            <a href="LogoutServlet" style="color: #FF4444; text-decoration: none; font-weight: bold; margin-left: 15px;">Esci</a>
        <% } else { %>
            <a href="login.jsp" class="btn-guest">Accedi</a>
            <a href="registrazione.jsp" class="btn-guest solid">Registrati</a>
        <% } %>
    </div>
</header>

<div class="cart-container">
    <h2 style="color: #00E5FF; text-transform: uppercase; border-bottom: 2px solid #00E5FF; padding-bottom: 10px;">Il tuo Carrello</h2>

    <% if (carrello != null && !carrello.isEmpty()) { %>
        <% for (Videogioco v : carrello) {
            double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
        %>
            <div class="cart-item">
                <div class="cart-item-info">
                    <h3><%= v.getTitolo() %></h3>
                    <span class="platform-tag"><%= v.getPiattaforma() %></span>
                </div>
                <div style="display: flex; align-items: center; gap: 20px;">
                    <span class="cart-item-price"><%= String.format("%.2f", prezzoScontato) %>€</span>
                    <form action="CartServlet" method="post" style="margin: 0;">
                        <input type="hidden" name="azione" value="rimuovi">
                        <input type="hidden" name="idVideogioco" value="<%= v.getIdVideogioco() %>">
                        <button type="submit" class="btn-remove">Rimuovi</button>
                    </form>
                </div>
            </div>
        <% } %>

        <div class="cart-total">
            Totale: <span style="color: #00E5FF;"><%= String.format("%.2f", totale) %>€</span>
        </div>

        <% if (utenteLoggato != null) { %>
            <form action="CheckoutServlet" method="post">
                <button type="submit" class="btn-checkout">Procedi al Checkout</button>
            </form>
        <% } else { %>
            <div style="text-align: center; margin-top: 20px; color: #FF4444; font-weight: bold;">
                Devi effettuare l'accesso per poter acquistare i giochi.
                <br><br>
                <a href="login.jsp" class="btn-guest">Accedi</a> o <a href="registrazione.jsp" class="btn-guest solid">Registrati</a>
            </div>
        <% } %>

    <% } else { %>
        <div class="empty-cart">
            <h3 style="color: #FFFFFF;">Il tuo carrello è vuoto</h3>
            <p>Esplora il catalogo per trovare i tuoi prossimi giochi preferiti!</p>
            <a href="index.jsp" class="btn-checkout" style="width: auto; display: inline-block;">Torna allo Store</a>
        </div>
    <% } %>
</div>

</body>
</html>
