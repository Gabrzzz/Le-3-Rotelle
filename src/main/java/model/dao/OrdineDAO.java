package model.dao;

import model.Ordine;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class OrdineDAO {

    public List<Ordine> doRetrieveAllForAdmin() {
        List<Ordine> ordini = new ArrayList<>();
        
        // ordinare i  dati dal nickname del cliente
        String query = "SELECT o.id_ordine, o.totale_ordine, o.url_fattura, o.data_acquisto, o.id_utente, u.nickname " +
                       "FROM Ordine o " +
                       "JOIN Utente u ON o.id_utente = u.id_utente " +
                       "ORDER BY o.id_ordine DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Ordine ordine = new Ordine();
                ordine.setIdOrdine(rs.getInt("id_ordine"));
                ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                ordine.setUrlFattura(rs.getString("url_fattura"));
                ordine.setIdUtente(rs.getInt("id_utente"));
                
                ordine.setNicknameUtente(rs.getString("nickname"));
                
                try {
                    ordine.setDataOrdine(rs.getTimestamp("data_acquisto"));
                } catch (SQLException e) {
                    // Se la colonna non esiste o è null, andiamo avanti
                }
                
                ordini.add(ordine);
            }
        } catch (SQLException e) {
            System.err.println("Errore in doRetrieveAllForAdmin: " + e.getMessage());
        }
        return ordini;
    }
}