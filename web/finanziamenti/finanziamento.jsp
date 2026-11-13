<%@page import="beans.Finanziamento"%>
<%@page import="gestioneDB.GestioneFinanziamento"%>
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
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    if(utente==null){
        response.sendRedirect(Utility.url+"/errore.jsp?errore=Sessione%20Scaduta");
        return;
    }  
    
    String id_finanziamento=Utility.elimina_null(request.getParameter("id_finanziamento"));
    Finanziamento f=GestioneFinanziamento.getIstanza().get_finanziamento(id_finanziamento);
    Documento d=GestioneDocumento.getIstanza().get_documento(f.getId_documento());
    String id_documento=f.getId_documento();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Finanziamento <%=f.toString()%> | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script>
            function modifica_finanziamento(inField){
                if(inField.getAttribute("refresh")=="si" || inField.id=="stato"){
                    mostra_loader("Operazione in corso...");
                }

                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/finanziamenti/__modifica_finanziamento.jsp",
                    data: {
                        id_finanziamento: '<%=id_finanziamento%>',
                        campo_da_modificare: inField.id,
                        new_valore: inField.value
                    },
                    dataType: "html",
                    success: function(msg){

                        if(inField.id === "stato" && inField.value === "-1"){
                            window.location = "<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>";
                        }

                        if(inField.getAttribute("refresh")=="si"){
                            location.reload();
                        }
                    },
                    error: function(){
                        aggiornamento_intestazione=false;
                        alert("Errore durante il salvataggio modifica_documento");
                    }
                });
            }
            
            
           
   
        $(document).ready(function(){
            controlla_campi_vuoti();
        });
        
        $(document).ajaxComplete(function(event,xhr,settings){
            controlla_campi_vuoti();
        });
        
        </script>
        <style>
            a,button{pointer-events: auto !important;}
        </style>
    </head>
    <body>
        
        <div id="container" <%if(utente.is_gestore()){%> class="pointer_events_none"<%}%>>
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
            <h1><%=f.toString()%> - <%=d.toString()%></h1>
            <div class="box">
                <a class="pulsante"  href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=d.getId()%>">
                    <i class="fa-solid fa-arrow-left"></i>Torna al Contratto
                </a>
                    <button class="pulsante cancella float-right" onclick="modifica_finanziamento(this)" id="stato" value="-1">
                    <i class="fa-solid fa-trash"></i>Cancella
                </button>
                <button class="pulsante grigio float-right" onclick="window.open('<%=Utility.url%>/pdf/finanziamento/pdf_finanziamento.jsp?id_finanziamento=<%=id_finanziamento%>')" >
                    <i class="fa-solid fa-print"></i>PDF
                </button>
            </div>
            <div class="box">
            <table>
                  <tr>
                    <td>Stato</td>
                    <td>
                        <label>
                            <select id="id_situazione" class="no_controllo" onchange="modifica_finanziamento(this);">                                    
                                <% for(Item sit:GestioneItems.getIstanza().ricerca("finanziamento", "id_situazione")){%>
                                    <option value="<%=sit.getId()%>" <%=Utility.selected_se_uguali(sit.getId(), f.getId_situazione()+"")%>><%=sit.getValore()%></option>
                                <%}%>
                            </select>
                        </label>
                    </td>
                    <td>Numero</td>
                    <td>
                        <input type="text" id="numero" name="numero" value="<%=f.getNumero()%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>Garante Presente?</td>
                    <td>
                        <select id="garante_presente" class="no_controllo" name="garante_presente" refresh="si" onchange="modifica_finanziamento(this);">
                            <option value="">No</option>
                            <option value="si" <%=Utility.elimina_null(f.getGarante_presente()).equals("si")?"selected":""%>>Si</option>
                        </select>
                    </td>
                </tr>
            </table>
                                
            <div class="height-10"></div>                  
            <h3>DATI FINANZIAMENTO</h3>

            <table>
                <tr>
                    <td>
                        <label>Importo richiesto da finanziare (€)</label><br>
                        <input type="text" id="importo" name="importo" value="<%=Utility.formatta_prezzo_no_valuta(f.getImporto())%>" onchange="modifica_finanziamento(this);">
                    </td>

                    <td>
                        <label>Tipo finanziamento</label><br>
                        <select id="tipo" refresh="si" name="tipo" onchange="modifica_finanziamento(this);">
                            <option value="">Seleziona...</option>
                            <option value="<%=Finanziamento.TIPO_STANDARD%>" <% if(f.is_tipo_standard()){%>selected="true"<%}%>>Tasso standard</option>
                            <option value="<%=Finanziamento.TIPO_TASSO_0%>" <% if(f.is_tipo_tasso_0()){%>selected="true"<%}%>>Tasso zero</option>
                        </select>
                    </td>

                    <td>
                        <label>Numero rate</label><br>
                        <input type="number" id="numero_rate" name="numero_rate" min="1" value="<%=f.getNumero_rate()%>" onchange="modifica_finanziamento(this);">
                    </td>

                    <td>
                        <label>Prima rata</label><br>
                        <select id="prima_rata" name="prima_rata" onchange="modifica_finanziamento(this);">
                            <option value="">Seleziona...</option>
                            <option value="30" <%=Utility.elimina_null(f.getPrima_rata()).equals("30")?"selected":""%>>30 giorni</option>
                            <% if(f.is_tipo_standard()){%>
                                <option value="120" <%=Utility.elimina_null(f.getPrima_rata()).equals("120")?"selected":""%>>120 giorni</option>
                            <%}%>
                        </select>
                    </td>
                </tr>
            </table>

                                
            <div class="height-10"></div>
            
            <h3>DATI RICHIEDENTE</h3>

            <table>
                <tr>
                    <% if(f.getPrivato_azienda().equals("privato")){%>
                    <td>
                        <label>Nome</label><br>
                        <input type="text" id="nome" name="nome" value="<%=Utility.elimina_null(f.getNome())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Cognome</label><br>
                        <input type="text" id="cognome" name="cognome" value="<%=Utility.elimina_null(f.getCognome())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <%}%>
                    <% if(f.getPrivato_azienda().equals("azienda")){%>
                    <td>
                        <label>Ragione sociale</label><br>
                        <input type="text" id="ragione_sociale" name="ragione_sociale" value="<%=Utility.elimina_null(f.getRagione_sociale())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <%}%>
                </tr>
            </table>
            <table>
                <tr>
                    <td colspan="2">
                        <label>Codice fiscale</label><br>
                        <input type="text" id="cf" name="cf" value="<%=Utility.elimina_null(f.getCf())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <% if(f.getPrivato_azienda().equals("azienda")){%>
                            <label>Partita IVA</label><br>
                            <input type="text" id="piva" name="piva" value="<%=Utility.elimina_null(f.getPiva())%>" onchange="modifica_finanziamento(this);">
                        <%}%>
                    </td>
                    <td>
                        <label>Data di nascita</label><br>
                        <input type="date" id="data_nascita" name="data_nascita" value="<%=f.getData_nascita()%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Luogo di nascita</label><br>
                        <input type="text" id="luogo_nascita" name="luogo_nascita" value="<%=Utility.elimina_null(f.getLuogo_nascita())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Provincia di nascita</label><br>
                        <input type="text" id="provincia_nascita" name="provincia_nascita" value="<%=Utility.elimina_null(f.getProvincia_nascita())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Cittadinanza</label><br>
                        <input type="text" id="cittadinanza" name="cittadinanza" value="<%=Utility.elimina_null(f.getCittadinanza())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Seconda cittadinanza</label><br>
                        <input type="text" id="seconda_cittadinanza" class="no_controllo" name="seconda_cittadinanza" value="<%=Utility.elimina_null(f.getSeconda_cittadinanza())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>
            </table>
            <div class="height-10"></div>
            <h3>DOCUMENTO DI IDENTITÀ</h3>

            <table>
                <tr>
                    <td>
                        <label>Tipo documento</label><br>
                        <select id="documento_tipo" name="documento_tipo" onchange="modifica_finanziamento(this);">
                            <option value="">Seleziona...</option>
                            <%
                                String tipoDoc=Utility.elimina_null(f.getDocumento_tipo());
                                String[] tipiDoc={"Carta d'identità","Patente","Passaporto"};
                                for(String tipo:tipiDoc){
                            %>
                            <option value="<%=tipo%>" <%=tipoDoc.equals(tipo)?"selected":""%>><%=tipo%></option>
                            <%}%>
                        </select>
                    </td>
                    <td>
                        <label>Numero documento</label><br>
                        <input type="text" id="documento_numero" name="documento_numero" value="<%=Utility.elimina_null(f.getDocumento_numero())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Rilasciato da</label><br>
                        <input type="text" id="documento_rilasciato_da" name="documento_rilasciato_da" value="<%=Utility.elimina_null(f.getDocumento_rilasciato_da())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Data rilascio</label><br>
                        <input type="date" id="documento_rilasciato_il" name="documento_rilasciato_il" value="<%=Utility.elimina_null(f.getDocumento_rilasciato_il())%>" onblur="modifica_finanziamento(this);">
                    </td>
                </tr>
            </table>
            <div class="height-10"></div>
            <h3>RESIDENZA E RECAPITI</h3>

            <table>
                <tr>
                    <td colspan="2">
                        <label>Indirizzo di residenza</label><br>
                        <input type="text" id="indirizzo" name="indirizzo" value="<%=Utility.elimina_null(f.getIndirizzo())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>CAP</label><br>
                        <input type="text" id="cap" name="cap" value="<%=Utility.elimina_null(f.getCap())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Località</label><br>
                        <input type="text" id="localita" name="localita" value="<%=Utility.elimina_null(f.getLocalita())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Comune</label><br>
                        <input type="text" id="comune" name="comune" value="<%=Utility.elimina_null(f.getComune())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Provincia</label><br>
                        <input type="text" id="provincia" name="provincia" value="<%=Utility.elimina_null(f.getProvincia())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Residente dal (MM/AA)</label><br>
                        <input type="text" id="indirizzo_dal" name="indirizzo_dal" placeholder="MM/AA" value="<%=Utility.elimina_null(f.getIndirizzo_dal())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Tipo abitazione</label><br>
                        <select id="residenza" name="residenza" onchange="modifica_finanziamento(this);">
                            <option value="">Seleziona...</option>
                            <%
                                String residenza=Utility.elimina_null(f.getResidenza());
                                String[] tipiResidenza={"Proprietà","Affitto","Presso genitori/terzi","Uso gratuito","Altro"};
                                for(String tipo:tipiResidenza){
                            %>
                            <option value="<%=tipo%>" <%=residenza.equals(tipo)?"selected":""%>><%=tipo%></option>
                            <%}%>
                        </select>
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                        <label>Indirizzo precedente (se residente da meno di 5 anni)</label><br>
                        <input class="no_controllo" type="text" id="indirizzo_precedente" name="indirizzo_precedente" value="<%=Utility.elimina_null(f.getIndirizzo_precedente())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td colspan="2">
                        <label>Note residenza</label><br>
                        <input class="no_controllo" type="text" id="residenza_note" name="residenza_note" value="<%=Utility.elimina_null(f.getResidenza_note())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Telefono casa</label><br>
                        <input class="no_controllo" type="text" id="telefono" name="telefono" value="<%=Utility.elimina_null(f.getTelefono())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Cellulare</label><br>
                        <input type="text" id="cellulare" name="cellulare" value="<%=Utility.elimina_null(f.getCellulare())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td colspan="2">
                        <label>E-mail</label><br>
                        <input type="email" id="email" name="email" value="<%=Utility.elimina_null(f.getEmail())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>
            </table>
            <div class="height-10"></div>
            <h3>SITUAZIONE LAVORATIVA</h3>

            <table>
                <tr>
                    <td>
                        <label>Tipo di contratto</label><br>
                        <select id="tipo_contratto" name="tipo_contratto" onchange="modifica_finanziamento(this);">
                            <option value="">Seleziona...</option>
                            <%
                                String contratto=Utility.elimina_null(f.getTipo_contratto());
                                String[] tipiContratto={"Tempo indeterminato","Tempo determinato","Autonomo","Pensionato","Altro"};
                                for(String tipo:tipiContratto){
                            %>
                            <option value="<%=tipo%>" <%=contratto.equals(tipo)?"selected":""%>><%=tipo%></option>
                            <%}%>
                        </select>
                    </td>
                    <td>
                        <label>Scadenza contratto (MM/AA)</label><br>
                        <input type="text" id="scadenza_contratto" name="scadenza_contratto" placeholder="MM/AA" value="<%=Utility.elimina_null(f.getScadenza_contratto())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Professione</label><br>
                        <input type="text" id="professione" name="professione" value="<%=Utility.elimina_null(f.getProfessione())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>

                <tr>
                    <td>
                        <label>Settore attività</label><br>
                        <input type="text" id="professione_settore" name="professione_settore" value="<%=Utility.elimina_null(f.getProfessione_settore())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Datore di lavoro</label><br>
                        <input type="text" id="datore_lavoro" name="datore_lavoro" value="<%=Utility.elimina_null(f.getDatore_lavoro())%>" onchange="modifica_finanziamento(this);">
                    </td>
                    <td>
                        <label>Reddito mensile netto (€)</label><br>
                        <input type="text" id="reddito" name="reddito" value="<%=Utility.elimina_null(f.getReddito())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>
            </table>
            <div class="height-10"></div>
            <h3>SITUAZIONE FAMILIARE</h3>

            <table>
                <tr>
                    <td colspan="2">
                        <label>Stato civile</label><br>
                        <select id="stato_civile" name="stato_civile" onchange="modifica_finanziamento(this);">
                            <option value="">Seleziona...</option>
                            <%
                                String statoCivile=Utility.elimina_null(f.getStato_civile());
                                String[] statiCivili={"Celibe/Nubile","Sposato/a","Convivente","Separato/a","Divorziato/a","Vedovo/a"};
                                for(String stato:statiCivili){
                            %>
                            <option value="<%=stato%>" <%=statoCivile.equals(stato)?"selected":""%>><%=stato%></option>
                            <%}%>
                        </select>
                    </td>
                    <td>
                        <label>Numero figli a carico</label><br>
                        <input type="number" min="0" id="numero_figli" name="numero_figli" value="<%=Utility.elimina_null(f.getNumero_figli())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>
            </table>
            <div class="height-10"></div>
            <h3>DATI BANCARI</h3>

            <table>
                <tr>
                    <td>
                        <label>IBAN</label><br>
                        <input type="text" id="iban" name="iban" maxlength="34" style="text-transform:uppercase;" value="<%=Utility.elimina_null(f.getIban())%>" onchange="modifica_finanziamento(this);">
                    </td>
                </tr>
            </table>


            <div class="height-10"></div>
              
            <!-- GARANTE -->
                                
            <% if(f.is_garante_presente()){%>
                <div class="height-10"></div>
                <h3>DATI GARANTE (coniuge/convivente)</h3>

                <table>
                    <tr>
                        <td>
                            <label>Nome</label><br>
                            <input type="text" id="garante_nome" name="garante_nome" value="<%=Utility.elimina_null(f.getGarante_nome())%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>Cognome</label><br>
                            <input type="text" id="garante_cognome" name="garante_cognome" value="<%=Utility.elimina_null(f.getGarante_cognome())%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>Codice fiscale</label><br>
                            <input type="text" id="garante_cf" name="garante_cf" value="<%=Utility.elimina_null(f.getGarante_cf())%>" onchange="modifica_finanziamento(this);">
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <label>Luogo di nascita</label><br>
                            <input type="text" id="garante_luogo_nascita" name="garante_luogo_nascita" value="<%=Utility.elimina_null(f.getGarante_luogo_nascita())%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>Data di nascita</label><br>
                            <input type="date" id="garante_data_nascita" name="garante_data_nascita" value="<%=f.getGarante_data_nascita()%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>Cittadinanza</label><br>
                            <input type="text" id="garante_cittadinanza" name="garante_cittadinanza" value="<%=Utility.elimina_null(f.getGarante_cittadinanza())%>" onchange="modifica_finanziamento(this);">
                        </td>
                    </tr>
                </table>

                <div class="height-10"></div>
                <h3>DOCUMENTO DI IDENTITÀ GARANTE</h3>
                <table>
                    <tr>
                        <td>
                            <label>Tipo documento</label><br>
                            <select id="garante_documento_tipo" name="garante_documento_tipo" onchange="modifica_finanziamento(this);">
                                <option value="">Seleziona...</option>
                                <%
                                    String garanteTipoDoc=Utility.elimina_null(f.getGarante_documento_tipo());
                                    String[] garanteTipiDoc={"Carta d'identità","Patente","Passaporto"};
                                    for(String tipo:garanteTipiDoc){
                                %>
                                <option value="<%=tipo%>" <%=garanteTipoDoc.equals(tipo)?"selected":""%>><%=tipo%></option>
                                <%}%>
                            </select>
                        </td>
                        <td>
                            <label>Numero documento</label><br>
                            <input type="text" id="garante_documento_numero" name="garante_documento_numero" value="<%=Utility.elimina_null(f.getGarante_documento_numero())%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>Rilasciato da</label><br>
                            <input type="text" id="garante_documento_rilasciato_da" name="garante_documento_rilasciato_da" value="<%=Utility.elimina_null(f.getGarante_documento_rilasciato_da())%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>Data rilascio</label><br>
                            <input type="date" id="garante_documento_rilasciato_il" name="garante_documento_rilasciato_il" value="<%=Utility.elimina_null(f.getGarante_documento_rilasciato_il())%>" onblur="modifica_finanziamento(this);">
                        </td>
                    </tr>
                </table>

                <div class="height-10"></div>
                <h3>SITUAZIONE LAVORATIVA E RECAPITI GARANTE</h3>

                <table>
                    <tr>
                        <td>
                            <label>Professione</label><br>
                            <input type="text" id="garante_professione" name="garante_professione" value="<%=Utility.elimina_null(f.getGarante_professione())%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>Reddito mensile netto (€)</label><br>
                            <input type="text" id="garante_reddito" name="garante_reddito" value="<%=Utility.elimina_null(f.getGarante_reddito())%>" onchange="modifica_finanziamento(this);">
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <label>Cellulare</label><br>
                            <input type="text" id="garante_cellulare" name="garante_cellulare" value="<%=Utility.elimina_null(f.getGarante_cellulare())%>" onchange="modifica_finanziamento(this);">
                        </td>
                        <td>
                            <label>E-mail</label><br>
                            <input type="email" id="garante_email" name="garante_email" value="<%=Utility.elimina_null(f.getGarante_email())%>" onchange="modifica_finanziamento(this);">
                        </td>
                    </tr>

                    <tr>
                        <td colspan="2">
                            <label>Persona politicamente esposta</label><br>
                            <select id="garante_esposto" name="garante_esposto" onchange="modifica_finanziamento(this);">
                                <option value="">Seleziona...</option>
                                <option value="si" <%=Utility.elimina_null(f.getGarante_esposto()).equals("si")?"selected":""%>>Si</option>
                                <option value="no" <%=Utility.elimina_null(f.getGarante_esposto()).equals("no")?"selected":""%>>No</option>
                            </select>
                        </td>
                    </tr>
                </table>
                            
                
                <!-- FIRME GARANTE -->
                <div class="height-10"></div>
                <h3>FIRME GARANTE</h3>
                <div style="display:flex;align-items:center;gap:10px;flex-wrap:nowrap;">
                    <a class="pulsante <% if(f.getFirma_garante()!=null && !f.getFirma_garante().equals("")){%> ok <%}%>" style="flex-shrink:0;" href="<%=Utility.url%>/firma.jsp?id_finanziamento=<%=id_finanziamento%>&campo_da_modificare=firma_garante">
                        <i class="fa fa-pencil"></i> Firma Grafometrica
                    </a>
                    <% if(!f.is_otp_verificato_garante()){%>
                        <a class="pulsante arancio" style="flex-shrink:0;" href="<%=Utility.url%>/otp/genera_otp.jsp?id_finanziamento=<%=id_finanziamento%>&garante=si">
                            <i class="fa-solid fa-mobile-screen-button"></i> Firma con OTP
                        </a>
                    <%}else{%>
                        <div style="cursor:help;flex-shrink:0;white-space:nowrap;padding:8px 12px;background:#e8f7ed;border:1px solid #b7dfc3;border-radius:6px;color:#237a3b;font-size:13px;" title="numero: <%=f.getOtp_sms_garante()%> - data verifica: <%=Utility.converti_datetime_formato_it(f.getOtp_data_ora_verifica_garante())%>">
                            <i class="fa-solid fa-circle-check"></i>
                            <strong>OTP verificato</strong>
                        </div>
                    <%}%>
                </div>
                            
                <%}%>

                <div class="height-10"></div>
                <div class="height-10"></div>
                <h3>TRATTAMENTO DATI PERSONALI - RICHIEDENTE</h3>

                <table class="tabella_consensi">
                    <thead>
                        <tr>
                            <th style="width:25%;">C.2.1 - Comunicazioni pubblicitarie e promozionali</th>
                            <th style="width:25%;">C.2.2 - Profilazione commerciale</th>
                            <th style="width:25%;">C.2.3 - Comunicazione dati personali a società del gruppo e terzi</th>
                            <th style="width:25%;">C.3 - Trattamento di categorie particolari di dati personali</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <select id="consenso1" name="consenso1" onchange="modifica_finanziamento(this);">
                                    <option value="">Seleziona...</option>
                                    <option value="si" <%=Utility.elimina_null(f.getConsenso1()).equals("si")?"selected":""%>>Do il consenso</option>
                                    <option value="no" <%=Utility.elimina_null(f.getConsenso1()).equals("no")?"selected":""%>>Nego il consenso</option>
                                </select>
                            </td>
                            <td>
                                <select id="consenso2" name="consenso2" onchange="modifica_finanziamento(this);">
                                    <option value="">Seleziona...</option>
                                    <option value="si" <%=Utility.elimina_null(f.getConsenso2()).equals("si")?"selected":""%>>Do il consenso</option>
                                    <option value="no" <%=Utility.elimina_null(f.getConsenso2()).equals("no")?"selected":""%>>Nego il consenso</option>
                                </select>
                            </td>
                            <td>
                                <select id="consenso3" name="consenso3" onchange="modifica_finanziamento(this);">
                                    <option value="">Seleziona...</option>
                                    <option value="si" <%=Utility.elimina_null(f.getConsenso3()).equals("si")?"selected":""%>>Do il consenso</option>
                                    <option value="no" <%=Utility.elimina_null(f.getConsenso3()).equals("no")?"selected":""%>>Nego il consenso</option>
                                </select>
                            </td>
                            <td>
                                <select id="consenso4" name="consenso4" onchange="modifica_finanziamento(this);">
                                    <option value="">Seleziona...</option>
                                    <option value="si" <%=Utility.elimina_null(f.getConsenso4()).equals("si")?"selected":""%>>Do il consenso</option>
                                    <option value="no" <%=Utility.elimina_null(f.getConsenso4()).equals("no")?"selected":""%>>Nego il consenso</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <% if(f.is_garante_presente()){%>

                    <h3>TRATTAMENTO DATI PERSONALI - GARANTE</h3>

                    <table class="tabella_consensi">
                        <thead>
                            <tr>
                                <th style="width:25%;">C.2.1 - Comunicazioni pubblicitarie e promozionali</th>
                                <th style="width:25%;">C.2.2 - Profilazione commerciale</th>
                                <th style="width:25%;">C.2.3 - Comunicazione dati personali a società del gruppo e terzi</th>
                                <th style="width:25%;">C.3 - Trattamento di categorie particolari di dati personali</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <select id="consenso5" name="consenso5" onchange="modifica_finanziamento(this);">
                                        <option value="">Seleziona...</option>
                                        <option value="si" <%=Utility.elimina_null(f.getConsenso5()).equals("si")?"selected":""%>>Do il consenso</option>
                                        <option value="no" <%=Utility.elimina_null(f.getConsenso5()).equals("no")?"selected":""%>>Nego il consenso</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="consenso6" name="consenso6" onchange="modifica_finanziamento(this);">
                                        <option value="">Seleziona...</option>
                                        <option value="si" <%=Utility.elimina_null(f.getConsenso6()).equals("si")?"selected":""%>>Do il consenso</option>
                                        <option value="no" <%=Utility.elimina_null(f.getConsenso6()).equals("no")?"selected":""%>>Nego il consenso</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="consenso7" name="consenso7" onchange="modifica_finanziamento(this);">
                                        <option value="">Seleziona...</option>
                                        <option value="si" <%=Utility.elimina_null(f.getConsenso7()).equals("si")?"selected":""%>>Do il consenso</option>
                                        <option value="no" <%=Utility.elimina_null(f.getConsenso7()).equals("no")?"selected":""%>>Nego il consenso</option>
                                    </select>
                                </td>
                                <td>
                                    <select id="consenso8" name="consenso8" onchange="modifica_finanziamento(this);">
                                        <option value="">Seleziona...</option>
                                        <option value="si" <%=Utility.elimina_null(f.getConsenso8()).equals("si")?"selected":""%>>Do il consenso</option>
                                        <option value="no" <%=Utility.elimina_null(f.getConsenso8()).equals("no")?"selected":""%>>Nego il consenso</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                <%}%>

            </div>
            <div class="box">
                <table>
                    <tr>
                        <td>
                            <label>Note Interne</label><br>
                            <textarea id="note_interne" onchange="modifica_finanziamento(this);" class="no_controllo"><%=Utility.elimina_null(Utility.standardizza_testo_textarea(f.getNote_interne()))%></textarea>
                        </td>
                    </tr>
                </table>
            </div>
                        
            <div class="height-10"></div>
                
                <!-- ALLEGATI -->
                <div class="box">
                <h2>Allegati</h2>
                    <%String queryallegati=" allegati.rif='FINANZIAMENTO' AND allegati.idrif="+Utility.is_null(id_documento)+" AND allegati.stato='1' ORDER BY allegati.id DESC";%>
                    <jsp:include page="../_allegati.jsp">
                        <jsp:param name="query" value="<%=queryallegati%>"></jsp:param>
                        <jsp:param name="id_rif" value="<%=id_documento%>"></jsp:param>
                        <jsp:param name="rif" value="FINANZIAMENTO"></jsp:param>
                    </jsp:include>

                    <div class="height-10"></div>
                    <jsp:include page="../_nuovo_allegato.jsp">
                        <jsp:param name="idrif" value="<%=id_documento%>"></jsp:param>
                        <jsp:param name="rif" value="FINANZIAMENTO"></jsp:param>
                    </jsp:include>
                </div>            
            </div>
        </div>          
    </body>
</html>
