<%@page import="utility.Utility"%>
<%
    String tipologia = Utility.elimina_null(request.getParameter("tipologia"));

    if(tipologia.equals(""))
        tipologia = "CLIENTE";

    String prefisso = "C";

    if(tipologia.equals("FORNITORE"))
        prefisso = "F";
    else if(tipologia.equals("CLIENTE_FORNITORE"))
        prefisso = "CF";
    else if(tipologia.equals("UTENTE"))
        prefisso = "U";
    
    String ruolo="";
    if(tipologia.equals("UTENTE")){
        ruolo="DIPENDENTE";
    }

    String ultimo = Utility.getIstanza().query_select(
        "SELECT MAX(CAST(REPLACE(codice,'" + prefisso + "','') AS UNSIGNED)) AS ultimo " +
        "FROM soggetto WHERE codice LIKE '" + prefisso + "%'",
        "ultimo"
    );

    int progressivo = 1;
    if(!Utility.elimina_null(ultimo).equals(""))
        progressivo = Integer.parseInt(ultimo) + 1;

    String codice = prefisso + String.format("%06d", progressivo);

    String id_soggetto = Utility.getIstanza().query_insert(
        "INSERT INTO soggetto(" +
        "codice," +
        "tipologia," +
        "ruolo," +
        "stato" +
        ") VALUES(" +
        Utility.is_null(codice) + "," +
        Utility.is_null(tipologia) + "," +
        Utility.is_null(ruolo) + "," +
        "'1'" +
        ")"
    );

    out.print(id_soggetto);
%>