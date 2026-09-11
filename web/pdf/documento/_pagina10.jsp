<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>

<%
Document document=(Document)request.getAttribute("pdf");
Documento d=(Documento)request.getAttribute("documento");

document.setMargins(50,50,45,45);
document.newPage();

Font font_normale_p10=new Font(Font.FontFamily.HELVETICA,12,Font.NORMAL,BaseColor.BLACK);
Font font_bold_p10=new Font(Font.FontFamily.HELVETICA,12,Font.BOLD,BaseColor.BLACK);
Font font_pallino_p10=new Font(Font.FontFamily.HELVETICA,13,Font.BOLD,BaseColor.BLACK);

/* LOGO */
Image logo=Image.getInstance(application.getRealPath("/img/bioenergia.png"));
logo.scaleToFit(260,90);
logo.setAlignment(Image.ALIGN_CENTER);
document.add(logo);

Paragraph spazio=new Paragraph(" ");
spazio.setSpacingAfter(25);
document.add(spazio);


/* A */
Paragraph p=new Paragraph();
p.add(new Chunk("A)   ",font_bold_p10));
p.add(new Chunk("Cognome e nome intestatario della detrazione fiscale : ",font_normale_p10));
p.add(new Chunk(Utility.elimina_null(d.getDetrazione_intestatario()),font_normale_p10));
p.setSpacingAfter(15);
document.add(p);


/* B */
p=new Paragraph();
p.add(new Chunk("B)   ",font_bold_p10));
p.add(new Chunk("Superficie utile calpestabile (mq dell’abitazione a cui l’impianto eroga energia) : ",font_normale_p10));

String superficie=Utility.elimina_zero(d.getImmobile_superficie_mq());

p.add(new Chunk(superficie,font_normale_p10));
p.add(new Chunk(" mq",font_normale_p10));
p.setSpacingAfter(15);
document.add(p);


/* C */
p=new Paragraph();
p.add(new Chunk("C)   ",font_bold_p10));
p.add(new Chunk("Titolo di possesso dell’abitazione (dell’intestatario della detrazione)",font_normale_p10));
p.setSpacingAfter(5);
document.add(p);

String titolo=Utility.elimina_null(d.getImmobile_titolo_possesso());

String[] titoli={
    "proprietario o comproprietario",
    "detentore o co-detentore",
    "familiare convivente",
    "condominio"
};

String[] titoli_testo={
    "Proprietario o comproprietario",
    "Detentore o co-detentore (es. locatore, comodatario usufruttuario, etc.)",
    "Familiare convivente con il possessore o con il detentore",
    "Condominio"
};

for(int i=0;i<titoli.length;i++){
    PdfPTable riga=new PdfPTable(3);
    riga.setWidthPercentage(95);
    riga.setWidths(new float[]{4,5,91});
    riga.setHorizontalAlignment(Element.ALIGN_LEFT);

    PdfPCell c1=new PdfPCell(new Phrase(titolo.equals(titoli[i]) ? "X" : "",font_pallino_p10));
    c1.setBorder(Rectangle.NO_BORDER);
    c1.setHorizontalAlignment(Element.ALIGN_CENTER);
    c1.setPadding(0);

    PdfPCell c2=new PdfPCell(new Phrase((i+1)+".",font_normale_p10));
    c2.setBorder(Rectangle.NO_BORDER);
    c2.setPadding(0);

    PdfPCell c3=new PdfPCell(new Phrase(titoli_testo[i],font_normale_p10));
    c3.setBorder(Rectangle.NO_BORDER);
    c3.setPadding(0);

    riga.addCell(c1);
    riga.addCell(c2);
    riga.addCell(c3);

    document.add(riga);
}

spazio=new Paragraph(" ");
spazio.setSpacingAfter(5);
document.add(spazio);


/* D */
p=new Paragraph();
p.add(new Chunk("D)   ",font_bold_p10));
p.add(new Chunk("Numero unità immobiliari che compongono l’edificio (es. casa singola è composta da 1 unità, bifamiliare è composta da 2 unità, trifamiliare è composta da 3 unità, etc.) : ",font_normale_p10));
p.add(new Chunk(Utility.elimina_zero(d.getImmobile_num_unita()),font_normale_p10));
p.setLeading(14);
p.setSpacingAfter(15);
document.add(p);


/* E */
p=new Paragraph();
p.add(new Chunk("E)   ",font_bold_p10));
p.add(new Chunk("Anno di costruzione immobile (anche stimato) : ",font_normale_p10));
p.add(new Chunk(Utility.elimina_null(d.getImmobile_anno_costruzione()),font_normale_p10));
p.setSpacingAfter(15);
document.add(p);


/* F */
p=new Paragraph();
p.add(new Chunk("F)   ",font_bold_p10));
p.add(new Chunk("Tipologia edilizia",font_normale_p10));
p.setSpacingAfter(8);
document.add(p);

String tipologia=Utility.elimina_null(d.getImmobile_tipologia_edilizia());

String[] tipologie={
    "edificio in linea e condominio oltre i tre piani fuori terra",
    "edificio a schiera e condominio fino a tre piani",
    "costruzione isolata",
    "edificio industriale, artigianale o commerciale",
    "altro"
};

String[] tipologie_testo={
    "Edificio in linea e condominio oltre i tre piani fuori terra",
    "Edificio a schiera e condominio fino a tre piani",
    "Costruzione isolata (es. mono o plurifamiliare)",
    "Edificio industriale, artigianale o commerciale",
    "Altro"
};

for(int i=0;i<tipologie.length;i++){
    PdfPTable riga=new PdfPTable(3);
    riga.setWidthPercentage(95);
    riga.setWidths(new float[]{4,5,91});
    riga.setHorizontalAlignment(Element.ALIGN_LEFT);

    PdfPCell c1=new PdfPCell(new Phrase(tipologia.equals(tipologie[i]) ? "X" : "",font_pallino_p10));
    c1.setBorder(Rectangle.NO_BORDER);
    c1.setHorizontalAlignment(Element.ALIGN_CENTER);
    c1.setPadding(0);

    PdfPCell c2=new PdfPCell(new Phrase((i+1)+".",font_normale_p10));
    c2.setBorder(Rectangle.NO_BORDER);
    c2.setPadding(0);

    String testo=tipologie_testo[i];

    if(tipologie[i].equals("altro") && tipologia.equals("altro")){
        String altro=Utility.elimina_null(d.getImmobile_tipologia_edilizia_altro());
        if(!altro.equals(""))
            testo+=": "+altro;
    }

    PdfPCell c3=new PdfPCell(new Phrase(testo,font_normale_p10));
    c3.setBorder(Rectangle.NO_BORDER);
    c3.setPadding(0);

    riga.addCell(c1);
    riga.addCell(c2);
    riga.addCell(c3);

    document.add(riga);
}
spazio=new Paragraph(" ");
spazio.setSpacingAfter(5);
document.add(spazio);


/* G */
p=new Paragraph();
p.add(new Chunk("G)   ",font_bold_p10));
p.add(new Chunk("Intervento su",font_normale_p10));
p.setSpacingAfter(8);
document.add(p);

String intervento=Utility.elimina_null(d.getImmobile_tipo_intervento());

String[] interventi={
    "singola unita immobiliare",
    "edificio singola unita immobiliare",
    "parti comuni condominiali",
    "intero edificio"
};

String[] interventi_testo={
    "Singola unità immobiliare (in edificio costituito da più unità immobiliari)",
    "Edificio costituito da una singola unità immobiliare",
    "Parti comuni condominiali",
    "Intero edificio (qualsiasi tipo di edificio non incluso nei casi sopra riportati)"
};

for(int i=0;i<interventi.length;i++){
    PdfPTable riga=new PdfPTable(3);
    riga.setWidthPercentage(95);
    riga.setWidths(new float[]{4,5,91});
    riga.setHorizontalAlignment(Element.ALIGN_LEFT);

    PdfPCell c1=new PdfPCell(new Phrase(intervento.equals(interventi[i]) ? "X" : "",font_pallino_p10));
    c1.setBorder(Rectangle.NO_BORDER);
    c1.setHorizontalAlignment(Element.ALIGN_CENTER);
    c1.setPadding(0);

    PdfPCell c2=new PdfPCell(new Phrase((i+1)+".",font_normale_p10));
    c2.setBorder(Rectangle.NO_BORDER);
    c2.setPadding(0);

    PdfPCell c3=new PdfPCell(new Phrase(interventi_testo[i],font_normale_p10));
    c3.setBorder(Rectangle.NO_BORDER);
    c3.setPadding(0);

    riga.addCell(c1);
    riga.addCell(c2);
    riga.addCell(c3);

    document.add(riga);
}

spazio=new Paragraph(" ");
spazio.setSpacingAfter(5);
document.add(spazio);


/* H */
p=new Paragraph();
p.add(new Chunk("H)   ",font_bold_p10));
p.add(new Chunk("Numero unità immobiliari oggetto dell’intervento per cui si chiede la detrazione : ",font_normale_p10));
p.add(new Chunk(d.getImmobile_unita_intervento(),font_normale_p10));
document.add(p);
%>