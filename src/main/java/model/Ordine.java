package model;

import java.sql.Timestamp;

public class Ordine {
    private int idOrdine;
    private Timestamp dataOrdine;
    private double prezzoTotale;
    private String emailCliente; // Ricavata con una JOIN per la plancia admin

    public Ordine() {}

    public int getIdOrdine() { return idOrdine; }
    public void setIdOrdine(int idOrdine) { this.idOrdine = idOrdine; }

    public Timestamp getDataOrdine() { return dataOrdine; }
    public void setDataOrdine(Timestamp dataOrdine) { this.dataOrdine = dataOrdine; }

    public double getPrezzoTotale() { return prezzoTotale; }
    public void setPrezzoTotale(double prezzoTotale) { this.prezzoTotale = prezzoTotale; }

    public String getEmailCliente() { return emailCliente; }
    public void setEmailCliente(String emailCliente) { this.emailCliente = emailCliente; }
}