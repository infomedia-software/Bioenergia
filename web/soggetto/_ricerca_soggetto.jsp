<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    String tipologia = Utility.elimina_null(request.getParameter("tipologia")).trim();
    String cerca = Utility.elimina_null(request.getParameter("cerca")).trim();

    int pagina = 1;

    try{
        pagina = Integer.parseInt(Utility.elimina_null(request.getParameter("pagina")));
    }catch(Exception e){}

    if(pagina < 1)
        pagina = 1;

    int offset = (pagina - 1) * Utility.righe_pagina;

    String query = "soggetto.stato='1'";

    if("CLIENTE".equals(tipologia))
        query += " AND soggetto.tipologia IN('CLIENTE','CLIENTE_FORNITORE')";

    if("FORNITORE".equals(tipologia))
        query += " AND soggetto.tipologia IN('FORNITORE','CLIENTE_FORNITORE')";

    if(!cerca.equals("")){
        String cerca_sql = cerca.replace("'", "''");

        query += " AND ("
              + "soggetto.codice LIKE '%" + cerca_sql + "%' OR "
              + "soggetto.ragione_sociale LIKE '%" + cerca_sql + "%' OR "
              + "soggetto.nome LIKE '%" + cerca_sql + "%' OR "
              + "soggetto.cognome LIKE '%" + cerca_sql + "%' OR "
              + "soggetto.referente LIKE '%" + cerca_sql + "%' OR "
              + "soggetto.comune LIKE '%" + cerca_sql + "%' OR "
              + "soggetto.telefono LIKE '%" + cerca_sql + "%' OR "
              + "soggetto.email LIKE '%" + cerca_sql + "%'"
              + ")";
    }

    int totale_record = 0;

    try{
        totale_record = Integer.parseInt(
            Utility.getIstanza().query_select(
                "SELECT COUNT(*) AS totale FROM soggetto WHERE " + query,
                "totale"
            )
        );
    }catch(Exception e){}

    int totale_pagine = (int)Math.ceil((double)totale_record / Utility.righe_pagina);

    ArrayList<Soggetto> lista_soggetto =
        GestioneSoggetto.getIstanza().ricerca_soggetto(
            query,
            "soggetto.ragione_sociale ASC, soggetto.nome ASC, soggetto.cognome ASC",
            offset
        );
%>

<script type="text/javascript">

    function ricerca_soggetto(){
        $("#ricerca_soggetto_pagina").val("1");

        $("#popup_contenuto").load(
            "<%=Utility.url%>/soggetto/_ricerca_soggetto.jsp",
            $("#form_ricerca_soggetto").serialize()
        );

        return false;
    }

    function vai_pagina_soggetto(pagina){
        $("#ricerca_soggetto_pagina").val(pagina);

        $("#popup_contenuto").load(
            "<%=Utility.url%>/soggetto/_ricerca_soggetto.jsp",
            $("#form_ricerca_soggetto").serialize()
        );
    }

</script>

<form id="form_ricerca_soggetto" method="get" onsubmit="return ricerca_soggetto();">

    <input type="hidden" name="tipologia" value="<%=tipologia%>">
    <input type="hidden" id="ricerca_soggetto_pagina" name="pagina" value="<%=pagina%>">

    <div class="ricerca-principale">

        <div class="ricerca-input">
            <input type="text"
                   name="cerca"
                   value="<%=cerca%>"
                   placeholder="Cerca soggetto per codice, nome, comune, telefono o email...">
        </div>

        <button type="submit" class="ricerca-bottone">
            <i class="fa-solid fa-magnifying-glass"></i>
            Cerca
        </button>

    </div>

</form>

<div style="margin-bottom:10px;">
    Risultati: <strong><%=totale_record%></strong>
</div>

<table class="tabella">
    <thead>
        <tr>
            <th>Cognome Nome / Ragione Sociale</th>
            <th>Comune</th>
            <th>Telefono</th>
            <th>Email</th>
            <th style="width:110px;"></th>
        </tr>
    </thead>

    <tbody>

    <%for(Soggetto soggetto : lista_soggetto){

        String nome_soggetto = Utility.elimina_null(soggetto.getRagione_sociale()).trim();

        if(nome_soggetto.equals(""))
            nome_soggetto = (Utility.elimina_null(soggetto.getNome()) + " " + Utility.elimina_null(soggetto.getCognome())).trim();
    %>

        <tr>
            
            <td><%=Utility.elimina_null(soggetto.toString())%></td>
            <td><%=Utility.elimina_null(soggetto.getComune())%></td>
            <td><%=Utility.elimina_null(soggetto.getTelefono())%></td>
            <td><%=Utility.elimina_null(soggetto.getEmail())%></td>

            <td style="text-align:center;">
                <button type="button"
                        id_soggetto="<%=soggetto.getId()%>"
                        nome_soggetto="<%=nome_soggetto.replace("\"", "&quot;")%>"
                        onclick="seleziona_soggetto(this)">
                    <i class="fa-solid fa-check"></i> Seleziona
                </button>
            </td>
        </tr>

    <%}%>

    <%if(lista_soggetto.isEmpty()){%>
        <tr>
            <td colspan="8">Nessun soggetto trovato</td>
        </tr>
    <%}%>

    </tbody>
</table>

<%if(totale_pagine > 1){%>

    <div class="box" style="text-align:center; margin-top:16px;">

        <%if(pagina > 1){%>
            <button type="button" onclick="vai_pagina_soggetto(<%=pagina - 1%>)">
                <i class="fa-solid fa-chevron-left"></i> Precedente
            </button>
        <%}%>

        <span style="margin:0 12px;">
            Pagina <strong><%=pagina%></strong> di <strong><%=totale_pagine%></strong>
        </span>

        <%if(pagina < totale_pagine){%>
            <button type="button" onclick="vai_pagina_soggetto(<%=pagina + 1%>)">
                Successiva <i class="fa-solid fa-chevron-right"></i>
            </button>
        <%}%>

    </div>

<%}%>