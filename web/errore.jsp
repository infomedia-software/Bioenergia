<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="/_importazioni.jsp"%>

<%
    String errore = Utility.elimina_null(request.getParameter("errore"));
    if(errore.equals(""))
        errore = "Si è verificato un errore durante l'elaborazione della richiesta.";
%>

<!DOCTYPE html>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Errore</title>
    </head>

    <body>

        <div id="container">

            <%@include file="/_menu.jsp"%>

            <div id="content">

                <h1>                   
                    Errore
                </h1>

                <div class="box">

                    <div class="messaggio errore">
                        <%=errore%>
                    </div>

                    <br>

                    <button type="button" onclick="history.back();">
                        <i class="fa-solid fa-arrow-left"></i>
                        Torna indietro
                    </button>

                </div>

            </div>

        </div>

    </body>
</html>