
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    
    String nome_utente="";
    String password="";
    
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=Utility.nome_software%></title>
        <jsp:include page="_importazioni.jsp"></jsp:include>
    </head>
    <body>
        
        <div id="container">
            <%if(utente==null){%>
            
                <jsp:include page="_loader.jsp"></jsp:include>
                <div id="login">

                <div class="box">

                    <h1><img src="<%=Utility.url%>/img/bioenergia.png" style="width: 100%"></h1>
                    <h2>Accesso riservato</h2>

                    <form action="<%=Utility.url%>/utente/__login.jsp" method="post" onsubmit="mostra_loader();">
                        <div class="etichetta">Username</div>
                        <input type="text" name="nome_utente" autofocus value="<%=nome_utente%>">
                        <div class="etichetta">Password</div>
                        <input type="password" name="password" autocomplete="current-password" value="<%=password%>">
                        <button type="submit">Accedi</button>

                        <%if("si".equals(request.getParameter("errore"))){%>
                            <div id="errore">
                                Username o password non validi.
                            </div>

                        <%}%>
                    </form>
                </div>

                <div id="powered">
                    Powered by <a href="https://www.infomediatek.it" target="_blank">Infomedia</a>
                </div>

            </div>

                   

            <%}else{%>
                <jsp:include page="_menu.jsp"></jsp:include>
                <div id="content">

                </div>
            <%}%>
        </div>
    </body>
</html>
