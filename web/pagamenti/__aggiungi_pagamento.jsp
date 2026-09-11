<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    String id_soggetto=Utility.elimina_null(request.getParameter("id_soggetto"));
    String finanziamento=Utility.elimina_null(request.getParameter("finanziamento"));
    Utility.getIstanza().query("INSERT INTO pagamento (id_documento,id_soggetto, id_autore, entrata_uscita,finanziamento, stato) VALUES ("+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'entrata',"+Utility.is_null(finanziamento)+",'1')");  
%>