<%@page import="utility.PdfPreventivoEvent"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="utility.Utility"%>
<%@page import="beans.Documento"%>
<%@page import="beans.Soggetto"%>
<%@page trimDirectiveWhitespaces="true"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    if(utente==null){
        response.sendError(401);
        return;
    }

    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    Documento documento=GestioneDocumento.getIstanza().get_documento(id_documento);

    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition","inline; filename=preventivo_"+id_documento+".pdf");

    Document pdf=new Document(PageSize.A4,40,40,160,70);
    PdfWriter writer=PdfWriter.getInstance(pdf,response.getOutputStream());

    String numero=documento.getNumero()+"/"+documento.getAnno();
    String data=Utility.converti_data_formato_it(documento.getData());

    String percorsoLogo=application.getRealPath("/img/bioenergia.png");

    writer.setPageEvent(new PdfPreventivoEvent(numero,data,percorsoLogo));

    pdf.open();

    BaseColor AZZURRO=new BaseColor(0,145,190);
    BaseColor GRIGIO=new BaseColor(110,110,110);

    Font font_normale=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.DARK_GRAY);
    Font font_piccolo=new Font(Font.FontFamily.HELVETICA,7,Font.NORMAL,BaseColor.DARK_GRAY);
    Font font_bold=new Font(Font.FontFamily.HELVETICA,9,Font.BOLD,BaseColor.DARK_GRAY);
    Font font_titolo=new Font(Font.FontFamily.HELVETICA,10,Font.BOLD,GRIGIO);
    Font font_totale=new Font(Font.FontFamily.HELVETICA,16,Font.BOLD,GRIGIO);

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
<%
    pdf.close();
    return;
%>