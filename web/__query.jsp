<%@page import="utility.Utility"%>
<%
    String query=Utility.elimina_null(request.getParameter("query"));    
    Utility.getIstanza().query(query);
    
    String query1=Utility.elimina_null(request.getParameter("query1"));    
    if(!query1.equals(""))
        Utility.getIstanza().query(query1);
    
    String query2=Utility.elimina_null(request.getParameter("query2"));    
    if(!query2.equals(""))
        Utility.getIstanza().query(query2);
%>