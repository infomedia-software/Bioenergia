package beans;

public class Item {
    
    private String id;
    private String tabella;
    private String campo;
    private String valore;
    private String colore;
    private String immagine;
    private int ordinamento;
    private String stato;
    private String bloccato;

    
    public String getColore() {
        return colore;
    }

    public void setColore(String colore) {
        this.colore = colore;
    }

   
    
    public String getValore() {
        return valore;
    }

    public void setValore(String valore) {
        this.valore = valore;
    }
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTabella() {
        return tabella;
    }

    public void setTabella(String tabella) {
        this.tabella = tabella;
    }

    public String getCampo() {
        return campo;
    }

    public void setCampo(String campo) {
        this.campo = campo;
    }

    public int getOrdinamento() {
        return ordinamento;
    }

    public void setOrdinamento(int ordinamento) {
        this.ordinamento = ordinamento;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

 
    public String getImmagine() {
        return immagine;
    }

    public void setImmagine(String immagine) {
        this.immagine = immagine;
    }

    public String getBloccato() {
        return bloccato;
    }

    public void setBloccato(String bloccato) {
        this.bloccato = bloccato;
    }

    public boolean is_bloccato(){
        return bloccato.toLowerCase().equals("si");
    }
}
