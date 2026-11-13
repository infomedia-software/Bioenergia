<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String tipo=Utility.elimina_null(request.getParameter("tipo"));
    String id_soggetto=Utility.elimina_null(request.getParameter("id_soggetto"));
    String contratto_tipologia=Utility.elimina_null(request.getParameter("contratto_tipologia"));
    String conto_termico_tipo=Utility.elimina_null(request.getParameter("conto_termico_tipo"));
    Soggetto cliente=new Soggetto();
    if(!id_soggetto.equals("0") && !id_soggetto.equals(""))
        cliente=GestioneSoggetto.getIstanza().get_soggetto(id_soggetto);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Nuovo <%=tipo%> | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script>
           function aggiungi_documento(){
                var contratto_tipologia=$("#contratto_tipologia").val();
                var cf=$("#cf").val().trim();
                var piva=$("#piva").val().trim();
                <% if(!tipo.equals(Documento.TIPO_PREVENTIVO)){%>
                    if(!contratto_tipologia || contratto_tipologia==""){
                        alert("Selezionare la tipologia di contratto");
                        $("#contratto_tipologia").focus();
                        return;
                    }
                <%}%>
                if(cf=="" && piva==""){
                    alert("Inserire il Codice Fiscale oppure la Partita IVA");
                    return;
                }
                mostra_loader("Creazione documento...");
                $.ajax({
                    type:"POST",
                    url:"<%=Utility.url%>/documenti/__aggiungi_documento.jsp",
                    data:$("#form_aggiungi_documento").serialize(),
                    dataType:"html",
                    success:function(id_documento){
                        window.location="<%=Utility.url%>/documenti/documento.jsp?id_documento="+id_documento;
                    },
                    error:function(){
                        nascondi_loader();
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE aggiungi_documento");
                    }
                });
            }
            
            function seleziona_soggetto(inField){
                var id_soggetto=inField.getAttribute("id_soggetto");                
                var contratto_tipologia=$("#contratto_tipologia").val();
                var conto_termico_tipo=$("#conto_termico_tipo").val();
                mostra_loader("Recupero dati cliente in corso...");
                location.href="<%=Utility.url%>/documenti/aggiungi_documento.jsp?tipo=<%=tipo%>&id_soggetto="+id_soggetto+"&contratto_tipologia="+contratto_tipologia+"&conto_termico_tipo="+conto_termico_tipo;
            }
            
            function seleziona_privato_azienda(obj){
                $("#id_soggetto").val("");

                if(obj.value=="privato"){
                    $("#riga_privato").css("display","table-row");
                    $("#riga_azienda").hide();
                    $(".campo_azienda").hide();
                    $(".campo_privato").show();
                    $("#ragione_sociale").val("");
                }else{
                    $("#riga_privato").hide();
                    $(".campo_privato").hide();
                    $(".campo_azienda").show();
                    $("#riga_azienda").css("display","table-row");
                    $("#nome").val("");
                    $("#cognome").val("");
                }
            }
            
            function seleziona_contratto_tipologia(){
                mostra_loader("Operazione in corso...");
                $.ajax({
                    type:"POST",
                    url:"<%=Utility.url%>/documenti/aggiungi_documento.jsp",
                    data:{
                        tipo:"<%=tipo%>",
                        id_soggetto:$("#id_soggetto").val(),
                        contratto_tipologia:$("#contratto_tipologia").val(),
                        conto_termico_tipo:$("#conto_termico_tipo").val()
                    },
                    success:function(html){
                        $("#div_aggiungi_documento").html($(html).find("#div_aggiungi_documento").html());
                        nascondi_loader();
                    },
                    error:function(){
                        nascondi_loader();
                        alert("Errore durante l'aggiornamento del documento");
                    }
                });
            }
        </script>
    </head>
    <body>
        
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
                <div id="div_aggiungi_documento">
                <h1>Nuovo <%=tipo%> <span style="font-size: 12px;"><%=contratto_tipologia.replace("_"," ")%></span></h1>
                <div class="box">
                    <form method="post" id="form_aggiungi_documento" onsubmit="event.preventDefault(); aggiungi_documento();">
                        <input type="hidden" name="tipo" value="<%=tipo%>">
                        <input type="hidden" id="id_soggetto" name="id_soggetto" value="<%=id_soggetto%>">
                        <table>
                            <tr>
                                <th style="width: 125px;">Tipologia Contratto</th>
                                <td>
                                    <select id="contratto_tipologia" name="contratto_tipologia" required="true" onchange="seleziona_contratto_tipologia()">
                                        <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO%>" <%=contratto_tipologia.equals(Documento.CONTRATTO_FOTOVOLTAICO) ? "selected" : ""%>>Fotovoltaico</option>
                                        <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO%>" <%=contratto_tipologia.equals(Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO) ? "selected" : ""%>>Fotovoltaico + Accumulo</option>
                                        <option value="<%=Documento.CONTRATTO_ACCUMULO%>" <%=contratto_tipologia.equals(Documento.CONTRATTO_ACCUMULO) ? "selected" : ""%>>Accumulo</option>
                                        <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO_CONTO_TERMICO%>" <%=contratto_tipologia.equals(Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO_CONTO_TERMICO) ? "selected" : ""%>>Fotovoltaico + Accumulo + Conto Termico</option>
                                        <option value="<%=Documento.CONTRATTO_CONTO_TERMICO%>" <%=contratto_tipologia.equals(Documento.CONTRATTO_CONTO_TERMICO) ? "selected" : ""%>>Conto Termico</option>
                                        <% if(tipo.equals(Documento.TIPO_PREVENTIVO)){%>
                                            <option value="<%=Documento.PREVENTIVO_COLONNINA%>" <%=contratto_tipologia.equals(Documento.PREVENTIVO_COLONNINA) ? "selected" : ""%>>Colonnina</option>
                                            <option value="<%=Documento.PREVENTIVO_BACKUP%>" <%=contratto_tipologia.equals(Documento.PREVENTIVO_BACKUP) ? "selected" : ""%>>Backup</option>
                                        <%}%>
                                    </select>
                                </td>
                            </tr>
                            
                            <tr>
                                <th>PDC</th>
                                <td>
                                     <select id="conto_termico_tipo" name="conto_termico_tipo" <%if(!utente.is_amministratore()){%>disabled="true" style="pointer-events: none;"<%}%> required="true">
                                        <option value=""></option>
                                        <option value="<%=Documento.CONTO_TERMICO_POMPA_DI_CALORE%>" <%=conto_termico_tipo.equals(Documento.CONTO_TERMICO_POMPA_DI_CALORE) ? "selected" : ""%>>Pompa di Calore</option>
                                        <option value="<%=Documento.CONTO_TERMICO_CALDAIA_IBRIDA%>" <%=conto_termico_tipo.equals(Documento.CONTO_TERMICO_CALDAIA_IBRIDA) ? "selected" : ""%>>Caldaia Ibrida</option>
                                    </select>
                                </td>
                            </tr>
                            
                        </table>
                        <div class="height-10"></div>
                        <h2>
                            Dati Cliente
                            <button type="button" class="pulsante_small float-right" onclick="mostra_popup('<%=Utility.url%>/soggetto/_ricerca_soggetto.jsp?tipologia=CLIENTE')"><i class="fa fa-search"></i></button>
                        </h2>
                        <table>
                            <tr>
                                <td>Privato</td>
                                <td>
                                    <label>
                                        <input type="radio" name="privato_azienda" value="privato" <% if(cliente.getPrivato_azienda().equals("") || cliente.getPrivato_azienda().equals("privato")){%> checked="true" <%}%> onchange="seleziona_privato_azienda(this)" >
                                    </label>
                                </td>
                                <td>Azienda</td>
                                <td>
                                    <label>
                                        <input type="radio" name="privato_azienda" value="azienda" onchange="seleziona_privato_azienda(this)" <% if(cliente.getPrivato_azienda().equals("azienda")){%> checked="true" <%}%>>
                                    </label>
                                </td>
                            </tr>

                            <tr id="riga_azienda" <% if(cliente.getPrivato_azienda().equals("azienda")){%>style="display:table-row;"<%}else{%>style="display:none;"<%}%>>
                                <td colspan="4">
                                    <label>Ragione Sociale *</label><br>
                                    <div style="display:flex;gap:5px;">
                                        <input type="text" id="ragione_sociale" name="ragione_sociale" value="<%=cliente.getRagione_sociale()%>">
                                    </div>
                                </td>
                            </tr>

                            <tr id="riga_privato" <% if(cliente.getPrivato_azienda().equals("") || cliente.getPrivato_azienda().equals("privato")){%>style="display:table-row;"<%}else{%>style="display:none;"<%}%>>
                                <td colspan="2">
                                    <label>Nome*</label><br>
                                    <input type="text" id="nome" name="nome" value="<%=cliente.getNome()%>">
                                </td>
                                <td colspan="2">
                                    <label>Cognome*</label><br>
                                    <input type="text" id="cognome" name="cognome" value="<%=cliente.getCognome()%>">
                                </td>
                            </tr>
                            <tr>
                                <td style="width:45%;">
                                    <label>Indirizzo *</label><br>
                                    <input type="text" id="indirizzo" name="indirizzo"  required value="<%=cliente.getIndirizzo()%>">
                                </td>
                                <td style="width:10%;">
                                    <label>CAP *</label><br>
                                    <input type="text" id="cap" name="cap" maxlength="5"  required value="<%=cliente.getCap()%>">
                                </td>
                                <td style="width:35%;">
                                    <label>Comune *</label><br>
                                    <input type="text" id="comune" name="comune"  required value="<%=cliente.getComune()%>">
                                </td>
                                <td style="width:10%;">
                                    <label>Provincia *</label><br>
                                    <input type="text" id="provincia" name="provincia" maxlength="2"  required value="<%=cliente.getProvincia()%>">
                                </td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td>
                                    <label>Telefono casa</label><br>
                                    <input type="text" id="telefono" name="telefono"  value="<%=cliente.getTelefono()%>">
                                </td>
                                <td colspan="2">
                                    <label>Cellulare *</label><br>
                                    <input type="text" id="cellulare" name="cellulare"  required value="<%=cliente.getCellulare()%>">
                                </td>
                                <td>
                                    <label>E-mail<%if(tipo.equals(Documento.TIPO_PREVENTIVO)){%>*<%}%></label><br>
                                    <input type="email" id="email" name="email"  value="<%=cliente.getEmail()%>" <%if(tipo.equals(Documento.TIPO_PREVENTIVO)){%> required="true" <%}%>>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <label>Codice fiscale*</label><br>
                                    <input type="text" id="cf" name="cf"  value="<%=cliente.getCf()%>">
                                </td>
                                <td colspan="2" class="campo_azienda" style="display: none;">
                                    <label>Partita IVA*</label><br>
                                    <input type="text" id="piva" name="piva"  value="<%=cliente.getPiva()%>">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align:right;">
                                    <button type="submit" class="pulsante"><i class="fa-solid fa-save"></i>Continua</button>
                                </td>
                            </tr>
                        </table>
                    </form>
                    </div>
                </div>
            </div>
        </div>          
    </body>
</html>
