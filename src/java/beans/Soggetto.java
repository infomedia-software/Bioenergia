package beans;

import enums.SoggettoTipologia;
import utility.Utility;

public class Soggetto {

    private String id;
    private String privato_azienda;
    private String codice;
    private String nome_utente;
    private String password;
    private SoggettoTipologia tipologia;
    private String ruolo;
    private String ragione_sociale;
    private String alias;
    private String nome; 
    private String cognome;
    private String referente;
    private String piva;
    private String cf;
    private String indirizzo;
    private String cap;
    private String comune;
    private String provincia;
    private String regione;
    private String nazione;
    private String telefono;
    private String cellulare;
    private String email;
    private String pec;
    private String sdi;
    private String fax;
    private String sito;
    private String data_nascita;
    private String luogo_nascita;
    private String condizioni_pagamento;
    private String banca;
    private String iban;
    private String bic;
    private String regime_iva;
    private String separazione_iva;
    private double ritenuta;
    private double iva_abituale;
    private double sconto;
    private double costo_orario;
    private String immagine;
    private String firma;
    private String campo1;
    private String campo2;
    private String campo3;
    private String campo4;
    private String campo5;
    private String campo6;
    private String campo7;
    private String campo8;
    private String campo9;
    private String campo10;
    private String attivo;
    private String note;
    private String stato;

    public boolean is_amministratore(){
        return ruolo.equals("AMMINISTRATORE");
    }
    public boolean is_dipendente(){
        return ruolo.equals("DIPENDENTE");
    }
    
    public boolean is_tecnico(){
        return ruolo.equals("TECNICO");
    }
    
    
    public Soggetto(){
        this.id="";
        this.nome="";
        this.cognome="";
        this.alias="";
        this.ragione_sociale="";
        this.indirizzo="";
        this.cap="";
        this.provincia="";
        this.comune="";
        this.cellulare="";
        this.telefono="";
        this.cf="";
        this.piva="";
        this.email="";
        this.luogo_nascita="";
        this.privato_azienda="";
    }
    
    public boolean is_cliente(){
        return tipologia.equals(SoggettoTipologia.CLIENTE) || tipologia.equals(SoggettoTipologia.CLIENTE_FORNITORE);
    }
    public boolean is_fornitore(){
        return tipologia.equals(SoggettoTipologia.FORNITORE) || tipologia.equals(SoggettoTipologia.CLIENTE_FORNITORE);
    }
    public boolean is_utente(){
        return tipologia.equals(SoggettoTipologia.UTENTE);
    }
    
    public String url(){
        if(is_utente())
            return Utility.url+"/utente/utente.jsp?id_utente="+id;
        else
            return Utility.url+"/soggetto/soggetto.jsp?id_soggetto="+id;
            
    }

    @Override
    public String toString(){
        if(tipologia.equals(SoggettoTipologia.UTENTE.name())) return (Utility.elimina_null(cognome)+" "+Utility.elimina_null(nome)).trim();
        if(privato_azienda.equals("azienda")) return Utility.elimina_null(ragione_sociale);
        return (Utility.elimina_null(cognome)+" "+Utility.elimina_null(nome)).trim();
    }
    

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
   
    public String getCodice() {
        return codice;
    }

    public void setCodice(String codice) {
        this.codice = codice;
    }

    public String getNome_utente() {
        return nome_utente;
    }

    public void setNome_utente(String nome_utente) {
        this.nome_utente = nome_utente;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public SoggettoTipologia getTipologia() {
        return tipologia;
    }

    public void setTipologia(SoggettoTipologia tipologia) {
        this.tipologia = tipologia;
    }

    
    
    public String getRuolo() {
        return ruolo;
    }

    public void setRuolo(String ruolo) {
        this.ruolo = ruolo;
    }

    public String getRagione_sociale() {
        return ragione_sociale;
    }

    public void setRagione_sociale(String ragione_sociale) {
        this.ragione_sociale = ragione_sociale;
    }

    public String getAlias() {
        return alias;
    }

    public void setAlias(String alias) {
        this.alias = alias;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public String getReferente() {
        return referente;
    }

    public void setReferente(String referente) {
        this.referente = referente;
    }

    public String getPiva() {
        return piva;
    }

    public void setPiva(String piva) {
        this.piva = piva;
    }

    public String getCf() {
        return cf;
    }

    public void setCf(String cf) {
        this.cf = cf;
    }

    public String getIndirizzo() {
        return indirizzo;
    }

    public void setIndirizzo(String indirizzo) {
        this.indirizzo = indirizzo;
    }

    public String getCap() {
        return cap;
    }

    public void setCap(String cap) {
        this.cap = cap;
    }

    public String getComune() {
        return comune;
    }

    public void setComune(String comune) {
        this.comune = comune;
    }

    public String getProvincia() {
        return provincia;
    }

    public void setProvincia(String provincia) {
        this.provincia = provincia;
    }

    public String getRegione() {
        return regione;
    }

    public void setRegione(String regione) {
        this.regione = regione;
    }

    public String getNazione() {
        return nazione;
    }

    public void setNazione(String nazione) {
        this.nazione = nazione;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCellulare() {
        return cellulare;
    }

    public void setCellulare(String cellulare) {
        this.cellulare = cellulare;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPec() {
        return pec;
    }

    public void setPec(String pec) {
        this.pec = pec;
    }

    public String getSdi() {
        return sdi;
    }

    public void setSdi(String sdi) {
        this.sdi = sdi;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
    }

    public String getSito() {
        return sito;
    }

    public void setSito(String sito) {
        this.sito = sito;
    }

    public String getCondizioni_pagamento() {
        return condizioni_pagamento;
    }

    public void setCondizioni_pagamento(String condizioni_pagamento) {
        this.condizioni_pagamento = condizioni_pagamento;
    }

    public String getBanca() {
        return banca;
    }

    public void setBanca(String banca) {
        this.banca = banca;
    }

    public String getIban() {
        return iban;
    }

    public void setIban(String iban) {
        this.iban = iban;
    }

    public String getBic() {
        return bic;
    }

    public void setBic(String bic) {
        this.bic = bic;
    }

    public String getRegime_iva() {
        return regime_iva;
    }

    public void setRegime_iva(String regime_iva) {
        this.regime_iva = regime_iva;
    }

    public String getSeparazione_iva() {
        return separazione_iva;
    }

    public void setSeparazione_iva(String separazione_iva) {
        this.separazione_iva = separazione_iva;
    }

    public double getRitenuta() {
        return ritenuta;
    }

    public void setRitenuta(double ritenuta) {
        this.ritenuta = ritenuta;
    }

    public double getIva_abituale() {
        return iva_abituale;
    }

    public void setIva_abituale(double iva_abituale) {
        this.iva_abituale = iva_abituale;
    }

    public double getSconto() {
        return sconto;
    }

    public void setSconto(double sconto) {
        this.sconto = sconto;
    }

    public double getCosto_orario() {
        return costo_orario;
    }

    public void setCosto_orario(double costo_orario) {
        this.costo_orario = costo_orario;
    }

    public String getImmagine() {
        return immagine;
    }

    public void setImmagine(String immagine) {
        this.immagine = immagine;
    }

    public String getFirma() {
        return firma;
    }

    public void setFirma(String firma) {
        this.firma = firma;
    }

    public String getCampo1() {
        return campo1;
    }

    public void setCampo1(String campo1) {
        this.campo1 = campo1;
    }

    public String getCampo2() {
        return campo2;
    }

    public void setCampo2(String campo2) {
        this.campo2 = campo2;
    }

    public String getCampo3() {
        return campo3;
    }

    public void setCampo3(String campo3) {
        this.campo3 = campo3;
    }

    public String getCampo4() {
        return campo4;
    }

    public void setCampo4(String campo4) {
        this.campo4 = campo4;
    }

    public String getCampo5() {
        return campo5;
    }

    public void setCampo5(String campo5) {
        this.campo5 = campo5;
    }

    public String getCampo6() {
        return campo6;
    }

    public void setCampo6(String campo6) {
        this.campo6 = campo6;
    }

    public String getCampo7() {
        return campo7;
    }

    public void setCampo7(String campo7) {
        this.campo7 = campo7;
    }

    public String getCampo8() {
        return campo8;
    }

    public void setCampo8(String campo8) {
        this.campo8 = campo8;
    }

    public String getCampo9() {
        return campo9;
    }

    public void setCampo9(String campo9) {
        this.campo9 = campo9;
    }

    public String getCampo10() {
        return campo10;
    }

    public void setCampo10(String campo10) {
        this.campo10 = campo10;
    }


    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getAttivo() {
        return attivo;
    }

    public void setAttivo(String attivo) {
        this.attivo = attivo;
    }

    public String getPrivato_azienda() {
        return privato_azienda;
    }

    public void setPrivato_azienda(String privato_azienda) {
        this.privato_azienda = privato_azienda;
    }

    public String getData_nascita() {
        return data_nascita;
    }

    public void setData_nascita(String data_nascita) {
        this.data_nascita = data_nascita;
    }

    public String getLuogo_nascita() {
        return luogo_nascita;
    }

    public void setLuogo_nascita(String luogo_nascita) {
        this.luogo_nascita = luogo_nascita;
    }
     
    
    
}