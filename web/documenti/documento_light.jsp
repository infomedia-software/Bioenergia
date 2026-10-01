<%@page import="beans.Item"%>
<%@page import="gestioneDB.GestioneItems"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Pagamento"%>
<%@page import="gestioneDB.GestionePagamento"%>
<%@page import="beans.Riga"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    Documento d=GestioneDocumento.getIstanza().get_documento(id_documento);
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%=d.toString()%> | <%=Utility.nome_software%></title>
        <jsp:include page="../_importazioni.jsp"></jsp:include>
        
    </head>
    <body>
        
        <div id="container">
            <jsp:include page="../_menu.jsp"></jsp:include>
            <div id="content">
            <h1><%=d.toString()%></h1>
            <div class="box">
                <a class="pulsante" href="<%=Utility.url%>/documenti/index.jsp?tipo=<%=d.getTipo()%>">
                    <i class="fa-solid fa-arrow-left"></i>Torna alla Lista
                </a>
               
                <button class="pulsante grigio float-right" onclick="window.open('<%=Utility.url%>/pdf/documento/pdf_documento.jsp?id_documento=<%=id_documento%>')" >
                    <i class="fa-solid fa-print"></i>PDF
                </button>
            </div>
                <div class="col_100">
                    <table>
                        <tr>
                            <td style="vertical-align: top;">
                                <label>IBAN</label><br>
                                <input type="text" value="<%=d.getIban()%>" id="iban" onchange="modifica_documento(this)">
                            </td>
                            <td>
                                <label>Note Interne</label><br>
                                <textarea id="note1" onchange="modifica_documento(this)" class="no_controllo"><%=Utility.elimina_null(Utility.standardizza_testo_textarea(d.getNote1()))%></textarea>
                            </td>
                        </tr>
                    </table>
                </div>
                    
                <!-- ALLEGATI -->
                <div class="box">
                    <h2>Allegati</h2>
                    <%String queryallegati=" allegati.rif='DOCUMENTO' AND allegati.idrif="+Utility.is_null(id_documento)+" AND allegati.stato='1' ORDER BY allegati.id DESC";%>
                    <jsp:include page="../_allegati.jsp">
                        <jsp:param name="query" value="<%=queryallegati%>"></jsp:param>
                        <jsp:param name="id_rif" value="<%=id_documento%>"></jsp:param>
                        <jsp:param name="rif" value="DOCUMENTO"></jsp:param>
                    </jsp:include>

                    <div class="height-10"></div>
                    <jsp:include page="../_nuovo_allegato.jsp">
                        <jsp:param name="idrif" value="<%=id_documento%>"></jsp:param>
                        <jsp:param name="rif" value="DOCUMENTO"></jsp:param>
                    </jsp:include>
                </div>        
            </div>
        </div>          
    </body>
</html>
