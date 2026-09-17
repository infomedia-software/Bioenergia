<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true"%>
<!DOCTYPE html>
<%
    
    Soggetto utente_sessione=(Soggetto)session.getAttribute("utente");
    
    if(!utente_sessione.is_amministratore()){
        response.sendRedirect(Utility.url+"/errore.jsp?errore=Account%20non%20abilitato");
        return;
    }
    String id_utente=Utility.elimina_null(request.getParameter("id_utente"));
    Soggetto utente=GestioneSoggetto.getIstanza().get_soggetto(id_utente);

    if(utente==null){
        response.sendRedirect(Utility.url+"/utente/lista_utente.jsp");
        return;
    }
    

    String nome_completo=(Utility.elimina_null(utente.getNome())+" "+Utility.elimina_null(utente.getCognome())).trim();
    String titolo=nome_completo.equals("") ? "Nuovo utente" : nome_completo;
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=titolo%> | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        <script type="text/javascript">
            function modifica_utente(inField){
                var id_utente=$(inField).attr("id_utente");
                var campo_da_modificare=$(inField).attr("campo_da_modificare");
                var new_valore=inField.value;

                if(campo_da_modificare==="stato" && new_valore==="-1"){
                    if(!confirm("Procedere alla cancellazione dell'utente?"))
                        return;
                }

                if(inField.type==="number" && new_valore.trim()===""){
                    new_valore="0";
                    inField.value="0";
                }

                if(inField.type==="checkbox")
                    new_valore=inField.checked ? "si" : "";

                $.ajax({
                    type:"POST",
                    url:"<%=Utility.url%>/utente/__modifica_utente.jsp",
                    data:{
                        id_utente:String(id_utente),
                        campo_da_modificare:String(campo_da_modificare),
                        new_valore:String(new_valore)
                    },
                    dataType:"html",
                    success:function(msg){
                        if(campo_da_modificare==="stato" && new_valore==="-1")
                            window.location="<%=Utility.url%>/utente/lista_utente.jsp";
                    },
                    error:function(){
                        alert("Errore durante il salvataggio dell'utente");
                    }
                });
            }

            function modifica_privilegio(inField){
                var privilegio=$(inField).attr("privilegio");
                var valore=inField.checked ? "si" : "";
                alert("DA IMPLEMENTARE");
              
            }

            function mostra_password(){
                var campo=document.getElementById("password");
                var icona=document.getElementById("icona_password");

                if(campo.type==="password"){
                    campo.type="text";
                    icona.className="fa-solid fa-eye-slash";
                }else{
                    campo.type="password";
                    icona.className="fa-solid fa-eye";
                }
            }

            function seleziona_tutti_privilegi(valore){
                $(".checkbox_privilegio").each(function(){
                    if(this.checked!==valore){
                        this.checked=valore;
                        modifica_privilegio(this);
                    }
                });
            }
           
        </script>
    </head>
    <body>
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
                <h1><%=titolo%></h1>
                <div class="box">
                    <a class="pulsante" href="<%=Utility.url%>/utente/lista_utente.jsp"><i class="fa-solid fa-arrow-left"></i> Torna alla lista</a>
                    <button type="button" class="pulsante cancella float-right" onclick="modifica_utente(this)" campo_da_modificare="stato" id_utente="<%=id_utente%>" value="-1"><i class="fa-solid fa-trash"></i> Cancella</button>
                    <div class="clear"></div>
                </div>

                <div class="row">
                    <div class="col_50">
                        <div class="box">
                            <h3>Dati anagrafici</h3>
                            <div class="etichetta">Codice</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(utente.getCodice())%>" campo_da_modificare="codice" id_utente="<%=id_utente%>" onchange="modifica_utente(this)"></div>
                            <div class="etichetta">Nome</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(utente.getNome())%>" campo_da_modificare="nome" id_utente="<%=id_utente%>" onchange="modifica_utente(this)"></div>
                            <div class="etichetta">Cognome</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(utente.getCognome())%>" campo_da_modificare="cognome" id_utente="<%=id_utente%>" onchange="modifica_utente(this)"></div>
                            <div class="etichetta">Email</div>
                            <div class="valore"><input type="email" value="<%=Utility.elimina_null(utente.getEmail())%>" campo_da_modificare="email" id_utente="<%=id_utente%>" onchange="modifica_utente(this)"></div>
                            <div class="etichetta">Cellulare</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(utente.getCellulare())%>" campo_da_modificare="cellulare" id_utente="<%=id_utente%>" onchange="modifica_utente(this)"></div>
                            <div class="etichetta">Telefono</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(utente.getTelefono())%>" campo_da_modificare="telefono" id_utente="<%=id_utente%>" onchange="modifica_utente(this)"></div>
                            <div class="etichetta">Note</div>
                            <div class="valore"><textarea campo_da_modificare="note" id_utente="<%=id_utente%>" onchange="modifica_utente(this)" style="width:100%;min-height:130px;"><%=Utility.standardizza_testo_textarea(utente.getNote())%></textarea></div>
                        </div>
                        
                    </div>

                    <div class="col_50">
                        <div class="box">
                            <h2><i class="fa-solid fa-key"></i> Dati di Accesso</h2>
                            
                           <div class="etichetta">Ruolo</div>
                            <div class="valore">
                                <select campo_da_modificare="ruolo" id_utente="<%=id_utente%>" onchange="modifica_utente(this)">
                                    <option value="AMMINISTRATORE" <%=Utility.selected_se_uguali(utente.getRuolo(),"AMMINISTRATORE")%>>Amministratore</option>
                                    <option value="CONSULENTE" <%=Utility.selected_se_uguali(utente.getRuolo(),"CONSULENTE")%>>Consulente</option>
                                    <option value="GESTORE" <%=Utility.selected_se_uguali(utente.getRuolo(),"GESTORE")%>>Gestore</option>
                                </select>
                            </div>
                                
                            <div class="etichetta">Nome utente</div>
                            <div class="valore"><input type="text" value="<%=Utility.elimina_null(utente.getNome_utente())%>" campo_da_modificare="nome_utente" id_utente="<%=id_utente%>" onchange="modifica_utente(this)" autocomplete="off"></div>
                            <div class="etichetta">Password</div>
                            <div class="valore">
                                <div style="display:flex;align-items:center;width:100%;gap:5px;">
                                    <input id="password" type="password" value="<%=Utility.elimina_null(utente.getPassword())%>" campo_da_modificare="password" id_utente="<%=id_utente%>" onchange="modifica_utente(this)" autocomplete="new-password" style="flex:1;width:auto;min-width:0;">
                                    <button type="button" class="pulsante_small" onclick="mostra_password()" title="Mostra o nascondi password" style="flex:0 0 32px;margin:0;"><i id="icona_password" class="fa-solid fa-eye"></i></button>
                                </div>
                            </div>                  
                        </div>

                                    
                        <div class="box">
                            <h2>Foto Utente</h2>
                            <%String queryallegati=" allegati.rif='UTENTE_IMMAGINE' AND allegati.idrif="+Utility.is_null(id_utente)+" AND allegati.stato='1' ORDER BY allegati.id DESC";%>
                            <jsp:include page="../_allegati.jsp">
                                <jsp:param name="query" value="<%=queryallegati%>"></jsp:param>
                                <jsp:param name="id_rif" value="<%=id_utente%>"></jsp:param>
                                <jsp:param name="rif" value="UTENTE_IMMAGINE"></jsp:param>
                            </jsp:include>
                            <% if(utente.getImmagine()==null || utente.getImmagine().equals("")){%>
                            <div class="height-10"></div>
                            <jsp:include page="../_nuovo_allegato.jsp">
                                <jsp:param name="idrif" value="<%=id_utente%>"></jsp:param>
                                <jsp:param name="rif" value="UTENTE_IMMAGINE"></jsp:param>
                            </jsp:include>
                            <%}%>
                            <div class="height-10"></div>
                            <h2>Immagine Firma</h2>
                            <% queryallegati=" allegati.rif='UTENTE_FIRMA' AND allegati.idrif="+Utility.is_null(id_utente)+" AND allegati.stato='1' ORDER BY allegati.id DESC";%>
                            <jsp:include page="../_allegati.jsp">
                                <jsp:param name="query" value="<%=queryallegati%>"></jsp:param>
                                <jsp:param name="id_rif" value="<%=id_utente%>"></jsp:param>
                                <jsp:param name="rif" value="UTENTE_FIRMA"></jsp:param>
                            </jsp:include>
                            <% if(utente.getFirma()==null || utente.getFirma().equals("")){%>
                                <div class="height-10"></div>
                                <jsp:include page="../_nuovo_allegato.jsp">
                                    <jsp:param name="idrif" value="<%=id_utente%>"></jsp:param>
                                    <jsp:param name="rif" value="UTENTE_FIRMA"></jsp:param>
                                </jsp:include>
                            <%}%>
                        </div>
                    </div>
                    
                    
                 
                    </div>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <script>
             
            function aggiorna_allegatiUTENTE_IMMAGINE_<%=utente.getId()%>(){
                mostra_loader("Operazione in corso...");                
                location.reload();
            }
            function aggiorna_allegatiUTENTE_FIRMA_<%=utente.getId()%>(){
                mostra_loader("Operazione in corso...");
                location.reload();
            }
        </script>
    </body>
</html>