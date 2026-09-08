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
                            location.reload();
                        }
                    },
                    error: function(){
                        alert("Errore durante il salvataggio modifica_documento");
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
                </table>
            </div>
            <div class="box">
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
                                <input type="radio" id="cliente_privato_azienda" name="privato_azienda" value="privato" <%if(d.getCliente_privato_azienda().equals("") || d.getCliente_privato_azienda().equals("privato")){%>checked="true"<%}%> onchange="seleziona_privato_azienda_documento(this); modifica_documento(this);">
                            </label>
                        </td>
                        <td>Azienda</td>
                        <td>
                            <label>
                                <input type="radio" id="cliente_privato_azienda" name="privato_azienda" value="azienda" <%if(d.getCliente_privato_azienda().equals("azienda")){%>checked="true"<%}%> onchange="seleziona_privato_azienda_documento(this); modifica_documento(this);">
                            </label>
                        </td>
                    </tr>

                    <tr id="riga_azienda" <%if(d.getCliente_privato_azienda().equals("azienda")){%>style="display:table-row;"<%}else{%>style="display:none;"<%}%>>
                        <td colspan="4">
                            <label>Ragione Sociale *</label><br>
                            <div style="display:flex;gap:5px;">
                                <input type="text" id="cliente_ragione_sociale" name="ragione_sociale" value="<%=d.getCliente_ragione_sociale()%>" onchange="modifica_documento(this);">
                            </div>
                        </td>
                    </tr>

                    <tr id="riga_privato" <%if(d.getCliente_privato_azienda().equals("") || d.getCliente_privato_azienda().equals("privato")){%>style="display:table-row;"<%}else{%>style="display:none;"<%}%>>
                        <td colspan="2">
                            <label>Nome *</label><br>
                            <input type="text" id="cliente_nome" name="nome" value="<%=d.getCliente_nome()%>" onchange="modifica_documento(this);">
                        </td>
                        <td colspan="2">
                            <label>Cognome *</label><br>
                            <div style="display:flex;gap:5px;">
                                <input type="text" id="cliente_cognome" name="cognome" value="<%=d.getCliente_cognome()%>" onchange="modifica_documento(this);">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width:45%;">
                            <label>Via</label><br>
                            <input type="text" id="cliente_indirizzo" name="indirizzo"  required value="<%=d.getCliente_indirizzo()%>" onchange="modifica_documento(this);">
                        </td>
                        <td style="width:10%;">
                            <label>CAP</label><br>
                            <input type="text" id="cliente_cap" name="cap" maxlength="5"  required value="<%=d.getCliente_cap()%>" onchange="modifica_documento(this);">
                        </td>
                        <td style="width:35%;">
                            <label>Località</label><br>
                            <input type="text" id="cliente_comune" name="comune"  required value="<%=d.getCliente_comune()%>" onchange="modifica_documento(this);">
                        </td>
                        <td style="width:10%;">
                            <label>Provincia</label><br>
                            <input type="text" id="cliente_provincia" name="provincia" maxlength="2"  required value="<%=d.getCliente_provincia()%>" onchange="modifica_documento(this);">
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>
                            <label>Telefono casa</label><br>
                            <input type="text" id="cliente_telefono" name="telefono"  value="<%=d.getCliente_telefono()%>" onchange="modifica_documento(this);">
                        </td>
                        <td colspan="2">
                            <label>Cellulare</label><br>
                            <input type="text" id="cliente_cellulare" name="cellulare"  required value="<%=d.getCliente_cellulare()%>" onchange="modifica_documento(this);">
                        </td>
                        <td>
                            <label>E-mail</label><br>
                            <input type="email" id="cliente_email" name="email"  value="<%=d.getCliente_email()%>" onchange="modifica_documento(this);">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <label>Codice fiscale</label><br>
                            <input type="text" id="cliente_cf" name="cf"  value="<%=d.getCliente_cf()%>" onchange="modifica_documento(this);">
                        </td>
                        <td colspan="2">
                            <label>Partita IVA</label><br>
                            <input type="text" id="cliente_piva" name="piva"  value="<%=d.getCliente_piva()%>" onchange="modifica_documento(this);">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <label>Luogo di Nascita</label><br>
                            <input type="text" id="cliente_luogo_nascita"  value="<%=d.getCliente_luogo_nascita()%>" onchange="modifica_documento(this);">
                        </td>
                        <td colspan="2">
                            <label>Data di Nascita</label><br>
                            <input type="date" id="cliente_data_nascita"  value="<%=d.getCliente_data_nascita()%>" onblur="modifica_documento(this);">
                        </td>
                    </tr>
                </table>
                </div>
                        
                <!-- RIGHE -->
                <div class="box">
                    <h2>Descrizione prodotti e servizi</h2>
                </div>
                
                <!-- PAGAMENTI -->
                <div class="box">
                    <h2>Modalità e termini di pagamento</h2>
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
                                <textarea style="min-height: 200px;" id="osservazioni" onchange="modifica_documento(this);"><%=Utility.standardizza_testo_textarea(d.getOsservazioni())%></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>          
    </body>
</html>
