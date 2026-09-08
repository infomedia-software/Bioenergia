package beans;

public class Documento {

    private int id;
    private int id_autore;
    private int id_soggetto;
    private int id_situazione;
    
    private Soggetto autore;
    
    private String tipo = "";
    private int numero;
    private String lettera = "";
    private String luogo = "";
    private String data = "";
    private String data_modifica = "";
    private String data_creazione = "";

    private String firma_cliente = "";
    private String osservazioni = "";
    private String servizi_inclusi = "";
    private String modalita_pagamento = "";
    private String note1 = "";
    private String note2 = "";
    private String note3 = "";

    private double imponibile;
    private double iva;
    private double totale;
    private double gse_prezzi;

    private String pagamento = "";
    private String stato = "";

    // DATI CLIENTE
    private String cliente_privato_azienda = "";
    private String cliente_nome = "";
    private String cliente_cognome = "";
    private String cliente_ragione_sociale = "";
    private String cliente_cf = "";
    private String cliente_piva = "";
    private String cliente_indirizzo = "";
    private String cliente_cap = "";
    private String cliente_localita = "";
    private String cliente_comune = "";
    private String cliente_provincia = "";
    private String cliente_telefono = "";
    private String cliente_cellulare = "";
    private String cliente_email = "";
    private String cliente_luogo_nascita = "";
    private String cliente_data_nascita = "";
    private String cliente_qualifica = "";
    private String cliente_societa_rappresentata = "";

    // MODULO STRATIFICAZIONE MANTO DI COPERTURA
    private String abitazione_tipologia = "";
    private String abitazione_tipologia_altro = "";
    private String copertura_tipologia = "";
    private String copertura_tipologia_altro = "";
    private String copertura_guaina = "";
    private double altezza_grondaia;
    private String copertura_coibentazione = "";
    private String copertura_materiale = "";
    private String copertura_materiale_altro = "";
    private String copertura_struttura = "";

    // MODULO DETRAZIONE
    private String detrazione_intestatario = "";
    private double immobile_superficie_mq;
    private String immobile_titolo_possesso = "";
    private int immobile_num_unita;
    private String immobile_anno_costruzione = "";
    private String immobile_tipologia_edilizia = "";
    private String immobile_tipo_intervento = "";
    private String immobile_unita_intervento = "";

    // DATI IMPIANTO
    private String impianto_procedura = "";
    private String impianto_intervento_edilizio = "";
    private String impianto_tipologia = "";
    private double impianto_superficie_moduli;
    private String impianto_localita = "";
    private String impianto_comune = "";
    private String impianto_foglio_catastale = "";
    private String impianto_particella = "";
    private String impianto_coordinate = "";
    private String impianto_data_entrata_esercizio = "";
    private double impianto_potenza_kw;
    private double impianto_producibilita_annua;
    private String impianto_note = "";

    // OTP
    private String otp_sms = "";
    private String otp_hash = "";
    private String otp_data_ora_generazione = "";
    private String otp_data_ora_scadenza = "";
    private String otp_data_ora_verifica = "";
    private String otp_ip = "";
    private String otp_id_soggetto_verifica = "";


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId_autore() {
        return id_autore;
    }

    public void setId_autore(int id_autore) {
        this.id_autore = id_autore;
    }

    public int getId_soggetto() {
        return id_soggetto;
    }

    public void setId_soggetto(int id_soggetto) {
        this.id_soggetto = id_soggetto;
    }

    public int getId_situazione() {
        return id_situazione;
    }

    public void setId_situazione(int id_situazione) {
        this.id_situazione = id_situazione;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public int getNumero() {
        return numero;
    }

    public void setNumero(int numero) {
        this.numero = numero;
    }

    public String getLettera() {
        return lettera;
    }

    public void setLettera(String lettera) {
        this.lettera = lettera;
    }

    public String getLuogo() {
        return luogo;
    }

    public void setLuogo(String luogo) {
        this.luogo = luogo;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getData_modifica() {
        return data_modifica;
    }

    public void setData_modifica(String data_modifica) {
        this.data_modifica = data_modifica;
    }

    public String getData_creazione() {
        return data_creazione;
    }

    public void setData_creazione(String data_creazione) {
        this.data_creazione = data_creazione;
    }

    public String getFirma_cliente() {
        return firma_cliente;
    }

    public void setFirma_cliente(String firma_cliente) {
        this.firma_cliente = firma_cliente;
    }

    public String getOsservazioni() {
        return osservazioni;
    }

    public void setOsservazioni(String osservazioni) {
        this.osservazioni = osservazioni;
    }

    public String getServizi_inclusi() {
        return servizi_inclusi;
    }

    public void setServizi_inclusi(String servizi_inclusi) {
        this.servizi_inclusi = servizi_inclusi;
    }

    public String getModalita_pagamento() {
        return modalita_pagamento;
    }

    public void setModalita_pagamento(String modalita_pagamento) {
        this.modalita_pagamento = modalita_pagamento;
    }

    public String getNote1() {
        return note1;
    }

    public void setNote1(String note1) {
        this.note1 = note1;
    }

    public String getNote2() {
        return note2;
    }

    public void setNote2(String note2) {
        this.note2 = note2;
    }

    public String getNote3() {
        return note3;
    }

    public void setNote3(String note3) {
        this.note3 = note3;
    }

    public double getImponibile() {
        return imponibile;
    }

    public void setImponibile(double imponibile) {
        this.imponibile = imponibile;
    }

    public double getIva() {
        return iva;
    }

    public void setIva(double iva) {
        this.iva = iva;
    }

    public double getTotale() {
        return totale;
    }

    public void setTotale(double totale) {
        this.totale = totale;
    }

    public double getGse_prezzi() {
        return gse_prezzi;
    }

    public void setGse_prezzi(double gse_prezzi) {
        this.gse_prezzi = gse_prezzi;
    }

    public String getPagamento() {
        return pagamento;
    }

    public void setPagamento(String pagamento) {
        this.pagamento = pagamento;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getCliente_nome() {
        return cliente_nome;
    }

    public void setCliente_nome(String cliente_nome) {
        this.cliente_nome = cliente_nome;
    }

    public String getCliente_cognome() {
        return cliente_cognome;
    }

    public void setCliente_cognome(String cliente_cognome) {
        this.cliente_cognome = cliente_cognome;
    }

    public String getCliente_ragione_sociale() {
        return cliente_ragione_sociale;
    }

    public void setCliente_ragione_sociale(String cliente_ragione_sociale) {
        this.cliente_ragione_sociale = cliente_ragione_sociale;
    }

    public String getCliente_cf() {
        return cliente_cf;
    }

    public void setCliente_cf(String cliente_cf) {
        this.cliente_cf = cliente_cf;
    }

    public String getCliente_piva() {
        return cliente_piva;
    }

    public void setCliente_piva(String cliente_piva) {
        this.cliente_piva = cliente_piva;
    }

    public String getCliente_indirizzo() {
        return cliente_indirizzo;
    }

    public void setCliente_indirizzo(String cliente_indirizzo) {
        this.cliente_indirizzo = cliente_indirizzo;
    }

    public String getCliente_cap() {
        return cliente_cap;
    }

    public void setCliente_cap(String cliente_cap) {
        this.cliente_cap = cliente_cap;
    }

    public String getCliente_localita() {
        return cliente_localita;
    }

    public void setCliente_localita(String cliente_localita) {
        this.cliente_localita = cliente_localita;
    }

    public String getCliente_comune() {
        return cliente_comune;
    }

    public void setCliente_comune(String cliente_comune) {
        this.cliente_comune = cliente_comune;
    }

    public String getCliente_provincia() {
        return cliente_provincia;
    }

    public void setCliente_provincia(String cliente_provincia) {
        this.cliente_provincia = cliente_provincia;
    }

    public String getCliente_telefono() {
        return cliente_telefono;
    }

    public void setCliente_telefono(String cliente_telefono) {
        this.cliente_telefono = cliente_telefono;
    }

    public String getCliente_cellulare() {
        return cliente_cellulare;
    }

    public void setCliente_cellulare(String cliente_cellulare) {
        this.cliente_cellulare = cliente_cellulare;
    }

    public String getCliente_email() {
        return cliente_email;
    }

    public void setCliente_email(String cliente_email) {
        this.cliente_email = cliente_email;
    }

    public String getCliente_luogo_nascita() {
        return cliente_luogo_nascita;
    }

    public void setCliente_luogo_nascita(String cliente_luogo_nascita) {
        this.cliente_luogo_nascita = cliente_luogo_nascita;
    }

    public String getCliente_data_nascita() {
        return cliente_data_nascita;
    }

    public void setCliente_data_nascita(String cliente_data_nascita) {
        this.cliente_data_nascita = cliente_data_nascita;
    }

    public String getCliente_qualifica() {
        return cliente_qualifica;
    }

    public void setCliente_qualifica(String cliente_qualifica) {
        this.cliente_qualifica = cliente_qualifica;
    }

    public String getCliente_societa_rappresentata() {
        return cliente_societa_rappresentata;
    }

    public void setCliente_societa_rappresentata(String cliente_societa_rappresentata) {
        this.cliente_societa_rappresentata = cliente_societa_rappresentata;
    }

    public String getAbitazione_tipologia() {
        return abitazione_tipologia;
    }

    public void setAbitazione_tipologia(String abitazione_tipologia) {
        this.abitazione_tipologia = abitazione_tipologia;
    }

    public String getAbitazione_tipologia_altro() {
        return abitazione_tipologia_altro;
    }

    public void setAbitazione_tipologia_altro(String abitazione_tipologia_altro) {
        this.abitazione_tipologia_altro = abitazione_tipologia_altro;
    }

    public String getCopertura_tipologia() {
        return copertura_tipologia;
    }

    public void setCopertura_tipologia(String copertura_tipologia) {
        this.copertura_tipologia = copertura_tipologia;
    }

    public String getCopertura_tipologia_altro() {
        return copertura_tipologia_altro;
    }

    public void setCopertura_tipologia_altro(String copertura_tipologia_altro) {
        this.copertura_tipologia_altro = copertura_tipologia_altro;
    }

    public String getCopertura_guaina() {
        return copertura_guaina;
    }

    public void setCopertura_guaina(String copertura_guaina) {
        this.copertura_guaina = copertura_guaina;
    }

    public double getAltezza_grondaia() {
        return altezza_grondaia;
    }

    public void setAltezza_grondaia(double altezza_grondaia) {
        this.altezza_grondaia = altezza_grondaia;
    }

    public String getCopertura_coibentazione() {
        return copertura_coibentazione;
    }

    public void setCopertura_coibentazione(String copertura_coibentazione) {
        this.copertura_coibentazione = copertura_coibentazione;
    }

    public String getCopertura_materiale() {
        return copertura_materiale;
    }

    public void setCopertura_materiale(String copertura_materiale) {
        this.copertura_materiale = copertura_materiale;
    }

    public String getCopertura_materiale_altro() {
        return copertura_materiale_altro;
    }

    public void setCopertura_materiale_altro(String copertura_materiale_altro) {
        this.copertura_materiale_altro = copertura_materiale_altro;
    }

    public String getCopertura_struttura() {
        return copertura_struttura;
    }

    public void setCopertura_struttura(String copertura_struttura) {
        this.copertura_struttura = copertura_struttura;
    }

    public String getDetrazione_intestatario() {
        return detrazione_intestatario;
    }

    public void setDetrazione_intestatario(String detrazione_intestatario) {
        this.detrazione_intestatario = detrazione_intestatario;
    }

    public double getImmobile_superficie_mq() {
        return immobile_superficie_mq;
    }

    public void setImmobile_superficie_mq(double immobile_superficie_mq) {
        this.immobile_superficie_mq = immobile_superficie_mq;
    }

    public String getImmobile_titolo_possesso() {
        return immobile_titolo_possesso;
    }

    public void setImmobile_titolo_possesso(String immobile_titolo_possesso) {
        this.immobile_titolo_possesso = immobile_titolo_possesso;
    }

    public int getImmobile_num_unita() {
        return immobile_num_unita;
    }

    public void setImmobile_num_unita(int immobile_num_unita) {
        this.immobile_num_unita = immobile_num_unita;
    }

    public String getImmobile_anno_costruzione() {
        return immobile_anno_costruzione;
    }

    public void setImmobile_anno_costruzione(String immobile_anno_costruzione) {
        this.immobile_anno_costruzione = immobile_anno_costruzione;
    }

    public String getImmobile_tipologia_edilizia() {
        return immobile_tipologia_edilizia;
    }

    public void setImmobile_tipologia_edilizia(String immobile_tipologia_edilizia) {
        this.immobile_tipologia_edilizia = immobile_tipologia_edilizia;
    }

    public String getImmobile_tipo_intervento() {
        return immobile_tipo_intervento;
    }

    public void setImmobile_tipo_intervento(String immobile_tipo_intervento) {
        this.immobile_tipo_intervento = immobile_tipo_intervento;
    }

    public String getImmobile_unita_intervento() {
        return immobile_unita_intervento;
    }

    public void setImmobile_unita_intervento(String immobile_unita_intervento) {
        this.immobile_unita_intervento = immobile_unita_intervento;
    }

    public String getImpianto_procedura() {
        return impianto_procedura;
    }

    public void setImpianto_procedura(String impianto_procedura) {
        this.impianto_procedura = impianto_procedura;
    }

    public String getImpianto_intervento_edilizio() {
        return impianto_intervento_edilizio;
    }

    public void setImpianto_intervento_edilizio(String impianto_intervento_edilizio) {
        this.impianto_intervento_edilizio = impianto_intervento_edilizio;
    }

    public String getImpianto_tipologia() {
        return impianto_tipologia;
    }

    public void setImpianto_tipologia(String impianto_tipologia) {
        this.impianto_tipologia = impianto_tipologia;
    }

    public double getImpianto_superficie_moduli() {
        return impianto_superficie_moduli;
    }

    public void setImpianto_superficie_moduli(double impianto_superficie_moduli) {
        this.impianto_superficie_moduli = impianto_superficie_moduli;
    }

    public String getImpianto_localita() {
        return impianto_localita;
    }

    public void setImpianto_localita(String impianto_localita) {
        this.impianto_localita = impianto_localita;
    }

    public String getImpianto_comune() {
        return impianto_comune;
    }

    public void setImpianto_comune(String impianto_comune) {
        this.impianto_comune = impianto_comune;
    }

    public String getImpianto_foglio_catastale() {
        return impianto_foglio_catastale;
    }

    public void setImpianto_foglio_catastale(String impianto_foglio_catastale) {
        this.impianto_foglio_catastale = impianto_foglio_catastale;
    }

    public String getImpianto_particella() {
        return impianto_particella;
    }

    public void setImpianto_particella(String impianto_particella) {
        this.impianto_particella = impianto_particella;
    }

    public String getImpianto_coordinate() {
        return impianto_coordinate;
    }

    public void setImpianto_coordinate(String impianto_coordinate) {
        this.impianto_coordinate = impianto_coordinate;
    }

    public String getImpianto_data_entrata_esercizio() {
        return impianto_data_entrata_esercizio;
    }

    public void setImpianto_data_entrata_esercizio(String impianto_data_entrata_esercizio) {
        this.impianto_data_entrata_esercizio = impianto_data_entrata_esercizio;
    }

    public double getImpianto_potenza_kw() {
        return impianto_potenza_kw;
    }

    public void setImpianto_potenza_kw(double impianto_potenza_kw) {
        this.impianto_potenza_kw = impianto_potenza_kw;
    }

    public double getImpianto_producibilita_annua() {
        return impianto_producibilita_annua;
    }

    public void setImpianto_producibilita_annua(double impianto_producibilita_annua) {
        this.impianto_producibilita_annua = impianto_producibilita_annua;
    }

    public String getImpianto_note() {
        return impianto_note;
    }

    public void setImpianto_note(String impianto_note) {
        this.impianto_note = impianto_note;
    }

    public String getOtp_sms() {
        return otp_sms;
    }

    public void setOtp_sms(String otp_sms) {
        this.otp_sms = otp_sms;
    }

    public String getOtp_hash() {
        return otp_hash;
    }

    public void setOtp_hash(String otp_hash) {
        this.otp_hash = otp_hash;
    }

    public String getOtp_data_ora_generazione() {
        return otp_data_ora_generazione;
    }

    public void setOtp_data_ora_generazione(String otp_data_ora_generazione) {
        this.otp_data_ora_generazione = otp_data_ora_generazione;
    }

    public String getOtp_data_ora_scadenza() {
        return otp_data_ora_scadenza;
    }

    public void setOtp_data_ora_scadenza(String otp_data_ora_scadenza) {
        this.otp_data_ora_scadenza = otp_data_ora_scadenza;
    }

    public String getOtp_data_ora_verifica() {
        return otp_data_ora_verifica;
    }

    public void setOtp_data_ora_verifica(String otp_data_ora_verifica) {
        this.otp_data_ora_verifica = otp_data_ora_verifica;
    }

    public String getOtp_ip() {
        return otp_ip;
    }

    public void setOtp_ip(String otp_ip) {
        this.otp_ip = otp_ip;
    }

    public String getOtp_id_soggetto_verifica() {
        return otp_id_soggetto_verifica;
    }

    public void setOtp_id_soggetto_verifica(String otp_id_soggetto_verifica) {
        this.otp_id_soggetto_verifica = otp_id_soggetto_verifica;
    }

    public Soggetto getAutore() {
        return autore;
    }

    public void setAutore(Soggetto autore) {
        this.autore = autore;
    }
    
    public String getData_it() {
        if(data==null || data.trim().equals(""))
            return "";

        try {
            String[] parti=data.split("-");
            return parti[2]+"/"+parti[1]+"/"+parti[0];
        } catch(Exception e) {
            return data;
        }
    }

    public String getNumero_completo() {
        String numero_completo=String.valueOf(numero);

        if(lettera!=null && !lettera.trim().equals(""))
            numero_completo+="/"+lettera;

        return numero_completo;
    }

    public String getCf_piva() {
        if(cliente_cf!=null && !cliente_cf.trim().equals(""))
            return cliente_cf;

        if(cliente_piva!=null)
            return cliente_piva;

        return "";
    }

    public String getCliente_privato_azienda() {
        return cliente_privato_azienda;
    }

    public void setCliente_privato_azienda(String cliente_privato_azienda) {
        this.cliente_privato_azienda = cliente_privato_azienda;
    }
    
    
    
    public String toString(){
        return (tipo==null || tipo.equals("") ? "" : tipo.replaceAll("_"," ").substring(0,1).toUpperCase()+tipo.substring(1))+" "+getNumero_completo();
    }
}