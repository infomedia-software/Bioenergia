<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true"%>
<!DOCTYPE html>
<%
    String cerca=Utility.elimina_null(request.getParameter("cerca")).trim();

    int pagina=1;
    try{
        pagina=Integer.parseInt(Utility.elimina_null(request.getParameter("pagina")));
    }catch(Exception e){}

    if(pagina<1)
        pagina=1;

    int offset=(pagina-1)*Utility.righe_pagina;
    String query="soggetto.stato='1' AND soggetto.tipologia='UTENTE'";

    if(!cerca.equals("")){
        String cerca_sql=cerca.replace("'","''");
        query+=" AND (soggetto.codice LIKE '%"+cerca_sql+"%' OR soggetto.nome LIKE '%"+cerca_sql+"%' OR soggetto.cognome LIKE '%"+cerca_sql+"%' OR CONCAT(soggetto.nome,' ',soggetto.cognome) LIKE '%"+cerca_sql+"%' OR CONCAT(soggetto.cognome,' ',soggetto.nome) LIKE '%"+cerca_sql+"%' OR soggetto.telefono LIKE '%"+cerca_sql+"%' OR soggetto.cellulare LIKE '%"+cerca_sql+"%' OR soggetto.email LIKE '%"+cerca_sql+"%')";
    }

    int totale_record=0;
    try{
        totale_record=Integer.parseInt(Utility.getIstanza().query_select("SELECT COUNT(*) AS totale FROM soggetto WHERE "+query,"totale"));
    }catch(Exception e){}

    int totale_pagine=(int)Math.ceil((double)totale_record/Utility.righe_pagina);

    if(totale_pagine>0 && pagina>totale_pagine){
        pagina=totale_pagine;
        offset=(pagina-1)*Utility.righe_pagina;
    }

    ArrayList<Soggetto> lista_utente=GestioneSoggetto.getIstanza().ricerca_soggetto(query,"soggetto.cognome ASC, soggetto.nome ASC",offset);
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Utenti | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function nuovo_utente(){
                mostra_loader("Creazione in corso...");
                $.ajax({
                    type:"POST",
                    url:"<%=Utility.url%>/soggetto/__nuovo_soggetto.jsp",
                    data:{tipologia:"UTENTE"},
                    success:function(id_soggetto){
                        id_soggetto=$.trim(id_soggetto);
                        window.location="<%=Utility.url%>/utente/utente.jsp?id_soggetto="+id_soggetto;
                    },
                    error:function(){
                        nascondi_loader();
                        alert("Errore durante la creazione dell'utente");
                    }
                });
            }

            function vai_pagina(pagina){
                mostra_loader("Caricamento...");
                $("#pagina").val(pagina);
                $("#form_ricerca").submit();
            }

            function azzera_ricerca(){
                mostra_loader("Caricamento...");
                window.location="<%=Utility.url%>/soggetto/lista_utente.jsp";
            }
        </script>
    </head>
    <body>
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
                <h1>Utenti</h1>
                <div class="box">
                    <form id="form_ricerca" method="get" action="lista_utente.jsp" onsubmit="mostra_loader('Ricerca in corso...')">
                        <input type="hidden" id="pagina" name="pagina" value="<%=pagina%>">
                        <div class="ricerca-principale">
                            <input type="text" name="cerca" value="<%=cerca%>" placeholder="Cerca per codice, nome, cognome, telefono o email..." style="flex:1;">
                            <button type="submit" class="pulsante"><i class="fa-solid fa-magnifying-glass"></i> Cerca</button>
                            <%if(!cerca.equals("")){%>
                            <button type="button" class="pulsante_invertito" onclick="azzera_ricerca()"><i class="fa-solid fa-rotate-left"></i> Azzera</button>
                            <%}%>
                            <button type="button" class="pulsante" onclick="nuovo_utente()"><i class="fa-solid fa-plus"></i> Nuovo utente</button>
                        </div>
                    </form>
                </div>

                <div style="margin-bottom:10px;">Utenti trovati: <strong><%=totale_record%></strong></div>

                <table>
                    <thead>
                        <tr>
                            <th>Codice</th>
                            <th>Cognome</th>
                            <th>Nome</th>
                            <th>Telefono</th>
                            <th>Email</th>
                            <th style="width:100px;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%for(Soggetto utente:lista_utente){%>
                        <tr>
                            <td><%=Utility.elimina_null(utente.getCodice())%></td>
                            <td><%=Utility.elimina_null(utente.getCognome())%></td>
                            <td><%=Utility.elimina_null(utente.getNome())%></td>
                            <td><%=Utility.elimina_null(utente.getTelefono())%></td>
                            <td><%=Utility.elimina_null(utente.getEmail())%></td>
                            <td><a href="<%=utente.url()%>" class="pulsante" onclick="mostra_loader('Caricamento utente...')"><i class="fa-solid fa-arrow-up-right-from-square"></i> Dettagli</a></td>
                        </tr>
                        <%}%>
                        <%if(lista_utente.isEmpty()){%>
                        <tr><td colspan="6">Nessun utente trovato</td></tr>
                        <%}%>
                    </tbody>
                </table>

                <%if(totale_pagine>1){%>
                <div class="box" style="text-align:center;margin-top:16px;">
                    <%if(pagina>1){%>
                    <button type="button" class="pulsante_invertito" onclick="vai_pagina(<%=pagina-1%>)"><i class="fa-solid fa-chevron-left"></i> Precedente</button>
                    <%}%>
                    <span style="margin:0 12px;">Pagina <strong><%=pagina%></strong> di <strong><%=totale_pagine%></strong></span>
                    <%if(pagina<totale_pagine){%>
                    <button type="button" class="pulsante_invertito" onclick="vai_pagina(<%=pagina+1%>)">Successiva <i class="fa-solid fa-chevron-right"></i></button>
                    <%}%>
                </div>
                <%}%>
            </div>
        </div>
    </body>
</html>