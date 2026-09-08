<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="<%=Utility.url%>/css/stile.css?v=1.0.2">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/10.32.0/js/vendor/jquery.ui.widget.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/blueimp-file-upload/10.32.0/js/jquery.fileupload.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<link rel="icon" type="image/png" href="<%=Utility.url%>/img/bioenergia.png">


<script type="text/javascript">
   
   
    $("#toggleMenu").on("click", function() {
            $("#menu").toggleClass("open");
    });
   
    function carica_pagina_div(url_pagina,id_box){
        mostra_loader();
        $("#"+id_box).load(url_pagina,function(){nascondi_loader();});
    }
    
    
    
    
    function mostra_loader(testo){
        $("#loader_testo").html(testo && testo!="" ? testo : "Caricamento...");
        $("#loader").stop(true, true).css("display","flex").hide().fadeIn(120);
    }

    function nascondi_loader(){
        $("#loader").stop(true, true).fadeOut(120);
    }
    
    function logout(){
        mostra_loader("Logout in corso...");
        $.ajax({
            type: "POST",
            url: "<%=Utility.url%>/utenti/__logout.jsp",
            data: "",
            dataType: "html",
            success: function(msg){
                location.href='<%=Utility.url%>'
            },
            error: function(){
                alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
            }
        });
    }
   
    function mostra_popup(url, titolo){

     if(typeof titolo === "undefined")
         titolo = "";

     $("#popup_titolo").html(titolo);

     $.get(url)
         .done(function(html){
             $("#popup_contenuto").html(html);
             $("#popup").fadeIn(120);
         })
         .fail(function(){
             $("#popup_contenuto").html("<div class='messaggio'>Errore durante il caricamento.</div>");
             $("#popup").fadeIn(120);
         });
 }

    function nascondi_popup(){
        $("#popup").hide();
        $("#popup_titolo").html("");
        $("#popup_contenuto").html("");
    }
   
   function toggle_menu(){
        document.body.classList.toggle("menu_aperto");
    }

    function chiudi_menu(){
        document.body.classList.remove("menu_aperto");
    }

    $(document).keyup(function(e){
        if(e.keyCode==27)
            chiudi_menu();
    });

    $(window).resize(function(){
        if($(window).width()>1100)
            chiudi_menu();
    });
   
</script>