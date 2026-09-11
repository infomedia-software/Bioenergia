<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Soggetto"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    String otp_sms=Utility.elimina_null(request.getParameter("otp_sms"));
    String mandante=Utility.elimina_null(request.getParameter("mandante"));
    int limite_tentativi_falliti=5;
    Documento documento=GestioneDocumento.getIstanza().get_documento(id_documento);
    String data_ora_scadenza=documento.getOtp_data_ora_scadenza();
    int tentativi_falliti=documento.getOtp_tentativi_falliti();
    String tipo="cliente";
    if(mandante.equals("si")){
        tentativi_falliti=documento.getOtp_tentativi_falliti_mandante();
        data_ora_scadenza=documento.getOtp_data_ora_scadenza_mandante();
        tipo="mandante";
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Verifica OTP | <%=Utility.nome_software%></title>
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
            function verifica_Otp() {
                var codice = document.getElementById("otp_codice").value;
                if (codice.trim() === "") {
                    alert("Inserire un codice di sei cifre per continuare.");
                    return false;
                }

                //if (confirm("Confermi la verifica del codice OTP?")) {
                    mostra_loader("Verifica codice OTP in corso...");
                    $.ajax({
                        type: "POST",
                        url: "<%=Utility.url%>/otp/__verifica_otp.jsp",
                        data: $("#form_verifica_otp").serialize(),
                        dataType: "html",
                        success: function(msg) {
                            if(msg!=""){
                                alert(msg);
                                nascondi_loader();
                                location.reload();
                            }else{
                                alert("OTP verificato correttamente");
                                <% if(!id_documento.equals("")){%>
                                    location.href="<%=Utility.url%>/documenti/documento.jsp?id_documento=<%=id_documento%>";
                                <%}%>
                                
                            }
                            
                        },
                        error: function() {
                            nascondi_loader();
                            alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE");
                        }
                    });
                //}

                return false;
            }
            $(function(){
                $("#otp_codice").focus();
            })
        </script>
    </head>

    <body>
        <div id="container">
        <jsp:include page="../_menu.jsp"></jsp:include>
        <div id="content">
            <div class="otp-card">
                <div class="otp-title">Verifica OTP firma <%=tipo%></div>

                <div class="otp-subtitle">
                    
                </div>

                <form method="post" onsubmit="return verifica_Otp();" id='form_verifica_otp'>
                    <label for="otp_email" class="otp-label">Inserisci il Codice OTP ricevuto al numero <%=otp_sms%></label>
                    <input type='hidden' name='id_documento' value='<%=id_documento%>'>
                    <input type='hidden' name='mandante' value='<%=mandante%>'>
                    <input type="text" id="otp_codice" name="otp_codice" class="otp-input" value="" placeholder="Inserisci qui il tuo Codice OTP di verifica" required>

                    <div class="otp-info">
                        <% if(tentativi_falliti>0){%>
                            <%=tentativi_falliti%> tentativi falliti. Hai a disposizione altri <%=limite_tentativi_falliti-tentativi_falliti%> tentativi.
                            <div class="clear"></div>
                        <%}%>
                        <% if(documento!=null){%>
                            Codice OTP valido fino al <%=Utility.converti_datetime_formato_it(data_ora_scadenza)%>
                            <% if(tentativi_falliti>=5 || (data_ora_scadenza!=null && Utility.viene_prima(data_ora_scadenza, Utility.data_ora_corrente())) ){%>
                                <div class="height-10"></div>
                                <a class="pulsante arancio" href="<%=Utility.url%>/otp/genera_otp.jsp?id_documento=<%=id_documento%>">GENERA NUOVO OTP</a>
                                <div class="clear"></div>
                            <%}%>
                        <%}%>
                    </div>

                    <div class="otp-actions">
                        <% if(tentativi_falliti<limite_tentativi_falliti){%>
                        <button type="submit" class="pulsante marginauto color_green">
                            <i class="fa-solid fa-file-invoice"></i>VERIFICA OTP
                        </button>
                        <%}%>
                    </div>
                </form>
            </div>
            </div>
        </div>
    </body>
</html>