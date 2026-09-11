<%@page import="beans.Soggetto"%>
<%@page import="beans.Allegato"%>
<%@page import="java.util.ArrayList"%>
<%@page import="gestioneDB.GestioneAllegati"%> 
<%@page import="utility.Utility"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    if(utente==null){
        response.sendRedirect(Utility.url+"/index.jsp?errore=Sessione%20Scaduta.%20Effettua%20nuovamente%20l'accesso");
        return;
    }
    String query=Utility.elimina_null(request.getParameter("query"));
    String id_rif=Utility.elimina_null(request.getParameter("id_rif"));
    String rif=Utility.elimina_null(request.getParameter("rif"));
    ArrayList<Allegato> allegati=GestioneAllegati.getIstanza().ricercaAllegati(query);
    
%>

<script type='text/javascript'>
    
    function aggiorna_allegati<%=rif%>_<%=id_rif%>() {
        var queryallegati = $("#queryallegati<%=id_rif%>").val();
        $("#allegati<%=id_rif%>").load(
            "<%=Utility.url%>/_allegati.jsp?id_rif=<%=id_rif%>&query=" + encodeURIComponent(String(queryallegati)) + " #allegati_inner<%=id_rif%>",
            function () {
                nascondi_loader();
            }
        );
    }
    
    function modifica_allegato<%=rif%>_<%=id_rif%>(inField,id_allegato){
        var new_valore=inField.value;
        var campo_da_modificare=inField.id;
        var rif=inField.getAttribute("rif") || '';
        if(campo_da_modificare==='stato'){
            if(confirm("Procedere alla cancellazione dell'allegato?")===false){            
                return;
            }
        }
        var query="UPDATE allegati SET "+campo_da_modificare+"='"+encodeURIComponent(String(new_valore))+"' WHERE id="+id_allegato;
        var query1="";
        if(rif=="UTENTE_FIRMA")
            query1="UPDATE soggetto SET firma=null WHERE id=<%=id_rif%>";
        if(rif=="UTENTE_IMMAGINE")
            query1="UPDATE soggetto SET immagine='' WHERE id=<%=id_rif%>";
        if(campo_da_modificare==='stato')
            mostra_loader("Operazione in corso...");        
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/__query.jsp",
            data: "query="+query+"&query1="+query1,
            dataType: "html",
            success: function(msg){
                if(campo_da_modificare==='stato')
                    aggiorna_allegati<%=rif%>_<%=id_rif%>();
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE modifica_allegato()");
            }
        });           
    }    
</script>

<input type='hidden' id='queryallegati<%=id_rif%>' value="<%=query%>">
<div id='allegati<%=id_rif%>'>
    <div id='allegati_inner<%=id_rif%>'>        

        <%if(allegati.size()==0){%>
            <div class="messaggio">Nessun Allegato presente</div>
        <%}else{%>
            <table class="tabella_totali">
                <%for(Allegato allegato:allegati){%>
                    <tr>                
                        <td style="overflow: hidden;">
                            <a href='<%=Utility.url%>/allegati/<%=allegato.getUrl()%>' target="_blank" title="<%=allegato.getUrl()%>" class="pulsante_medium">                        
                                <i class="fa-solid fa-eye"></i>&nbsp;&nbsp;<%=allegato.getUrl()%>
                            </a>
                        </td>                        
                        <td>
                            <%=Utility.converti_datetime_formato_it(allegato.getData())%>
                        </td>
                        <td>                            
                            <button class="pulsante_small rosso" onclick="modifica_allegato<%=rif%>_<%=id_rif%>(this,'<%=allegato.getId()%>');" rif="<%=allegato.getRif()%>" id="stato" value="-1">
                                <i class="fa-solid fa-trash"></i>
                            </button>                            
                        </td>
                    </tr>
                <%}%>
            </table>
        <%}%>
    </div>
</div>
