<%@page import="beans.Item"%>
<%@page import="gestioneDB.GestioneItems"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Pagamento"%>
<%@page import="gestioneDB.GestionePagamento"%>
<%@page import="beans.Riga"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    Documento d=GestioneDocumento.getIstanza().get_documento(id_documento);
    ArrayList<Item> situazioni=null;
    if(d.is_contratto())
        situazioni=GestioneItems.getIstanza().ricerca("documento", "id_situazione");
    if(d.is_preventivo())
        situazioni=GestioneItems.getIstanza().ricerca("preventivo", "id_situazione");
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=d.toString()%> | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script>
        function modifica_documento(inField){
            
            if(inField.getAttribute("refresh")=="si" || inField.id=="stato"){
                mostra_loader("Operazione in corso...");
            }

            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/documenti/__modifica_documento.jsp",
                data: {
                    id_documento: '<%=id_documento%>',
                    campo_da_modificare: inField.id,
                    new_valore: inField.value
                },
                dataType: "html",
                success: function(msg){

                    if(inField.id === "stato" && inField.value === "-1"){
                        window.location = "<%=Utility.url%>/documenti/index.jsp?tipo=<%=d.getTipo()%>";
                    }

                    if(inField.getAttribute("refresh")=="si"){
                        location.reload();
                    }
                },
                error: function(){                    
                    alert("Errore durante il salvataggio modifica_documento");
                }
            });
        }
                
        </script>
    </head>
    <body>
        
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
            <h1><%=d.toString()%> - Cliente: <%=d.getCliente_cognome()%> <%=d.getCliente_nome()%></h1>
            <div class="box">
                <a class="pulsante" href="<%=Utility.url%>/documenti/index.jsp?tipo=<%=d.getTipo()%>">
                    <i class="fa-solid fa-arrow-left"></i>Torna alla Lista
                </a>
                <% if(d.is_contratto()){%>
                    <% if(d.is_contratto_accumulo() || d.is_contratto_fotovoltaico() || d.is_contratto_fotovoltaico_accumulo() || d.is_contratto_fotovoltaico_accumulo_conto_termico()){%>
                        <button class="pulsante float-right" style="background:#e67e22;color:white;" onclick="window.open('<%=Utility.url%>/pdf/documento/pdf_documento.jsp?id_documento=<%=id_documento%>')">
                            <i class="fa-solid fa-file-contract"></i> PDF <% if(d.is_contratto_accumulo()){%>ACCUMULO<%}else{%> FOTOVOLTAICO<%}%>
                        </button>
                    <%}%>
                    <% if(d.is_contratto_conto_termico() || d.is_contratto_fotovoltaico_accumulo_conto_termico()){%>
                        <button class="pulsante float-right" style="background:#16a34a;color:white;" onclick="window.open('<%=Utility.url%>/pdf/conto_termico/pdf_conto_termico.jsp?id_documento=<%=id_documento%>')">
                            <i class="fa-solid fa-file-pdf"></i> PDF CONTO TERMICO
                        </button>
                    <%}%>
                <%}%>
                <% if(d.is_preventivo()){%>
                    <button class="pulsante grigio float-right" onclick="window.open('<%=Utility.url%>/pdf/preventivo/pdf_preventivo.jsp?id_documento=<%=id_documento%>')" >
                        <i class="fa-solid fa-print"></i>PDF
                    </button>
                <%}%>
            </div>
                <div class="col_100">
                    <table>
                        <tr>
                            <td colspan="2">
                                <label>Stato</label><br>
                                <select id="id_situazione" onchange="modifica_documento(this);">                                    
                                <% for(Item sit:situazioni){%>
                                    <option value="<%=sit.getId()%>" <%=Utility.selected_se_uguali(sit.getId(), d.getId_situazione()+"")%>><%=sit.getValore()%></option>
                                <%}%>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <table>
                         <tr>
                            <td>Tipologia Contratto</td>
                            <td>
                                <label>
                                    <select id="contratto_tipologia" refresh="si"  onchange="modifica_documento(this);">
                                        <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_FOTOVOLTAICO) ? "selected" : ""%>>Fotovoltaico</option>
                                        <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO) ? "selected" : ""%>>Fotovoltaico + Accumulo</option>
                                        <option value="<%=Documento.CONTRATTO_ACCUMULO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_ACCUMULO) ? "selected" : ""%>>Accumulo</option>
                                        <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO_CONTO_TERMICO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO_CONTO_TERMICO) ? "selected" : ""%>>Fotovoltaico + Accumulo + Conto Termico</option>
                                        <option value="<%=Documento.CONTRATTO_CONTO_TERMICO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_CONTO_TERMICO) ? "selected" : ""%>>Conto Termico</option>
                                    </select>
                                </label>
                            </td>
                            <td>PDC</td>
                            <td colspan="3">
                                <label>
                                <select id="conto_termico_tipo" class="no_controllo" onchange="modifica_documento(this);">
                                    <option value=""></option>
                                    <option value="<%=Documento.CONTO_TERMICO_POMPA_DI_CALORE%>" <%=d.is_conto_termico_pompa_di_calore() ? "selected" : ""%>>Pompa di Calore</option>
                                    <option value="<%=Documento.CONTO_TERMICO_CALDAIA_IBRIDA%>" <%=d.is_conto_termico_caldaia_ibrida() ? "selected" : ""%>>Caldaia Ibrida</option>
                                </select>
                                </label>
                            </td>
                        </tr>

                    </table>
                                
                    <% if(d.is_contratto()){%>
                    <table>
                    <tr>
                        <td style="vertical-align: top;">
                            <label>IBAN</label><br>
                            <input type="text" value="<%=d.getIban()%>" id="iban" onchange="modifica_documento(this)">
                        </td>
                        <td>
                            <label>Note Interne</label><br>
                            <textarea id="note1" onchange="modifica_documento(this)" class="no_controllo"><%=Utility.elimina_null(Utility.standardizza_testo_textarea(d.getNote1()))%></textarea>
                        </td>
                    </tr>
                    </table>
                    <%}%>
                    
                </div>
                
                <div class="height-10"></div>
                <div class="box">
                    <table>
                        <tr>
                            <td>Osservazioni</td>
                        </tr>
                        <tr>
                            <td>
                                <%=Utility.elimina_null(d.getOsservazioni())%>
                            </td>
                        </tr>
                    </table>
                </div>
                    
                <!-- ALLEGATI -->
                <div class="box">
                    <h2>Allegati</h2>
                    <%String queryallegati=" allegati.rif='DOCUMENTO' AND allegati.idrif="+Utility.is_null(id_documento)+" AND allegati.stato='1' ORDER BY allegati.id DESC";%>
                    <jsp:include page="../_allegati.jsp">
                        <jsp:param name="query" value="<%=queryallegati%>"></jsp:param>
                        <jsp:param name="id_rif" value="<%=id_documento%>"></jsp:param>
                        <jsp:param name="rif" value="DOCUMENTO"></jsp:param>
                    </jsp:include>

                    <div class="height-10"></div>
                    <jsp:include page="../_nuovo_allegato.jsp">
                        <jsp:param name="idrif" value="<%=id_documento%>"></jsp:param>
                        <jsp:param name="rif" value="DOCUMENTO"></jsp:param>
                    </jsp:include>
                </div>        
            </div>
        </div>          
    </body>
</html>
