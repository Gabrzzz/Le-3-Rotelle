<%@ page import="model.*, java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Utente utenteLoggato = (Utente) session.getAttribute("utenteLoggato");
    if (utenteLoggato == null || !"AMMINISTRATORE".equals(utenteLoggato.getRuolo())) {
        response.sendRedirect("index.jsp"); return;
    }
    String activeTab = (String) request.getAttribute("activeTab");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pannello Amministrativo - RotaGames</title>
<link rel="stylesheet" type="text/css" href="css/style.css">
<style>
    body { margin: 0; display: flex; height: 100vh; overflow: hidden; background-color: #04142C; color: #fff; }
    
    /* Layout Sidebar */
    .sidebar { width: 260px; background-color: #112A54; padding: 20px 0; border-right: 2px solid #00E5FF; display: flex; flex-direction: column; }
    .sidebar-header { text-align: center; padding-bottom: 20px; border-bottom: 1px solid #04142C; margin-bottom: 20px; }
    .sidebar-header h2 { color: #00E5FF; margin: 0; font-size: 1.4em; letter-spacing: 1px; }
    .nav-link { padding: 15px 20px; color: #A0B0C8; text-decoration: none; font-weight: bold; display: block; border-left: 4px solid transparent; transition: all 0.3s; }
    .nav-link:hover, .nav-link.active { background-color: #04142C; color: #00E5FF; border-left: 4px solid #00E5FF; }
    
    /* Area Contenuti */
    .main-content { flex: 1; padding: 40px; overflow-y: auto; box-sizing: border-box; }
    .header-bar { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #112A54; padding-bottom: 20px; margin-bottom: 30px; }
    
    /* Tabelle strutturate */
    table { width: 100%; border-collapse: collapse; background-color: #112A54; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.3); margin-top: 15px; }
    th { background-color: #00E5FF; color: #04142C; padding: 12px; text-align: left; font-weight: bold; }
    td { padding: 12px; border-bottom: 1px solid #04142C; color: #FFFFFF; }
    tr:hover { background-color: #0c2042; }
    
    .btn-delete { background-color: #FF4444; color: #fff; border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
    .btn-delete:hover { background-color: #CC0000; }
    
    /* Box del Formulario */
    .form-box { background-color: #112A54; padding: 25px; border-radius: 8px; border-top: 3px solid #00E5FF; margin-bottom: 30px; }
    .form-box h3 { color: #00E5FF; margin-top: 0; margin-bottom: 20px; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; color: #A0B0C8; font-size: 0.9em; margin-bottom: 5px; font-weight: bold; }
    .form-box input[type="text"], .form-box input[type="number"], .form-box textarea { width: 100%; padding: 10px; border: 1px solid #0088CC; background-color: #04142C; color: #fff; border-radius: 4px; box-sizing: border-box; }
    
    /* Checkbox Allineati */
    .checkbox-group { display: flex; gap: 15px; flex-wrap: wrap; background-color: #04142C; padding: 10px; border-radius: 4px; border: 1px solid #0088CC; }
    .checkbox-item { display: flex; align-items: center; gap: 5px; color: #fff; font-size: 0.9em; }
    
    /* Griglia input requisiti */
    .req-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
    
    .btn-submit { background-color: #00E5FF; color: #04142C; padding: 12px 20px; border: none; border-radius: 4px; font-weight: bold; cursor: pointer; width: 100%; margin-top: 10px; letter-spacing: 1px; }
    .btn-submit:hover { background-color: #0088CC; color: #fff; }
    
    /* Schede Statistiche */
    .stats-grid { display: flex; gap: 20px; }
    .stat-card { flex: 1; background-color: #112A54; padding: 25px; border-radius: 8px; border-left: 4px solid #00E5FF; text-align: center; box-shadow: 0 4px 10px rgba(0,0,0,0.3); }
    .stat-card h3 { color: #A0B0C8; font-size: 0.95em; margin-top: 0; text-transform: uppercase; }
    .stat-card .num { font-size: 2.8em; color: #00E5FF; font-weight: bold; margin-top: 5px; }
</style>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-header">
            <h2>RotaGames</h2>
            <span style="font-size: 0.8em; color: #A0B0C8; font-weight: bold; letter-spacing: 1px;">AMMINISTRAZIONE</span>
        </div>
        <a href="AdminDashboardServlet?tab=statistiche" class="nav-link <%= "statistiche".equals(activeTab) ? "active" : "" %>">📊 Statistiche Profilazione</a>
        <a href="AdminDashboardServlet?tab=catalogo" class="nav-link <%= "catalogo".equals(activeTab) ? "active" : "" %>">🕹️ Gestione Catalogo</a>
        <a href="AdminDashboardServlet?tab=ordini" class="nav-link <%= "ordini".equals(activeTab) ? "active" : "" %>">🛒 Interfaccia E-Commerce</a>
        <a href="AdminDashboardServlet?tab=utenti" class="nav-link <%= "utenti".equals(activeTab) ? "active" : "" %>">👥 Gestione Utenti</a>
    </aside>

    <main class="main-content">
        <div class="header-bar">
            <h2>Area: <%= activeTab.toUpperCase() %></h2>
            <div>
                <span>Pannello di: <strong><%= utenteLoggato.getNickname() %></strong></span>
                <a href="index.jsp" style="color: #00E5FF; margin-left: 15px; text-decoration: none; font-weight: bold;">Interfaccia Negozio</a>
            </div>
        </div>

        <%-- TAB 1: STATISTICHE DI PROFILAZIONE AGGREGATE --%>
        <% if ("statistiche".equals(activeTab)) { %>
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Utenti Iscritti</h3>
                    <div class="num"><%= request.getAttribute("totaleUtenti") %></div>
                </div>
                <div class="stat-card">
                    <h3>Titoli in Vetrina</h3>
                    <div class="num"><%= request.getAttribute("totaleGiochi") %></div>
                </div>
                <div class="stat-card">
                    <h3>Genere Preferito</h3>
                    <div class="num">JRPG</div>
                </div>
            </div>
        <% } %>

        <%-- TAB 2: GESTIONE COMPLETA CATALOGO (AGGIUNTA, MODIFICA, ELIMINAZIONE) --%>
        <% if ("catalogo".equals(activeTab)) { %>
            <div class="form-box">
                <h3>Aggiungi Nuovo Prodotto nel Catalogo</h3>
                <form action="AdminDashboardServlet" method="post">
                    <input type="hidden" name="azione" value="aggiungiGioco">
                    
                    <div class="req-grid">
                        <div class="form-group">
                            <label>Titolo dell'opera</label>
                            <input type="text" name="titolo" placeholder="es. Persona 3 Reload" required>
                        </div>
                        <div class="form-group" style="display: flex; gap: 10px;">
                            <div style="flex: 1;">
                                <label>Prezzo Base (€)</label>
                                <input type="number" step="0.01" name="prezzoBase" placeholder="es. 59.99" required>
                            </div>
                            <div style="flex: 1;">
                                <label>Sconto (%)</label>
                                <input type="number" name="scontoAttivo" value="0" min="0" max="100" required>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Scegli le Piattaforme abilitate</label>
                        <div class="checkbox-group">
                            <div class="checkbox-item"><input type="checkbox" name="piattaforme" value="PC" checked> PC</div>
                            <div class="checkbox-item"><input type="checkbox" name="piattaforme" value="PS5"> PS5</div>
                            <div class="checkbox-item"><input type="checkbox" name="piattaforme" value="Xbox Series X/S"> Xbox Series X/S</div>
                            <div class="checkbox-item"><input type="checkbox" name="piattaforme" value="Nintendo Switch"> Nintendo Switch</div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Descrizione Estesa</label>
                        <textarea name="descrizione" placeholder="Inserisci la sinossi e i dettagli commerciali del titolo..." rows="2" required></textarea>
                    </div>

                    <div class="form-group">
                        <label>Requisiti di Sistema di Base</label>
                        <div class="req-grid">
                            <input type="text" name="reqOS" placeholder="Sistema Operativo (es. Windows 11)" required>
                            <input type="text" name="reqCPU" placeholder="Processore (es. Intel i7 / Ryzen 5)" required>
                            <input type="number" name="reqRAM" placeholder="Memoria RAM (in GB, es. 16)" required>
                            <input type="text" name="reqGPU" placeholder="Scheda Grafica (es. RTX 3060)" required>
                        </div>
                    </div>

                    <%-- Nuova sezione per impostare lo stato iniziale del gioco --%>
                    <div class="form-group">
                        <label>Stato di Pubblicazione Iniziale</label>
                        <select name="statoApprovazione" style="width: 100%; padding: 10px; border: 1px solid #0088CC; background-color: #04142C; color: #fff; border-radius: 4px; box-sizing: border-box;">
                            <option value="APPROVATO" selected>✓ Approva e Pubblica Immediatamente</option>
                            <option value="IN_ATTESA">⏳ Salva in Attesa di Approvazione</option>
                        </select>
                    </div>

                    <input type="submit" value="REGISTRATI E PUBBLICA SUL DATABASE" class="btn-submit">
                </form>
            </div>

            <h3 style="color: #fff;">Prodotti in Archivio</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Titolo</th>
                        <th>Prezzo</th>
                        <th>Piattaforme</th>
                        <th>Stato Catalogo</th> <%-- Nuova colonna --%>
                        <th>Operazione</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Videogioco> giochi = (List<Videogioco>) request.getAttribute("listaVideogiochi");
                        if(giochi != null && !giochi.isEmpty()) { 
                            for(Videogioco g : giochi) { 
                    %>
                    <tr>
                        <td><%= g.getIdVideogioco() %></td>
                        <td><strong><%= g.getTitolo() %></strong></td>
                        <td><%= String.format("%.2f", g.getPrezzoBase()) %>€</td>
                        <td><span style="color: #A0B0C8; font-size: 0.9em;"><%= g.getPiattaforma() %></span></td>
                        
                        <td>
                            <% if("IN_ATTESA".equals(g.getStatoApprovazione())) { %>
                                <span style="color: #FFCC00; font-weight: bold; background-color: rgba(255,204,0,0.1); padding: 4px 8px; border-radius: 4px;">⏳ IN ATTESA</span>
                            <% } else { %>
                                <span style="color: #00FF7F; font-weight: bold; background-color: rgba(0,255,127,0.1); padding: 4px 8px; border-radius: 4px;">✓ APPROVATO</span>
                            <% } %>
                        </td>
                        
                        <%-- Colonna Operazioni Aggiornata --%>
                        <td>
                            <div style="display: flex; gap: 8px; align-items: center;">
                                <%-- Se il gioco è in attesa, l'admin può approvarlo al volo con un click --%>
                                <% if("IN_ATTESA".equals(g.getStatoApprovazione())) { %>
                                    <form action="AdminDashboardServlet" method="post" style="margin:0;">
                                        <input type="hidden" name="azione" value="approvaGioco">
                                        <input type="hidden" name="idVideogioco" value="<%= g.getIdVideogioco() %>">
                                        <input type="submit" value="Approva" class="btn-action" style="background-color: #00FF7F; color: #04142C; padding: 4px 10px; font-size: 0.8em; margin: 0;">
                                    </form>
                                <% } %>
                                
                                <form action="AdminDashboardServlet" method="post" style="margin:0;" onsubmit="return confirm('Eliminare definitivamente questo titolo?');">
                                    <input type="hidden" name="azione" value="eliminaGioco">
                                    <input type="hidden" name="idVideogioco" value="<%= g.getIdVideogioco() %>">
                                    <input type="submit" value="Elimina" class="btn-delete" style="padding: 4px 10px; font-size: 0.8em;">
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% 
                            } 
                        } else { 
                    %>
                        <tr><td colspan="6" style="text-align:center; color:#A0B0C8;">Nessun gioco presente in archivio.</td></tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>

        <%-- TAB 3: INTERFACCIA E-COMMERCE (ORDINI FILTRATI PER DATA E CLIENTE) --%>
        <% if ("ordini".equals(activeTab)) { %>
            <div class="form-box" style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                <h3 style="color:#00E5FF; margin:0; flex:1; min-width: 200px;">Strumenti di Filtro Ricevute:</h3>
                <input type="text" id="txtCliente" placeholder="Filtra per Email Cliente..." onkeyup="eseguiFiltro()" style="width:280px; margin:0;">
                <input type="date" id="dateOrdine" onchange="eseguiFiltro()" style="width:200px; margin:0;">
            </div>

            <table id="tblRicevute">
                <thead>
                    <tr><th>Codice Ordine</th><th>Contatto Cliente</th><th>Data Ricevuta</th><th>Importo Complessivo</th></tr>
                </thead>
                <tbody>
                    <% 
                        List<Ordine> ordini = (List<Ordine>) request.getAttribute("listaOrdini");
                        if(ordini != null && !ordini.isEmpty()) { for(Ordine o : ordini) { 
                    %>
                    <tr class="riga-ordine-reale">
                        <td>#<%= o.getIdOrdine() %></td>
                        <td class="campo-email-cliente" style="font-weight: bold;"><%= o.getEmailCliente() %></td>
                        <td class="campo-data-ordine"><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(o.getDataOrdine()) %></td>
                        <td style="color:#00FF7F; font-weight:bold;"><%= String.format("%.2f", o.getPrezzoTotale()) %> €</td>
                    </tr>
                    <% } } else { %>
                        <tr><td colspan="4" style="text-align:center; color:#A0B0C8;">Nessuna transazione commerciale registrata nel DB.</td></tr>
                    <% } %>
                </tbody>
            </table>

            <script>
                function eseguiFiltro() {
                    let mailInput = document.getElementById("txtCliente").value.toLowerCase();
                    let dataInput = document.getElementById("dateOrdine").value;
                    let record Ordini = document.getElementsByClassName("riga-ordine-reale");

                    for (let i = 0; i < recordOrdini.length; i++) {
                        let emailTesto = recordOrdini[i].getElementsByClassName("campo-email-cliente")[0].innerText.toLowerCase();
                        let dataTesto = recordOrdini[i].getElementsByClassName("campo-data-ordine")[0].innerText;
                        
                        let matchEmail = emailTesto.includes(mailInput);
                        let matchData = (dataInput === "" || dataTesto.includes(dataInput));
                        
                        if (matchEmail && matchData) {
                            recordOrdini[i].style.display = "";
                        } else {
                            recordOrdini[i].style.display = "none";
                        }
                    }
                }
            </script>
        <% } %>

        <%-- TAB 4: GESTIONE UTENTI REGISTRATI --%>
        <% if ("utenti".equals(activeTab)) { %>
            <table>
                <thead>
                    <tr><th>ID</th><th>Pseudonimo</th><th>Indirizzo Email</th><th>Ruolo di Sistema</th><th>Azione Consentita</th></tr>
                </thead>
                <tbody>
                    <% 
                        List<Utente> utenti = (List<Utente>) request.getAttribute("listaUtenti");
                        if(utenti != null) { for(Utente u : utenti) { 
                    %>
                    <tr>
                        <td><%= u.getIdUtente() %></td>
                        <td><strong><%= u.getNickname() %></strong></td>
                        <td><%= u.getEmail() %></td>
                        <td><span style="color: #00E5FF; font-weight: bold;"><%= u.getRuolo() %></span></td>
                        <td>
                            <% if(u.getIdUtente() != utenteLoggato.getIdUtente()) { %>
                            <form action="AdminDashboardServlet" method="post" style="margin:0;" onsubmit="return confirm('Revocare l\'accesso ed eliminare l\'utente?');">
                                <input type="hidden" name="azione" value="eliminaUtente">
                                <input type="hidden" name="idUtente" value="<%= u.getIdUtente() %>">
                                <input type="submit" value="Elimina" class="btn-delete">
                            </form>
                            <% } else { %>
                                <span style="color: #A0B0C8; font-size: 0.9em; font-style: italic;">Profilo Attivo</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        <% } %>
    </main>

</body>
</html>