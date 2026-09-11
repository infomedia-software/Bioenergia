<%@page import="com.itextpdf.text.Font"%>
<%@page import="com.itextpdf.text.PageSize"%>
<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Documento"%>
<%@page import="beans.Soggetto"%>

<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    Documento documento=GestioneDocumento.getIstanza().get_documento(id_documento);
    

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition","inline; filename=contratto_"+id_documento+".pdf");

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
    request.setAttribute("id_documento",id_documento);
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

<%pdf.newPage();%>

<jsp:include page="_pagina4.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina5.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina6.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina7.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina8.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina9.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina10.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina11.jsp"/>

<%pdf.newPage();%>

<jsp:include page="_pagina12.jsp"/>
<%
    pdf.close();
    writer.close();
    return;
%>