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
</head>
<body class="admin-body">

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

                    <%-- Sezione per impostare lo stato iniziale del gioco --%>
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
                        <th>Stato Catalogo</th> 
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
                        
                        
                        <td>
                            <div style="display: flex; gap: 8px; align-items: center;">
                                <%-- Se il gioco è in attesa, l'admin può approvarlo --%>
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
            
            <div class="form-container" style="margin-top: 30px;">
			    <h3 style="color: #00E5FF;">Carica Copertina Gioco</h3>
			    
			    <form action="UploadCopertinaServlet" method="post" enctype="multipart/form-data">
			        
			        <label for="idGioco" style="color: #A0B0C8;">ID del Gioco:</label>
			        <input type="number" name="idVideogioco" required placeholder="Es. 1">
			        
			        <label style="color: #A0B0C8; display: block; margin-top: 15px;">Seleziona Immagine (.jpg, .png):</label>
			        <input type="file" name="copertina_file" accept="image/png, image/jpeg" required style="background: #030D1A; padding: 10px; border: 1px dashed #00E5FF;">
			        
			        <input type="submit" value="Carica Immagine 🚀">
			    </form>
			</div>
        <% } %>

        <%-- TAB 3: INTERFACCIA E-COMMERCE (ORDINI FILTRATI PER DATA E CLIENTE) --%>
        <% if ("ordini".equals(activeTab)) { %>
            <div class="form-box" style="display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
                <h3 style="color:#00E5FF; margin:0; flex:1; min-width: 200px;">Strumenti di Filtro Ricevute:</h3>
                <input type="text" id="txtCliente" placeholder="Filtra per Cliente..." onkeyup="eseguiFiltro()" style="width:280px; margin:0;">
                <input type="date" id="dateOrdine" onchange="eseguiFiltro()" style="width:200px; margin:0;">
            </div>

            <table id="tblRicevute">
                <thead>
                    <tr>
                        <th>Codice Ordine</th>
                        <th>Cliente</th>
                        <th>Data Ricevuta</th>
                        <th>Importo Complessivo</th>
                        <th>Fattura PDF</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        java.util.List<model.Ordine> ordini = (java.util.List<model.Ordine>) request.getAttribute("listaOrdini");
                        if(ordini != null && !ordini.isEmpty()) { 
                            for(model.Ordine o : ordini) { 
                                String rawDate = (o.getDataOrdine() != null) ? new java.text.SimpleDateFormat("yyyy-MM-dd").format(o.getDataOrdine()) : "";
                                String displayDate = (o.getDataOrdine() != null) ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(o.getDataOrdine()) : "N/D";
                    %>
                    <tr class="riga-ordine-reale">
                        <td style="color: #00E5FF; font-weight: bold;">#<%= o.getIdOrdine() %></td>
                        <td class="campo-email-cliente">👤 <%= o.getNicknameUtente() %></td>
                        
                        <td class="campo-data-ordine" data-raw-date="<%= rawDate %>"><%= displayDate %></td>
                        
                        <td style="color:#00FF7F; font-weight:bold;"><%= String.format("%.2f", o.getTotaleOrdine()) %> €</td>
                        <td>
                            <% if (o.getUrlFattura() != null && !o.getUrlFattura().isEmpty()) { %>
                                <a href="<%= request.getContextPath() %><%= o.getUrlFattura() %>" target="_blank" style="color: #00E5FF; text-decoration: none;">📄 Apri PDF</a>
                            <% } else { %>
                                <span style="color: #5C6F8E;">Non disp.</span>
                            <% } %>
                        </td>
                    </tr>
                    <% 
                            } 
                        } else { 
                    %>
                        <tr><td colspan="5" style="text-align:center; color:#A0B0C8;">Nessuna transazione registrata nel DB.</td></tr>
                    <% } %>
                </tbody>
            </table>

            <script>
                function eseguiFiltro() {
                    let textInput = document.getElementById("txtCliente").value.toLowerCase();
                    let dataInput = document.getElementById("dateOrdine").value; //formato YYYY-MM-DD
                    
                    let recordOrdini = document.getElementsByClassName("riga-ordine-reale");

                    for (let i = 0; i < recordOrdini.length; i++) {
                        let clienteTesto = recordOrdini[i].getElementsByClassName("campo-email-cliente")[0].innerText.toLowerCase();
                        
                        let rawDate = recordOrdini[i].getElementsByClassName("campo-data-ordine")[0].getAttribute("data-raw-date");
                        
                        let matchTesto = clienteTesto.includes(textInput);
                        let matchData = (dataInput === "" || rawDate === dataInput);
                        
                        if (matchTesto && matchData) {
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