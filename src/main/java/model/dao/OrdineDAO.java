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

    public void doSave(Ordine ordine, List<model.Videogioco> carrello) {
        Connection con = null;
        PreparedStatement psOrdine = null;
        PreparedStatement psComposizione = null;
        ResultSet rs = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            String insertOrdine = "INSERT INTO ordine (id_utente, totale_ordine, data_acquisto) VALUES (?, ?, ?)";
            psOrdine = con.prepareStatement(insertOrdine, java.sql.Statement.RETURN_GENERATED_KEYS);
            psOrdine.setInt(1, ordine.getIdUtente());
            psOrdine.setDouble(2, ordine.getTotaleOrdine());
            psOrdine.setTimestamp(3, new java.sql.Timestamp(ordine.getDataOrdine().getTime()));
            psOrdine.executeUpdate();

            rs = psOrdine.getGeneratedKeys();
            int idOrdine = -1;
            if (rs.next()) {
                idOrdine = rs.getInt(1);
            }

            if (idOrdine != -1) {
                String insertComposizione = "INSERT INTO composizione (id_ordine, id_videogioco, prezzo_acquisto, product_key) VALUES (?, ?, ?, ?)";
                psComposizione = con.prepareStatement(insertComposizione);

                for (model.Videogioco v : carrello) {
                    psComposizione.setInt(1, idOrdine);
                    psComposizione.setInt(2, v.getIdVideogioco());
                    double prezzoScontato = v.getPrezzoBase() - (v.getPrezzoBase() * v.getScontoAttivo() / 100.0);
                    psComposizione.setDouble(3, prezzoScontato);
                    psComposizione.setString(4, java.util.UUID.randomUUID().toString());
                    psComposizione.executeUpdate();
                }

                PreparedStatement psLibreria = null;
                try {
                    String insertLibreria = "INSERT INTO libreria (id_utente, id_videogioco, stato_avanzamento, product_key_posseduta) VALUES (?, ?, ?, ?)";
                    psLibreria = con.prepareStatement(insertLibreria);
                    for (model.Videogioco v : carrello) {
                        psLibreria.setInt(1, ordine.getIdUtente());
                        psLibreria.setInt(2, v.getIdVideogioco());
                        psLibreria.setString(3, "Da giocare");
                        psLibreria.setString(4, java.util.UUID.randomUUID().toString());
                        psLibreria.executeUpdate();
                    }
                } finally {
                    if (psLibreria != null) psLibreria.close();

                }
            }

            con.commit();
        } catch (SQLException e) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (psComposizione != null) psComposizione.close();
                if (psOrdine != null) psOrdine.close();
                if (con != null) { con.setAutoCommit(true); con.close(); }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

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