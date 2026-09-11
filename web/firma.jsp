<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Soggetto"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    if(utente==null){
        response.sendRedirect(Utility.url+"/index.jsp?errore=Sessione%20Scaduta.%20Effettua%20nuovamente%20l'accesso");
        return;
    }
    
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    String campo_da_modificare=Utility.elimina_null(request.getParameter("campo_da_modificare"));
    String nuova_firma=Utility.elimina_null(request.getParameter("nuova_firma"));      
    Documento d=GestioneDocumento.getIstanza().get_documento(id_documento);
    String firma=d.getFirma_cliente();
    if(campo_da_modificare.equals("firma_mandante"))
        firma=d.getFirma_mandante();
%> 
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Firma <%=d.toString()%> | <%=Utility.nome_software%></title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <link rel="stylesheet" href="<%=Utility.url%>/js/firma/css/signature-pad.css">
    <jsp:include page="_importazioni.jsp"></jsp:include>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <script type="text/javascript">
        
        var wrapper = document.getElementById("signature-pad");
        var canvas = wrapper.querySelector("canvas");
        var signaturePad = new SignaturePad(canvas, {backgroundColor: 'rgb(255, 255, 255)'});
        
        function salva(){
            if(signaturePad.isEmpty()){
                alert("Inserire la firma");
                return;
            }
            mostra_loader("Salvataggio firma in corso...");
            var dataURL=signaturePad.toDataURL();
            function_modifica_documento('<%=id_documento%>','<%=campo_da_modificare%>',dataURL,'si');
        }
        
        
        function aggiorna_documento(){
            location.href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>";
        }
        
        function pulisci(){
            var canvas = document. getElementById("canvas_firma");
            var context = canvas. getContext('2d');
            context.clearRect(0, 0, canvas. width, canvas. height);
        }
        
    </script>
  
</head>
<body onselectstart="return false">
    <div id="container">
       <jsp:include page="_menu.jsp"></jsp:include>
       <div id="content">
        <h1><%=campo_da_modificare.replace("_", " ").toUpperCase()%> - <%=d.toString()%></h1>
       <%if(firma==null || firma.equals("") || nuova_firma.equals("si")){%>
           <div class="box">   
               <a class="pulsante float-left" href='<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>'><i class="fa-solid fa-arrow-left"></i></a>              
               <button type="button" class="pulsante verde" onclick="salva()"><i class="fa fa-save"></i>Salva</button>
               <button type="button" class="pulsante rosso" onclick='pulisci()'><i class="fa fa-trash"></i>Pulisci</button>                      
           </div>

           <div id="signature-pad" class="signature-pad" style="width:100% !important;height: 500px;">
               <div class="signature-pad--body" >
                 <canvas id='canvas_firma'></canvas>
               </div>
               <div class="signature-pad--footer">
                 <div class="description">Inserisci la Firma</div>
               </div>
           </div>
           <script src="<%=Utility.url%>/js/firma/js/signature_pad.umd.js"></script>
           <script src="<%=Utility.url%>/js/firma/js/app.js"></script>
       <%}else{%>    
           <div class="box">
               <a class="pulsante float-left" href='<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>'><i class="fa-solid fa-arrow-left"></i></a>              
               <a class='pulsante verde' href='<%=Utility.url%>/firma.jsp?id_documento=<%=id_documento%>&campo_da_modificare=<%=campo_da_modificare%>&nuova_firma=si'>
                   <i class="fa fa-plus"></i>
                   Nuova Firma
               </a>
           </div>
           <img src="<%=firma%>" alt="firma" style="height: 500px;">
       <%}%>
       </div>
    </div>
</body>
</html>
