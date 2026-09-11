<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.Image"%>
<%@page import="com.itextpdf.text.PageSize"%>

<%
    Document pdf=(Document)request.getAttribute("pdf");

    Image pagina3=Image.getInstance(application.getRealPath("/img/condizioni_generali1.png"));
    pagina3.scaleAbsolute(PageSize.A4.getWidth(),PageSize.A4.getHeight());
    pagina3.setAbsolutePosition(0,0);
    pdf.add(pagina3);
%>