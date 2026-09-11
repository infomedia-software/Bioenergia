<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="java.util.Base64"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>

<%
    Document document=(Document)request.getAttribute("pdf");
    Documento d=(Documento)request.getAttribute("documento");

    // =========================================================================
    // PAGINA 7 - MODULO STRATIFICAZIONE MANTO DI COPERTURA
    // =========================================================================

    document.newPage();

    BaseColor AZZURRO=new BaseColor(0,145,190);

    Font font_normale_p7=new Font(Font.FontFamily.HELVETICA,8,Font.NORMAL,BaseColor.DARK_GRAY);
    Font font_bold_p7=new Font(Font.FontFamily.HELVETICA,9,Font.BOLD,BaseColor.DARK_GRAY);
    Font font_titolo_p7=new Font(Font.FontFamily.HELVETICA,11,Font.BOLD,BaseColor.BLACK);

    String path_pagina7=application.getRealPath("/img/");

    // =========================================================================
    // HEADER
    // =========================================================================

    try{
        Image header7=Image.getInstance(path_pagina7+"header_pagina7_8.png");
        header7.scaleAbsolute(document.getPageSize().getWidth(),header7.getHeight()*(document.getPageSize().getWidth()/header7.getWidth()));
        header7.setAbsolutePosition(0,document.getPageSize().getHeight()-header7.getScaledHeight());
        document.add(header7);
    }catch(Exception e){
        e.printStackTrace();
    }

    // =========================================================================
    // FOOTER
    // =========================================================================

    try{
        Image footer7=Image.getInstance(path_pagina7+"footer_pagina7_8.png");
        footer7.scaleAbsolute(document.getPageSize().getWidth(),footer7.getHeight()*(document.getPageSize().getWidth()/footer7.getWidth()));
        footer7.setAbsolutePosition(0,0);
        document.add(footer7);
    }catch(Exception e){
        e.printStackTrace();
    }

    Paragraph p;
    PdfPCell cella;

    // =========================================================================
    // TITOLO
    // =========================================================================

    p=new Paragraph("MODULO STRATIFICAZIONE MANTO DI COPERTURA",font_titolo_p7);
    p.setSpacingBefore(15);
    p.setSpacingAfter(15);
    document.add(p);

    // =========================================================================
    // TIPOLOGIA ABITAZIONE
    // =========================================================================

    String abitazione_tipologia=Utility.elimina_null(d.getAbitazione_tipologia());
    String abitazione_tipologia_altro=Utility.elimina_null(d.getAbitazione_tipologia_altro());

    PdfPTable abitazione=new PdfPTable(new float[]{30,5,65});
    abitazione.setWidthPercentage(100);
    abitazione.setSpacingAfter(7);

    cella=new PdfPCell(new Phrase("TIPOLOGIA ABITAZIONE",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
    abitazione.addCell(cella);

    cella=new PdfPCell(new Phrase(abitazione_tipologia.equals("piano terra") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    abitazione.addCell(cella);

    cella=new PdfPCell(new Phrase("PIANO TERRA",font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setPaddingBottom(4);
    abitazione.addCell(cella);

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    abitazione.addCell(cella);

    cella=new PdfPCell(new Phrase(abitazione_tipologia.equals("2 piani") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    abitazione.addCell(cella);

    cella=new PdfPCell(new Phrase("2 PIANI",font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setPaddingBottom(4);
    abitazione.addCell(cella);

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    abitazione.addCell(cella);

    cella=new PdfPCell(new Phrase(abitazione_tipologia.equals("3 piani") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    abitazione.addCell(cella);

    cella=new PdfPCell(new Phrase("3 PIANI",font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setPaddingBottom(4);
    abitazione.addCell(cella);

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    abitazione.addCell(cella);

    cella=new PdfPCell(new Phrase(abitazione_tipologia.equals("altro") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    abitazione.addCell(cella);

    String valore_altro_abitazione=abitazione_tipologia.equals("altro") ? abitazione_tipologia_altro : "";

    cella=new PdfPCell(new Phrase("ALTRO   "+valore_altro_abitazione,font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setBorderWidthBottom(0.5f);
    cella.setPaddingBottom(3);
    abitazione.addCell(cella);

    document.add(abitazione);

    // =========================================================================
    // ALTEZZA GRONDAIA
    // =========================================================================

    PdfPTable grondaia=new PdfPTable(new float[]{30,5,65});
    grondaia.setWidthPercentage(100);
    grondaia.setSpacingAfter(8);

    cella=new PdfPCell(new Phrase("ALTEZZA DA TERRA DELLA GRONDAIA",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    grondaia.addCell(cella);
    
    
    cella=new PdfPCell(new Phrase("",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    grondaia.addCell(cella);

    String altezza_grondaia=Utility.elimina_zero(d.getAltezza_grondaia());

    cella=new PdfPCell(new Phrase(altezza_grondaia,font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setBorderWidthBottom(0.5f);
    cella.setPaddingBottom(3);
    grondaia.addCell(cella);

    document.add(grondaia);

    // =========================================================================
    // TIPOLOGIA COPERTURA
    // =========================================================================

    String copertura_tipologia=Utility.elimina_null(d.getCopertura_tipologia());

    PdfPTable copertura=new PdfPTable(new float[]{30,5,30,35});
    copertura.setWidthPercentage(100);
    copertura.setSpacingAfter(7);

    String[][] tipologie_copertura={
        {"tegola bassa","TEGOLA BASSA","tegola-bassa.jpg"},
        {"tegola portoghese","TEGOLA PORTOGHESE","tegola-portoghese.jpg"},
        {"coppi","COPPI","coppi.jpg"},
        {"lamiera","LAMIERA","lamiera.jpg"}
    };

    for(int i=0;i<tipologie_copertura.length;i++){

        if(i==0){
            cella=new PdfPCell(new Phrase("TIPOLOGIA COPERTURA",font_bold_p7));
        }else{
            cella=new PdfPCell();
        }

        cella.setBorder(Rectangle.NO_BORDER);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
        copertura.addCell(cella);

        cella=new PdfPCell(new Phrase(copertura_tipologia.equals(tipologie_copertura[i][0]) ? "X" : "",font_bold_p7));
        cella.setBorder(Rectangle.NO_BORDER);
        cella.setHorizontalAlignment(Element.ALIGN_CENTER);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
        copertura.addCell(cella);

        cella=new PdfPCell(new Phrase(tipologie_copertura[i][1],font_normale_p7));
        cella.setBorder(Rectangle.NO_BORDER);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
        copertura.addCell(cella);

        try{
            Image img=Image.getInstance(path_pagina7+tipologie_copertura[i][2]);
            img.scaleToFit(75,42);

            cella=new PdfPCell(img,false);
            cella.setBorder(Rectangle.NO_BORDER);
            cella.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cella.setPaddingTop(2);
            cella.setPaddingBottom(2);
        }catch(Exception e){
            cella=new PdfPCell();
            cella.setBorder(Rectangle.NO_BORDER);
        }

        copertura.addCell(cella);
    }

    document.add(copertura);

    // =========================================================================
    // GUAINA + COIBENTAZIONE
    // =========================================================================

    String copertura_guaina=Utility.elimina_null(d.getCopertura_guaina());
    String copertura_coibentazione=Utility.elimina_null(d.getCopertura_coibentazione());

    PdfPTable caratteristiche=new PdfPTable(new float[]{10,5,5,5,5,5,35,5,10,5,10});
    caratteristiche.setWidthPercentage(100);
    caratteristiche.setSpacingAfter(8);

    cella=new PdfPCell(new Phrase("GUAINA",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase(copertura_guaina.equals("si") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase("SI",font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase(copertura_guaina.equals("no") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase("NO",font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase("COIBENTAZIONE COPERTURA",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase(copertura_coibentazione.equals("si") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase("SI",font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase(copertura_coibentazione.equals("no") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    caratteristiche.addCell(cella);

    cella=new PdfPCell(new Phrase("NO",font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    caratteristiche.addCell(cella);

    document.add(caratteristiche);

    // =========================================================================
    // MATERIALE COPERTURA
    // =========================================================================

    String copertura_materiale=Utility.elimina_null(d.getCopertura_materiale());
    String copertura_materiale_altro=Utility.elimina_null(d.getCopertura_materiale_altro());

    PdfPTable materiale=new PdfPTable(new float[]{30,5,35,30});
    materiale.setWidthPercentage(100);
    materiale.setSpacingAfter(5);

    String[][] materiali={
        {"legno","LEGNO","legno.jpg"},
        {"legno ventilato","LEGNO VENTILATO","legno-ventilato.jpg"},
        {"legno con tavelline","LEGNO CON TAVELLINE","legno-con-tavelline.jpg"},
        {"cls","CLS","cls.jpg"},
        {"tavelloni + cls","TAVELLONI + CLS","tavelloni-cls.jpg"},
        {"tavelloni","TAVELLONI","tavelloni.jpg"}
    };

    for(int i=0;i<materiali.length;i++){

        if(i==0){
            cella=new PdfPCell(new Phrase("MATERIALE COPERTURA",font_bold_p7));
        }else{
            cella=new PdfPCell();
        }

        cella.setBorder(Rectangle.NO_BORDER);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
        materiale.addCell(cella);

        cella=new PdfPCell(new Phrase(copertura_materiale.equals(materiali[i][0]) ? "X" : "",font_bold_p7));
        cella.setBorder(Rectangle.NO_BORDER);
        cella.setHorizontalAlignment(Element.ALIGN_CENTER);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
        materiale.addCell(cella);

        cella=new PdfPCell(new Phrase(materiali[i][1],font_normale_p7));
        cella.setBorder(Rectangle.NO_BORDER);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
        materiale.addCell(cella);

        try{
            Image img=Image.getInstance(path_pagina7+materiali[i][2]);
            img.scaleToFit(105,48);

            cella=new PdfPCell(img,false);
            cella.setBorder(Rectangle.NO_BORDER);
            cella.setHorizontalAlignment(Element.ALIGN_RIGHT);
            cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
            cella.setPaddingTop(2);
            cella.setPaddingBottom(2);
        }catch(Exception e){
            cella=new PdfPCell();
            cella.setBorder(Rectangle.NO_BORDER);
        }

        materiale.addCell(cella);
    }

    // ALTRO

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    materiale.addCell(cella);

    cella=new PdfPCell(new Phrase(copertura_materiale.equals("altro") ? "X" : "",font_bold_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setHorizontalAlignment(Element.ALIGN_CENTER);
    materiale.addCell(cella);

    String valore_altro_materiale=copertura_materiale.equals("altro") ? copertura_materiale_altro : "";

    cella=new PdfPCell(new Phrase("ALTRO   "+valore_altro_materiale,font_normale_p7));
    cella.setBorder(Rectangle.NO_BORDER);
    cella.setBorderWidthBottom(0.5f);
    cella.setPaddingBottom(3);
    materiale.addCell(cella);

    cella=new PdfPCell();
    cella.setBorder(Rectangle.NO_BORDER);
    materiale.addCell(cella);

    document.add(materiale);

    
%>