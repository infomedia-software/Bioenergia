<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
Document document=(Document)request.getAttribute("pdf");
Documento documento=(Documento)request.getAttribute("documento");
document.setMargins(50,50,55,55);
Font font_normale_p5=new Font(Font.FontFamily.HELVETICA,12,Font.NORMAL,BaseColor.BLACK);
Font font_bold_p5=new Font(Font.FontFamily.HELVETICA,12,Font.BOLD,BaseColor.BLACK);
Font font_corsivo_p5=new Font(Font.FontFamily.HELVETICA,12,Font.ITALIC,BaseColor.BLACK);

document.newPage();

Paragraph p;

p=new Paragraph("Con il presente atto da valersi ad ogni effetto di legge",font_normale_p5);
p.setSpacingAfter(14);
document.add(p);

p=new Paragraph("Il sottoscritto",font_normale_p5);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingAfter(16);
document.add(p);

p=new Paragraph(
    "Nome "+Utility.elimina_null(documento.getMandante_nome())+"........................, " +
    "Cognome "+Utility.elimina_null(documento.getMandante_cognome())+"........................",
    font_normale_p5
);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph(
    "Nato a "+Utility.elimina_null(documento.getMandante_luogo_nascita())+"........................, " +
    "il "+Utility.converti_data_formato_it(documento.getMandante_data_nascita())+"........................",
    font_normale_p5
);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph(
    "Codice fiscale "+Utility.elimina_null(documento.getMandante_cf())+"........................................",
    font_normale_p5
);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph(
    "Residente in via "+Utility.elimina_null(documento.getMandante_indirizzo())+"........................................",
    font_normale_p5
);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph(
    "Comune "+Utility.elimina_null(documento.getMandante_comune())+"........................................, " +
    "provincia "+Utility.elimina_null(documento.getMandante_provincia())+"....................",
    font_normale_p5
);
p.setSpacingAfter(14);
document.add(p);

p=new Paragraph("oppure",font_normale_p5);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph("in qualità di "+Utility.elimina_null(documento.getMandante_qualifica())+".................... (di seguito mandante)",font_normale_p5);
p.setSpacingAfter(4);
document.add(p);


p=new Paragraph(
    "consapevole delle responsabilità e sanzioni penali previste dall’art. 76 del D.P.R. n. 445/2000 per false attestazioni e dichiarazioni mendaci.",
    font_normale_p5
);
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(15);
p.setSpacingAfter(16);
document.add(p);

p=new Paragraph("dichiara",font_bold_p5);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingAfter(16);
document.add(p);

p=new Paragraph(
    "anche ai sensi dell’art. 46 del sopracitato DPR n.445/2000 di conferire, con la presente scrittura, mandato con rappresentanza per la gestione tramite il Portale informatico di e-distribuzione (di seguito Portale), della domanda di connessione alla rete elettrica, nonché dell’intero iter di connessione comprensivo dello scambio elettronico dei relativi documenti, a proprio nome e per proprio conto",
    font_normale_p5
);
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(15);
p.setSpacingAfter(14);
document.add(p);

p=new Paragraph("al signor:",font_normale_p5);
p.setSpacingAfter(14);
document.add(p);

p=new Paragraph("Nome MASSIMILIANO................, Cognome TIGNOLA................",font_normale_p5);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph("Nato a PADOVA................, il 02/10/1973........................",font_normale_p5);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph("Codice fiscale TGNMSM73R02G224B........................",font_normale_p5);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph("Residente in via NATISONE 50............................",font_normale_p5);
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph("Comune PADOVA............................, provincia PD................",font_normale_p5);
document.add(p);
%>