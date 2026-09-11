<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String tipo=Utility.elimina_null(request.getParameter("tipo"));
    String id_soggetto=Utility.elimina_null(request.getParameter("id_soggetto"));
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
                var cf=$("#cf").val().trim();
                var piva=$("#piva").val().trim();

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
                mostra_loader("Recupero dati cliente in corso...");
                location.href="<%=Utility.url%>/documenti/aggiungi_documento.jsp?tipo=<%=tipo%>&id_soggetto="+id_soggetto;
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
        </script>
    </head>
    <body>
        
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
            <h1>Nuovo <%=tipo%></h1>
            <div class="box">
                <form method="post" id="form_aggiungi_documento" onsubmit="event.preventDefault(); aggiungi_documento();">
                    <input type="hidden" name="tipo" value="<%=tipo%>">
                    <input type="hidden" id="id_soggetto" name="id_soggetto" value="<%=id_soggetto%>">
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
                                <label>E-mail</label><br>
                                <input type="email" id="email" name="email"  value="<%=cliente.getEmail()%>">
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
    </body>
</html>
