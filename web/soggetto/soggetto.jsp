<%@page import="enums.SoggettoTipologia"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String id_soggetto = Utility.elimina_null(request.getParameter("id_soggetto"));
    Soggetto soggetto = GestioneSoggetto.getIstanza().get_soggetto(id_soggetto);

    if(soggetto == null){
        response.sendRedirect(Utility.url + "/soggetto/lista_soggetto.jsp");
        return;
    }

    String tipologia = "";
    if(soggetto.getTipologia() != null)
        tipologia = soggetto.getTipologia().name();
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=Utility.elimina_null(soggetto.getRagione_sociale()).equals("") ? "Soggetto" : soggetto.getRagione_sociale()%> | <%=Utility.nome_software%></title>

        <jsp:include page="../_importazioni.jsp"></jsp:include>

        <script type="text/javascript">
            function modifica_soggetto(inField){
                var id_soggetto = $(inField).attr("id_soggetto");
                var campo_da_modificare = $(inField).attr("campo_da_modificare");
                var new_valore = inField.value;

                if(campo_da_modificare === "stato" && new_valore === "-1"){
                    if(!confirm("Procedere alla cancellazione?"))
                        return;
                }

                if(inField.type === "number" && new_valore.trim() === ""){
                    new_valore = "0";
                    inField.value = "0";
                }

                if(inField.type === "checkbox"){
                    new_valore = inField.checked ? "si" : "";
                }

                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/soggetto/__modifica_soggetto.jsp",
                    data: {
                        id_soggetto: String(id_soggetto),
                        campo_da_modificare: String(campo_da_modificare),
                        new_valore: String(new_valore)
                    },
                    dataType: "html",
                    success: function(msg){
                        if(campo_da_modificare === "stato" && new_valore === "-1"){
                            window.location = "<%=Utility.url%>/soggetto/lista_soggetto.jsp?tipologia=<%=tipologia%>";
                        }
                    },
                    error: function(){
                        alert("Errore durante il salvataggio modifica_soggetto");
                    }
                });
            }
            
            function seleziona_privato_azienda_soggetto(obj){
                mostra_loader("Operazione in corso...");

                if(obj.value=="privato"){
                    $("#ragione_sociale").val("");
                    modifica_soggetto($("#ragione_sociale")[0]);
                }else{
                    $("#nome").val("");
                    $("#cognome").val("");
                    modifica_soggetto($("#nome")[0]);
                    modifica_soggetto($("#cognome")[0]);
                }

                modifica_soggetto(obj);

                setTimeout(function(){
                    location.reload();
                },2000);
            }
        </script>
    </head>

    <body>
        
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>

            <div id="content">

                <h1><%=Utility.elimina_null(soggetto.getRagione_sociale()).equals("") ? "Nuovo soggetto" : soggetto.getRagione_sociale()%></h1>

                <div class="box">
                    <a class="pulsante" href="<%=Utility.url%>/soggetto/lista_soggetto.jsp?tipologia=<%=tipologia%>">
                        <i class="fa-solid fa-arrow-left"></i>Torna alla Lista
                    </a>

                    <button class="pulsante cancella float-right" onclick="modifica_soggetto(this)" campo_da_modificare="stato" id_soggetto="<%=id_soggetto%>" value="-1">
                        <i class="fa-solid fa-trash"></i>Cancella
                    </button>

                    <div class="clear"></div>
                </div>

                <div id="div_soggetto" class="row">

                    <div class="col_50">
                        <div class="box">
                            <h2>Dati principali</h2>

                            <!--div class="etichetta">Attivo</div>
                            <div class="valore">
                                <input type="checkbox" campo_da_modificare='attivo' <%if(soggetto.getAttivo().equals("si")){%> checked="true"<%}%> id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)">
                            </div-->

                            <div class="etichetta">Tipo cliente</div>
                            <div class="valore">
                                <label style="margin-right:20px;">
                                    <input type="radio" name="privato_azienda" value="privato" campo_da_modificare="privato_azienda" id_soggetto="<%=id_soggetto%>" <%if(soggetto.getPrivato_azienda().equals("") || soggetto.getPrivato_azienda().equals("privato")){%>checked<%}%> onchange="seleziona_privato_azienda_soggetto(this)">
                                    Privato
                                </label>

                                <label>
                                    <input type="radio" name="privato_azienda" value="azienda" campo_da_modificare="privato_azienda" id_soggetto="<%=id_soggetto%>" <%if(soggetto.getPrivato_azienda().equals("azienda")){%>checked<%}%> onchange="seleziona_privato_azienda_soggetto(this)">
                                    Azienda
                                </label>
                            </div>

                            
                            <div class="etichetta">Codice</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getCodice())%>" campo_da_modificare="codice" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <!--div class="etichetta">Tipologia</div>
                            <div class="valore">
                                <select campo_da_modificare="tipologia" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)">
                                    <% for(SoggettoTipologia t : SoggettoTipologia.values()){ %>
                                        <option value="<%=t.name()%>" <%=t.name().equals(tipologia) ? "selected" : ""%>><%=t.name()%></option>
                                    <% } %>
                                </select>
                            </div-->
                            <% if(soggetto.getPrivato_azienda().equals("azienda")){%>
                                <div class="etichetta">Ragione sociale</div>
                                <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getRagione_sociale())%>" id="ragione_sociale" campo_da_modificare="ragione_sociale" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                            <%}%>
                            
                            <% if(soggetto.getPrivato_azienda().equals("privato") || soggetto.getPrivato_azienda().equals("")){%>
                                <div class="etichetta">Nome</div>
                                <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getNome())%>" id="nome" campo_da_modificare="nome" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                            

                                <div class="etichetta">Cognome</div>
                                <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getCognome())%>" id="cognome" campo_da_modificare="cognome" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                            <%}%>
                            <div class="etichetta">Referente</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getReferente())%>" campo_da_modificare="referente" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                            
                        </div>

                        <div class="box">
                            <h2>Contatti</h2>

                            <div class="etichetta">Telefono</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getTelefono())%>" campo_da_modificare="telefono" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Cellulare</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getCellulare())%>" campo_da_modificare="cellulare" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Email</div>
                            <div class="valore"><input type="email" value="<%=Utility.elimina_null(soggetto.getEmail())%>" campo_da_modificare="email" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Sito web</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getSito())%>" campo_da_modificare="sito" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                        </div>
                        
                    </div>

                    <div class="col_50">
                        <div class="box">
                            <h2>Dati fiscali</h2>

                            <div class="etichetta">Partita IVA</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getPiva())%>" campo_da_modificare="piva" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Codice fiscale</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getCf())%>" campo_da_modificare="cf" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">PEC</div>
                            <div class="valore"><input type="email" value="<%=Utility.elimina_null(soggetto.getPec())%>" campo_da_modificare="pec" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">SDI</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getSdi())%>" campo_da_modificare="sdi" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                            <!--
                            <div class="etichetta">Regime IVA</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getRegime_iva())%>" campo_da_modificare="regime_iva" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Separazione IVA</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getSeparazione_iva())%>" campo_da_modificare="separazione_iva" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">IVA abituale</div>
                            <div class="valore"><input type="number" step="0.01" value="<%=Utility.elimina_zero(soggetto.getIva_abituale())%>" campo_da_modificare="iva_abituale" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Ritenuta</div>
                            <div class="valore"><input type="number" step="0.01" value="<%=Utility.elimina_zero(soggetto.getRitenuta())%>" campo_da_modificare="ritenuta" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                            -->
                        </div>
                        <!--
                        <div class="box">
                            <h2>Pagamento</h2>

                            <div class="etichetta">Condizioni pagamento</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getCondizioni_pagamento())%>" campo_da_modificare="condizioni_pagamento" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Banca</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getBanca())%>" campo_da_modificare="banca" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">IBAN</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getIban())%>" campo_da_modificare="iban" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">BIC</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getBic())%>" campo_da_modificare="bic" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            
                        </div>
                        -->

                        <div class="box">
                            <h2>Indirizzo</h2>

                            <div class="etichetta">Indirizzo</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getIndirizzo())%>" campo_da_modificare="indirizzo" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">CAP</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getCap())%>" campo_da_modificare="cap" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Comune</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getComune())%>" campo_da_modificare="comune" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Provincia</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getProvincia())%>" campo_da_modificare="provincia" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Regione</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getRegione())%>" campo_da_modificare="regione" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>

                            <div class="etichetta">Nazione</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(soggetto.getNazione())%>" campo_da_modificare="nazione" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)"></div>
                        </div>

                       

                        <div class="box">
                            <h2>Note</h2>

                            <div class="valore">
                                <textarea campo_da_modificare="note" id_soggetto="<%=id_soggetto%>" onchange="modifica_soggetto(this)" style="width:100%; min-height:130px;"><%=Utility.elimina_null(soggetto.getNote())%></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="clear"></div>
                </div>

            </div>
        </div>

    </body>
</html>