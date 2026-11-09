<%@page import="gestioneDB.GestioneFinanziamento"%>
<%@page import="beans.Finanziamento"%>
<%@page import="java.security.SecureRandom"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Documento"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    
String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
String id_finanziamento=Utility.elimina_null(request.getParameter("id_finanziamento"));
String mandante=Utility.elimina_null(request.getParameter("mandante"));
String otp_codice=Utility.elimina_null(request.getParameter("otp_codice")).trim();
String otp_hash=Utility.decodifica_sha512(otp_codice);

String errore="";
// DOCUMENTO
if(!id_documento.equals("")){
    Documento documento=GestioneDocumento.getIstanza().get_documento(id_documento);
    if(mandante.equals("")){
        if(documento.getOtp_data_ora_verifica()!=null){
            errore="Documento già validato con OTP";
        }

        if(!documento.getOtp_hash().equals("") && documento.getOtp_data_ora_scadenza()!=null && Utility.viene_prima(documento.getOtp_data_ora_scadenza(),Utility.data_ora_corrente())){
            errore="Codice OTP scaduto. Genera un nuovo OTP per riprovare.";
        }

        if(!documento.getOtp_hash().equals(otp_hash)){
            errore="Codice OTP errato. Riprova.";
            Utility.getIstanza().query("UPDATE documento SET otp_tentativi_falliti=otp_tentativi_falliti+1 WHERE id="+id_documento);
        }

        if(errore.equals("") && documento.getOtp_hash().equals(otp_hash)){
            Utility.getIstanza().query("UPDATE documento SET otp_ip="+Utility.is_null(Utility.indirizzoIP(request))+", otp_data_ora_verifica=NOW() WHERE id="+id_documento);
            // invia sms
        }
    }else{
        if(documento.getOtp_data_ora_verifica_mandante()!=null){
            errore="Documento già validato con OTP dal mandante";
        }

        if(!documento.getOtp_hash_mandante().equals("") && documento.getOtp_data_ora_scadenza_mandante()!=null && Utility.viene_prima(documento.getOtp_data_ora_scadenza_mandante(),Utility.data_ora_corrente())){
            errore="Codice OTP scaduto. Genera un nuovo OTP per riprovare.";
        }

        if(!documento.getOtp_hash_mandante().equals(otp_hash)){
            errore="Codice OTP errato. Riprova.";
            Utility.getIstanza().query("UPDATE documento SET otp_tentativi_falliti_mandante=otp_tentativi_falliti_mandante+1 WHERE id="+id_documento);
        }

        if(errore.equals("") && documento.getOtp_hash_mandante().equals(otp_hash)){
            Utility.getIstanza().query("UPDATE documento SET otp_ip_mandante="+Utility.is_null(Utility.indirizzoIP(request))+", otp_data_ora_verifica_mandante=NOW() WHERE id="+id_documento);
            // invia sms
        }
    }
}

// FINANZIAMENTO
if(!id_finanziamento.equals("")){
    Finanziamento finanziamento=GestioneFinanziamento.getIstanza().get_finanziamento(id_finanziamento);

    if(finanziamento==null){
        errore="Finanziamento non trovato.";
    }else{
        String suffisso="_garante";
        String hash_salvato=finanziamento.getOtp_hash_garante();
        String data_scadenza=finanziamento.getOtp_data_ora_scadenza_garante();
        String data_verifica=finanziamento.getOtp_data_ora_verifica_garante();

        if(data_verifica!=null && !data_verifica.equals("")){
            errore="Finanziamento già validato con OTP dal garante.";
        }

        else if(otp_codice.equals("") || hash_salvato.equals("")){
            errore="Codice OTP non valido. Genera un nuovo OTP.";
        }

        else if(data_scadenza==null || data_scadenza.equals("") || !Utility.viene_prima(Utility.data_ora_corrente(),data_scadenza)){
            errore="Codice OTP scaduto. Genera un nuovo OTP per riprovare.";
        }

        else if(!hash_salvato.equals(otp_hash)){
            errore="Codice OTP errato. Riprova.";
            Utility.getIstanza().query("UPDATE finanziamento SET otp_tentativi_falliti"+suffisso+"=COALESCE(otp_tentativi_falliti"+suffisso+",0)+1 WHERE id="+Utility.is_null(id_finanziamento));
        }

        else{
            Utility.getIstanza().query("UPDATE finanziamento SET otp_ip"+suffisso+"="+Utility.is_null(Utility.indirizzoIP(request))+",otp_data_ora_verifica"+suffisso+"=NOW() WHERE id="+Utility.is_null(id_finanziamento)+" AND otp_data_ora_verifica"+suffisso+" IS NULL AND otp_hash"+suffisso+"="+Utility.is_null(otp_hash)+" AND otp_data_ora_scadenza"+suffisso+">NOW()");

            // OTP verificato: eventuale invio SMS di conferma
        }
    }
}

out.print(errore);
%>