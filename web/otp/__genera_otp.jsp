<%@page import="gestioneDB.GestioneFinanziamento"%>
<%@page import="beans.Finanziamento"%>
<%@page import="utility.InviaSms"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    String id_finanziamento=Utility.elimina_null(request.getParameter("id_finanziamento"));
    String mandante=Utility.elimina_null(request.getParameter("mandante"));
    String otp_sms=Utility.elimina_null(request.getParameter("otp_sms"));
    String otp_codice = String.format("%06d", new SecureRandom().nextInt(1000000));
    String otp_hash = Utility.codifica_sha512(otp_codice);
    int limite_tentativi_falliti=5;

    String testo =
        "Salve," +
        "è stato richiesto un codice di conferma per la firma del contratto." +
        "Codice OTP: " +
        otp_codice +
        " Inserisci il codice OTP per completare la procedura di firma.";
    
    String errore="";
    if (!id_documento.equals("")) {
        Documento documento=GestioneDocumento.getIstanza().get_documento(id_documento);
        if(mandante.equals("")){
            if(documento.getOtp_data_ora_verifica()!=null){
                errore="Documento già validato con OTP";
            }
            if(documento.getOtp_tentativi_falliti()<limite_tentativi_falliti && !documento.getOtp_hash().equals("") && documento.getOtp_data_ora_scadenza()!=null && Utility.viene_prima(Utility.data_ora_corrente(), documento.getOtp_data_ora_scadenza()) ){
                errore="Già è stato generato un OTP per il documento\nInserire l'OTP ricevuto al numero "+documento.getOtp_sms();
            }
            if(errore.equals("")){
                InviaSms.invia_sms("39"+otp_sms, testo);
                Utility.getIstanza().query(
                    "UPDATE documento SET " +
                    "otp_sms=" + Utility.is_null(otp_sms) + ", " +
                    "otp_hash=" + Utility.is_null(otp_hash) + ", " +
                    "otp_data_ora_generazione=NOW(), " +
                    "otp_tentativi_falliti=0, " +
                    "otp_data_ora_scadenza=DATE_ADD(NOW(), INTERVAL 10 MINUTE), " +
                    "otp_data_ora_verifica=NULL " +
                    "WHERE id=" + id_documento
                );

            }
        }else{
            if(documento.getOtp_data_ora_verifica_mandante()!=null){
                errore="Documento già validato con OTP dal mandante";
            }

            if(documento.getOtp_tentativi_falliti_mandante()<limite_tentativi_falliti && !documento.getOtp_hash_mandante().equals("") && documento.getOtp_data_ora_scadenza_mandante()!=null && Utility.viene_prima(Utility.data_ora_corrente(), documento.getOtp_data_ora_scadenza_mandante())){
                errore="Già è stato generato un OTP per il mandante\nInserire l'OTP ricevuto al numero "+documento.getOtp_sms_mandante();
            }

            if(errore.equals("")){
                InviaSms.invia_sms("39"+otp_sms, testo);

                Utility.getIstanza().query(
                    "UPDATE documento SET " +
                    "otp_sms_mandante=" + Utility.is_null(otp_sms) + ", " +
                    "otp_hash_mandante=" + Utility.is_null(otp_hash) + ", " +
                    "otp_data_ora_generazione_mandante=NOW(), " +
                    "otp_tentativi_falliti_mandante=0, " +
                    "otp_data_ora_scadenza_mandante=DATE_ADD(NOW(), INTERVAL 10 MINUTE), " +
                    "otp_data_ora_verifica_mandante=NULL " +
                    "WHERE id=" + id_documento
                );
            }
        }
    }
    
    
    // FINANZIAMENTO
    if(!id_finanziamento.equals("")){
        Finanziamento finanziamento=GestioneFinanziamento.getIstanza().get_finanziamento(id_finanziamento);
        if(finanziamento==null){
            errore="Finanziamento non trovato.";
        }else{


            String hash_salvato=finanziamento.getOtp_hash_garante();
            String data_scadenza=finanziamento.getOtp_data_ora_scadenza_garante();
            String data_verifica=finanziamento.getOtp_data_ora_verifica_garante();
            String numero_salvato=finanziamento.getOtp_sms_garante();
            int tentativi_falliti=finanziamento.getOtp_tentativi_falliti_garante();

            if(data_verifica!=null && !data_verifica.equals("")){
                errore="Finanziamento già validato con OTP dal garante.";
            }

            else if(otp_sms.equals("") || !otp_sms.matches("[0-9]{9,10}")){
                errore="Inserire un numero di cellulare valido, senza prefisso internazionale.";
            }

            else if(tentativi_falliti<limite_tentativi_falliti && !hash_salvato.equals("") && data_scadenza!=null && Utility.viene_prima(Utility.data_ora_corrente(),data_scadenza)){
                errore="È già stato generato un OTP per il garante.\nInserire l'OTP ricevuto al numero "+numero_salvato;
            }

            else{
                String query="UPDATE finanziamento SET "
                    + "otp_sms_garante="+Utility.is_null(otp_sms)+","
                    + "otp_hash_garante="+Utility.is_null(otp_hash)+","
                    + "otp_data_ora_generazione_garante=NOW(),"
                    + "otp_tentativi_falliti_garante=0,"
                    + "otp_data_ora_scadenza_garante=DATE_ADD(NOW(),INTERVAL 10 MINUTE),"
                    + "otp_data_ora_verifica_garante=NULL,"
                    + "otp_ip_garante='' "
                    + "WHERE id="+Utility.is_null(id_finanziamento)
                    + " AND otp_data_ora_verifica_garante IS NULL";

                // Invio SMS
                try{
                    InviaSms.invia_sms("39"+otp_sms,testo);
                    Utility.getIstanza().query(query);
                }catch(Exception e){
                    errore="Errore durante la generazione o l'invio del codice OTP.";
                    System.out.println("Errore OTP finanziamento "+id_finanziamento+": "+e.getMessage());
                }
            }
        }

    }

    out.print(errore);
%>