<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));    

    String query=""
        + "INSERT INTO finanziamento ("
            + "id_documento,"
            + "id_situazione,"
            + "stato,"
            + "privato_azienda,"
            + "luogo,"
            + "data,"
            + "nome,"
            + "cognome,"
            + "ragione_sociale,"
            + "cf,"
            + "piva,"
            + "indirizzo,"
            + "cap,"
            + "localita,"
            + "comune,"
            + "provincia,"
            + "telefono,"
            + "cellulare,"
            + "email,"
            + "luogo_nascita,"
            + "data_nascita"
        + ") "
        + "SELECT "
            + "id,"
            + "'12',"
            + "'1',"
            + "cliente_privato_azienda,"
            + "luogo,"
            + "data,"
            + "cliente_nome,"
            + "cliente_cognome,"
            + "cliente_ragione_sociale,"
            + "cliente_cf,"
            + "cliente_piva,"
            + "cliente_indirizzo,"
            + "cliente_cap,"
            + "cliente_localita,"
            + "cliente_comune,"
            + "cliente_provincia,"
            + "cliente_telefono,"
            + "cliente_cellulare,"
            + "cliente_email,"
            + "cliente_luogo_nascita,"
            + "cliente_data_nascita "
        + "FROM documento "
        + "WHERE id="+Utility.is_null(id_documento);

    String id_finanziamento=Utility.getIstanza().query_insert(query);

    out.print(id_finanziamento);
%>