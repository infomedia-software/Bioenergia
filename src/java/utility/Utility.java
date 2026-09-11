package utility;

import connection.ConnectionPoolException;
import gestioneDB.DBConnection;
import gestioneDB.DBUtility;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Locale;
import javax.servlet.http.HttpServletRequest;


public class Utility {

    private static Utility istanza;
    
    public static Utility getIstanza(){
        if(istanza==null){
            istanza=new Utility();           
            
        }
        return istanza;
    }
    
    public static String url=Config.get("URL");
    public static String url_allegati=Config.get("URL_ALLEGATI");
    public static String socket_url=Config.get("SOCKET_URL");
    public static String percorso_tomcat=Config.get("PERCORSO_TOMCAT");
    public static String apiKey=Config.get("BREVO_API_KEY");
    public static int righe_pagina=30;
    
    public static String nome_software="Bioenergia - Infogest Infomedia";
    
    
    
    public static String smtp_username="";
    public static String smtp_porta="";
    public static String smtp_url="";
    public static String mittente_email="";
    public static String mittente_password="";
    public static String mail_replyto="";
            
    public static String elimina_null(String stringa){
        if(stringa==null)
            return"";
        else
            return stringa;
    }
    
    public static String elimina_zero(double v) {
        if (v == Math.floor(v))
            return String.valueOf((long) v);
        return String.valueOf(v);
    }
    

    public static String is_null(String pStr) {       
        if (pStr == null) {
            return "''";
        }
        pStr = pStr.trim();
        if (pStr.length() == 0 || pStr.equalsIgnoreCase("null")) {
            return "''";
        }        
        if (pStr.matches("^-?\\d+$") || pStr.matches("^-?\\d+\\.\\d+$")) {
            return pStr;
        }       
        pStr = ReplaceAllStrings(pStr, "'", "''"); // Escape per SQL: apice singolo raddoppiato        
        pStr = ReplaceAllStrings(pStr, "\"", "\"\""); // Se ti serve ancora l'escape del doppio apice:    
        pStr = pStr.replaceAll("(\r\n|\n)", "<br>");     // Gestione a capo -> <br>
        return "'" + pStr + "'";
    }
    
    
    
     private static String ReplaceAllStrings(String sourceStr, String searchFor, String replaceWith) {
        StringBuffer searchBuffer = new StringBuffer(sourceStr);
        StringBuffer newStringBuffer = new StringBuffer("");

        while (searchBuffer.toString().toUpperCase().indexOf(searchFor.toUpperCase()) >= 0) {
                int newIndex = searchBuffer.toString().toUpperCase().indexOf(searchFor.toUpperCase());
                newStringBuffer.append(searchBuffer.substring(0, newIndex));
                newStringBuffer.append(replaceWith);
                searchBuffer = new StringBuffer(searchBuffer.substring(newIndex+ searchFor.length(), searchBuffer.length()));
        }
        newStringBuffer.append(searchBuffer);
        return newStringBuffer.toString();
    }
    
         
    public String query(String query){
        String toReturn="";    
        try {    
            System.out.println("query >>> "+ query);
            
            Connection conn=DBConnection.getConnection();
            DBUtility.executeOperation(conn, query);
            DBConnection.releaseConnection(conn);                        
        } catch (ConnectionPoolException | SQLException ex ) {
            GestioneErrori.errore("Utility", "query", ex);
        }
        return toReturn;
    }
     
    public String query_select(String query,String campo){            
        String toReturn="";
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        System.out.println("query_select >>> "+ query);
        
        try{                   
            conn=gestioneDB.DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);            
            while(rs.next()){                
                toReturn=rs.getString(campo);
            }                              
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("Utility", "query_select", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("Utility", "query_select", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }                    
        return toReturn;        
    }
     public double query_select_double(String query,String campo){            
        double toReturn=0;
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        System.out.println("query_select_double >>> "+ query);
        
        try{                   
            conn=gestioneDB.DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);            
            while(rs.next()){                
                toReturn=rs.getDouble(campo);
            }                              
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("Utility", "query_select_double", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("Utility", "query_select_double", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }                    
        return toReturn;        
    }
     
    public int query_select_int(String query,String campo){            
        int toReturn=0;
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{                 
            System.out.println("query_select_int >>> "+ query);
            
            conn=gestioneDB.DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);            
            while(rs.next()){                
                toReturn=rs.getInt(campo);
            }                              
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("Utility", "query_select_int", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("Utility", "query_select_int", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }                    
        return toReturn;        
    }
     
     
     public static int converti_stringa_int(String daConvertire){
        int toReturn=0;
        if(daConvertire==null)
            return toReturn;
        try{
            toReturn=Integer.parseInt(daConvertire);
            return toReturn;
        }catch(NumberFormatException ex){            
            return toReturn;
        }
    }
    
    public static double converti_stringa_double(String daConvertire){
        double toReturn=0;
        if(daConvertire==null)
            return toReturn;
        try{
            toReturn=Double.parseDouble(daConvertire);
            return toReturn;
        }catch(NumberFormatException ex){            
            return toReturn;
        }
    }
    
    public static String selected_se_uguali(String s1, String s2) {
        String toReturn="";
        if (s1 != null && s1.equals(s2)) {
            toReturn= " selected=\"true\" ";
        }
        return toReturn;
    }
    public static String checked_se_uguali(String s1, String s2) {
        String toReturn="";
        if (s1 != null && s1.equals(s2)) {
            toReturn= " checked=\"true\" ";
        }
        return toReturn;
    }
    
    
    public static String standardizza_testo_textarea(String testo) {
       if (testo == null) return "";
        return testo.replaceAll("(?i)<br\\s*/?>", "\n");
}
    
    
    public static String crea_query_ricerca(String query_input, String query_fissa) {
        
        String query = "";

        if (!query_input.isEmpty()) {
            query = query_input;
        }

        if (!query_fissa.isEmpty()) {
            if (!query.isEmpty()) {
                query += " AND ";
            }
            query += query_fissa;
        }

        return query;
    }
    
    public static int calcola_pagina_ricerca(String pagina_param) {
        
        if (pagina_param.isEmpty()) {
            return 1;
        }

        int pagina = converti_stringa_int(pagina_param);
        if (pagina <= 1) {
            pagina = 1;
        }

        return pagina;
    }
    public static int calcola_limite_ricerca(int pagina, int righe_per_pagina) {
        if (pagina <= 1) {
            pagina = 1;
        }
        return (pagina - 1) * righe_per_pagina;
    }
    
    public static int calcola_numero_pagine_ricerca(int totale_record, int righe_per_pagina) {
        if (righe_per_pagina <= 0) {
            return 1;
        }
        return (int) Math.ceil((double) totale_record / righe_per_pagina);
    }
    
    public static String anno_corrente() {
        return GregorianCalendar.getInstance().get(Calendar.YEAR) + "";
    }
    public static int anno_corrente_int() {
        return GregorianCalendar.getInstance().get(Calendar.YEAR);
    }
    
    public static String data_ora_corrente() {
        return java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
    }
    
    public static String formatta_prezzo(double prezzo) {
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ITALY);
        nf.setMinimumFractionDigits(2);
        nf.setMaximumFractionDigits(2);
        return "&euro; "+nf.format(prezzo);
    }
    
 
    public static String converti_datetime_formato_it(String datetime) {
        if (datetime == null || datetime.isEmpty()) {
            return "";
        }

        String[] parti = datetime.split(" ");
        if (parti.length == 0) {
            return "";
        }


        if (parti[0].equals("3001-01-01")) {
            return "da definire";
        }

        String data_it = converti_data_formato_it(parti[0]);

        if (parti.length < 2) {
            return data_it;
        }

        String orario_raw = parti[1];
        String orario = orario_raw.length() >= 8 
                ? orario_raw.substring(0, 8) 
                : orario_raw;

        String risultato = data_it + " " + orario;
        return risultato;
    }
    
    public static String converti_data_formato_it(String data) {        
        if (data == null || data.isEmpty()) {
            return "";
        }

        if (data.equals("3001-01-01")) {
            return "da definire";
        }

        String[] parti_data = data.split("-");
        if (parti_data.length != 3) {
            // formato non valido, restituisco l'input o stringa vuota
            return "";
        }

        int giorno_int = converti_stringa_int(parti_data[2]);
        int mese_int   = converti_stringa_int(parti_data[1]);
        int anno_int   = converti_stringa_int(parti_data[0]);

        String giorno = (giorno_int < 10 ? "0" : "") + giorno_int;
        String mese   = (mese_int   < 10 ? "0" : "") + mese_int;
        String anno   = String.valueOf(anno_int);

        String risultato = giorno + "/" + mese + "/" + anno;
        return risultato;
    }
    
    
     public String query_insert(String query){
        String toReturn="";
	Connection conn=null;
	Statement stmt=null;
	ResultSet keys=null;        
	try 
	{                                 
            System.out.println("***query_insert >>> "+query+"***");            
            conn=DBConnection.getConnection();
            stmt = conn.createStatement();                        
            stmt.executeUpdate(query, Statement.RETURN_GENERATED_KEYS);
            keys = stmt.getGeneratedKeys();    
            keys.next();  
            toReturn = ""+keys.getInt(1);            
            keys.close();
            stmt.close();   		
            DBConnection.releaseConnection(conn);

	} catch (SQLException ex) {
		GestioneErrori.errore("Utility", "query_insert", ex);
	} catch (ConnectionPoolException ex) {
		GestioneErrori.errore("Utility", "query_insert", ex);
	}        
	return toReturn;           
    }
     
    public static String is_zero_se_vuoto(String value) {
        if (value == null || value.trim().equals("")) {
            return "0";
        }
        return value;
    }
    
    /**
    * Restituisce il numero massimo di pagine che entrano in un foglio,
    * considerando sia l'orientamento normale che quello ruotato.
    */
   
    public static int calcola_pagine_foglio(
        double foglio_larghezza,
        double foglio_altezza,
        double formato_aperto_larghezza,
        double formato_aperto_altezza,
        double margine,
        String orientamento) {

        // Margine 
        formato_aperto_larghezza += margine;
        formato_aperto_altezza += margine;

        int pagine_normale =(int)(foglio_larghezza / formato_aperto_larghezza) * (int)(foglio_altezza / formato_aperto_altezza);

        int pagine_ruotato =(int)(foglio_larghezza / formato_aperto_altezza) * (int)(foglio_altezza / formato_aperto_larghezza);

        orientamento = elimina_null(orientamento).toLowerCase();

        if(orientamento.equals("normale"))
            return pagine_normale;

        if(orientamento.equals("ruotato"))
            return pagine_ruotato;

        return Math.max(pagine_normale, pagine_ruotato);
    }
    
    
     public static String indirizzoIP(HttpServletRequest request) throws IOException {  
        URL whatismyip = new URL("http://checkip.amazonaws.com");
        BufferedReader in = new BufferedReader(new InputStreamReader(whatismyip.openStream()));
        String ip_pubblico = in.readLine(); //you get the IP as a String                        
        
        
        
        String ip = request.getHeader("X-FORWARDED-FOR");  
        if (ip == null) {  
            ip = request.getRemoteAddr();  
        }        
        return ip_pubblico+"_"+ip;
    }
     
     public static String decodifica_sha512(String input) throws NoSuchAlgorithmException {
        String newHash = codifica_sha512(input);
        //System.out.println("decodifico da SHA-512: "+newHash);
        return newHash;
    }
     
     public static String codifica_sha512(String input) throws NoSuchAlgorithmException {
        // Ottieni un'istanza di MessageDigest per SHA-512
        MessageDigest md = MessageDigest.getInstance("SHA-512");

        // Converti l'input in un array di byte
        byte[] hashBytes = md.digest(input.getBytes());

        // Converti i byte dell'hash in formato esadecimale
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        //System.out.println("codifico in SHA-512: " + hexString.toString());
        return hexString.toString();
    }
     
    public static boolean viene_prima(String data_ora_0,String data_ora_1){
        boolean toReturn=false;
        java.sql.Timestamp oldTime=convertiStringaInTimestamp(data_ora_0);
        java.sql.Timestamp currentTime=convertiStringaInTimestamp(data_ora_1);
        long milliseconds1 = oldTime.getTime();
        long milliseconds2 = currentTime.getTime();
        long diff = milliseconds2 - milliseconds1;        
        if(diff>=0)
            toReturn=true;
        return toReturn;
    } 
      
    public static Timestamp convertiStringaInTimestamp(String yourString){
       Timestamp toReturn=null;
       try{
           yourString=Utility.elimina_null(yourString).trim();

           if(yourString.contains("/")){
               java.time.LocalDateTime data=java.time.LocalDateTime.parse(
                   yourString,
                   java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")
               );
               toReturn=Timestamp.valueOf(data);
           }else{
               if(yourString.length()==16)
                   yourString=yourString+":00";

               toReturn=Timestamp.valueOf(yourString);
           }
       }catch(Exception e){
           GestioneErrori.errore("Utility","convertiStringaInTimestamp",e);
       }
       return toReturn;
   }
}
