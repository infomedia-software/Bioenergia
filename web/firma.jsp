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
<html lang="it">

<head>

    <meta charset="utf-8">

    <title>Firma <%=d.toString()%> | <%=Utility.nome_software%></title>

    <meta name="description" content="">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=no,viewport-fit=cover">

    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">

    <link rel="stylesheet" href="<%=Utility.url%>/js/firma/css/signature-pad.css">

    <jsp:include page="_importazioni.jsp"></jsp:include>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <style>

        #firma_container{
            width:100%;
            max-width:100%;
            margin-top:15px;
        }

        #signature-pad{
            width:100%;
            height:500px;
            background:#fff;
            border:1px solid #ccc;
            border-radius:6px;
            overflow:hidden;
            position:relative;
        }

        .signature-pad--body{
            width:100%;
            height:450px;
            position:relative;
        }

        #canvas_firma{
            width:100%;
            height:100%;
            display:block;
            background:#fff;

            /*
            IMPORTANTISSIMO PER IPAD / IPHONE:
            impedisce a Safari di interpretare la firma
            come scroll, zoom o trascinamento pagina
            */
            touch-action:none;
            -ms-touch-action:none;
        }

        .signature-pad--footer{
            height:50px;
            display:flex;
            align-items:center;
            justify-content:center;
            background:#f5f5f5;
            border-top:1px solid #ddd;
        }

        .signature-pad--footer .description{
            font-size:14px;
            color:#666;
        }

        .firma_salvata{
            display:block;
            max-width:100%;
            max-height:500px;
            margin:20px auto;
            object-fit:contain;
        }

        @media(max-width:768px){

            #signature-pad{
                height:400px;
            }

            .signature-pad--body{
                height:350px;
            }

        }

        @media(max-width:500px){

            #signature-pad{
                height:350px;
            }

            .signature-pad--body{
                height:300px;
            }

        }

    </style>

</head>

<body onselectstart="return false">

    <div id="container">

        <jsp:include page="_menu.jsp"></jsp:include>

        <div id="content">

            <h1>
                <%=campo_da_modificare.replace("_"," ").toUpperCase()%> - <%=d.toString()%>
            </h1>

            <%if(firma==null || firma.equals("") || nuova_firma.equals("si")){%>

                <div class="box">

                    <a class="pulsante float-left" href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>">
                        <i class="fa-solid fa-arrow-left"></i>
                    </a>

                    <button type="button" class="pulsante verde" onclick="salvaFirma()">
                        <i class="fa fa-save"></i>
                        Salva
                    </button>

                    <button type="button" class="pulsante rosso" onclick="pulisciFirma()">
                        <i class="fa fa-trash"></i>
                        Pulisci
                    </button>

                </div>

                <div id="firma_container">

                    <div id="signature-pad" class="signature-pad">

                        <div class="signature-pad--body">
                            <canvas id="canvas_firma"></canvas>
                        </div>

                        <div class="signature-pad--footer">
                            <div class="description">
                                Firma all'interno del riquadro
                            </div>
                        </div>

                    </div>

                </div>

                <script src="<%=Utility.url%>/js/firma/js/signature_pad.umd.js"></script>

                <script type="text/javascript">

                    var canvas=null;
                    var signaturePad=null;
                    var resizeTimeout=null;

                    /*
                     * INIZIALIZZAZIONE FIRMA
                     */
                    $(document).ready(function(){

                        canvas=document.getElementById("canvas_firma");

                        if(!canvas){
                            console.log("Canvas firma non trovato");
                            return;
                        }

                        signaturePad=new SignaturePad(canvas,{
                            backgroundColor:"rgb(255,255,255)",
                            penColor:"rgb(0,0,0)",
                            minWidth:0.8,
                            maxWidth:2.5,
                            throttle:16
                        });

                        ridimensionaCanvas(false);

                        /*
                         * Utile soprattutto su iPad quando viene
                         * ruotato da verticale a orizzontale
                         */
                        window.addEventListener("orientationchange",function(){

                            clearTimeout(resizeTimeout);

                            resizeTimeout=setTimeout(function(){
                                ridimensionaCanvas(true);
                            },400);

                        });

                        /*
                         * Safari può modificare le dimensioni del viewport
                         * anche senza un orientationchange esplicito
                         */
                        window.addEventListener("resize",function(){

                            clearTimeout(resizeTimeout);

                            resizeTimeout=setTimeout(function(){
                                ridimensionaCanvas(true);
                            },250);

                        });

                    });


                    /*
                     * RIDIMENSIONA CANVAS MANTENENDO LA QUALITA'
                     * SU IPAD / RETINA DISPLAY
                     */
                    function ridimensionaCanvas(mantieniFirma){

                        if(canvas==null || signaturePad==null)
                            return;

                        var data=null;

                        /*
                         * Salviamo temporaneamente la firma
                         * per non perderla durante la rotazione
                         */
                        if(mantieniFirma && !signaturePad.isEmpty())
                            data=signaturePad.toData();

                        var ratio=Math.max(window.devicePixelRatio || 1,1);

                        var larghezza=canvas.offsetWidth;
                        var altezza=canvas.offsetHeight;

                        if(larghezza<=0 || altezza<=0)
                            return;

                        canvas.width=larghezza*ratio;
                        canvas.height=altezza*ratio;

                        var context=canvas.getContext("2d");

                        context.setTransform(1,0,0,1,0,0);
                        context.scale(ratio,ratio);

                        signaturePad.clear();

                        /*
                         * Ripristiniamo la firma dopo resize/orientamento
                         */
                        if(data!=null)
                            signaturePad.fromData(data);

                    }


                    /*
                     * CANCELLA FIRMA
                     */
                    function pulisciFirma(){

                        if(signaturePad!=null)
                            signaturePad.clear();

                    }


                    /*
                     * SALVA FIRMA
                     */
                    function salvaFirma(){

                        if(signaturePad==null){
                            alert("Errore inizializzazione firma");
                            return;
                        }

                        if(signaturePad.isEmpty()){
                            alert("Inserire la firma");
                            return;
                        }

                        mostra_loader("Salvataggio firma in corso...");

                        /*
                         * PNG compatibile con iPad / Safari
                         */
                        var dataURL=signaturePad.toDataURL("image/png");

                        function_modifica_documento(
                            '<%=id_documento%>',
                            '<%=campo_da_modificare%>',
                            dataURL,
                            'si'
                        );

                    }


                    function aggiorna_documento(){

                        location.href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>";

                    }

                </script>

            <%}else{%>

                <div class="box">

                    <a class="pulsante float-left" href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>">
                        <i class="fa-solid fa-arrow-left"></i>
                    </a>

                    <a class="pulsante verde" href="<%=Utility.url%>/firma.jsp?id_documento=<%=id_documento%>&campo_da_modificare=<%=campo_da_modificare%>&nuova_firma=si">
                        <i class="fa fa-plus"></i>
                        Nuova Firma
                    </a>

                </div>

                <img src="<%=firma%>" alt="Firma" class="firma_salvata">

            <%}%>

        </div>

    </div>

</body>

</html>