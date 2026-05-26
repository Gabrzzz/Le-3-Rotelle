package model.dao;
import model.Ordine;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;

public class OrdineDAO {

    /**
     * Recupera tutti gli ordini con l'email del relativo utente tramite una JOIN.
     */
    public synchronized List<Ordine> doRetrieveAllWithUser() {
        List<Ordine> lista = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        // Eseguiamo una JOIN tra Ordine e Utente per mostrare i dati reali all'admin
        String query = "SELECT o.id_ordine, o.data_acquisto, o.prezzo_totale, u.email " +
                "FROM Ordine o JOIN Utente u ON o.id_utente = u.id_utente " +
                "ORDER BY o.data_acquisto DESC";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Ordine o = new Ordine();
                o.setIdOrdine(rs.getInt("id_ordine"));
                o.setDataOrdine(rs.getTimestamp("data_acquisto"));
                o.setPrezzoTotale(rs.getDouble("prezzo_totale"));
                o.setEmailCliente(rs.getString("email"));
                lista.add(o);
            }
        } catch (SQLException e) {
            System.err.println("Errore in OrdineDAO.doRetrieveAllWithUser: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return lista;
    }
}