package model;

import java.sql.Timestamp;

public class Recensione {
    private int idRecensione;
    private int idVideogioco;
    private String nicknameUtente; // Chi ha scritto la recensione
    private int voto; // Da 1 a 10 (o da 1 a 5, in base a come l'avete definito)
    private String testo;
    private Timestamp dataCreazione;

    // Costruttore vuoto
    public Recensione() {}

    // Getter e Setter
    public int getIdRecensione() { return idRecensione; }
    public void setIdRecensione(int idRecensione) { this.idRecensione = idRecensione; }

    public int getIdVideogioco() { return idVideogioco; }
    public void setIdVideogioco(int idVideogioco) { this.idVideogioco = idVideogioco; }

    public String getNicknameUtente() { return nicknameUtente; }
    public void setNicknameUtente(String nicknameUtente) { this.nicknameUtente = nicknameUtente; }

    public int getVoto() { return voto; }
    public void setVoto(int voto) { this.voto = voto; }

    public String getTesto() { return testo; }
    public void setTesto(String testo) { this.testo = testo; }

    public Timestamp getDataCreazione() { return dataCreazione; }
    public void setDataCreazione(Timestamp dataCreazione) { this.dataCreazione = dataCreazione; }
}