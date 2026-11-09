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
    if(utente==null){
        response.sendRedirect(Utility.url+"/errore.jsp?errore=Sessione%20Scaduta");
        return;
    }  
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    Documento d=GestioneDocumento.getIstanza().get_documento(id_documento);
    
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=d.toString()%> | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
        <script>
        var aggiornamento_intestazione=false;
            
            
        function modifica_documento(inField){
            if(aggiornamento_intestazione)
                return;

            if(inField.getAttribute("refresh")=="si" || inField.getAttribute("reload")=="si" || inField.id=="stato"){
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
                        aggiorna_documento_intestazione(inField);
                    }
                    
                    if(inField.getAttribute("reload")=="si"){
                        location.reload();
                    }
                },
                error: function(){
                    aggiornamento_intestazione=false;
                    alert("Errore durante il salvataggio modifica_documento");
                }
            });
        }
            
        function aggiorna_documento_intestazione(inField){
            if(aggiornamento_intestazione)
                return;

            aggiornamento_intestazione=true;

            var campi=$("#div_documento_intestazione").find("input:visible, select:visible, textarea:visible");
            var indice=campi.index(inField);
            var idSuccessivo=indice>=0 && indice+1<campi.length ? campi.eq(indice+1).attr("id") : "";
            
            $("#div_documento_intestazione").load(
                "<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%> #div_documento_intestazione > *",
                function(){
                    nascondi_loader();

                    if(idSuccessivo!="")
                        $("#"+idSuccessivo).focus();

                    setTimeout(function(){
                        aggiornamento_intestazione=false;
                    },300);
                }
            );
        }
            
            function modifica_riga(inField,id_riga){
                if(inField.getAttribute("refresh")=="si" || inField.id=="stato"){
                    mostra_loader("Operazione in corso...");
                }
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/righe/__modifica_riga.jsp",
                    data: {
                        id_riga: id_riga,
                        campo_da_modificare: inField.getAttribute("campo"),
                        new_valore: inField.value
                    },
                    dataType: "html",
                    success: function(msg){
                        if(inField.id === "stato" && inField.value === "-1"){
                            window.location = "<%=Utility.url%>/documenti/index.jsp?tipo=<%=d.getTipo()%>";
                        }
                        if(inField.getAttribute("refresh")=="si"){
                            aggiorna_righe(inField);
                        }
                    },
                    error: function(){
                        alert("Errore durante il salvataggio modifica_riga");
                    }
                });
                
            }
            
            function aggiungi_riga(tipo){
                mostra_loader("Operazione in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/righe/__aggiungi_riga.jsp?tipo="+tipo,
                    data: {
                        id_documento: <%=id_documento%>,
                    },
                    dataType: "html",
                    success: function(msg){
                        aggiorna_righe();
                    },
                    error: function(){
                        alert("Errore durante il salvataggio aggiungi_riga");
                    }
                });
                
            }
            
            function aggiorna_righe(inField){
                var campi=$("#div_righe").find("input:visible, select:visible, textarea:visible");
                var indice=campi.index(inField);
                var idSuccessivo="";

                if(indice>=0 && indice+1<campi.length){
                    idSuccessivo=campi.eq(indice+1).attr("id");
                }

                $("#div_righe").load("<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%> #div_righe > *",function(){
                    nascondi_loader();

                    if(idSuccessivo!=""){
                        setTimeout(function(){
                            $("#"+idSuccessivo).focus();
                        },100);
                    }
                });
            }
            
            function seleziona_soggetto(inField){
                var id_soggetto=inField.getAttribute("id_soggetto");                
                mostra_loader("Recupero dati cliente in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/documenti/__modifica_documento.jsp",
                    data: {
                        id_documento: '<%=id_documento%>',
                        campo_da_modificare: 'id_soggetto',
                        new_valore: id_soggetto
                    },
                    dataType: "html",
                    success: function(msg){
                        location.reload();
                    },
                    error: function(){
                        alert("Errore durante il salvataggio seleziona_soggetto");
                    }
                });
            }
            
            function seleziona_privato_azienda_documento(obj){
                if(obj.value=="privato"){
                    $("#riga_privato").css("display","table-row");
                    $("#riga_azienda").hide();
                    $("#cliente_ragione_sociale").val("");
                }else{
                    $("#riga_privato").hide();
                    $("#riga_azienda").css("display","table-row");
                    $("#cliente_nome").val("");
                    $("#cliente_cognome").val("");
                }

                $.ajax({
                    type:"POST",
                    url:"<%=Utility.url%>/documenti/__modifica_documento.jsp",
                    data:{
                        id_documento:"<%=d.getId()%>",
                        campo_da_modificare:"cliente_privato_azienda",
                        new_valore:obj.value
                    }
                });
            }
            
        
            function modifica_pagamento_tipo(){
                var valori=[];

                $(".check_pagamento:checked").each(function(){
                    valori.push($(this).val());
                });

                mostra_loader("Operazione in corso...");

                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/documenti/__modifica_documento.jsp",
                    data: {
                        id_documento: "<%=id_documento%>",
                        campo_da_modificare: "pagamento",
                        new_valore: valori.join(",")
                    },
                    dataType: "html",
                    success: function(msg){
                        aggiorna_pagamenti();
                    },
                    error: function(){
                        nascondi_loader();
                        alert("Errore durante il salvataggio del pagamento");
                    }
                });
            }

            
            function modifica_pagamento(inField){
                if(inField.getAttribute("refresh")=="si" || inField.id=="stato"){
                    mostra_loader("Operazione in corso...");
                }
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/pagamenti/__modifica_pagamento.jsp",
                    data: {
                        id_documento: <%=id_documento%>,
                        id_pagamento: inField.getAttribute("id_pagamento"),
                        campo_da_modificare: inField.getAttribute("campo"),
                        new_valore: inField.value
                    },
                    dataType: "html",
                    success: function(msg){
                        if(inField.id === "stato" && inField.value === "-1"){
                            window.location = "<%=Utility.url%>/documenti/index.jsp?tipo=<%=d.getTipo()%>";
                        }
                        if(inField.getAttribute("refresh")=="si"){
                            aggiorna_pagamenti(inField);
                        }
                    },
                    error: function(){
                        alert("Errore durante il salvataggio modifica_pagamento");
                    }
                });
                
            }
            
            
        function aggiungi_pagamento(finanziamento){
            mostra_loader("Operazione in corso...");
            $.ajax({
                type: "POST",
                url: "<%=Utility.url%>/pagamenti/__aggiungi_pagamento.jsp",
                data: {
                    id_documento: <%=id_documento%>,
                    id_soggetto: <%=d.getId_soggetto()%>,
                    finanziamento: finanziamento
                },
                dataType: "html",
                success: function(msg){
                    aggiorna_pagamenti();
                },
                error: function(){
                    alert("Errore durante il salvataggio aggiungi_pagamento");
                }
            });

        }
           
        function aggiorna_pagamenti(inField){
            var campi=$("#div_pagamenti").find("input:visible, select:visible, textarea:visible");
            var indice=campi.index(inField);

            $("#div_pagamenti").load("<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%> #div_pagamenti > *",function(){
                nascondi_loader();

                var nuoviCampi=$("#div_pagamenti").find("input:visible, select:visible, textarea:visible");

                if(indice>=0 && indice+1<nuoviCampi.length){
                    setTimeout(function(){
                        nuoviCampi.eq(indice+1).focus();
                    },100);
                }
            });
        }
        
        function gestione_altro(nome_radio,id_campo_altro){
            var valore=$("input[name='"+nome_radio+"']:checked").val();

            if(valore=="altro"){
                $("#"+id_campo_altro).show();
            }else{
                $("#"+id_campo_altro).hide();
            }
        }
        
      
            
        function controlla_campi_vuoti(){
            $("input, select, textarea").each(function(){
                var campo=$(this);
                var tipo=campo.attr("type");

                if(tipo=="hidden" || tipo=="button" || tipo=="submit" || campo.hasClass("no_controllo"))
                    return;

                if(tipo=="radio"){
                    var nome=campo.attr("name");

                    if($("input[name='"+nome+"']:checked").length>0)
                        $("input[name='"+nome+"']").removeClass("campo_errore");
                    else
                        $("input[name='"+nome+"']").addClass("campo_errore");

                    return;
                }

                if($.trim(campo.val())=="")
                    campo.addClass("campo_errore");
                else
                    campo.removeClass("campo_errore");
            });
        }
        
        $(document).ready(function(){
            controlla_campi_vuoti();
        });
        
        $(document).ajaxComplete(function(event,xhr,settings){
            controlla_campi_vuoti();
        });
        
    function inizializza_editor_descrizioni(){
        document.querySelectorAll(".editor_descrizione").forEach(function(elemento){
            if(elemento.dataset.editorAttivo==="si")return;

            ClassicEditor.create(elemento,{
                 toolbar:{
                        items:["heading","|","bold","italic","|","bulletedList","numberedList","|","undo","redo"],
                        shouldNotGroupWhenFull:true
                    },
                    heading:{
                        options:[
                            {model:"paragraph",title:"Paragrafo",class:"ck-heading_paragraph"},
                            {model:"heading1",view:"h1",title:"Titolo 1",class:"ck-heading_heading1"},
                            {model:"heading2",view:"h2",title:"Titolo 2",class:"ck-heading_heading2"},
                            {model:"heading3",view:"h3",title:"Titolo 3",class:"ck-heading_heading3"}
                        ]
                    }
            }).then(function(editor){
                elemento.dataset.editorAttivo="si";

                editor.model.document.on("change:data",function(){
                    elemento.value=editor.getData();
                });

                editor.ui.focusTracker.on("change:isFocused",function(evt,nome,isFocused){
                    if(!isFocused){
                        elemento.value=editor.getData();
                        modifica_riga(elemento,elemento.id.replace("riga_",""));
                    }
                });
            }).catch(function(error){
                console.error("Errore CKEditor:",error);
            });
        });
    }

    $(document).ready(function(){
        inizializza_editor_descrizioni();
    });
    
    $(document).ajaxComplete(function(event,xhr,settings){
        inizializza_editor_descrizioni();
    });

    </script>
        
    </head>
    <body>
        
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
            <h1><%=d.toString()%></h1>
            <div class="box">
                <a class="pulsante" href="<%=Utility.url%>/documenti/index.jsp?tipo=<%=d.getTipo()%>">
                    <i class="fa-solid fa-arrow-left"></i>Torna alla Lista
                </a>
                    
                <button class="pulsante cancella float-right" onclick="modifica_documento(this)" id="stato" value="-1">
                    <i class="fa-solid fa-trash"></i>Cancella
                </button>
                <button class="pulsante grigio float-right" onclick="window.open('<%=Utility.url%>/pdf/preventivo/pdf_preventivo.jsp?id_documento=<%=id_documento%>')" >
                    <i class="fa-solid fa-print"></i>PDF
                </button>
            </div>
            <div class="box">
                <table>
                      <tr>
                        <td>Numero</td>
                        <td>
                            <label>
                                <input type="text" id="numero" onchange="modifica_documento(this);" value="<%=d.getNumero()%>">
                            </label>
                        </td>
                        <!--td>Luogo</td>
                        <td>
                            <label>
                                <input type="text" id="luogo" onchange="modifica_documento(this);" value="<%=d.getLuogo()%>">
                            </label>
                        </td-->
                        <td>Data</td>
                        <td>
                            <label>
                                <input type="date" id="data" name="data" onblur="modifica_documento(this);" value="<%=d.getData()%>">
                            </label>
                        </td>
                      
                        <td>Consulente</td>
                        <td>
                            <label>
                                <select id="id_autore" <% if(!utente.is_amministratore()){%>disabled="true" style="pointer-events: none;"<%}%> onchange="modifica_documento(this);">
                                <% for(Soggetto ut:GestioneSoggetto.getIstanza().ricerca_soggetto(" tipologia='UTENTE' ", " cognome ASC ", -1)){%>
                                    <option value="<%=ut.getId()%>" <%=Utility.selected_se_uguali(ut.getId(), d.getId_autore()+"")%>><%=ut.toString()%></option>
                                <%}%>
                                </select>
                            </label>
                        </td>
                   
                        <td>Stato</td>
                        <td>
                            <label>
                                <select id="id_situazione" onchange="modifica_documento(this);">                                    
                                    <% for(Item sit:GestioneItems.getIstanza().ricerca("preventivo", "id_situazione")){%>
                                        <option value="<%=sit.getId()%>" <%=Utility.selected_se_uguali(sit.getId(), d.getId_situazione()+"")%>><%=sit.getValore()%></option>
                                    <%}%>
                                </select>
                            </label>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                    <td>Tipologia Preventivo</td>
                        <td>
                            <label>
                                <select id="contratto_tipologia" refresh="si" <%if(!utente.is_amministratore()){%>disabled="true" style="pointer-events: none;"<%}%> onchange="modifica_documento(this);">
                                    <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_FOTOVOLTAICO) ? "selected" : ""%>>Fotovoltaico</option>
                                    <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO) ? "selected" : ""%>>Fotovoltaico + Accumulo</option>
                                    <option value="<%=Documento.CONTRATTO_ACCUMULO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_ACCUMULO) ? "selected" : ""%>>Accumulo</option>
                                    <option value="<%=Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO_CONTO_TERMICO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_FOTOVOLTAICO_ACCUMULO_CONTO_TERMICO) ? "selected" : ""%>>Fotovoltaico + Accumulo + Conto Termico</option>
                                    <option value="<%=Documento.CONTRATTO_CONTO_TERMICO%>" <%=d.getContratto_tipologia().equals(Documento.CONTRATTO_CONTO_TERMICO) ? "selected" : ""%>>Conto Termico</option>
                                </select>
                            </label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="box" id="div_documento_intestazione">
                    <% if(d.is_contratto_conto_termico() || d.is_contratto_fotovoltaico_accumulo_conto_termico()){%>
                        <table>
                            <tr>
                                <th>Tipo Conto Termico</th>
                                <td>
                                    <label>
                                    <select id="conto_termico_tipo" <%if(!utente.is_amministratore()){%>disabled="true" style="pointer-events: none;"<%}%> onchange="modifica_documento(this);">
                                        <option value="<%=Documento.CONTO_TERMICO_POMPA_DI_CALORE%>" <%=d.is_conto_termico_pompa_di_calore() ? "selected" : ""%>>Pompa di Calore</option>
                                        <option value="<%=Documento.CONTO_TERMICO_CALDAIA_IBRIDA%>" <%=d.is_conto_termico_caldaia_ibrida() ? "selected" : ""%>>Caldaia Ibrida</option>
                                    </select>
                                    </label>
                                </td>
                            </tr>
                        </table>
                        <div class="height-10"></div>
                    <%}%>
                                       
                    <h2>
                        Dati Cliente
                        <button type="button" class="pulsante_small" onclick="window.open('<%=Utility.url%>/soggetto/soggetto.jsp?id_soggetto=<%=d.getId_soggetto()%>')"><i class="fa fa-solid fa-address-book"></i></button>
                        <button type="button" class="pulsante_small" onclick="mostra_popup('<%=Utility.url%>/soggetto/_ricerca_soggetto.jsp?tipologia=CLIENTE')"><i class="fa fa-search"></i></button>
                    </h2>
                    <input type="hidden" id="id_soggetto" name="id_soggetto" value="<%=d.getId_soggetto()%>">
                    <table>
                          <tr>
                            <td>Privato</td>
                            <td>
                                <label>
                                    <input type="radio" id="cliente_privato_azienda" refresh="si" name="privato_azienda" value="privato" <%if(d.getCliente_privato_azienda().equals("") || d.getCliente_privato_azienda().equals("privato")){%>checked="true"<%}%> onchange="seleziona_privato_azienda_documento(this); modifica_documento(this);">
                                </label>
                            </td>
                            <td>Azienda</td>
                            <td>
                                <label>
                                    <input type="radio" id="cliente_privato_azienda" refresh="si"  name="privato_azienda" value="azienda" <%if(d.getCliente_privato_azienda().equals("azienda")){%>checked="true"<%}%> onchange="seleziona_privato_azienda_documento(this); modifica_documento(this);">
                                </label>
                            </td>
                        </tr>

                        <tr id="riga_azienda" <%if(d.getCliente_privato_azienda().equals("azienda")){%>style="display:table-row;"<%}else{%>style="display:none;"<%}%>>
                            <td colspan="4">
                                <label>Ragione Sociale *</label><br>
                                <div style="display:flex;gap:5px;">
                                    <input type="text" id="cliente_ragione_sociale"  name="ragione_sociale" value="<%=d.getCliente_ragione_sociale()%>" onchange="modifica_documento(this);">
                                </div>
                            </td>
                        </tr>

                        <tr id="riga_privato" <%if(d.getCliente_privato_azienda().equals("") || d.getCliente_privato_azienda().equals("privato")){%>style="display:table-row;"<%}else{%>style="display:none;"<%}%>>
                            <td colspan="2">
                                <label>Nome *</label><br>
                                <input type="text" id="cliente_nome" name="nome"  refresh="si"  value="<%=d.getCliente_nome()%>" onchange="modifica_documento(this);">
                            </td>
                            <td colspan="2">
                                <label>Cognome *</label><br>
                                <div style="display:flex;gap:5px;">
                                    <input type="text" id="cliente_cognome" name="cognome"  refresh="si" value="<%=d.getCliente_cognome()%>" onchange="modifica_documento(this);">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="width:45%;">
                                <label>Indirizzo</label><br>
                                <input type="text" id="cliente_indirizzo" name="indirizzo"  refresh="si"   value="<%=d.getCliente_indirizzo()%>" onchange="modifica_documento(this);">
                            </td>
                            <td style="width:10%;">
                                <label>CAP</label><br>
                                <input type="text" id="cliente_cap" name="cap" maxlength="5"   value="<%=d.getCliente_cap()%>" onchange="modifica_documento(this);">
                            </td>
                            <td style="width:35%;">
                                <label>Comune</label><br>
                                <input type="text" id="cliente_comune" name="comune"  refresh="si"    value="<%=d.getCliente_comune()%>" onchange="modifica_documento(this);">
                            </td>
                            <td style="width:10%;">
                                <label>Provincia</label><br>
                                <input type="text" id="cliente_provincia" name="provincia"  refresh="si"  maxlength="2"   value="<%=d.getCliente_provincia()%>" onchange="modifica_documento(this);">
                            </td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <td>
                                <label>Telefono casa</label><br>
                                <input type="text" class="no_controllo" id="cliente_telefono" name="telefono"  value="<%=d.getCliente_telefono()%>" onchange="modifica_documento(this);">
                            </td>
                            <td colspan="2">
                                <label>Cellulare</label><br>
                                <input type="text" id="cliente_cellulare" name="cellulare"   value="<%=d.getCliente_cellulare()%>" onchange="modifica_documento(this);">
                            </td>
                            <td>
                                <label>E-mail</label><br>
                                <input type="email" id="cliente_email" name="email"  value="<%=d.getCliente_email()%>" onchange="modifica_documento(this);">
                            </td>
                        </tr>
                        <!--tr>
                            <td colspan="2">
                                <label>Codice fiscale</label><br>
                                <input type="text" id="cliente_cf" name="cf"  refresh="si"   value="<%=d.getCliente_cf()%>" onchange="modifica_documento(this);">
                            </td>
                            <td colspan="2">
                                <% if(d.getCliente_privato_azienda().equals("azienda")){%>
                                    <label>Partita IVA</label><br>
                                    <input type="text" id="cliente_piva" name="piva"  value="<%=d.getCliente_piva()%>" onchange="modifica_documento(this);">
                                <%}%>
                            </td>
                        </tr-->
                        <% if(!d.getCliente_privato_azienda().equals("azienda")){%>
                        <!--tr>
                            <td colspan="2">
                                <label>Luogo di Nascita</label><br>
                                <input type="text" id="cliente_luogo_nascita" refresh="si"  value="<%=d.getCliente_luogo_nascita()%>" onchange="modifica_documento(this);">
                            </td>
                            <td colspan="2">
                                <label>Data di Nascita</label><br>
                                <input type="date" id="cliente_data_nascita"  refresh="si" value="<%=d.getCliente_data_nascita()%>" onblur="modifica_documento(this);">
                            </td>
                        </tr-->
                        <%}%>
                    </table>
                    
                    <div class="height-10"></div>
                    
                    <!-- FIRME -->
                    <div style="display:flex;align-items:center;gap:10px;flex-wrap:nowrap;">
                        <a class="pulsante <% if(d.getFirma_cliente()!=null && !d.getFirma_cliente().equals("")){%> ok <%}%>" style="flex-shrink:0;" href="<%=Utility.url%>/firma.jsp?id_documento=<%=id_documento%>&campo_da_modificare=firma_cliente">
                            <i class="fa fa-pencil"></i> Firma Grafometrica
                        </a>

                        <% if(!d.is_otp_verificato()){%>
                            <a class="pulsante arancio" style="flex-shrink:0;" href="<%=Utility.url%>/otp/genera_otp.jsp?id_documento=<%=id_documento%>">
                                <i class="fa-solid fa-mobile-screen-button"></i> Firma con OTP
                            </a>
                        <%}else{%>
                            <div style="cursor:help;flex-shrink:0;white-space:nowrap;padding:8px 12px;background:#e8f7ed;border:1px solid #b7dfc3;border-radius:6px;color:#237a3b;font-size:13px;"
                                 title="numero: <%=d.getOtp_sms()%> - data verifica: <%=Utility.converti_datetime_formato_it(d.getOtp_data_ora_verifica())%>">
                                <i class="fa-solid fa-circle-check"></i>
                                <strong>OTP verificato</strong>
                            </div>
                        <%}%>
                    </div>
            
                    <div class="height-10"></div>
                    
                    <!--div class="col_100">
                        <table>
                            <tr>
                                <td>
                                    <label>Note Interne</label><br>
                                    <textarea id="note1" onchange="modifica_documento(this)" class="no_controllo"><%=Utility.elimina_null(Utility.standardizza_testo_textarea(d.getNote1()))%></textarea>
                                </td>
                            </tr>
                        </table>
                    </div-->
                </div>
                <div class="clear"></div>
                
                <!-- RIGHE -->
              <div id="div_righe">
                <%
                    ArrayList<Riga> righe_documento=GestioneDocumento.getIstanza().get_righe_documento(id_documento);
                %>
                <div class="box">
                    <h2>
                        Prodotti / Servizi
                        <button type="button" class="pulsante_small verde float-right" onclick="aggiungi_riga('')"><i class="fa fa-plus"></i></button>
                    </h2>
                    <table>
                        <thead>
                            <tr>
                                <th style="width:3%;">#</th>
                                <th style="width:80%;">Articolo</th>
                                <th style="width:15%;">Prezzo IVA inclusa €</th>
                                <th style="width:2%;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int i=1;
                                for(Riga r:righe_documento){
                                    if("descrittiva".equals(r.getTipo()))continue;
                            %>
                            <tr>
                                <td><%=i++%></td>
                                <td>
                                    <!--<%=r.getAliquota()%>-><%=r.getIva()%>-->
                                    <input type="text" class="no_controllo" value="<%=r.getDescrizione()%>" id="riga_<%=r.getId()%>" campo="descrizione" onchange="modifica_riga(this,'<%=r.getId()%>')"></td>
                                <td><input type="number" value="<%=Utility.elimina_zero(r.getTotale())%>" id="riga_<%=r.getId()%>" campo="totale" refresh="si" onchange="modifica_riga(this,'<%=r.getId()%>')" style="text-align:right;"></td>
                                <td><button type="button" class="rosso pulsante_small" campo="stato" value="-1" refresh="si" onclick="modifica_riga(this,'<%=r.getId()%>')"><i class="fa-solid fa-trash"></i></button></td>
                            </tr>
                            <%}%>
                            <tr>
                                <th></th>
                                <th>Aliquota %</th>
                                <td>
                                    <input type="number" reload="si" style="text-align: right;" value="<%=Utility.elimina_zero(d.getAliquota())%>" id="aliquota" onchange="modifica_documento(this)">
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <th></th>
                                <th>IMPONIBILE</th>
                                <td class="text-right">
                                    <%=Utility.formatta_prezzo(d.getImponibile())%>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <th></th>
                                <th>IVA</th>
                                <td class="text-right">
                                    <%=Utility.formatta_prezzo(d.getIva())%>
                                </td>
                                <td></td>
                            </tr>
                            <tr>
                                <th></th>
                                <th>TOTALE</th>
                                <th class="text-right"><%=Utility.formatta_prezzo(d.getTotale())%></th>
                                <th></th>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="box">
                    <h2>
                        Descrizione
                        <button type="button" class="pulsante_small verde float-right" onclick="aggiungi_riga('descrittiva')"><i class="fa fa-plus"></i></button>
                    </h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Descrizione</th>
                                <th style="width:2%;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%for(Riga r:righe_documento){
                                if(!"descrittiva".equals(r.getTipo()))continue;
                            %>
                            <tr>
                                <td><textarea class="no_controllo editor_descrizione" id="riga_<%=r.getId()%>" campo="descrizione"><%=r.getDescrizione()%></textarea></td>
                                <td><button type="button" class="rosso pulsante_small" campo="stato" value="-1" refresh="si" onclick="modifica_riga(this,'<%=r.getId()%>')"><i class="fa-solid fa-trash"></i></button></td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>
            
                
                <!-- PAGAMENTI -->
                <div class="box" id="div_pagamenti">
                    <h2>Pagamento</h2>
                    <table>
                        <tr>
                            <td><textarea id="modalita_pagamento" id="modalita_pagamento" onchange="modifica_documento(this);" ><%=Utility.standardizza_testo_textarea(d.getModalita_pagamento())%></textarea></td>
                        </tr>
                    </table>
                    <table>
                        <tr>
                            <th style="width: 100px;">Validità</th>
                            <td>
                                <input type="text" class="no_controllo" id="validita" onchange="modifica_documento(this)" value="<%=d.getValidita()%>">
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
                
                <!-- ALLEGATI -->
                <div class="box" >
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
