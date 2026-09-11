<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Soggetto"%>
<%@page import="beans.Documento"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String id_documento=Utility.elimina_null(request.getParameter("id_documento")); 
    String mandante=Utility.elimina_null(request.getParameter("mandante")); 
    Documento documento=GestioneDocumento.getIstanza().get_documento(id_documento);
    String tel=documento.getCliente_cellulare();
%>  
     
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Genera OTP | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>

        <style>
            .otp-card {
                max-width: 520px;
                margin: 30px auto;
                padding: 25px;
                background: #ffffff;
                border-radius: 12px;
                box-shadow: 0 4px 18px rgba(0,0,0,0.08);
            }

            .otp-title {
                margin-bottom: 10px;
                font-size: 24px;
                font-weight: 600;
                text-align: center;
            }

            .otp-subtitle {
                margin-bottom: 25px;
                color: #666;
                font-size: 14px;
                text-align: center;
                line-height: 1.5;
            }

            .otp-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
            }

            .otp-input {
                width: 100%;
                padding: 12px 14px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 16px;
                box-sizing: border-box;
            }

            .otp-input:focus {
                outline: none;
                border-color: #2b7cff;
                box-shadow: 0 0 0 3px rgba(43,124,255,0.15);
            }

            .otp-actions {
                margin-top: 25px;
                text-align: center;
            }

            .otp-info {
                margin-top: 18px;
                padding: 12px;
                background: #f7f9fc;
                border-left: 4px solid #2b7cff;
                font-size: 13px;
                color: #555;
                line-height: 1.5;
            }
        </style>

        <script>
            function confermaInvioOtp() {
                var tel = document.getElementById("otp_sms").value;
                if (tel.trim() === "") {
                    alert("Inserire un numero di cellulare valido.");
                    return false;
                }

                if (confirm("Confermi l'invio del codice OTP al numero \n" + tel + "?")) {
                    mostra_loader("Invio SMS con OTP in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/otp/__genera_otp.jsp",
                        data: $("#form_genera_otp").serialize(),
                        dataType: "html",
                        success: function(msg) {
                            if(msg!=""){
                                alert(msg);
                                nascondi_loader();
                            }else{
                                alert("OTP inviato correttamente");
                                location.href="<%=Utility.url%>/otp/verifica_otp.jsp?"+$("#form_genera_otp").serialize();
                            }
                            
                        },
                        error: function() {
                            nascondi_loader();
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                        }
                    });
                }

                return false;
            }
        </script>
    </head>

    <body>
        <div id="container">
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="content">
                <a class="pulsante" href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>">
                    <i class="fa-solid fa-arrow-left"></i>Torna alla Contratto
                </a>
                <div class="otp-card">
                    <div class="otp-title">Genera OTP firma <% if(mandante.equals("")){%>cliente<%}else{%>mandante<%}%></div>

                    <div class="otp-subtitle">
                        Verrà inviato un codice OTP al numero di cellulare del <% if(mandante.equals("")){%>cliente<%}else{%>mandante<%}%>.<br>
                    </div>

                    <form method="post" onsubmit="return confermaInvioOtp();" id='form_genera_otp'>
                        <label for="otp_email" class="otp-label">Numero di Cellulare destinatario OTP</label>
                        <input type='hidden' name='id_documento' value='<%=id_documento%>'>
                        <input type="hidden" name="mandante" value="<%=mandante%>">
                        <input type="text" id="otp_sms" name="otp_sms" class="otp-input" value="<%=tel%>" placeholder="" required>

                        <div class="otp-info">
                            Il codice OTP sarà utilizzato per confermare la firma del documento.<br>
                            <i>Inserire il numero di cellulare senza il prefisso internazionale +39, che verrà aggiunto automaticamente.</i>
                        </div>

                        <div class="otp-actions">
                            <button type="submit" class="pulsante arancio float-left">
                                <i class="fa-solid fa-mobile-screen-button"></i>
                                INVIA OTP
                            </button>
                            <!-- codice presente e non scaduto -> posso verificarlo -->
                            <% if(mandante.equals("")){%>
                                <% if(!documento.getOtp_hash().equals("") && documento.getOtp_data_ora_scadenza()!=null && Utility.viene_prima(Utility.data_ora_corrente(), documento.getOtp_data_ora_scadenza()) ){%>
                                    <div class="height10"></div>
                                    <a class="pulsante verde float-right" href="<%=Utility.url%>/otp/verifica_otp.jsp?id_documento=<%=id_documento%>">VERIFICA OTP</a>
                                <%}%>
                            <%}%>
                            
                            <% if(!mandante.equals("")){%>
                                <% if(!documento.getOtp_hash_mandante().equals("") && documento.getOtp_data_ora_scadenza_mandante()!=null && Utility.viene_prima(Utility.data_ora_corrente(), documento.getOtp_data_ora_scadenza_mandante()) ){%>
                                    <div class="height10"></div>
                                    <a class="pulsante verde float-right" href="<%=Utility.url%>/otp/verifica_otp.jsp?id_documento=<%=id_documento%>">VERIFICA OTP</a>
                                <%}%>
                            <%}%>
                            <div class="clear"></div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
