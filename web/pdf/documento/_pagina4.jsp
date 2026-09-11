<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.Image"%>
<%@page import="com.itextpdf.text.PageSize"%>

<%
    Document pdf=(Document)request.getAttribute("pdf");

    Image pagina4=Image.getInstance(application.getRealPath("/img/condizioni_generali2.png"));
    pagina4.scaleAbsolute(PageSize.A4.getWidth(),PageSize.A4.getHeight());
    pagina4.setAbsolutePosition(0,0);
    pdf.add(pagina4);
%>