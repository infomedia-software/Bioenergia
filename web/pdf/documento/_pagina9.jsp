<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>

<%
    Document document=(Document)request.getAttribute("pdf");
    Documento d=(Documento)request.getAttribute("documento");

    // =========================================================================
    // PAGINA 9 - STRUTTURA COPERTURA
    // =========================================================================

    document.newPage();

    Font font_normale_p9=new Font(Font.FontFamily.HELVETICA,8,Font.NORMAL,BaseColor.DARK_GRAY);
    Font font_bold_p9=new Font(Font.FontFamily.HELVETICA,8,Font.BOLD,BaseColor.DARK_GRAY);
    Font font_x_p9=new Font(Font.FontFamily.HELVETICA,10,Font.BOLD,BaseColor.BLACK);

    String path_pagina9=application.getRealPath("/img/");

    // =========================================================================
    // HEADER
    // =========================================================================

    try{
        Image header9=Image.getInstance(path_pagina9+"header_pagina7_8.png");

        float larghezza=document.getPageSize().getWidth();
        float altezza=header9.getHeight()*(larghezza/header9.getWidth());

        header9.scaleAbsolute(larghezza,altezza);
        header9.setAbsolutePosition(
            0,
            document.getPageSize().getHeight()-header9.getScaledHeight()
        );

        document.add(header9);

    }catch(Exception e){
        e.printStackTrace();
    }

    // =========================================================================
    // FOOTER
    // =========================================================================

    try{
        Image footer9=Image.getInstance(path_pagina9+"footer_pagina7_8.png");

        float larghezza=document.getPageSize().getWidth();
        float altezza=footer9.getHeight()*(larghezza/footer9.getWidth());

        footer9.scaleAbsolute(larghezza,altezza);
        footer9.setAbsolutePosition(0,0);

        document.add(footer9);

    }catch(Exception e){
        e.printStackTrace();
    }

    // =========================================================================
    // DATI
    // =========================================================================

    String copertura_struttura=Utility.elimina_null(d.getCopertura_struttura());
    String copertura_struttura_altro=Utility.elimina_null(d.getCopertura_struttura_altro());

    // =========================================================================
    // SPAZIO DA HEADER
    // =========================================================================

    Paragraph spazio=new Paragraph(" ");
    spazio.setSpacingBefore(70);
    spazio.setSpacingAfter(0);
    document.add(spazio);

    // =========================================================================
    // STRUTTURA COPERTURA
    // =========================================================================

    PdfPTable struttura=new PdfPTable(new float[]{32,6,62});
    struttura.setWidthPercentage(100);
    struttura.setSpacingBefore(5);
    struttura.setHorizontalAlignment(Element.ALIGN_LEFT);

    PdfPCell cella;

    // -------------------------------------------------------------------------
    // OTTIMO
    // -------------------------------------------------------------------------

    cella=new PdfPCell(new Phrase("STRUTTURA COPERTURA :",font_bold_p9));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingTop(3);
    cella.setPaddingBottom(9);
    struttura.addCell(cella);

    cella=new PdfPCell(
        new Phrase(
            copertura_struttura.equals("ottimo") ? "X" : "",
            copertura_struttura.equals("ottimo") ? font_x_p9 : font_bold_p9
        )
    );
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingBottom(9);
    struttura.addCell(cella);

    cella=new PdfPCell(new Phrase("OTTIMO",font_normale_p9));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingTop(3);
    cella.setPaddingBottom(9);
    struttura.addCell(cella);

    // -------------------------------------------------------------------------
    // BUONO
    // -------------------------------------------------------------------------

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    struttura.addCell(cella);

    cella=new PdfPCell(
        new Phrase(
            copertura_struttura.equals("buono") ? "X" : "",
            copertura_struttura.equals("buono") ? font_x_p9 : font_bold_p9
        )
    );
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingBottom(9);
    struttura.addCell(cella);

    cella=new PdfPCell(new Phrase("BUONO",font_normale_p9));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingTop(3);
    cella.setPaddingBottom(9);
    struttura.addCell(cella);

    // -------------------------------------------------------------------------
    // PESSIMO
    // -------------------------------------------------------------------------

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    struttura.addCell(cella);

    cella=new PdfPCell(
        new Phrase(
            copertura_struttura.equals("pessimo") ? "X" : "",
            copertura_struttura.equals("pessimo") ? font_x_p9 : font_bold_p9
        )
    );
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingBottom(9);
    struttura.addCell(cella);

    cella=new PdfPCell(new Phrase("PESSIMO",font_normale_p9));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingTop(3);
    cella.setPaddingBottom(9);
    struttura.addCell(cella);

    // -------------------------------------------------------------------------
    // ALTRO
    // -------------------------------------------------------------------------

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    struttura.addCell(cella);

    cella=new PdfPCell(
        new Phrase(
            copertura_struttura.equals("altro") ? "X" : "",
            copertura_struttura.equals("altro") ? font_x_p9 : font_bold_p9
        )
    );
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    struttura.addCell(cella);

    String valore_altro_struttura=copertura_struttura.equals("altro") ? copertura_struttura_altro : "";

    cella=new PdfPCell(new Phrase("ALTRO   "+valore_altro_struttura,font_normale_p9));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setBorderWidthBottom(0.5f);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cella.setPaddingTop(3);
    cella.setPaddingBottom(3);
    struttura.addCell(cella);

    document.add(struttura);
%>