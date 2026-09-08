<%@page import="java.util.ArrayList"%>
<%@page import="beans.Soggetto"%>
<%@page import="enums.SoggettoTipologia"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String nome_utente=Utility.elimina_null(request.getParameter("nome_utente")).trim();
    String password=Utility.elimina_null(request.getParameter("password")).trim();

    if(nome_utente.equals("") || password.equals("")){
        response.sendRedirect(Utility.url+"/index.jsp?errore=si");
        return;
    }

    String query=
        "nome_utente="+Utility.is_null(nome_utente)+
        " AND password="+Utility.is_null(password)+
        " AND tipologia="+Utility.is_null(SoggettoTipologia.UTENTE.name())+
        " AND stato='1'";

    ArrayList<Soggetto> lista_soggetti=GestioneSoggetto.getIstanza().ricerca_soggetto(query,"",-1);

    if(lista_soggetti.size()==1){
        Soggetto utente=lista_soggetti.get(0);

        session.setAttribute("utente",utente);

        response.sendRedirect(Utility.url+"/documenti/index.jsp?tipo=contratto");
        return;
    }

    response.sendRedirect(Utility.url+"/index.jsp?errore=si");
%>