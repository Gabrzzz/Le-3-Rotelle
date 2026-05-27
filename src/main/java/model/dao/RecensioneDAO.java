package model.dao;

import model.Recensione;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection; // Assicurati che il package del tuo DBConnection sia corretto

public class RecensioneDAO {

    public List<Recensione> doRetrieveByVideogioco(int idVideogioco) {
        List<Recensione> lista = new ArrayList<>();
        
        // La JOIN magica: prende i dati della recensione e li unisce al nickname dell'utente associato
        String query = "SELECT r.id_recensione, r.id_videogioco, r.testo, r.valutazione, r.data_pubblicazione, u.nickname " +
                       "FROM Recensione r " +
                       "JOIN Utente u ON r.id_utente = u.id_utente " +
                       "WHERE r.id_videogioco = ? " +
                       "ORDER BY r.id_recensione DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idVideogioco);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Recensione r = new Recensione();
                r.setIdRecensione(rs.getInt("id_recensione"));
                r.setIdVideogioco(rs.getInt("id_videogioco"));
                
                // Mappatura con i nomi corretti del tuo DB
                r.setNicknameUtente(rs.getString("nickname")); // Preso dalla tabella Utente tramite la JOIN
                r.setVoto(rs.getInt("valutazione"));           // Nel DB si chiama valutazione
                r.setTesto(rs.getString("testo"));
                
                // Gestione della data (nel DB è data_pubblicazione)
                java.sql.Timestamp dataPubb = rs.getTimestamp("data_pubblicazione");
                if (dataPubb != null) {
                    r.setDataCreazione(dataPubb);
                } else {
                    // Fallback di sicurezza se la data nel DB è NULL
                    r.setDataCreazione(new java.sql.Timestamp(System.currentTimeMillis()));
                }
                
                lista.add(r);
            }
        } catch (SQLException e) {
            System.err.println("Errore in RecensioneDAO: " + e.getMessage());
        }
        return lista;
    }
}