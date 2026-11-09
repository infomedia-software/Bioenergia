<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="com.itextpdf.text.Font"%>
<%@page import="com.itextpdf.text.PageSize"%>
<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="gestioneDB.GestioneFinanziamento"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Finanziamento"%>
<%@page import="beans.Soggetto"%>
<%@page contentType="application/pdf" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String id_finanziamento=Utility.elimina_null(request.getParameter("id_finanziamento"));
    Finanziamento finanziamento=GestioneFinanziamento.getIstanza().get_finanziamento(id_finanziamento);
    Documento documento=GestioneDocumento.getIstanza().get_documento(finanziamento.getId_documento());
    if(finanziamento==null){
        response.sendError(404,"Finanziamento non trovato");
        return;
    }

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition","inline; filename=finanziamento_"+finanziamento.getNumero()+".pdf");

    Document pdf=new Document(PageSize.A4,30,30,25,25);
    PdfWriter writer=PdfWriter.getInstance(pdf,response.getOutputStream());

    pdf.open();

    BaseColor AZZURRO=new BaseColor(0,145,190);
    BaseColor GRIGIO=new BaseColor(110,110,110);

    Font font_normale=new Font(Font.FontFamily.HELVETICA,7,Font.NORMAL,BaseColor.DARK_GRAY);
    Font font_piccolo=new Font(Font.FontFamily.HELVETICA,6,Font.NORMAL,BaseColor.DARK_GRAY);
    Font font_bold=new Font(Font.FontFamily.HELVETICA,7,Font.BOLD,BaseColor.DARK_GRAY);
    Font font_titolo=new Font(Font.FontFamily.HELVETICA,8,Font.BOLD,AZZURRO);
    Font font_totale=new Font(Font.FontFamily.HELVETICA,8,Font.BOLD,BaseColor.DARK_GRAY);

    request.setAttribute("utente",utente);
    request.setAttribute("id_finanziamento",id_finanziamento);
    request.setAttribute("finanziamento",finanziamento);
    request.setAttribute("documento",documento);
    request.setAttribute("pdf",pdf);
    request.setAttribute("writer",writer);
    request.setAttribute("AZZURRO",AZZURRO);
    request.setAttribute("GRIGIO",GRIGIO);
    request.setAttribute("font_normale",font_normale);
    request.setAttribute("font_piccolo",font_piccolo);
    request.setAttribute("font_bold",font_bold);
    request.setAttribute("font_titolo",font_titolo);
    request.setAttribute("font_totale",font_totale);
%>

    <jsp:include page="_pagina1.jsp"/>

    <%pdf.newPage();%>

    <jsp:include page="_pagina2.jsp"/>

    <%pdf.newPage();%>

    <jsp:include page="_pagina3.jsp"/>

<%pdf.close();%>
