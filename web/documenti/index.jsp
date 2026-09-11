<%@page import="java.util.Map"%>
<%@page import="beans.Item"%>
<%@page import="gestioneDB.GestioneItems"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Documento"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    boolean amministratore=utente!=null && utente.is_amministratore();
    String tipo=Utility.elimina_null(request.getParameter("tipo")).trim();
    String cerca=Utility.elimina_null(request.getParameter("cerca")).trim();
    String id_soggetto=Utility.elimina_null(request.getParameter("id_soggetto")).trim();
    String id_autore=amministratore ? Utility.elimina_null(request.getParameter("id_autore")).trim() : "";
    String numero=Utility.elimina_null(request.getParameter("numero")).trim();
    String cliente=Utility.elimina_null(request.getParameter("cliente")).trim();
    String ragione_sociale=Utility.elimina_null(request.getParameter("ragione_sociale")).trim();
    String cf_piva=Utility.elimina_null(request.getParameter("cf_piva")).trim();
    String indirizzo=Utility.elimina_null(request.getParameter("indirizzo")).trim();
    String comune=Utility.elimina_null(request.getParameter("comune")).trim();
    String provincia=Utility.elimina_null(request.getParameter("provincia")).trim();
    String cap=Utility.elimina_null(request.getParameter("cap")).trim();
    String telefono=Utility.elimina_null(request.getParameter("telefono")).trim();
    String id_situazione=Utility.elimina_null(request.getParameter("id_situazione")).trim();
    String data_da=Utility.elimina_null(request.getParameter("data_da")).trim();
    String data_a=Utility.elimina_null(request.getParameter("data_a")).trim();
    Map<String,Item> mappa_situazioni=GestioneItems.getIstanza().mappa("documento", "id_situazione");
    if(!id_soggetto.matches("\\d+")) id_soggetto="";
    if(!id_autore.matches("\\d+")) id_autore="";
    if(!id_situazione.matches("\\d+")) id_situazione="";

    int pagina=1;
    try{ pagina=Integer.parseInt(Utility.elimina_null(request.getParameter("pagina"))); }catch(Exception e){}
    if(pagina<1) pagina=1;

    int offset=(pagina-1)*Utility.righe_pagina;
    String tipo_sql=tipo.replace("'","''");
    String query="documento.tipo='"+tipo_sql+"'";

    if(!amministratore) query+=" AND documento.id_autore="+utente.getId();

    if(!cerca.equals("")){
        String cerca_sql=cerca.replace("'","''");
        query+=" AND (documento.numero LIKE '%"+cerca_sql+"%' OR documento.lettera LIKE '%"+cerca_sql+"%' OR documento.cliente_ragione_sociale LIKE '%"+cerca_sql+"%' OR documento.cliente_nome LIKE '%"+cerca_sql+"%' OR documento.cliente_cognome LIKE '%"+cerca_sql+"%' OR documento.cliente_cf LIKE '%"+cerca_sql+"%' OR documento.cliente_piva LIKE '%"+cerca_sql+"%' OR documento.cliente_indirizzo LIKE '%"+cerca_sql+"%' OR documento.cliente_comune LIKE '%"+cerca_sql+"%' OR documento.cliente_provincia LIKE '%"+cerca_sql+"%' OR documento.cliente_cap LIKE '%"+cerca_sql+"%' OR documento.cliente_telefono LIKE '%"+cerca_sql+"%' OR documento.cliente_cellulare LIKE '%"+cerca_sql+"%'";
        if(amministratore) query+=" OR soggetto.ragione_sociale LIKE '%"+cerca_sql+"%' OR soggetto.alias LIKE '%"+cerca_sql+"%' OR soggetto.nome LIKE '%"+cerca_sql+"%' OR soggetto.cognome LIKE '%"+cerca_sql+"%'";
        query+=")";
    }

    if(!id_soggetto.equals("")) query+=" AND documento.id_soggetto="+id_soggetto;
    if(amministratore && !id_autore.equals("")) query+=" AND documento.id_autore="+id_autore;
    if(!numero.equals("")) query+=" AND documento.numero LIKE '%"+numero.replace("'","''")+"%'";

    if(!cliente.equals("")){
        String cliente_sql=cliente.replace("'","''");
        query+=" AND (documento.cliente_nome LIKE '%"+cliente_sql+"%' OR documento.cliente_cognome LIKE '%"+cliente_sql+"%' OR documento.cliente_ragione_sociale LIKE '%"+cliente_sql+"%')";
    }

    if(!ragione_sociale.equals("")) query+=" AND documento.cliente_ragione_sociale LIKE '%"+ragione_sociale.replace("'","''")+"%'";

    if(!cf_piva.equals("")){
        String cf_piva_sql=cf_piva.replace("'","''");
        query+=" AND (documento.cliente_cf LIKE '%"+cf_piva_sql+"%' OR documento.cliente_piva LIKE '%"+cf_piva_sql+"%')";
    }

    if(!indirizzo.equals("")) query+=" AND documento.cliente_indirizzo LIKE '%"+indirizzo.replace("'","''")+"%'";
    if(!comune.equals("")) query+=" AND documento.cliente_comune LIKE '%"+comune.replace("'","''")+"%'";
    if(!provincia.equals("")) query+=" AND documento.cliente_provincia LIKE '%"+provincia.replace("'","''")+"%'";
    if(!cap.equals("")) query+=" AND documento.cliente_cap LIKE '%"+cap.replace("'","''")+"%'";

    if(!telefono.equals("")){
        String telefono_sql=telefono.replace("'","''");
        query+=" AND (documento.cliente_telefono LIKE '%"+telefono_sql+"%' OR documento.cliente_cellulare LIKE '%"+telefono_sql+"%')";
    }

    if(!id_situazione.equals("")) query+=" AND documento.id_situazione="+id_situazione;
    if(!data_da.equals("")) query+=" AND documento.data>='"+data_da.replace("'","''")+"'";
    if(!data_a.equals("")) query+=" AND documento.data<='"+data_a.replace("'","''")+"'";

    int totale_record=0;
    try{ totale_record=Integer.parseInt(Utility.getIstanza().query_select("SELECT COUNT(*) AS totale FROM documento LEFT JOIN soggetto ON soggetto.id=documento.id_autore WHERE documento.stato='1' AND "+query,"totale")); }catch(Exception e){}

    int totale_pagine=(int)Math.ceil((double)totale_record/Utility.righe_pagina);

    ArrayList<Documento> lista_documenti=GestioneDocumento.getIstanza().ricerca_documento(query,"documento.id DESC",offset);
    ArrayList<Soggetto> lista_autore=new ArrayList<Soggetto>();
    if(amministratore) lista_autore=GestioneSoggetto.getIstanza().ricerca_soggetto("soggetto.tipologia='UTENTE' AND soggetto.stato='1'","soggetto.cognome ASC, soggetto.nome ASC, soggetto.ragione_sociale ASC",-1);

    boolean filtri_aperti=!id_soggetto.equals("") || (amministratore && !id_autore.equals("")) || !numero.equals("") || !cliente.equals("") || !ragione_sociale.equals("") || !cf_piva.equals("") || !indirizzo.equals("") || !comune.equals("") || !provincia.equals("") || !cap.equals("") || !telefono.equals("") || !id_situazione.equals("") || !data_da.equals("") || !data_a.equals("");

    String titolo="Documenti";
    if(tipo.equals("contratto"))
        titolo="Contratti";
%>

<html>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=titolo%> | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>

        <script type="text/javascript">

            function aggiungi_documento(){
                location.href='aggiungi_documento.jsp?tipo=<%=tipo%>';
            }

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
                window.location="<%=Utility.url%>/documenti/index.jsp?tipo=<%=tipo%>";
            }

        </script>

    </head>


    <body>
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
                <h1><%=titolo%></h1>
                  <div class="box">

                    <form id="form_ricerca" method="get" action="index.jsp" onsubmit="mostra_loader('Ricerca in corso...')">
                        <input type="hidden" name="tipo" value="<%=tipo%>">
                        <input type="hidden" id="pagina" name="pagina" value="1">
                        <div class="ricerca-principale">
                            <input type="text" name="cerca" value="<%=cerca%>" placeholder="Cerca per cliente, indirizzo, numero, tel, ecc..." style="flex:1;">
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

                            <button type="button" class="verde" onclick="aggiungi_documento()">
                                <i class="fa-solid fa-plus"></i>
                                Contratto
                            </button>

                        </div>
                            
                    <div id="filtri_avanzati" style="display:<%=filtri_aperti ? "block" : "none"%>;margin-top:14px;">
                        <table>
                            <tr>
                                <%if(amministratore){%>
                                <td>
                                    <label>Consulente</label>
                                    <select name="id_autore">
                                        <option value="">Tutti</option>
                                        <%for(Soggetto autore_temp : lista_autore){
                                            String nome_autore=(Utility.elimina_null(autore_temp.getCognome())+" "+Utility.elimina_null(autore_temp.getNome())).trim();
                                            if(nome_autore.equals("")) nome_autore=Utility.elimina_null(autore_temp.getRagione_sociale());
                                        %>
                                        <option value="<%=autore_temp.getId()%>" <%=id_autore.equals(String.valueOf(autore_temp.getId())) ? "selected" : ""%>><%=nome_autore%></option>
                                        <%}%>
                                    </select>
                                </td>
                                <%}%>

                                <td>
                                    <label>Numero</label><br>
                                    <input type="text" name="numero" value="<%=numero%>">
                                </td>

                                <td>
                                    <label>Data da</label><br>
                                    <input type="date" name="data_da" value="<%=data_da%>" style="width: 125px;">
                                </td>

                                <td>
                                    <label>Data a</label><br>
                                    <input type="date" name="data_a" value="<%=data_a%>" style="width: 125px;">
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <label>Cliente</label><br>
                                    <input type="text" name="cliente" value="<%=cliente%>" placeholder="Nome, Cognome, Ragione Sociale">
                                </td>

                             

                                <td>
                                    <label>CF / P.IVA</label><br>
                                    <input type="text" name="cf_piva" value="<%=cf_piva%>">
                                </td>
                                
                                 <td>
                                    <label>Comune</label><br>
                                    <input type="text" name="comune" value="<%=comune%>">
                                </td>

                                <td>
                                    <label>Provincia</label><br>
                                    <input type="text" name="provincia" value="<%=provincia%>">
                                </td>

                            </tr>

                            <tr>
                               


                                <td>
                                    <label>Telefono / Cellulare</label><br>
                                    <input type="text" name="telefono" value="<%=telefono%>">
                                </td>
                            
                                <td>
                                    <label>Situazione</label><br>
                                    <select name="id_situazione">
                                        <option value="">Tutte</option>
                                        <% for(Item item:mappa_situazioni.values()){ %>
                                            <option value="<%=item.getId()%>" <% if(id_situazione.equals(item.getId())){%>selected<%}%>>
                                                <%=item.getValore()%>
                                            </option>
                                        <% } %>
                                    </select>
                                </td>

                                <td colspan="2" style="vertical-align:bottom;">
                                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Applica filtri</button>
                                </td>
                            </tr>
                        </table>
                    </div>


                <div style="margin:10px;">
                    Risultati:
                    <strong><%=totale_record%></strong>
                </div>


                <div class="box">
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 50px;">N.</th>
                                <th style="width: 100px;">Data</th>
                                <%if(amministratore){%>
                                    <th>Consulente</th>
                                <%}%>
                                <th>Cliente</th>
                                <th>CF / P.IVA</th>
                                <!--th>Indirizzo</th-->
                                <th>Comune</th>
                                <th>Provincia</th>
                                
                                <th>Tel.</th>
                                <th>Totale</th>
                                <th>Stato</th>
                                <th style="width:30px;"></th>
                            </tr>
                        </thead>
                        <tbody>

                            <%for(Documento documento : lista_documenti){%>
                            <tr>

                                <td><%=documento.getNumero_completo()%></td>
                                <td><%=documento.getData_it()%></td>
                                <%if(amministratore){%>
                                    <td><%=documento.getAutore().getCognome()%> <%=documento.getAutore().getNome()%></td>
                                <%}%>
                                
                                <td>
                                    <% if(documento.getCliente_privato_azienda().equals("azienda")){%>
                                        <%=documento.getCliente_ragione_sociale()%>
                                    <%}else{%>
                                        <%=documento.getCliente_cognome()%> <%=documento.getCliente_nome()%>
                                    <%}%>
                                </td>
                                <td><%=documento.getCf_piva()%></td>
                                <!--td><%=documento.getCliente_indirizzo()%></td-->
                                <td><%=documento.getCliente_comune()%></td>
                                <td><%=documento.getCliente_provincia()%></td>
                                
                                <td><%=documento.getCliente_cellulare()%></td>
                                <td style="text-align:right;"><%=Utility.formatta_prezzo(documento.getTotale())%></td>
                                <td>
                                    <%
                                        Item situazione=mappa_situazioni.get(documento.getId_situazione()+"");                                        
                                        if(situazione!=null){
                                    %>
                                        <span style="background:<%=situazione.getColore()%>;color:#fff;padding:4px 8px;border-radius:5px;white-space:nowrap;">
                                            <%=situazione.getValore().toUpperCase()%>
                                        </span>
                                    <% } %>
                                </td>
                                <td style="text-align:center;">
                                    <a class="pulsante_small" href="documento.jsp?id_documento=<%=documento.getId()%>">
                                        <i class="fa-solid fa-arrow-up-right-from-square"></i>
                                        
                                    </a>
                                </td>

                            </tr>

                            <%}%>


                            <%if(lista_documenti.size()==0){%>
                            <tr>
                                <td colspan="<%=amministratore ? "8" : "7"%>">
                                    Nessun documento trovato
                                </td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>


                <%if(totale_pagine>1){%>

                <div class="box" style="text-align:center;margin-top:16px;">
                    <%if(pagina>1){%>
                    <button type="button"onclick="vai_pagina(<%=pagina-1%>)">
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
    </body>
</html>