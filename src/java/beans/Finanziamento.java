
package beans;


import java.sql.Date;

public class Finanziamento {
    
    public static final String TIPO_STANDARD="standard";
    public static final String TIPO_TASSO_0="tasso_0";
    
    private int id;
    private String id_documento = "";
    private String tipo = "";
    private int id_autore;
    private int id_soggetto;
    private int id_situazione;
    private String numero;
    private String contratto_numero;
    private String lettera = "";
    private String luogo = "";
    private Date data;
    private double importo = 0;
    private int numero_rate;
    private String prima_rata = "";
    private String iban = "";
    private String note_interne = "";
    private String privato_azienda = "";

    // Dati cliente
    private String nome = "";
    private String cognome = "";
    private String ragione_sociale = "";
    private String cf = "";
    private String piva = "";
    private String indirizzo_dal = "";
    private String indirizzo_precedente = "";
    private String indirizzo = "";
    private String cap = "";
    private String localita = "";
    private String comune = "";
    private String provincia = "";
    private String telefono = "";
    private String cellulare = "";
    private String email = "";
    private String luogo_nascita = "";
    private String provincia_nascita = "";
    private String data_nascita;
    private String cittadinanza = "";
    private String seconda_cittadinanza = "";
    private String documento_tipo = "";
    private String documento_numero = "";
    private String documento_rilasciato_il = "";
    private String documento_rilasciato_da = "";
    private String residenza = "";
    private String residenza_note = "";
    private String tipo_contratto = "";
    private String scadenza_contratto = "";
    private String professione = "";
    private String professione_settore = "";
    private String datore_lavoro = "";
    private String reddito = "";
    private String stato_civile = "";
    private String numero_figli = "";

    // Dati garante
    private String garante_presente = "";
    private String garante_nome = "";
    private String garante_cognome = "";
    private String garante_cf = "";
    private String garante_provincia_nascita = "";
    private String garante_luogo_nascita = "";
    private String garante_data_nascita;
    private String garante_cittadinanza = "";
    private String garante_documento_tipo = "";
    private String garante_documento_numero = "";
    private String garante_documento_rilasciato_il = "";
    private String garante_documento_rilasciato_da = "";
    private String garante_cellulare = "";
    private String garante_email = "";
    private String garante_reddito = "";
    private String garante_professione = "";
    private String garante_esposto = "";

    // Consensi e firme
    private String consenso1 = "";
    private String consenso2 = "";
    private String consenso3 = "";
    private String consenso4 = "";
    private String consenso5 = "";
    private String consenso6 = "";
    private String consenso7 = "";
    private String consenso8 = "";
    private String firma_garante = "";
    private String otp_sms_garante;
    private String otp_hash_garante;
    private String otp_data_ora_generazione_garante;
    private String otp_data_ora_scadenza_garante;
    private String otp_data_ora_verifica_garante;
    private String otp_ip_garante;
    private int otp_tentativi_falliti_garante;

    public Finanziamento() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getId_documento() { return id_documento; }
    public void setId_documento(String v) { this.id_documento = v; }

    public String getTipo() { return tipo; }
    public void setTipo(String v) { this.tipo = v; }

    public int getId_autore() { return id_autore; }
    public void setId_autore(int v) { this.id_autore = v; }

    public int getId_soggetto() { return id_soggetto; }
    public void setId_soggetto(int v) { this.id_soggetto = v; }

    public int getId_situazione() { return id_situazione; }
    public void setId_situazione(int v) { this.id_situazione = v; }

    public String getNumero() {return numero;}
    public void setNumero(String numero) {this.numero = numero;}

    public String getLettera() { return lettera; }
    public void setLettera(String v) { this.lettera = v; }

    public String getLuogo() { return luogo; }
    public void setLuogo(String v) { this.luogo = v; }

    public Date getData() { return data; }
    public void setData(Date v) { this.data = v; }

    public double getImporto() { return importo; }
    public void setImporto(double v) { this.importo = v; }

    public int getNumero_rate() { return numero_rate; }
    public void setNumero_rate(int v) { this.numero_rate = v; }

    public String getPrima_rata() { return prima_rata; }
    public void setPrima_rata(String v) { this.prima_rata = v; }

    public String getIban() { return iban; }
    public void setIban(String v) { this.iban = v; }

    public String getNome() { return nome; }
    public void setNome(String v) { this.nome = v; }

    public String getCognome() { return cognome; }
    public void setCognome(String v) { this.cognome = v; }

    public String getRagione_sociale() { return ragione_sociale; }
    public void setRagione_sociale(String v) { this.ragione_sociale = v; }

    public String getCf() { return cf; }
    public void setCf(String v) { this.cf = v; }

    public String getPiva() { return piva; }
    public void setPiva(String v) { this.piva = v; }

    public String getIndirizzo_dal() { return indirizzo_dal; }
    public void setIndirizzo_dal(String v) { this.indirizzo_dal = v; }

    public String getIndirizzo_precedente() { return indirizzo_precedente; }
    public void setIndirizzo_precedente(String v) { this.indirizzo_precedente = v; }

    public String getIndirizzo() { return indirizzo; }
    public void setIndirizzo(String v) { this.indirizzo = v; }

    public String getCap() { return cap; }
    public void setCap(String v) { this.cap = v; }

    public String getLocalita() { return localita; }
    public void setLocalita(String v) { this.localita = v; }

    public String getComune() { return comune; }
    public void setComune(String v) { this.comune = v; }

    public String getProvincia() { return provincia; }
    public void setProvincia(String v) { this.provincia = v; }

    public String getTelefono() { return telefono; }
    public void setTelefono(String v) { this.telefono = v; }

    public String getCellulare() { return cellulare; }
    public void setCellulare(String v) { this.cellulare = v; }

    public String getEmail() { return email; }
    public void setEmail(String v) { this.email = v; }

    public String getLuogo_nascita() { return luogo_nascita; }
    public void setLuogo_nascita(String v) { this.luogo_nascita = v; }

    public String getCittadinanza() { return cittadinanza; }
    public void setCittadinanza(String v) { this.cittadinanza = v; }

    public String getSeconda_cittadinanza() { return seconda_cittadinanza; }
    public void setSeconda_cittadinanza(String v) { this.seconda_cittadinanza = v; }

    public String getDocumento_tipo() { return documento_tipo; }
    public void setDocumento_tipo(String v) { this.documento_tipo = v; }

    public String getDocumento_numero() { return documento_numero; }
    public void setDocumento_numero(String v) { this.documento_numero = v; }

    public String getDocumento_rilasciato_il() { return documento_rilasciato_il; }
    public void setDocumento_rilasciato_il(String v) { this.documento_rilasciato_il = v; }

    public String getDocumento_rilasciato_da() { return documento_rilasciato_da; }
    public void setDocumento_rilasciato_da(String v) { this.documento_rilasciato_da = v; }

    public String getResidenza() { return residenza; }
    public void setResidenza(String v) { this.residenza = v; }

    public String getResidenza_note() { return residenza_note; }
    public void setResidenza_note(String v) { this.residenza_note = v; }

    public String getTipo_contratto() { return tipo_contratto; }
    public void setTipo_contratto(String v) { this.tipo_contratto = v; }

    public String getScadenza_contratto() { return scadenza_contratto; }
    public void setScadenza_contratto(String v) { this.scadenza_contratto = v; }

    public String getProfessione() { return professione; }
    public void setProfessione(String v) { this.professione = v; }

    public String getProfessione_settore() { return professione_settore; }
    public void setProfessione_settore(String v) { this.professione_settore = v; }

    public String getDatore_lavoro() { return datore_lavoro; }
    public void setDatore_lavoro(String v) { this.datore_lavoro = v; }

    public String getReddito() { return reddito; }
    public void setReddito(String v) { this.reddito = v; }

    public String getStato_civile() { return stato_civile; }
    public void setStato_civile(String v) { this.stato_civile = v; }

    public String getNumero_figli() { return numero_figli; }
    public void setNumero_figli(String v) { this.numero_figli = v; }

    public String getGarante_presente() { return garante_presente; }
    public void setGarante_presente(String v) { this.garante_presente = v; }

    public String getGarante_nome() { return garante_nome; }
    public void setGarante_nome(String v) { this.garante_nome = v; }

    public String getGarante_cognome() { return garante_cognome; }
    public void setGarante_cognome(String v) { this.garante_cognome = v; }

    public String getGarante_cf() { return garante_cf; }
    public void setGarante_cf(String v) { this.garante_cf = v; }

    public String getGarante_luogo_nascita() { return garante_luogo_nascita; }
    public void setGarante_luogo_nascita(String v) { this.garante_luogo_nascita = v; }

    public String getGarante_cittadinanza() { return garante_cittadinanza; }
    public void setGarante_cittadinanza(String v) { this.garante_cittadinanza = v; }

    public String getGarante_documento_tipo() { return garante_documento_tipo; }
    public void setGarante_documento_tipo(String v) { this.garante_documento_tipo = v; }

    public String getGarante_documento_numero() { return garante_documento_numero; }
    public void setGarante_documento_numero(String v) { this.garante_documento_numero = v; }

    public String getGarante_documento_rilasciato_il() { return garante_documento_rilasciato_il; }
    public void setGarante_documento_rilasciato_il(String v) { this.garante_documento_rilasciato_il = v; }

    public String getGarante_documento_rilasciato_da() { return garante_documento_rilasciato_da; }
    public void setGarante_documento_rilasciato_da(String v) { this.garante_documento_rilasciato_da = v; }

    public String getGarante_cellulare() { return garante_cellulare; }
    public void setGarante_cellulare(String v) { this.garante_cellulare = v; }

    public String getGarante_email() { return garante_email; }
    public void setGarante_email(String v) { this.garante_email = v; }

    public String getGarante_reddito() { return garante_reddito; }
    public void setGarante_reddito(String v) { this.garante_reddito = v; }

    public String getGarante_professione() { return garante_professione; }
    public void setGarante_professione(String v) { this.garante_professione = v; }

    public String getGarante_esposto() { return garante_esposto; }
    public void setGarante_esposto(String v) { this.garante_esposto = v; }

    public String getConsenso1() { return consenso1; }
    public void setConsenso1(String v) { this.consenso1 = v; }

    public String getConsenso2() { return consenso2; }
    public void setConsenso2(String v) { this.consenso2 = v; }

    public String getConsenso3() { return consenso3; }
    public void setConsenso3(String v) { this.consenso3 = v; }

    public String getConsenso4() { return consenso4; }
    public void setConsenso4(String v) { this.consenso4 = v; }

    public String getConsenso5() { return consenso5; }
    public void setConsenso5(String v) { this.consenso5 = v; }

    public String getConsenso6() { return consenso6; }
    public void setConsenso6(String v) { this.consenso6 = v; }

    public String getConsenso7() { return consenso7; }
    public void setConsenso7(String v) { this.consenso7 = v; }

    public String getConsenso8() { return consenso8; }
    public void setConsenso8(String v) { this.consenso8 = v; }

    public String getFirma_garante() { return firma_garante; }
    public void setFirma_garante(String v) { this.firma_garante = v; }


    public String getNote_interne() {
        return note_interne;
    }

    public void setNote_interne(String note_interne) {
        this.note_interne = note_interne;
    }
    

    public String getOtp_sms_garante() {
        return otp_sms_garante;
    }

    public void setOtp_sms_garante(String otp_sms_garante) {
        this.otp_sms_garante = otp_sms_garante;
    }

    public String getOtp_hash_garante() {
        return otp_hash_garante;
    }

    public void setOtp_hash_garante(String otp_hash_garante) {
        this.otp_hash_garante = otp_hash_garante;
    }

    public String getOtp_data_ora_generazione_garante() {
        return otp_data_ora_generazione_garante;
    }

    public void setOtp_data_ora_generazione_garante(String otp_data_ora_generazione_garante) {
        this.otp_data_ora_generazione_garante = otp_data_ora_generazione_garante;
    }

    public String getOtp_data_ora_scadenza_garante() {
        return otp_data_ora_scadenza_garante;
    }

    public void setOtp_data_ora_scadenza_garante(String otp_data_ora_scadenza_garante) {
        this.otp_data_ora_scadenza_garante = otp_data_ora_scadenza_garante;
    }

    public String getOtp_data_ora_verifica_garante() {
        return otp_data_ora_verifica_garante;
    }

    public void setOtp_data_ora_verifica_garante(String otp_data_ora_verifica_garante) {
        this.otp_data_ora_verifica_garante = otp_data_ora_verifica_garante;
    }

    public String getOtp_ip_garante() {
        return otp_ip_garante;
    }

    public void setOtp_ip_garante(String otp_ip_garante) {
        this.otp_ip_garante = otp_ip_garante;
    }

    public int getOtp_tentativi_falliti_garante() {
        return otp_tentativi_falliti_garante;
    }

    public void setOtp_tentativi_falliti_garante(int otp_tentativi_falliti_garante) {
        this.otp_tentativi_falliti_garante = otp_tentativi_falliti_garante;
    }

    public String getPrivato_azienda() {
        return privato_azienda;
    }

    public void setPrivato_azienda(String privato_azienda) {
        this.privato_azienda = privato_azienda;
    }

    public String getProvincia_nascita() {
        return provincia_nascita;
    }

    public void setProvincia_nascita(String provincia_nascita) {
        this.provincia_nascita = provincia_nascita;
    }

    public String getData_nascita() {
        return data_nascita;
    }

    public void setData_nascita(String data_nascita) {
        this.data_nascita = data_nascita;
    }

    public String getGarante_provincia_nascita() {
        return garante_provincia_nascita;
    }

    public void setGarante_provincia_nascita(String garante_provincia_nascita) {
        this.garante_provincia_nascita = garante_provincia_nascita;
    }

    public String getGarante_data_nascita() {
        return garante_data_nascita;
    }

    public void setGarante_data_nascita(String garante_data_nascita) {
        this.garante_data_nascita = garante_data_nascita;
    }

    public String getContratto_numero() {
        return contratto_numero;
    }

    public void setContratto_numero(String contratto_numero) {
        this.contratto_numero = contratto_numero;
    }
    
    public boolean is_otp_verificato_garante(){
        if(otp_data_ora_verifica_garante!=null)
            return true;
        else
            return false;
    }
    
    public boolean is_garante_presente(){
        return garante_presente.equals("si");
    }
    
    public boolean is_tipo_standard(){
        return tipo.equals(TIPO_STANDARD);
    }
    
    public boolean is_tipo_tasso_0(){
        return tipo.equals(TIPO_TASSO_0);
    }

    public String getTipo_string(){
        if(is_tipo_tasso_0())
            return "Tasso Zero";
        else
            return "Tasso Standard";
    }
    
    @Override
    public String toString() {
        return "Finanziamento "+getTipo_string()+" n."+numero;
    }
    
    
}
