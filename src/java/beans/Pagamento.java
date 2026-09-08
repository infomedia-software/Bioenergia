package beans;

public class Pagamento {

    private int id;
    private int id_documento;
    private int id_soggetto;
    private int id_autore;

    private double importo;

    private String data_saldo = "";
    private String data_scadenza = "";

    private String metodo = "";
    private String saldato = "";
    private String stato = "";

    private String data_creazione = "";
    private String data_modifica = "";

    private Soggetto soggetto;
    private Documento documento;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId_documento() {
        return id_documento;
    }

    public void setId_documento(int id_documento) {
        this.id_documento = id_documento;
    }

    public int getId_soggetto() {
        return id_soggetto;
    }

    public void setId_soggetto(int id_soggetto) {
        this.id_soggetto = id_soggetto;
    }

    public int getId_autore() {
        return id_autore;
    }

    public void setId_autore(int id_autore) {
        this.id_autore = id_autore;
    }

    public double getImporto() {
        return importo;
    }

    public void setImporto(double importo) {
        this.importo = importo;
    }

    public String getData_saldo() {
        return data_saldo;
    }

    public void setData_saldo(String data_saldo) {
        this.data_saldo = data_saldo;
    }

    public String getData_scadenza() {
        return data_scadenza;
    }

    public void setData_scadenza(String data_scadenza) {
        this.data_scadenza = data_scadenza;
    }

    public String getMetodo() {
        return metodo;
    }

    public void setMetodo(String metodo) {
        this.metodo = metodo;
    }

    public String getSaldato() {
        return saldato;
    }

    public void setSaldato(String saldato) {
        this.saldato = saldato;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getData_creazione() {
        return data_creazione;
    }

    public void setData_creazione(String data_creazione) {
        this.data_creazione = data_creazione;
    }

    public String getData_modifica() {
        return data_modifica;
    }

    public void setData_modifica(String data_modifica) {
        this.data_modifica = data_modifica;
    }

    public Soggetto getSoggetto() {
        return soggetto;
    }

    public void setSoggetto(Soggetto soggetto) {
        this.soggetto = soggetto;
    }

    public Documento getDocumento() {
        return documento;
    }

    public void setDocumento(Documento documento) {
        this.documento = documento;
    }
    
    
}