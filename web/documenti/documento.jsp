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
                            aggiorna_documento_intestazione(inField);
                        }
                    },
                    error: function(){
                        alert("Errore durante il salvataggio modifica_documento");
                    }
                });
            }
            
            function aggiorna_documento_intestazione(inField){
                var campi=$("#div_documento_intestazione").find("input:visible, select:visible, textarea:visible");
                var indice=campi.index(inField);
                var idSuccessivo=indice>=0 && indice+1<campi.length ? campi.eq(indice+1).attr("id") : "";

                $("#div_documento_intestazione").load("<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%> #div_documento_intestazione > *",function(){
                    nascondi_loader();
                    if(idSuccessivo!="") $("#"+idSuccessivo).focus();
                });
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
            
            function aggiungi_riga(){
                mostra_loader("Operazione in corso...");
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/righe/__aggiungi_riga.jsp",
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
            
            function modifica_servizi_inclusi(){
                var servizi=[];

                $(".servizio_incluso:checked").each(function(){
                    servizi.push($(this).val());
                });

                $("#servizi_inclusi").val(servizi.join(", "));
                modifica_documento($("#servizi_inclusi")[0]);
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
        
        function modifica_impianto_procedura(){
            var valori=[];

            $(".check_impianto_procedura:checked").each(function(){
                valori.push($(this).val());
            });

            modifica_documento({
                id:"impianto_procedura",
                value:valori.join(","),
                getAttribute:function(){ return ""; }
            });
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
                <button class="pulsante grigio float-right" onclick="window.open('<%=Utility.url%>/pdf/documento/pdf_documento.jsp?id_documento=<%=id_documento%>')" >
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
                        <td>Luogo</td>
                        <td>
                            <label>
                                <input type="text" id="luogo" onchange="modifica_documento(this);" value="<%=d.getLuogo()%>">
                            </label>
                        </td>
                        <td>Data</td>
                        <td>
                            <label>
                                <input type="date" id="data" name="data" onblur="modifica_documento(this);" value="<%=d.getData()%>">
                            </label>
                        </td>
                      </tr>
                      <tr>
                        <td>Consulente</td>
                        <td>
                            <label>
                                <select id="id_autore" onchange="modifica_documento(this);">
                                <% for(Soggetto ut:GestioneSoggetto.getIstanza().ricerca_soggetto(" tipologia='UTENTE' ", " cognome ASC ", -1)){%>
                                    <option value="<%=ut.getId()%>" <%=Utility.selected_se_uguali(ut.getId(), d.getId_autore()+"")%>><%=ut.toString()%></option>
                                <%}%>
                                </select>
                            </label>
                        </td>
                        
                        <td>Tecnico</td>
                        <td>
                            <label>
                                <select id="id_tecnico" onchange="modifica_documento(this);">
                                    <option value="">Seleziona il tecnico</option>
                                    <% for(Soggetto ut:GestioneSoggetto.getIstanza().ricerca_soggetto(" tipologia='UTENTE' AND ruolo='TECNICO' ", " cognome ASC ", -1)){%>
                                        <option value="<%=ut.getId()%>" <%=Utility.selected_se_uguali(ut.getId(), d.getTecnico().getId())%>><%=ut.toString()%></option>
                                    <%}%>
                                </select>
                            </label>
                        </td>
                        <td>Stato</td>
                        <td>
                            <label>
                                <select id="id_situazione" onchange="modifica_documento(this);">                                    
                                    <% for(Item sit:GestioneItems.getIstanza().ricerca("documento", "id_situazione")){%>
                                        <option value="<%=sit.getId()%>" <%=Utility.selected_se_uguali(sit.getId(), d.getId_situazione()+"")%>><%=sit.getValore()%></option>
                                    <%}%>
                                </select>
                            </label>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="box" id="div_documento_intestazione">
                <div class="col_60 float-left">
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
                        <tr>
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
                        </tr>
                        <% if(!d.getCliente_privato_azienda().equals("azienda")){%>
                        <tr>
                            <td colspan="2">
                                <label>Luogo di Nascita</label><br>
                                <input type="text" id="cliente_luogo_nascita" refresh="si"  value="<%=d.getCliente_luogo_nascita()%>" onchange="modifica_documento(this);">
                            </td>
                            <td colspan="2">
                                <label>Data di Nascita</label><br>
                                <input type="date" id="cliente_data_nascita"  refresh="si" value="<%=d.getCliente_data_nascita()%>" onblur="modifica_documento(this);">
                            </td>
                        </tr>
                        <%}%>
                    </table>
                    </div>
                    <div class="col_40 float-left">
                        <h2>
                            Dati Mandante
                        </h2>
                        
                        <table>
                            <tr>
                                <td>
                                    <label>Nome</label><br>
                                    <input type="text" id="mandante_nome" refresh="si" value="<%=d.getMandante_nome()%>" onchange="modifica_documento(this);">
                                </td>
                            
                                <td>
                                    <label>Cognome</label><br>
                                    <input type="text" id="mandante_cognome" refresh="si" value="<%=d.getMandante_cognome()%>" onchange="modifica_documento(this);">
                                </td>
                            </tr>
                             <tr>
                                <td>
                                    <label>Luogo di Nascita</label><br>
                                    <input type="text" id="mandante_luogo_nascita" refresh="si" value="<%=d.getMandante_luogo_nascita()%>" onchange="modifica_documento(this);">
                                </td>
                                <td>
                                    <label>Data di Nascita</label><br>
                                    <input type="date" id="mandante_data_nascita" refresh="si" value="<%=d.getMandante_data_nascita()%>" onblur="modifica_documento(this);">
                                </td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td>
                                    <label>Indirizzo</label><br>
                                    <input type="text" id="mandante_indirizzo" refresh="si" value="<%=d.getMandante_indirizzo()%>" onchange="modifica_documento(this);">
                                </td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td style="width: 70%;">
                                    <label>Comune</label><br>
                                    <input type="text" id="mandante_comune" refresh="si" value="<%=d.getMandante_comune()%>" onchange="modifica_documento(this);">
                                </td>
                                <td style="width: 30%;">
                                    <label>Provincia</label><br>
                                    <input type="text" id="mandante_provincia"  refresh="si" maxlength="2"  value="<%=d.getMandante_provincia()%>" onchange="modifica_documento(this);">
                                </td>
                            </tr>
                        </table>
                        <table>
                            <tr>
                                <td>
                                    <label>Codice Fiscale</label><br>
                                    <input type="text" id="mandante_cf" refresh="si" value="<%=d.getMandante_cf()%>" onchange="modifica_documento(this);">
                                </td>
                            </tr>
                            <% if(!d.isMandante_cliente()){%>
                            <tr>
                                <td>
                                    <label>In qualità di</label><br>
                                    <select id="mandante_qualifica" onchange="modifica_documento(this)">
                                        <option></option>
                                        <option value="procuratore" <%=Utility.selected_se_uguali(d.getMandante_qualifica(), "procuratore")%>>Procuratore</option>
                                        <option value="rappresentante_legale" <%=Utility.selected_se_uguali(d.getMandante_qualifica(), "rappresentante_legale")%>>Rappresentante Legale</option>
                                    </select>
                                </td>
                            </tr>
                            <%}%>
                        </table>
                    </div>
                    <div class="height-10"></div>
                
                        <!-- FIRME -->
                        <div class="col_60 float-left">
                            <h3>Firme Cliente</h3>
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
                        </div>
                        <div class="col_40 float-left">
                            <% if(!d.isMandante_cliente()){%>
                               <h3>Firme Mandante</h3>
                               <div style="display:flex;align-items:center;gap:10px;flex-wrap:nowrap;">
                                   <a class="pulsante <% if(d.getFirma_mandante()!=null && !d.getFirma_mandante().equals("")){%> ok <%}%>" style="flex-shrink:0;" href="<%=Utility.url%>/firma.jsp?id_documento=<%=id_documento%>&campo_da_modificare=firma_mandante">
                                       <i class="fa fa-pencil"></i> Firma Grafometrica
                                   </a>
                                   <% if(!d.is_otp_verificato_mandante()){%>
                                       <a class="pulsante arancio" style="flex-shrink:0;" href="<%=Utility.url%>/otp/genera_otp.jsp?id_documento=<%=id_documento%>&mandante=si">
                                           <i class="fa-solid fa-mobile-screen-button"></i> Firma con OTP
                                       </a>
                                   <%}else{%>
                                       <div style="cursor:help;flex-shrink:0;white-space:nowrap;padding:8px 12px;background:#e8f7ed;border:1px solid #b7dfc3;border-radius:6px;color:#237a3b;font-size:13px;" title="numero: <%=d.getOtp_sms_mandante()%> - data verifica: <%=Utility.converti_datetime_formato_it(d.getOtp_data_ora_verifica_mandante())%>">
                                           <i class="fa-solid fa-circle-check"></i>
                                           <strong>OTP verificato</strong>
                                       </div>
                                   <%}%>
                               </div>
                           <%}%>
                        </div>
                        <div class="clear"></div>
                </div>
                <div class="clear"></div>
                
                
                        
                <!-- RIGHE -->
                <div id="div_righe">
                <div class="box">
                    <h2>
                        Descrizione prodotti e servizi
                        <button type="button" class="pulsante_small verde float-right" onclick="aggiungi_riga()"><i class="fa fa-plus"></i></button>
                    </h2>
                    
                    <table>
                        <thead>
                            <tr>
                                <th style="width: 3%;">#</th>
                                <th style="width: 80%;">Articolo</th>
                                <th style="width: 15%;">Prezzo IVA inclusa €</th>
                                <th style="width: 2%;"></th>
                            </tr>
                        </thead>
                        <tbody>
                        <% int i=1; for(Riga r:GestioneDocumento.getIstanza().get_righe_documento(id_documento)){%>
                        <tr>
                            <td><%=i%></td>
                            <td><input type="text" class="no_controllo" value="<%=r.getDescrizione()%>" id="riga_<%=r.getId()%>" campo="descrizione" onchange="modifica_riga(this,'<%=r.getId()%>')"></td>
                            <td><input type="number" value="<%=Utility.elimina_zero(r.getTotale())%>" id="riga_<%=r.getId()%>" campo="totale" refresh="si" onchange="modifica_riga(this,'<%=r.getId()%>')" style="text-align: right;"></td>
                            <td><button type="button" class="rosso pulsante_small" campo="stato" value="-1" refresh="si" onclick="modifica_riga(this,'<%=r.getId()%>')"><i class="fa-solid fa-trash"></i></button></td>
                        </tr>
                        <%i++;}%>
                        <tr>
                            <th></th>
                            <th>TOTALE</th>
                            <th class="text-right"><%=Utility.formatta_prezzo(d.getTotale())%></th>
                            <th></th>
                        </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- PAGAMENTI -->
                <div class="box" id="div_pagamenti">
                    <h2>Modalità e termini di pagamento</h2>
                    <table>
                        <tr>
                            <td style="width: 10%;">
                                <input type="checkbox" class="check_pagamento" value="pagamento" onchange="modifica_pagamento_tipo()" <% if(d.getPagamento().contains("pagamento")){%>checked<%}%>>
                            </td>
                            <td style="width: 50%;">
                                pagamento intestato a <b>"Bioenergia S.r.l."</b> con le seguenti modalità
                            </td>
                            <td style="width: 40%;">
                                <input type="text" id="modalita_pagamento" value="<%=d.getModalita_pagamento()%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>
                    </table>
                    <% double percentuale_totale=0; %>
                    <% if(d.getPagamento().contains("pagamento")){%>
                        <table>
                            <%
                                ArrayList<Pagamento> pagamenti_no_finanziamento=GestionePagamento.getIstanza().ricerca_pagamento(" finanziamento='' AND id_documento="+id_documento, "", -1);
                                for(int j=0;j<pagamenti_no_finanziamento.size();j++){
                                    Pagamento p=pagamenti_no_finanziamento.get(j);
                                    percentuale_totale+=p.getPercentuale();
                                %>
                                <tr>
                                    <td style="width:10%;">
                                        <input type="number" style="width:50px;" value="<%=Utility.elimina_zero(p.getPercentuale())%>" refresh="si" id="percentuale_pagamento_<%=p.getId()%>" onchange="modifica_pagamento(this)" id_pagamento="<%=p.getId()%>" campo="percentuale">&nbsp;%
                                    </td>
                                    <td style="width:70%;">
                                        <input type="text" value="<%=p.getDescrizione()%>" class="no_controllo" campo="descrizione" id="descrizione_pagamento_<%=p.getId()%>" onchange="modifica_pagamento(this)" id_pagamento="<%=p.getId()%>">
                                    </td>
                                    <td style="width:10%;text-align:right;">
                                        <%=Utility.formatta_prezzo(p.getImporto())%>
                                    </td>
                                    <td style="width:5%;">
                                        <% if(j>0){%>
                                            <button type="button" class="pulsante_small rosso" onclick="modifica_pagamento(this)" value="-1" campo="stato" refresh="si" id_pagamento="<%=p.getId()%>"><i class="fa-solid fa-trash"></i></button>
                                        <%}%>
                                    </td>
                                    <td style="width:5%;">
                                        <% if(j==pagamenti_no_finanziamento.size()-1){%>
                                            <button type="button" class="pulsante_small verde" onclick="aggiungi_pagamento('')"><i class="fa-solid fa-plus"></i></button>
                                        <%}%>
                                    </td>
                                </tr>
                                <%}%>
                        </table>
                    <%}%>
                    <table>
                        <tr>
                            <td style="width: 10%;">
                                <input type="checkbox" class="check_pagamento" value="finanziamento" onchange="modifica_pagamento_tipo()" <% if(d.getPagamento().contains("finanziamento")){%>checked<%}%>>
                            </td>
                            <td style="width: 90%;">
                                erogazione a favore di <b>"Bioenergia S.r.l."</b> del finanziamento sottoscritto dal cliente
                            </td>
                        </tr>
                    </table>
                    <% if(d.getPagamento().contains("finanziamento")){%>
                        <table>
                          <%
                            ArrayList<Pagamento> pagamenti_finanziamento=GestionePagamento.getIstanza().ricerca_pagamento(" finanziamento='si' AND id_documento="+id_documento, "", -1);
                            for(int j=0;j<pagamenti_finanziamento.size();j++){
                                Pagamento p=pagamenti_finanziamento.get(j);
                                percentuale_totale+=p.getPercentuale();
                            %>
                            <tr>
                                <td style="width:10%;">
                                    <input type="number" style="width:50px;" value="<%=Utility.elimina_zero(p.getPercentuale())%>" refresh="si" id="percentuale_pagamento_finanziamento_<%=p.getId()%>" onchange="modifica_pagamento(this)" id_pagamento="<%=p.getId()%>" campo="percentuale">&nbsp;%
                                </td>
                                <td style="width:70%;">
                                    <input type="text" value="<%=p.getDescrizione()%>" class="no_controllo" campo="descrizione" id="descrizione_pagamento_finanziamento_<%=p.getId()%>" onchange="modifica_pagamento(this)" id_pagamento="<%=p.getId()%>">
                                </td>
                                <td style="width:10%;text-align:right;">
                                    <%=Utility.formatta_prezzo(p.getImporto())%>
                                </td>
                                <td style="width:5%;">
                                    <% if(j>0){%>
                                        <button type="button" class="pulsante_small rosso" onclick="modifica_pagamento(this)" value="-1" campo="stato" refresh="si" id_pagamento="<%=p.getId()%>"><i class="fa-solid fa-trash"></i></button>
                                    <%}%>
                                </td>
                                <td style="width:5%;">
                                    <% if(j==pagamenti_finanziamento.size()-1){%>
                                        <button type="button" class="pulsante_small verde" onclick="aggiungi_pagamento('si')"><i class="fa-solid fa-plus"></i></button>
                                    <%}%>
                                </td>
                            </tr>
                            <%}%>
                        </table>
                    <%}%>
                    <% if(percentuale_totale!=100){%>
                    <div class="messaggio">
                        <i class="fa-solid fa-eye"></i>
                        La percentuale dei pagamenti non è uguale al 100%. (Percentuale restante <%=Utility.elimina_zero(100-percentuale_totale)%>%)
                    </div>
                    <%}%>
                </div>
                </div>
                <!-- SERVIZI -->
                <div class="box">
                    <h2>Il nostro servizio</h2>
                    
                    <input type="hidden" id="servizi_inclusi" campo_da_modificare="servizi_inclusi" value="<%=Utility.elimina_null(d.getServizi_inclusi())%>">

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Studio di fattibilità tecnico personalizzato" <%=d.getServizi_inclusi().contains("Studio di fattibilità tecnico personalizzato") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Studio di fattibilità tecnico personalizzato;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Presentazione della pratica autorizzativa di inizio lavori" <%=d.getServizi_inclusi().contains("Presentazione della pratica autorizzativa di inizio lavori") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Presentazione della pratica autorizzativa di inizio lavori;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Presentazione delle pratiche di connessione con il gestore di rete elettrica competente" <%=d.getServizi_inclusi().contains("Presentazione delle pratiche di connessione con il gestore di rete elettrica competente") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Presentazione delle pratiche di connessione con il gestore di rete elettrica competente;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Presentazione delle pratiche per il finanziamento ove richiesto" <%=d.getServizi_inclusi().contains("Presentazione delle pratiche per il finanziamento ove richiesto") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Presentazione delle pratiche per il finanziamento ove richiesto;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Sopralluogo tecnico di approvazione fattibilità" <%=d.getServizi_inclusi().contains("Sopralluogo tecnico di approvazione fattibilità") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Sopralluogo tecnico di approvazione fattibilità;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Dimensionamento e progettazione dell’impianto con verifica fattibilità" <%=d.getServizi_inclusi().contains("Dimensionamento e progettazione dell’impianto con verifica fattibilità") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Dimensionamento e progettazione dell’impianto con verifica fattibilità;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Piano operativo di sicurezza" <%=d.getServizi_inclusi().contains("Piano operativo di sicurezza") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Piano operativo di sicurezza;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Installazione dell’impianto completo (installazione standard)" <%=d.getServizi_inclusi().contains("Installazione dell’impianto completo (installazione standard)") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Installazione dell’impianto completo (installazione standard);</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Dichiarazione di conformità impianto" <%=d.getServizi_inclusi().contains("Dichiarazione di conformità impianto") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Dichiarazione di conformità impianto;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Rilascio della documentazione necessaria per l’ottenimento della detrazione fiscale, ove spettante" <%=d.getServizi_inclusi().contains("Rilascio della documentazione necessaria per l’ottenimento della detrazione fiscale, ove spettante") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Rilascio della documentazione necessaria per l’ottenimento della detrazione fiscale, ove spettante;</label>
                    </div>

                    <div class="riga_servizio">
                        <label><input type="checkbox" class="servizio_incluso" value="Assistenza nella gestione della pratica di Scambio sul Posto o ritiro dedicato" <%=d.getServizi_inclusi().contains("Assistenza nella gestione della pratica di Scambio sul Posto o ritiro dedicato") ? "checked" : ""%> onchange="modifica_servizi_inclusi()"> Assistenza nella gestione della pratica di Scambio sul Posto o ritiro dedicato.</label>
                    </div>
                </div>
                
                <!-- OSSERVAZIONI -->
                <div class="box">
                    <h2>Osservazioni</h2>
                    <table>
                        <tr>
                            <td>
                                <textarea style="min-height: 200px;" class="no_controllo" id="osservazioni" onchange="modifica_documento(this);"><%=Utility.standardizza_testo_textarea(d.getOsservazioni())%></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                            
                            
                <!-- MODULO STRATIFICAZIONE MANTO DI COPERTURA -->
                <div class="box">
                    <h2>Modulo stratificazione manto di copertura</h2>
                        <table style="width:100%;" class="tabella_copertura">
                            <tr>
                                <td style="width:20%;"><b>Tipologia abitazione</b></td>
                                <td style="width:5%;"><input type="radio" id="abitazione_tipologia" name="abitazione_tipologia" value="piano terra" onchange="modifica_documento(this); gestione_altro('abitazione_tipologia','abitazione_tipologia_altro')" <% if(d.getAbitazione_tipologia().equals("piano terra")){%>checked<%}%>></td>
                                <td style="width:75%;">Piano terra</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="abitazione_tipologia" name="abitazione_tipologia" value="2 piani" onchange="modifica_documento(this); gestione_altro('abitazione_tipologia','abitazione_tipologia_altro')" <% if(d.getAbitazione_tipologia().equals("2 piani")){%>checked<%}%>></td>
                                <td>2 piani</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="abitazione_tipologia" name="abitazione_tipologia" value="3 piani" onchange="modifica_documento(this); gestione_altro('abitazione_tipologia','abitazione_tipologia_altro')" <% if(d.getAbitazione_tipologia().equals("3 piani")){%>checked<%}%>></td>
                                <td>3 piani</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="abitazione_tipologia" name="abitazione_tipologia" value="altro" onchange="modifica_documento(this); gestione_altro('abitazione_tipologia','abitazione_tipologia_altro')" <% if(d.getAbitazione_tipologia().equals("altro")){%>checked<%}%>></td>
                                <td>
                                    Altro
                                    <input type="text" id="abitazione_tipologia_altro" name="abitazione_tipologia_altro" value="<%=d.getAbitazione_tipologia_altro()%>" onchange="modifica_documento(this)" style="<% if(!d.getAbitazione_tipologia().equals("altro")){%>display:none;<%}%>">
                                </td>
                            </tr>

                            <tr>
                                <td><b>Tipologia copertura</b></td>
                                <td><input type="radio" id="copertura_tipologia" name="copertura_tipologia" value="tegola bassa" onchange="modifica_documento(this)" <% if(d.getCopertura_tipologia().equals("tegola bassa")){%>checked<%}%>></td>
                                <td>Tegola bassa</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_tipologia" name="copertura_tipologia" value="tegola portoghese" onchange="modifica_documento(this)" <% if(d.getCopertura_tipologia().equals("tegola portoghese")){%>checked<%}%>></td>
                                <td>Tegola portoghese</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_tipologia" name="copertura_tipologia" value="coppi" onchange="modifica_documento(this)" <% if(d.getCopertura_tipologia().equals("coppi")){%>checked<%}%>></td>
                                <td>Coppi</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_tipologia" name="copertura_tipologia" value="lamiera" onchange="modifica_documento(this)" <% if(d.getCopertura_tipologia().equals("lamiera")){%>checked<%}%>></td>
                                <td>Lamiera</td>
                            </tr>

                            <tr>
                                <td><b>Guaina copertura</b></td>
                                <td><input type="radio" id="copertura_guaina" name="copertura_guaina" value="si" onchange="modifica_documento(this)" <% if(d.getCopertura_guaina().equals("si")){%>checked<%}%>></td>
                                <td>Sì</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_guaina" name="copertura_guaina" value="no" onchange="modifica_documento(this)" <% if(d.getCopertura_guaina().equals("no")){%>checked<%}%>></td>
                                <td>No</td>
                            </tr>

                            <tr>
                                <td><b>Altezza grondaia</b></td>
                                <td></td>
                                <td><input type="number" step="0.01" id="altezza_grondaia" name="altezza_grondaia" value="<%=Utility.elimina_zero(d.getAltezza_grondaia())%>" onchange="modifica_documento(this)"></td>
                            </tr>

                            <tr>
                                <td><b>Coibentazione copertura</b></td>
                                <td><input type="radio" id="copertura_coibentazione" name="copertura_coibentazione" value="si" onchange="modifica_documento(this)" <% if(d.getCopertura_coibentazione().equals("si")){%>checked<%}%>></td>
                                <td>Sì</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_coibentazione" name="copertura_coibentazione" value="no" onchange="modifica_documento(this)" <% if(d.getCopertura_coibentazione().equals("no")){%>checked<%}%>></td>
                                <td>No</td>
                            </tr>

                            <tr>
                                <td><b>Materiale copertura</b></td>
                                <td><input type="radio" id="copertura_materiale" name="copertura_materiale" value="legno" onchange="modifica_documento(this); gestione_altro('copertura_materiale','copertura_materiale_altro')" <% if(d.getCopertura_materiale().equals("legno")){%>checked<%}%>></td>
                                <td>Legno</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_materiale" name="copertura_materiale" value="legno ventilato" onchange="modifica_documento(this); gestione_altro('copertura_materiale','copertura_materiale_altro')" <% if(d.getCopertura_materiale().equals("legno ventilato")){%>checked<%}%>></td>
                                <td>Legno ventilato</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_materiale" name="copertura_materiale" value="legno con tavelline" onchange="modifica_documento(this); gestione_altro('copertura_materiale','copertura_materiale_altro')" <% if(d.getCopertura_materiale().equals("legno con tavelline")){%>checked<%}%>></td>
                                <td>Legno con tavelline</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_materiale" name="copertura_materiale" value="cls" onchange="modifica_documento(this); gestione_altro('copertura_materiale','copertura_materiale_altro')" <% if(d.getCopertura_materiale().equals("cls")){%>checked<%}%>></td>
                                <td>CLS</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_materiale" name="copertura_materiale" value="tavelloni + cls" onchange="modifica_documento(this); gestione_altro('copertura_materiale','copertura_materiale_altro')" <% if(d.getCopertura_materiale().equals("tavelloni + cls")){%>checked<%}%>></td>
                                <td>Tavelloni + CLS</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_materiale" name="copertura_materiale" value="tavelloni" onchange="modifica_documento(this); gestione_altro('copertura_materiale','copertura_materiale_altro')" <% if(d.getCopertura_materiale().equals("tavelloni")){%>checked<%}%>></td>
                                <td>Tavelloni</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_materiale" name="copertura_materiale" value="altro" onchange="modifica_documento(this); gestione_altro('copertura_materiale','copertura_materiale_altro')" <% if(d.getCopertura_materiale().equals("altro")){%>checked<%}%>></td>
                                <td>
                                    Altro
                                    <input type="text" id="copertura_materiale_altro" name="copertura_materiale_altro" value="<%=d.getCopertura_materiale_altro()%>" onchange="modifica_documento(this)" style="<% if(!d.getCopertura_materiale().equals("altro")){%>display:none;<%}%>">
                                </td>
                            </tr>

                            <tr>
                                <td><b>Stato struttura copertura</b></td>
                                <td><input type="radio" id="copertura_struttura" name="copertura_struttura" value="ottimo" onchange="modifica_documento(this);gestione_altro('copertura_struttura','copertura_struttura_altro')" <% if(d.getCopertura_struttura().equals("ottimo")){%>checked<%}%>></td>
                                <td>Ottimo</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_struttura" name="copertura_struttura" value="buono" onchange="modifica_documento(this);gestione_altro('copertura_struttura','copertura_struttura_altro')" <% if(d.getCopertura_struttura().equals("buono")){%>checked<%}%>></td>
                                <td>Buono</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_struttura" name="copertura_struttura" value="pessimo" onchange="modifica_documento(this);gestione_altro('copertura_struttura','copertura_struttura_altro')" <% if(d.getCopertura_struttura().equals("pessimo")){%>checked<%}%>></td>
                                <td>Pessimo</td>
                            </tr>
                            <tr>
                                <td></td>
                                <td><input type="radio" id="copertura_struttura" name="copertura_struttura" value="altro" onchange="modifica_documento(this);gestione_altro('copertura_struttura','copertura_struttura_altro')" <% if(d.getCopertura_struttura().equals("altro")){%>checked<%}%>></td>
                                <td>
                                    Altro
                                    <input type="text" id="copertura_struttura_altro" name="copertura_struttura_altro" value="<%=d.getCopertura_struttura_altro()%>" onchange="modifica_documento(this)" style="<% if(!d.getCopertura_struttura_altro().equals("altro")){%>display:none;<%}%>">
                                </td>
                            </tr>
                        </table>
                </div>

                <!-- DATI DELL'IMMBILE -->
                <div class="box">
                    <h2>Dati dell'immobile</h2>
                    <table style="width:100%;">
                        <tr>
                            <td style="width:20%;"><b>Intestatario detrazione</b></td>
                            <td style="width:5%;"></td>
                            <td style="width:75%;">
                                <input type="text" id="detrazione_intestatario" name="detrazione_intestatario" value="<%=d.getDetrazione_intestatario()%>" onchange="modifica_documento(this)" style="width:100%;">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Superficie immobile (mq)</b></td>
                            <td></td>
                            <td>
                                <input type="number" step="0.01" id="immobile_superficie_mq" name="immobile_superficie_mq" value="<%=Utility.elimina_zero(d.getImmobile_superficie_mq())%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Titolo di possesso</b></td>
                            <td><input type="radio" id="immobile_titolo_possesso" name="immobile_titolo_possesso" value="proprietario o comproprietario" onchange="modifica_documento(this)" <% if(d.getImmobile_titolo_possesso().equals("proprietario o comproprietario")){%>checked<%}%>></td>
                            <td>Proprietario o comproprietario</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_titolo_possesso" name="immobile_titolo_possesso" value="detentore o co-detentore" onchange="modifica_documento(this)" <% if(d.getImmobile_titolo_possesso().equals("detentore o co-detentore")){%>checked<%}%>></td>
                            <td>Detentore o co-detentore (es. locatore, comodatario, usufruttuario, etc.)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_titolo_possesso" name="immobile_titolo_possesso" value="familiare convivente" onchange="modifica_documento(this)" <% if(d.getImmobile_titolo_possesso().equals("familiare convivente")){%>checked<%}%>></td>
                            <td>Familiare convivente con il possessore o con il detentore</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_titolo_possesso" name="immobile_titolo_possesso" value="condominio" onchange="modifica_documento(this)" <% if(d.getImmobile_titolo_possesso().equals("condominio")){%>checked<%}%>></td>
                            <td>Condominio</td>
                        </tr>

                        <tr>
                            <td><b>Numero unità immobiliari</b></td>
                            <td></td>
                            <td>
                                <input type="number" id="immobile_num_unita" name="immobile_num_unita" value="<%=Utility.elimina_zero(d.getImmobile_num_unita())%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Anno di costruzione</b></td>
                            <td></td>
                            <td>
                                <input type="number" id="immobile_anno_costruzione" name="immobile_anno_costruzione" value="<%=d.getImmobile_anno_costruzione()%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Tipologia edilizia</b></td>
                            <td><input type="radio" id="immobile_tipologia_edilizia" name="immobile_tipologia_edilizia" value="edificio in linea e condominio oltre i tre piani fuori terra" onchange="modifica_documento(this); gestione_altro('immobile_tipologia_edilizia','immobile_tipologia_edilizia_altro')" <% if(d.getImmobile_tipologia_edilizia().equals("edificio in linea e condominio oltre i tre piani fuori terra")){%>checked<%}%>></td>
                            <td>Edificio in linea e condominio oltre i tre piani fuori terra</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_tipologia_edilizia" name="immobile_tipologia_edilizia" value="edificio a schiera e condominio fino a tre piani" onchange="modifica_documento(this); gestione_altro('immobile_tipologia_edilizia','immobile_tipologia_edilizia_altro')" <% if(d.getImmobile_tipologia_edilizia().equals("edificio a schiera e condominio fino a tre piani")){%>checked<%}%>></td>
                            <td>Edificio a schiera e condominio fino a tre piani</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_tipologia_edilizia" name="immobile_tipologia_edilizia" value="costruzione isolata" onchange="modifica_documento(this); gestione_altro('immobile_tipologia_edilizia','immobile_tipologia_edilizia_altro')" <% if(d.getImmobile_tipologia_edilizia().equals("costruzione isolata")){%>checked<%}%>></td>
                            <td>Costruzione isolata (es. mono o plurifamiliare)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_tipologia_edilizia" name="immobile_tipologia_edilizia" value="edificio industriale, artigianale o commerciale" onchange="modifica_documento(this); gestione_altro('immobile_tipologia_edilizia','immobile_tipologia_edilizia_altro')" <% if(d.getImmobile_tipologia_edilizia().equals("edificio industriale, artigianale o commerciale")){%>checked<%}%>></td>
                            <td>Edificio industriale, artigianale o commerciale</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_tipologia_edilizia" name="immobile_tipologia_edilizia" value="altro" onchange="modifica_documento(this); gestione_altro('immobile_tipologia_edilizia','immobile_tipologia_edilizia_altro')" <% if(d.getImmobile_tipologia_edilizia().equals("altro")){%>checked<%}%>></td>
                            <td>
                                Altro
                                <input type="text" id="immobile_tipologia_edilizia_altro" name="immobile_tipologia_edilizia_altro" value="<%=d.getImmobile_tipologia_edilizia_altro()%>" onchange="modifica_documento(this)" style="<% if(!d.getImmobile_tipologia_edilizia().equals("altro")){%>display:none;<%}%>">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Tipo intervento</b></td>
                            <td><input type="radio" id="immobile_tipo_intervento" name="immobile_tipo_intervento" value="singola unita immobiliare" onchange="modifica_documento(this)" <% if(d.getImmobile_tipo_intervento().equals("singola unita immobiliare")){%>checked<%}%>></td>
                            <td>Singola unità immobiliare (in edificio costituito da più unità immobiliari)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_tipo_intervento" name="immobile_tipo_intervento" value="edificio singola unita immobiliare" onchange="modifica_documento(this)" <% if(d.getImmobile_tipo_intervento().equals("edificio singola unita immobiliare")){%>checked<%}%>></td>
                            <td>Edificio costituito da una singola unità immobiliare</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_tipo_intervento" name="immobile_tipo_intervento" value="parti comuni condominiali" onchange="modifica_documento(this)" <% if(d.getImmobile_tipo_intervento().equals("parti comuni condominiali")){%>checked<%}%>></td>
                            <td>Parti comuni condominiali</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td><input type="radio" id="immobile_tipo_intervento" name="immobile_tipo_intervento" value="intero edificio" onchange="modifica_documento(this)" <% if(d.getImmobile_tipo_intervento().equals("intero edificio")){%>checked<%}%>></td>
                            <td>Intero edificio (qualsiasi tipo di edificio non incluso nei casi sopra riportati)</td>
                        </tr>

                        <tr>
                            <td><b>Unità oggetto di intervento</b></td>
                            <td></td>
                            <td>
                                <input type="number" id="immobile_unita_intervento" name="immobile_unita_intervento" value="<%=d.getImmobile_unita_intervento()%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>
                    </table>
                </div>
                            
                            
                <div class="box">
                    <h2>Allegato "GSE"</h2>
                    <table>
                        <tr>
                            <td style="width: 20%;"><b>Tariffa da applicare alla pratica RID</b></td>
                            <td style="width: 5%;">
                                <input type="radio" id="gse_prezzi" name="gse_prezzi" value="prezzi_minimi_garantiti" onchange="modifica_documento(this)" <% if(d.getGse_prezzi().equals("prezzi_minimi_garantiti")){%>checked<%}%>>
                            </td>
                            <td style="width: 65%;">Prezzi minimi garantiti</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="radio" id="gse_prezzi" name="gse_prezzi" value="prezzi_medi_rid" onchange="modifica_documento(this)" <% if(d.getGse_prezzi().equals("prezzi_medi_rid")){%>checked<%}%>>
                            </td>
                            <td>Prezzi medi RID</td>
                        </tr>
                    </table>
                </div>
                            
                <!-- MODELLO INFORMATIVO IMPIANTO -->
                <div class="box">
                    <h2>Modello informativo impianto</h2>
                    <table style="width:100%;">
                        <tr>
                            <td style="width:20%;"><b>Tipologia di procedura</b></td>
                            <td style="width:5%;">
                                <input type="checkbox" class="check_impianto_procedura" value="DIA" onchange="modifica_impianto_procedura()" <% if(d.getImpianto_procedura().contains("DIA")){%>checked<%}%>>
                            </td>
                            <td style="width:75%;">DIA (solo nei casi previsti dall’art. 5 della L.R. 14/2009 e s.m.e.i.)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" class="check_impianto_procedura" value="PAS" onchange="modifica_impianto_procedura()" <% if(d.getImpianto_procedura().contains("PAS")){%>checked<%}%>>
                            </td>
                            <td>Procedura Autorizzativa Semplificata (PAS)</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" class="check_impianto_procedura" value="comunicazione al comune" onchange="modifica_impianto_procedura()" <% if(d.getImpianto_procedura().contains("comunicazione al comune")){%>checked<%}%>>
                            </td>
                            <td>Comunicazione al Comune</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="checkbox" class="check_impianto_procedura" value="intervento edilizio" onchange="modifica_impianto_procedura()" <% if(d.getImpianto_procedura().contains("intervento edilizio")){%>checked<%}%>>
                            </td>
                            <td>
                                Impianto realizzato nell’ambito di intervento edilizio
                                <br>
                                <input type="text" id="impianto_intervento_edilizio" class="no_controllo" name="impianto_intervento_edilizio" value="<%=d.getImpianto_intervento_edilizio()%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Tipologia di impianto</b></td>
                            <td>
                                <input type="radio" id="impianto_tipologia" name="impianto_tipologia" value="A - su edifici" onchange="modifica_documento(this)" <% if(d.getImpianto_tipologia().equals("A - su edifici")){%>checked<%}%>>
                            </td>
                            <td>A - su edifici</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="radio" id="impianto_tipologia" name="impianto_tipologia" value="B - tettoie, serre o pensiline" onchange="modifica_documento(this)" <% if(d.getImpianto_tipologia().equals("B - tettoie, serre o pensiline")){%>checked<%}%>>
                            </td>
                            <td>B - tettoie, serre o pensiline</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td>
                                <input type="radio" id="impianto_tipologia" name="impianto_tipologia" value="C - moduli collocati a terra" onchange="modifica_documento(this)" <% if(d.getImpianto_tipologia().equals("C - moduli collocati a terra")){%>checked<%}%>>
                            </td>
                            <td>C - moduli collocati a terra</td>
                        </tr>

                        <tr>
                            <td><b>Superficie dei moduli (mq)</b></td>
                            <td></td>
                            <td>
                                <input type="number" step="0.01" id="impianto_superficie_moduli" name="impianto_superficie_moduli" value="<%=Utility.elimina_zero(d.getImpianto_superficie_moduli())%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        
                        <tr>
                            <td>
                                <b><% if(d.getCliente_privato_azienda().equals("azienda")){%>Ragione Sociale<%}else{%>Cognome e Nome<%}%></b>
                            </td>
                            <td></td>
                            <td>
                                <% if(d.getCliente_privato_azienda().equals("azienda")){%>
                                    <%=d.getCliente_ragione_sociale()%>
                                <%}else{%>
                                    <%=d.getCliente_cognome()%> <%=d.getCliente_nome()%>
                                <%}%>
                            </td>
                         </tr>
                        
                         <tr>
                            <td>
                                <b>Indirizzo</b>
                            </td>
                            <td></td>
                            <td><%=d.getCliente_indirizzo()%></td>
                         </tr>
                        <tr>
                            <td>
                                <b>Comune</b>
                            </td>
                            <td></td>
                            <td><%=d.getCliente_comune()%></td>
                         </tr>
                         <tr>
                            <td>
                                <b>Provincia</b>
                            </td>
                            <td></td>
                            <td><%=d.getCliente_provincia()%></td>
                         </tr>
                         <tr>
                            <td>
                                <b>Cellulare</b>
                            </td>
                            <td></td>
                            <td><%=d.getCliente_cellulare()%></td>
                         </tr>
                         <tr>
                            <td>
                                <b>Email</b>
                            </td>
                            <td></td>
                            <td><%=d.getCliente_email()%></td>
                         </tr>
                        

                        <tr>
                            <td><b>Foglio catastale</b></td>
                            <td></td>
                            <td>
                                <input type="text" id="impianto_foglio_catastale" name="impianto_foglio_catastale" value="<%=d.getImpianto_foglio_catastale()%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Particella</b></td>
                            <td></td>
                            <td>
                                <input type="text" id="impianto_particella" name="impianto_particella" value="<%=d.getImpianto_particella()%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Coordinate</b></td>
                            <td></td>
                            <td>
                                <input type="text" id="impianto_coordinate" name="impianto_coordinate" value="<%=d.getImpianto_coordinate()%>" onchange="modifica_documento(this)" style="width:100%;">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Data prevista di entrata in esercizio</b></td>
                            <td></td>
                            <td>
                                <input type="date" id="impianto_data_entrata_esercizio" name="impianto_data_entrata_esercizio" value="<%=Utility.elimina_null(d.getImpianto_data_entrata_esercizio())%>" onblur="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Potenza elettrica installata (kW)</b></td>
                            <td></td>
                            <td>
                                <input type="number" step="0.001" id="impianto_potenza_kw" name="impianto_potenza_kw" value="<%=Utility.elimina_zero(d.getImpianto_potenza_kw())%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Producibilità annua attesa (kWh/anno)</b></td>
                            <td></td>
                            <td>
                                <input type="number" step="0.01" id="impianto_producibilita_annua" name="impianto_producibilita_annua" value="<%=Utility.elimina_zero(d.getImpianto_producibilita_annua())%>" onchange="modifica_documento(this)">
                            </td>
                        </tr>

                        <tr>
                            <td><b>Note</b></td>
                            <td></td>
                            <td>
                                <textarea id="impianto_note" class="no_controllo" name="impianto_note" onchange="modifica_documento(this)" style="width:100%;min-height:80px;"><%=Utility.elimina_null(Utility.standardizza_testo_textarea(d.getImpianto_note()))%></textarea>
                            </td>
                        </tr>

                    </table>
                </div>        
            </div>
        </div>          
    </body>
</html>
