
<%@page import="beans.Documento"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Item"%>
<%@page import="beans.Finanziamento"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneItems"%>
<%@page import="gestioneDB.GestioneFinanziamento"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    if(utente==null){
        response.sendRedirect(Utility.url+"/index.jsp?errore=Sessione Scaduta");
        return;
    }

    boolean amministratore=utente.is_amministratore() || utente.is_gestore();

    String cerca=Utility.elimina_null(request.getParameter("cerca")).trim();
    String cliente=Utility.elimina_null(request.getParameter("cliente")).trim();
    String numero_contratto=Utility.elimina_null(request.getParameter("numero_contratto")).trim();
    String id_situazione=Utility.elimina_null(request.getParameter("id_situazione")).trim();
    String tipo=Utility.elimina_null(request.getParameter("tipo")).trim();

    if(!id_situazione.matches("\\d+")) id_situazione="";

    int pagina=1;
    try{
        pagina=Integer.parseInt(Utility.elimina_null(request.getParameter("pagina")));
    }catch(Exception e){}

    if(pagina<1) pagina=1;

    int offset=(pagina-1)*Utility.righe_pagina;

    String query="finanziamento.stato='1'";

    if(!amministratore)
        query+=" AND finanziamento.id_autore="+utente.getId();

    if(!cerca.equals("")){
        String valore=cerca.replace("'","''");
        query+=" AND (finanziamento.nome LIKE '%"+valore+"%' OR finanziamento.cognome LIKE '%"+valore+"%' OR finanziamento.ragione_sociale LIKE '%"+valore+"%' OR documento.numero LIKE '%"+valore+"%')";
    }

    if(!cliente.equals("")){
        String valore=cliente.replace("'","''");
        query+=" AND (finanziamento.nome LIKE '%"+valore+"%' OR finanziamento.cognome LIKE '%"+valore+"%' OR finanziamento.ragione_sociale LIKE '%"+valore+"%')";
    }

    if(!numero_contratto.equals("")){
        String valore=numero_contratto.replace("'","''");
        query+=" AND documento.numero LIKE '%"+valore+"%'";
    }

    if(!id_situazione.equals(""))
        query+=" AND finanziamento.id_situazione="+id_situazione;
    
    if(!tipo.equals(""))
        query+=" AND finanziamento.tipo="+Utility.is_null(tipo);

    int totale_record=0;

    try{
        String sql="SELECT COUNT(*) AS totale FROM finanziamento LEFT JOIN documento ON documento.id=finanziamento.id_documento WHERE "+query;
        totale_record=Integer.parseInt(Utility.getIstanza().query_select(sql,"totale"));
    }catch(Exception e){
        System.out.println("Errore conteggio finanziamenti: "+e.getMessage());
    }

    int totale_pagine=(int)Math.ceil((double)totale_record/Utility.righe_pagina);

    ArrayList<Finanziamento> lista_finanziamenti=GestioneFinanziamento.getIstanza().ricerca_finanziamento(query,"finanziamento.id DESC",offset);

    Map<String,Item> mappa_situazioni=GestioneItems.getIstanza().mappa("finanziamento","id_situazione");

    boolean filtri_aperti=!cliente.equals("") || !numero_contratto.equals("") || !id_situazione.equals("");
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Finanziamenti | <%=Utility.nome_software%></title>

    <jsp:include page="../_importazioni.jsp"></jsp:include>

    <script type="text/javascript">

        function vai_pagina(pagina){
            mostra_loader("Caricamento...");
            $("#pagina").val(pagina);
            $("#form_ricerca").submit();
        }

        function mostra_filtri_avanzati(){
            $("#filtri_avanzati").slideToggle(150);
        }

        function azzera_ricerca(){
            mostra_loader("Caricamento...");
            window.location="<%=Utility.url%>/finanziamenti/index.jsp";
        }

    </script>
</head>

<body>
<div id="container">

    <jsp:include page="../_menu.jsp"></jsp:include>

    <div id="content">

        <h1>Finanziamenti</h1>

        <div class="box">

            <form id="form_ricerca" method="get" action="index.jsp" onsubmit="mostra_loader('Ricerca in corso...')">

                <input type="hidden" id="pagina" name="pagina" value="1">

                <div class="ricerca-principale">

                    <input type="text" name="cerca" value="<%=cerca%>" placeholder="Cerca per cliente, ragione sociale o numero contratto..." style="flex:1;">

                    <button type="submit">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        Cerca
                    </button>

                    <button type="button" class="arancio" onclick="mostra_filtri_avanzati()">
                        <i class="fa-solid fa-sliders"></i>
                        Filtri
                    </button>

                    <button type="button" class="rosso" onclick="azzera_ricerca()">
                        <i class="fa-solid fa-rotate-left"></i>
                        Azzera
                    </button>

                </div>

                <div id="filtri_avanzati" style="display:<%=filtri_aperti ? "block" : "none"%>;margin-top:14px;">

                    <table>
                        <tr>
                            <td>
                                <label>Cliente</label><br>
                                <input type="text" name="cliente" value="<%=cliente%>" placeholder="Nome, Cognome, Ragione Sociale">
                            </td>

                            <td>
                                <label>Numero Contratto</label><br>
                                <input type="text" name="numero_contratto" value="<%=numero_contratto%>">
                            </td>
                            
                             <td>
                                <label>Tasso</label><br>
                                 <select name="tipo">
                                    <option value="">Tutte</option>
                                    <option value="<%=Finanziamento.TIPO_STANDARD%>" <% if(tipo.equals(Finanziamento.TIPO_STANDARD)){%> selected="true"<%}%>>Tasso Standard</option>
                                    <option value="<%=Finanziamento.TIPO_TASSO_0%>" <% if(tipo.equals(Finanziamento.TIPO_TASSO_0)){%> selected="true"<%}%>>Tasso Zero</option                                           
                                    
                                </select>
                            </td>

                            <td>
                                <label>Situazione</label><br>
                                <select name="id_situazione">
                                    <option value="">Tutte</option>
                                    <%if(mappa_situazioni!=null){
                                        for(Item item:mappa_situazioni.values()){%>
                                            <option value="<%=item.getId()%>" <%=id_situazione.equals(String.valueOf(item.getId())) ? "selected" : ""%>>
                                                <%=item.getValore()%>
                                            </option>
                                        <%}
                                    }%>
                                </select>
                            </td>

                            <td style="vertical-align:bottom;">
                                <button type="submit">
                                    <i class="fa-solid fa-magnifying-glass"></i>
                                    Applica filtri
                                </button>
                            </td>
                        </tr>
                    </table>

                </div>

            </form>

            <div style="margin:10px;">
                Risultati:
                <strong><%=totale_record%></strong>
            </div>

            <div class="box">

                <table>
                    <thead>
                        <tr>
                            <th style="width:60px;">N.</th>
                            <th>Cliente</th>
                            <th>Contratto</th>
                            <th>Tasso</th>
                            <th class="text-right">Importo</th>
                            <th class="text-center">Rate</th>
                            <th>Situazione</th>
                            <th style="width:30px;"></th>
                        </tr>
                    </thead>

                    <tbody>

                        <%for(Finanziamento f:lista_finanziamenti){
                            String nominativo=(Utility.elimina_null(f.getCognome())+" "+Utility.elimina_null(f.getNome())).trim();
                            if(!Utility.elimina_null(f.getRagione_sociale()).equals(""))
                                nominativo=f.getRagione_sociale();

                            Item situazione=mappa_situazioni!=null ? mappa_situazioni.get(String.valueOf(f.getId_situazione())) : null;
                        %>

                        <tr>

                            <td><%=f.getId()%></td>
                            <td>
                                <strong><%=nominativo%></strong>
                            </td>
                            <td><a href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=f.getId_documento()%>" target="_blank"><%=f.getContratto_numero()%></a></td>
                            <td><%=Utility.elimina_null(f.getTipo_string())%></td>
                            <td style="text-align:right;white-space:nowrap;"><%=Utility.formatta_prezzo(f.getImporto())%></td>
                            <td style="text-align:center;"><%=f.getNumero_rate()%></td>
                            <td>
                                <%if(situazione!=null){%>
                                    <span style="background:<%=situazione.getColore()%>;color:#fff;padding:4px 8px;border-radius:5px;white-space:nowrap;">
                                        <%=situazione.getValore().toUpperCase()%>
                                    </span>
                                <%}%>
                            </td>

                            <td style="text-align:center;">
                                <a class="pulsante_small" href="finanziamento.jsp?id_finanziamento=<%=f.getId()%>">
                                    <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                </a>
                            </td>

                        </tr>

                        <%}%>

                        <%if(lista_finanziamenti.size()==0){%>
                            <tr>
                                <td colspan="8" style="text-align:center;">
                                    Nessun finanziamento trovato
                                </td>
                            </tr>
                        <%}%>

                    </tbody>
                </table>

            </div>

            <%if(totale_pagine>1){%>

                <div class="box" style="text-align:center;margin-top:16px;">

                    <%if(pagina>1){%>
                        <button type="button" onclick="vai_pagina(<%=pagina-1%>)">
                            <i class="fa-solid fa-chevron-left"></i>
                            Precedente
                        </button>
                    <%}%>

                    <span style="margin:0 12px;">
                        Pagina
                        <strong><%=pagina%></strong>
                        di
                        <strong><%=totale_pagine%></strong>
                    </span>

                    <%if(pagina<totale_pagine){%>
                        <button type="button" onclick="vai_pagina(<%=pagina+1%>)">
                            Successiva
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    <%}%>

                </div>

            <%}%>

        </div>

    </div>

</div>
</body>
</html>
