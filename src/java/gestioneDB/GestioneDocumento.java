/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gestioneDB;

import beans.Documento;
import beans.Riga;
import beans.Soggetto;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import utility.GestioneErrori;
import utility.Utility;

/**
 *
 * @author david
 */
public class GestioneDocumento {
     private static GestioneDocumento istanza;

    public static GestioneDocumento getIstanza() {
        if (istanza == null) {
            istanza = new GestioneDocumento();
        }
        return istanza;
    }

    public Documento get_documento(String id_documento) {
        Documento toReturn = null;
        ArrayList<Documento> temp = ricerca_documento("documento.id=" + id_documento + " AND documento.stato='1'","",-1);

        if (temp.size() == 1) {
            toReturn = temp.get(0);
        }

        return toReturn;
    }
    
    
    public ArrayList<Documento> ricerca_documento(String query_input, String ordinamento, int offset) {

        ArrayList<Documento> toReturn = new ArrayList<Documento>();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {

            String query = "SELECT documento.*, "
                + "soggetto.nome AS autore_nome, "
                + "soggetto.cognome AS autore_cognome "
                + "FROM documento "
                + "LEFT OUTER JOIN soggetto ON soggetto.id=documento.id_autore "
                + "WHERE documento.stato='1' ";

            if (query_input != null && !query_input.trim().equals("")) {
                query += " AND " + query_input;
            }

            if (ordinamento != null && !ordinamento.trim().equals("")) {
                query += " ORDER BY " + ordinamento;
            }

            if (offset >= 0) {
                query += " LIMIT " + offset + "," + Utility.righe_pagina;
            }
            
            conn = DBConnection.getConnection();
            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {

                Documento documento = new Documento();

                documento.setId(rs.getInt("id"));
                documento.setId_autore(rs.getInt("id_autore"));
                documento.setId_soggetto(rs.getInt("id_soggetto"));
                documento.setId_situazione(rs.getInt("id_situazione"));
                
                Soggetto autore = new Soggetto();
                autore.setId(String.valueOf(documento.getId_autore()));
                autore.setNome(rs.getString("autore_nome"));
                autore.setCognome(rs.getString("autore_cognome"));
                documento.setAutore(autore);

                documento.setTipo(rs.getString("tipo"));
                documento.setNumero(rs.getInt("numero"));
                documento.setLettera(rs.getString("lettera"));
                documento.setLuogo(rs.getString("luogo"));
                documento.setData(rs.getString("data"));
                documento.setData_modifica(rs.getString("data_modifica"));
                documento.setData_creazione(rs.getString("data_creazione"));

                documento.setFirma_cliente(rs.getString("firma_cliente"));
                documento.setOsservazioni(rs.getString("osservazioni"));
                documento.setServizi_inclusi(Utility.elimina_null(rs.getString("servizi_inclusi")));
                documento.setModalita_pagamento(rs.getString("modalita_pagamento"));

                documento.setNote1(rs.getString("note1"));
                documento.setNote2(rs.getString("note2"));
                documento.setNote3(rs.getString("note3"));

                documento.setImponibile(rs.getDouble("imponibile"));
                documento.setIva(rs.getDouble("iva"));
                documento.setTotale(rs.getDouble("totale"));
                documento.setGse_prezzi(rs.getDouble("gse_prezzi"));

                documento.setPagamento(rs.getString("pagamento"));
                documento.setStato(rs.getString("stato"));

                // CLIENTE
                documento.setCliente_privato_azienda(rs.getString("cliente_privato_azienda"));
                documento.setCliente_nome(rs.getString("cliente_nome"));
                documento.setCliente_cognome(rs.getString("cliente_cognome"));
                documento.setCliente_ragione_sociale(rs.getString("cliente_ragione_sociale"));
                documento.setCliente_cf(rs.getString("cliente_cf"));
                documento.setCliente_piva(rs.getString("cliente_piva"));
                documento.setCliente_indirizzo(rs.getString("cliente_indirizzo"));
                documento.setCliente_cap(rs.getString("cliente_cap"));
                documento.setCliente_localita(rs.getString("cliente_localita"));
                documento.setCliente_comune(rs.getString("cliente_comune"));
                documento.setCliente_provincia(rs.getString("cliente_provincia"));
                documento.setCliente_telefono(rs.getString("cliente_telefono"));
                documento.setCliente_cellulare(rs.getString("cliente_cellulare"));
                documento.setCliente_email(rs.getString("cliente_email"));
                documento.setCliente_luogo_nascita(rs.getString("cliente_luogo_nascita"));
                documento.setCliente_data_nascita(rs.getString("cliente_data_nascita"));
                documento.setCliente_qualifica(rs.getString("cliente_qualifica"));
                documento.setCliente_societa_rappresentata(rs.getString("cliente_societa_rappresentata"));

                // COPERTURA
                documento.setAbitazione_tipologia(rs.getString("abitazione_tipologia"));
                documento.setAbitazione_tipologia_altro(rs.getString("abitazione_tipologia_altro"));

                documento.setCopertura_tipologia(rs.getString("copertura_tipologia"));
                documento.setCopertura_tipologia_altro(rs.getString("copertura_tipologia_altro"));
                documento.setCopertura_guaina(rs.getString("copertura_guaina"));
                documento.setAltezza_grondaia(rs.getDouble("altezza_grondaia"));
                documento.setCopertura_coibentazione(rs.getString("copertura_coibentazione"));
                documento.setCopertura_materiale(rs.getString("copertura_materiale"));
                documento.setCopertura_materiale_altro(rs.getString("copertura_materiale_altro"));
                documento.setCopertura_struttura(rs.getString("copertura_struttura"));

                // DETRAZIONE
                documento.setDetrazione_intestatario(rs.getString("detrazione_intestatario"));
                documento.setImmobile_superficie_mq(rs.getDouble("immobile_superficie_mq"));
                documento.setImmobile_titolo_possesso(rs.getString("immobile_titolo_possesso"));
                documento.setImmobile_num_unita(rs.getInt("immobile_num_unita"));
                documento.setImmobile_anno_costruzione(rs.getString("immobile_anno_costruzione"));
                documento.setImmobile_tipologia_edilizia(rs.getString("immobile_tipologia_edilizia"));
                documento.setImmobile_tipo_intervento(rs.getString("immobile_tipo_intervento"));
                documento.setImmobile_unita_intervento(rs.getString("immobile_unita_intervento"));

                // IMPIANTO
                documento.setImpianto_procedura(rs.getString("impianto_procedura"));
                documento.setImpianto_intervento_edilizio(rs.getString("impianto_intervento_edilizio"));
                documento.setImpianto_tipologia(rs.getString("impianto_tipologia"));
                documento.setImpianto_superficie_moduli(rs.getDouble("impianto_superficie_moduli"));
                documento.setImpianto_localita(rs.getString("impianto_localita"));
                documento.setImpianto_comune(rs.getString("impianto_comune"));
                documento.setImpianto_foglio_catastale(rs.getString("impianto_foglio_catastale"));
                documento.setImpianto_particella(rs.getString("impianto_particella"));
                documento.setImpianto_coordinate(rs.getString("impianto_coordinate"));
                documento.setImpianto_data_entrata_esercizio(rs.getString("impianto_data_entrata_esercizio"));
                documento.setImpianto_potenza_kw(rs.getDouble("impianto_potenza_kw"));
                documento.setImpianto_producibilita_annua(rs.getDouble("impianto_producibilita_annua"));
                documento.setImpianto_note(rs.getString("impianto_note"));

                // OTP
                documento.setOtp_sms(rs.getString("otp_sms"));
                documento.setOtp_hash(rs.getString("otp_hash"));
                documento.setOtp_data_ora_generazione(rs.getString("otp_data_ora_generazione"));
                documento.setOtp_data_ora_scadenza(rs.getString("otp_data_ora_scadenza"));
                documento.setOtp_data_ora_verifica(rs.getString("otp_data_ora_verifica"));
                documento.setOtp_ip(rs.getString("otp_ip"));
                documento.setOtp_id_soggetto_verifica(rs.getString("otp_id_soggetto_verifica"));

                toReturn.add(documento);
            }
        }
        catch (SQLException ex) {
            GestioneErrori.errore("GestioneDocumenti", "ricerca_documento", ex);
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneDocumenti", "ricerca_documento", ex);
         }
        finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }

        return toReturn;
    }
    
    public int get_ultimo_numero(String tipo) {
        int numero=1;

        try {
            String numero_db=Utility.getIstanza().query_select(
                "SELECT IFNULL(MAX(numero),0)+1 AS numero "
                +"FROM documento "
                +"WHERE tipo='"+tipo.replace("'","''")+"' "
                +"AND stato='1'",
                "numero"
            );

            numero=Integer.parseInt(numero_db);

        } catch(Exception e) {
            GestioneErrori.errore("GestioneDocumento", "get_numero", e);
        }

        return numero;
    }
    
    
    public ArrayList<Riga> ricerca_righe(String query_input, String ordinamento, int offset) {
        ArrayList<Riga> toReturn = new ArrayList<Riga>();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {

            String query = "SELECT * FROM riga WHERE riga.stato='1' ";

            if (query_input != null && !query_input.trim().equals("")) {
                query += " AND " + query_input;
            }

            if (ordinamento != null && !ordinamento.trim().equals("")) {
                query += " ORDER BY " + ordinamento;
            }

            if (offset >= 0) {
                query += " LIMIT " + offset + "," + Utility.righe_pagina;
            }

            conn = DBConnection.getConnection();

            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {

                Riga riga = new Riga();

                riga.setId(rs.getInt("id"));
                riga.setId_documento(rs.getInt("id_documento"));

                riga.setDescrizione(rs.getString("descrizione"));

                riga.setImponibile(rs.getDouble("imponibile"));
                riga.setIva(rs.getDouble("iva"));
                riga.setTotale(rs.getDouble("totale"));

                riga.setStato(rs.getString("stato"));
                riga.setData_creazione(rs.getString("data_creazione"));
                riga.setData_modifica(rs.getString("data_modifica"));

                toReturn.add(riga);
            }

        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneDocumento", "ricerca_riga", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }

        return toReturn;
    }
    
    public ArrayList<Riga> get_righe_documento(int id_documento) {
        return ricerca_righe("id_documento=" + id_documento,"id ASC",-1);
    }
    
}
