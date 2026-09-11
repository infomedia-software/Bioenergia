<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="java.util.Base64"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>

<%
Document document=(Document)request.getAttribute("pdf");
Documento documento=(Documento)request.getAttribute("documento");

document.setMargins(45,45,55,55);
document.newPage();

Font font_normale_p7=new Font(Font.FontFamily.HELVETICA,11,Font.NORMAL,BaseColor.BLACK);
Font font_piccolo_p7=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.BLACK);

Paragraph p=new Paragraph(
    "Parimenti con la sottoscrizione della presente scrittura il mandatario dichiara di accettare integralmente il mandato conferitogli dal mandante e consapevole delle responsabilità e sanzioni penali per false attestazioni e dichiarazioni mendaci previste dall’art. 76 del DPR 445/2000, dichiara altresì che la firma apposta in calce dal mandante è autentica.",
    font_normale_p7
);
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(17);
p.setSpacingAfter(75);
document.add(p);


/* DATA + FIRME */
PdfPTable tabella_firme=new PdfPTable(2);
tabella_firme.setWidthPercentage(100);
tabella_firme.setWidths(new float[]{55,45});

PdfPCell cella_data=new PdfPCell(new Phrase("Data  "+Utility.converti_data_formato_it(documento.getData())+"..........",font_normale_p7));
cella_data.setBorder(Rectangle.NO_BORDER);
cella_data.setVerticalAlignment(Element.ALIGN_TOP);
cella_data.setPaddingTop(5);
tabella_firme.addCell(cella_data);

PdfPCell cella_firme=new PdfPCell();
cella_firme.setBorder(Rectangle.NO_BORDER);

/* FIRMA MANDANTE */
Paragraph firma_mandante_titolo=new Paragraph("Firma del Mandante",font_normale_p7);
firma_mandante_titolo.setAlignment(Element.ALIGN_CENTER);
firma_mandante_titolo.setSpacingAfter(5);
cella_firme.addElement(firma_mandante_titolo);

String firma_mandante=Utility.elimina_null(documento.getFirma_mandante());

if(!firma_mandante.equals("")){
    if(firma_mandante.contains(","))
        firma_mandante=firma_mandante.substring(firma_mandante.indexOf(",")+1);

    try{
        byte[] firma_bytes=Base64.getDecoder().decode(firma_mandante);
        Image img_firma_mandante=Image.getInstance(firma_bytes);
        img_firma_mandante.scaleToFit(150,65);
        img_firma_mandante.setAlignment(Image.ALIGN_CENTER);
        cella_firme.addElement(img_firma_mandante);
    }catch(Exception e){
        System.out.println("Errore firma mandante: "+e.getMessage());
    }
}

/* FIRMA MANDATARIO */
Paragraph firma_mandatario_titolo=new Paragraph("Firma del Mandatario",font_normale_p7);
firma_mandatario_titolo.setAlignment(Element.ALIGN_CENTER);
firma_mandatario_titolo.setSpacingBefore(12);
firma_mandatario_titolo.setSpacingAfter(3);
cella_firme.addElement(firma_mandatario_titolo);

Paragraph accettazione=new Paragraph("(per accettazione)",font_piccolo_p7);
accettazione.setAlignment(Element.ALIGN_CENTER);
accettazione.setSpacingAfter(3);
cella_firme.addElement(accettazione);

Image img_firma_mandatario=Image.getInstance(application.getRealPath("/img/firma_mandatario.png"));
img_firma_mandatario.scaleToFit(180,90);
img_firma_mandatario.setAlignment(Image.ALIGN_CENTER);
cella_firme.addElement(img_firma_mandatario);

tabella_firme.addCell(cella_firme);

document.add(tabella_firme);


/* NOTA FINALE */
Paragraph nota=new Paragraph(
    "Si allega copia del documento di riconoscimento del mandante e del mandatario in corso di validità ai sensi dell’art. 38 del D.P.R. n. 445/2000",
    font_piccolo_p7
);
nota.setLeading(13);
nota.setSpacingBefore(25);
document.add(nota);
%>