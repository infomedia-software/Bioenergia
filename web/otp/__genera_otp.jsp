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

    out.print(errore);
%>