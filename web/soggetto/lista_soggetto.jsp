<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String tipologia = Utility.elimina_null(request.getParameter("tipologia"));

    String cerca = Utility.elimina_null(request.getParameter("cerca")).trim();

    String codice = Utility.elimina_null(request.getParameter("codice")).trim();
    String ragione_sociale = Utility.elimina_null(request.getParameter("ragione_sociale")).trim();
    String nome = Utility.elimina_null(request.getParameter("nome")).trim();
    String referente = Utility.elimina_null(request.getParameter("referente")).trim();
    String comune = Utility.elimina_null(request.getParameter("comune")).trim();
    String telefono = Utility.elimina_null(request.getParameter("telefono")).trim();
    String email = Utility.elimina_null(request.getParameter("email")).trim();
    String attivo = Utility.elimina_null(request.getParameter("attivo")).trim();
    if(attivo.equals(""))
        attivo="si";

    int pagina = 1;

    try {
        pagina = Integer.parseInt(Utility.elimina_null(request.getParameter("pagina")));
    } catch(Exception e) {}

    if(pagina < 1)
        pagina = 1;

    int offset = (pagina - 1) * Utility.righe_pagina;

    String query = "soggetto.stato='1'";
    if(attivo.equals("si"))
        query+=" AND soggetto.attivo='si'";
    else if(attivo.equals("no"))
        query+=" AND soggetto.attivo=''";

    String titolo_pagina = "Soggetti";
    String testo_nuovo = "Nuovo soggetto";

    if("CLIENTE".equals(tipologia)){
        query += " AND soggetto.tipologia IN('CLIENTE','CLIENTE_FORNITORE')";
        titolo_pagina = "Clienti";
        testo_nuovo = "Nuovo cliente";
    }

    if("FORNITORE".equals(tipologia)){
        query += " AND soggetto.tipologia IN('FORNITORE','CLIENTE_FORNITORE')";
        titolo_pagina = "Fornitori";
        testo_nuovo = "Nuovo fornitore";
    }
    
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

    if(!codice.equals(""))
        query += " AND soggetto.codice LIKE '%" + codice.replace("'", "''") + "%'";

    if(!ragione_sociale.equals(""))
        query += " AND soggetto.ragione_sociale LIKE '%" + ragione_sociale.replace("'", "''") + "%'";

    if(!nome.equals("")){
        String nome_sql = nome.replace("'", "''");
        query += " AND (soggetto.nome LIKE '%" + nome_sql + "%' OR soggetto.cognome LIKE '%" + nome_sql + "%')";
    }

    if(!referente.equals(""))
        query += " AND soggetto.referente LIKE '%" + referente.replace("'", "''") + "%'";

    if(!comune.equals(""))
        query += " AND soggetto.comune LIKE '%" + comune.replace("'", "''") + "%'";

    if(!telefono.equals(""))
        query += " AND soggetto.telefono LIKE '%" + telefono.replace("'", "''") + "%'";

    if(!email.equals(""))
        query += " AND soggetto.email LIKE '%" + email.replace("'", "''") + "%'";

    int totale_record = 0;

    try {
        totale_record = Integer.parseInt(
            Utility.getIstanza().query_select(
                "SELECT COUNT(*) AS totale FROM soggetto WHERE " + query,
                "totale"
            )
        );
    } catch(Exception e) {}

    int totale_pagine = (int)Math.ceil((double)totale_record / Utility.righe_pagina);

    ArrayList<Soggetto> lista_soggetto =
        GestioneSoggetto.getIstanza().ricerca_soggetto(
            query,
            "soggetto.ragione_sociale ASC, soggetto.nome ASC, soggetto.cognome ASC",
            offset
        );

    boolean filtri_aperti =
        !codice.equals("") ||
        !ragione_sociale.equals("") ||
        !nome.equals("") ||
        !referente.equals("") ||
        !comune.equals("") ||
        !telefono.equals("") ||
        !email.equals("");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=titolo_pagina%> | <%=Utility.nome_software%></title>

        <jsp:include page="../_importazioni.jsp"></jsp:include>

        <script type="text/javascript">

            function nuovo_soggetto(){
                mostra_loader("Creazione soggetto...");

                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/soggetto/__nuovo_soggetto.jsp",
                    data: {
                        tipologia: "<%=tipologia%>"
                    },
                    success: function(id_soggetto){
                        window.location = "<%=Utility.url%>/soggetto/soggetto.jsp?id_soggetto=" + id_soggetto;
                    }
                });
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
                window.location = "lista_soggetto.jsp?tipologia=<%=tipologia%>";
            }

        </script>
    </head>

    <body>

        <div id="container">

            <jsp:include page="../_menu.jsp"></jsp:include>

            <div id="content">

                <h1><%=titolo_pagina%></h1>

                <div class="box">

                    <form id="form_ricerca"
                          method="get" 
                          action="lista_soggetto.jsp"
                          onsubmit="mostra_loader('Ricerca in corso...')">

                        <input type="hidden" name="tipologia" value="<%=tipologia%>">
                        <input type="hidden" id="pagina" name="pagina" value="1">

                        <div class="ricerca-principale">

                            <input type="text"
                                   name="cerca"
                                   value="<%=cerca%>"
                                   placeholder="Cerca per codice, ragione sociale, nome, comune, telefono, email..."
                                   style="flex:1;">

                            <button type="submit">
                                <i class="fa-solid fa-magnifying-glass"></i> Cerca
                            </button>

                            <button type="button" onclick="mostra_filtri_avanzati()">
                                <i class="fa-solid fa-sliders"></i> Filtri
                            </button>

                            <button type="button" onclick="azzera_ricerca()">
                                <i class="fa-solid fa-rotate-left"></i> Azzera
                            </button>

                            <button type="button" onclick="nuovo_soggetto()">
                                <i class="fa-solid fa-plus"></i> <%=testo_nuovo%>
                            </button>

                        </div>

                        <div id="filtri_avanzati" style="display:<%=filtri_aperti ? "block" : "none"%>; margin-top:14px;">

                            <table>
                                <tr>
                                    <td>
                                        <label>Codice</label>
                                        <input type="text" name="codice" value="<%=codice%>">
                                    </td>

                                    <td>
                                        <label>Ragione sociale</label>
                                        <input type="text" name="ragione_sociale" value="<%=ragione_sociale%>">
                                    </td>

                                    <td>
                                        <label>Nome / Cognome</label>
                                        <input type="text" name="nome" value="<%=nome%>">
                                    </td>

                                    <td>
                                        <label>Referente</label>
                                        <input type="text" name="referente" value="<%=referente%>">
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <label>Comune</label>
                                        <input type="text" name="comune" value="<%=comune%>">
                                    </td>

                                    <td>
                                        <label>Telefono</label>
                                        <input type="text" name="telefono" value="<%=telefono%>">
                                    </td>

                                    <td>
                                        <label>Email</label>
                                        <input type="text" name="email" value="<%=email%>">
                                    </td>

                                    <td>
                                        <label>Attivo</label>
                                        <select name="attivo">
                                            <option value="si" <%=attivo.equals("si")?"selected":""%>>Solo attivi</option>
                                            <option value="no" <%=attivo.equals("no")?"selected":""%>>Solo non attivi</option>
                                            <option value="tutte" <%=attivo.equals("tutte")?"selected":""%>>Tutte</option>
                                        </select>
                                    </td>
                                    <td style="vertical-align:bottom;">
                                        <button type="submit">
                                            <i class="fa-solid fa-magnifying-glass"></i> Applica filtri
                                        </button>
                                    </td>
                                </tr>
                            </table>

                        </div>

                    </form>

                </div>

                <div style="margin-bottom:10px;">
                    Risultati: <strong><%=totale_record%></strong>
                </div>
                <div class="box">
                <table>
                    <thead>
                        <tr>
                            <!--th>Codice</th-->
                            <th>Privato / Azienda</th>
                            <th>Cognome Nome / Ragione Sociale</th>
                            <th>Comune</th>
                            <th>Telefono</th>
                            <th>Email</th>
                            <th></th>
                        </tr>
                    </thead>

                    <tbody>

                        <% for(Soggetto soggetto : lista_soggetto){ %>

                            <tr>
                                <!--td><%=Utility.elimina_null(soggetto.getCodice())%></td-->

                                <td>
                                    <%=soggetto.getPrivato_azienda().toUpperCase()%>
                                </td>
                                <td><%=Utility.elimina_null(soggetto.toString())%></td>
                                <td><%=Utility.elimina_null(soggetto.getComune())%></td>
                                <td><%=Utility.elimina_null(soggetto.getTelefono())%></td>
                                <td><%=Utility.elimina_null(soggetto.getEmail())%></td>

                                <td>
                                    <a href="<%=soggetto.url()%>" class="pulsante" onclick="mostra_loader('Caricamento soggetto...')">
                                        <i class="fa-solid fa-arrow-up-right-from-square"></i> Dettagli
                                    </a>
                                </td>
                            </tr>

                        <% } %>

                        <% if(lista_soggetto.size() == 0){ %>
                            <tr>
                                <td colspan="9">Nessun soggetto trovato</td>
                            </tr>
                        <% } %>

                    </tbody>
                </table>
                </div>

                <% if(totale_pagine > 1){ %>

                    <div class="box" style="text-align:center; margin-top:16px;">

                        <% if(pagina > 1){ %>
                            <button type="button" onclick="vai_pagina(<%=pagina - 1%>)">
                                <i class="fa-solid fa-chevron-left"></i> Precedente
                            </button>
                        <% } %>

                        <span style="margin:0 12px;">
                            Pagina <strong><%=pagina%></strong> di <strong><%=totale_pagine%></strong>
                        </span>

                        <% if(pagina < totale_pagine){ %>
                            <button type="button" onclick="vai_pagina(<%=pagina + 1%>)">
                                Successiva <i class="fa-solid fa-chevron-right"></i>
                            </button>
                        <% } %>

                    </div>

                <% } %>

            </div>

        </div>

    </body>
</html>