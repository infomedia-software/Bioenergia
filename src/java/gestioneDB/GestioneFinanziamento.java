
package gestioneDB;

import beans.Finanziamento;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import utility.Utility;

public class GestioneFinanziamento {

    private static GestioneFinanziamento istanza;

    public static GestioneFinanziamento getIstanza() {
        if (istanza == null) {
            istanza = new GestioneFinanziamento();
        }
        return istanza;
    }

    public Finanziamento get_finanziamento(String id_finanziamento) {
        Finanziamento toReturn = null;

        if (id_finanziamento == null || !id_finanziamento.matches("\\d+")) {
            return null;
        }

        ArrayList<Finanziamento> temp = ricerca_finanziamento("finanziamento.id=" + id_finanziamento, "", -1);

        if (temp.size() == 1) {
            toReturn = temp.get(0);
        }
        return toReturn;
    }

    
    public ArrayList<Finanziamento> ricerca_finanziamento(String query_input, String ordinamento, int offset) {

        ArrayList<Finanziamento> toReturn=new ArrayList<Finanziamento>();

        String query="SELECT finanziamento.*, documento.numero AS contratto_numero "
            +"FROM finanziamento "
            +"LEFT JOIN documento ON documento.id=finanziamento.id_documento "
            +"WHERE finanziamento.stato='1' ";

        if(query_input!=null && !query_input.trim().equals("")){
            query+=" AND ("+query_input+")";
        }

        if(ordinamento!=null && !ordinamento.trim().equals("")){
            query+=" ORDER BY "+ordinamento;
        }

        if(offset>=0){
            query+=" LIMIT "+offset+","+Utility.righe_pagina;
        }

        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;

        try{
            conn=DBConnection.getConnection();
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery();

            while(rs.next()){

                Finanziamento f=new Finanziamento();

                // Dati generali
                f.setId(rs.getInt("id"));
                f.setId_documento(rs.getString("id_documento"));
                f.setTipo(rs.getString("tipo"));
                f.setId_autore(rs.getInt("id_autore"));
                f.setId_soggetto(rs.getInt("id_soggetto"));
                f.setId_situazione(rs.getInt("id_situazione"));
                f.setNumero(rs.getString("numero"));
                f.setContratto_numero(rs.getString("contratto_numero"));
                f.setLettera(rs.getString("lettera"));
                f.setLuogo(rs.getString("luogo"));
                f.setData(rs.getDate("data"));
                f.setImporto(rs.getDouble("importo"));
                f.setNumero_rate(rs.getInt("numero_rate"));
                f.setPrima_rata(rs.getString("prima_rata"));
                f.setIban(rs.getString("iban"));
                f.setNote_interne(rs.getString("note_interne"));

                // Dati cliente
                f.setPrivato_azienda(rs.getString("privato_azienda"));
                f.setNome(rs.getString("nome"));
                f.setCognome(rs.getString("cognome"));
                f.setRagione_sociale(rs.getString("ragione_sociale"));
                f.setCf(rs.getString("cf"));
                f.setPiva(rs.getString("piva"));
                f.setIndirizzo_dal(rs.getString("indirizzo_dal"));
                f.setIndirizzo_precedente(rs.getString("indirizzo_precedente"));
                f.setIndirizzo(rs.getString("indirizzo"));
                f.setCap(rs.getString("cap"));
                f.setLocalita(rs.getString("localita"));
                f.setComune(rs.getString("comune"));
                f.setProvincia(rs.getString("provincia"));
                f.setTelefono(rs.getString("telefono"));
                f.setCellulare(rs.getString("cellulare"));
                f.setEmail(rs.getString("email"));
                f.setLuogo_nascita(rs.getString("luogo_nascita"));
                f.setProvincia_nascita(rs.getString("provincia_nascita"));
                f.setData_nascita(rs.getString("data_nascita"));
                f.setCittadinanza(rs.getString("cittadinanza"));
                f.setSeconda_cittadinanza(rs.getString("seconda_cittadinanza"));
                f.setDocumento_tipo(rs.getString("documento_tipo"));
                f.setDocumento_numero(rs.getString("documento_numero"));
                f.setDocumento_rilasciato_il(rs.getString("documento_rilasciato_il"));
                f.setDocumento_rilasciato_da(rs.getString("documento_rilasciato_da"));
                f.setResidenza(rs.getString("residenza"));
                f.setResidenza_note(rs.getString("residenza_note"));
                f.setTipo_contratto(rs.getString("tipo_contratto"));
                f.setScadenza_contratto(rs.getString("scadenza_contratto"));
                f.setProfessione(rs.getString("professione"));
                f.setProfessione_settore(rs.getString("professione_settore"));
                f.setDatore_lavoro(rs.getString("datore_lavoro"));
                f.setReddito(rs.getString("reddito"));
                f.setStato_civile(rs.getString("stato_civile"));
                f.setNumero_figli(rs.getString("numero_figli"));

                // Dati garante
                f.setGarante_presente(rs.getString("garante_presente"));
                f.setGarante_nome(rs.getString("garante_nome"));
                f.setGarante_cognome(rs.getString("garante_cognome"));
                f.setGarante_cf(rs.getString("garante_cf"));
                f.setGarante_luogo_nascita(rs.getString("garante_luogo_nascita"));
                f.setGarante_provincia_nascita(rs.getString("garante_provincia_nascita"));
                f.setGarante_data_nascita(rs.getString("garante_data_nascita"));
                f.setGarante_cittadinanza(rs.getString("garante_cittadinanza"));
                f.setGarante_documento_tipo(rs.getString("garante_documento_tipo"));
                f.setGarante_documento_numero(rs.getString("garante_documento_numero"));
                f.setGarante_documento_rilasciato_il(rs.getString("garante_documento_rilasciato_il"));
                f.setGarante_documento_rilasciato_da(rs.getString("garante_documento_rilasciato_da"));
                f.setGarante_cellulare(rs.getString("garante_cellulare"));
                f.setGarante_email(rs.getString("garante_email"));
                f.setGarante_reddito(rs.getString("garante_reddito"));
                f.setGarante_professione(rs.getString("garante_professione"));
                f.setGarante_esposto(rs.getString("garante_esposto"));

                // Consensi
                f.setConsenso1(rs.getString("consenso1"));
                f.setConsenso2(rs.getString("consenso2"));
                f.setConsenso3(rs.getString("consenso3"));
                f.setConsenso4(rs.getString("consenso4"));
                f.setConsenso5(rs.getString("consenso5"));
                f.setConsenso6(rs.getString("consenso6"));
                f.setConsenso7(rs.getString("consenso7"));
                f.setConsenso8(rs.getString("consenso8"));

                // Firme
                f.setFirma_garante(rs.getString("firma_garante"));
                f.setOtp_sms_garante(rs.getString("otp_sms_garante"));
                f.setOtp_hash_garante(rs.getString("otp_hash_garante"));
                f.setOtp_data_ora_generazione_garante(rs.getString("otp_data_ora_generazione_garante"));
                f.setOtp_data_ora_scadenza_garante(rs.getString("otp_data_ora_scadenza_garante"));
                f.setOtp_data_ora_verifica_garante(rs.getString("otp_data_ora_verifica_garante"));
                f.setOtp_ip_garante(rs.getString("otp_ip_garante"));
                f.setOtp_tentativi_falliti_garante(rs.getInt("otp_tentativi_falliti_garante"));

                toReturn.add(f);
            }

        }catch(Exception e){
            System.out.println("ERRORE GestioneFinanziamento.ricerca_finanziamento: "+e.getMessage());
            e.printStackTrace();
        }finally{
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }

        return toReturn;
    }

}
