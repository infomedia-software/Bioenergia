<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    String tipo=Utility.elimina_null(request.getParameter("tipo"));
    Documento d=GestioneDocumento.getIstanza().get_documento(id_documento);
    Utility.getIstanza().query("INSERT INTO riga (id_documento,aliquota,tipo,stato) VALUES ("+Utility.is_null(id_documento)+","+d.getAliquota()+","+Utility.is_null(tipo)+",'1')");
    
%>