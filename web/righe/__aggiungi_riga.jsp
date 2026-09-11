<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    Utility.getIstanza().query("INSERT INTO riga (id_documento,stato) VALUES ("+Utility.is_null(id_documento)+",'1')");
    
%>