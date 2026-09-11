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
String mandante=Utility.elimina_null(request.getParameter("mandante"));
String otp_codice=Utility.elimina_null(request.getParameter("otp_codice")).trim();
String otp_hash=Utility.decodifica_sha512(otp_codice);

String errore="";

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
            Utility.getIstanza().query(
                "UPDATE documento SET otp_tentativi_falliti=otp_tentativi_falliti+1 WHERE id="+id_documento
            );
        }

        if(errore.equals("") && documento.getOtp_hash().equals(otp_hash)){
            Utility.getIstanza().query(
                "UPDATE documento SET " +
                "otp_ip="+Utility.is_null(Utility.indirizzoIP(request))+", " +
                "otp_data_ora_verifica=NOW() " +
                "WHERE id="+id_documento
            );
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
            Utility.getIstanza().query(
                "UPDATE documento SET otp_tentativi_falliti_mandante=otp_tentativi_falliti_mandante+1 WHERE id="+id_documento
            );
        }

        if(errore.equals("") && documento.getOtp_hash_mandante().equals(otp_hash)){
            Utility.getIstanza().query(
                "UPDATE documento SET " +
                "otp_ip_mandante="+Utility.is_null(Utility.indirizzoIP(request))+", " +
                "otp_data_ora_verifica_mandante=NOW() " +
                "WHERE id="+id_documento
            );
            // invia sms
        }
    }
}


out.print(errore);
%>