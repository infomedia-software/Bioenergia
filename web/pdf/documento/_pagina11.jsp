<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>

<%
Document document=(Document)request.getAttribute("pdf");
Documento d=(Documento)request.getAttribute("documento");

document.setMargins(45,45,45,45);
document.newPage();

Font font_normale_p11=new Font(Font.FontFamily.HELVETICA,10,Font.NORMAL,BaseColor.BLACK);
Font font_bold_p11=new Font(Font.FontFamily.HELVETICA,10,Font.NORMAL,BaseColor.BLACK);
Font font_piccolo_p11=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.BLACK);
Font font_corsivo_p11=new Font(Font.FontFamily.HELVETICA,9,Font.ITALIC,BaseColor.BLACK);
Font font_titolo_p11=new Font(Font.FontFamily.HELVETICA,11,Font.BOLD,BaseColor.BLACK);

Paragraph p;

p=new Paragraph("ALLEGATO “GSE”  - PRESENTAZIONE DELLA DOMANDA AL GSE PER IL “RITIRO DEDICATO”",font_titolo_p11);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingAfter(30);
document.add(p);

p=new Paragraph("DICHIARAZIONE SOSTITUTIVA DELL’ATTO DI NOTORIETÀ",font_titolo_p11);
p.setAlignment(Element.ALIGN_CENTER);
document.add(p);

p=new Paragraph("ai sensi dell’art. 47 del D.P.R. N. 445 del 2000",font_bold_p11);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingAfter(25);
document.add(p);


/* DATI CLIENTE */
p=new Paragraph();
p.add(new Chunk("Il/la sottoscritto/a (cognome) ",font_normale_p11));
p.add(new Chunk(Utility.elimina_null(d.getCliente_cognome()),font_normale_p11));
p.add(new Chunk("    (nome) ",font_normale_p11));
p.add(new Chunk(Utility.elimina_null(d.getCliente_nome()),font_normale_p11));
p.setSpacingAfter(10);
document.add(p);

p=new Paragraph();
p.add(new Chunk("codice fiscale  ",font_bold_p11));
p.add(new Chunk(Utility.elimina_null(d.getCliente_cf()),font_normale_p11));
p.setSpacingAfter(20);
document.add(p);


/* TESTO RESPONSABILITA */
p=new Paragraph(
    "CONSAPEVOLE DI QUANTO PRESCRITTO DALL’ART. 76 DEL D.P.R. N. 445 DEL 28.12.2000, SULLA RESPONSABILITÀ PENALE CUI PUÒ ANDARE INCONTRO IN CASO DI DICHIARAZIONI MENDACI E DELLA DECADENZA, IN CASO DI FALSE DICHIARAZIONI, DAI BENEFICI RICHIESTI, COME PREVISTO DALL’ART. 75 DEL D.P.R. N. 445/2000",
    font_bold_p11
);
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(14);
p.setSpacingAfter(22);
document.add(p);

p=new Paragraph("D I C H I A R A",font_titolo_p11);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingAfter(22);
document.add(p);


/* PUNTO 1 */
p=new Paragraph();
p.setIndentationLeft(15);
p.add(new Chunk("• ",font_bold_p11));
p.add(new Chunk(
    "di essere informato che relativamente all’impianto fotovoltaico oggetto di intervento non può essere attivata alcuna pratica per gli incentivi di scambio sul posto di cui all’art. 25-bis del DL 91/2014;",
    font_bold_p11
));
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(14);
p.setSpacingAfter(22);
document.add(p);


/* PUNTO 2 */
p=new Paragraph();
p.setIndentationLeft(15);
p.add(new Chunk("• ",font_bold_p11));
p.add(new Chunk(
    "che è in corso di espletamento la procedura finalizzata al perfezionamento del contratto col Gestore dei servizi energetici (GSE) per l’ammissione al servizio di ritiro dedicato per la remunerazione dell’energia non autoconsumata in sito ovvero non condivisa per l’autoconsumo;",
    font_bold_p11
));
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(14);
p.setSpacingAfter(22);
document.add(p);


/* PUNTO 3 */
p=new Paragraph();
p.setIndentationLeft(15);
p.add(new Chunk("• ",font_bold_p11));
p.add(new Chunk(
    "di conferire mandato gratuito a Bioenergia S.r.l. (codice fiscale: 04543770285) affinché completi la predetta procedura, in nome e per conto del sottoscritto, sino alla stipula del contratto con il GSE; a tale scopo dichiara che nella “pratica RID” intende optare per la tariffa:",
    font_bold_p11
));
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(14);
p.setSpacingAfter(10);
document.add(p);


p=new Paragraph("(barrare la lettera prescelta)",font_corsivo_p11);
p.setIndentationLeft(40);
p.setSpacingAfter(10);
document.add(p);


/* PREZZI GSE */
String gse_prezzi=Utility.elimina_null(d.getGse_prezzi());

PdfPTable tabella_gse=new PdfPTable(2);
tabella_gse.setWidthPercentage(90);
tabella_gse.setWidths(new float[]{6,94});
tabella_gse.setHorizontalAlignment(Element.ALIGN_CENTER);

PdfPCell c1=new PdfPCell(new Phrase(gse_prezzi.equals("prezzi_minimi_garantiti") ? "X" : "",font_bold_p11));
c1.setBorder(Rectangle.NO_BORDER);
c1.setHorizontalAlignment(Element.ALIGN_CENTER);

PdfPCell c2=new PdfPCell(new Phrase("(a) Prezzi minimi garantiti",font_titolo_p11));
c2.setBorder(Rectangle.NO_BORDER);

tabella_gse.addCell(c1);
tabella_gse.addCell(c2);

c1=new PdfPCell(new Phrase(gse_prezzi.equals("prezzi_medi_rid") ? "X" : "",font_bold_p11));
c1.setBorder(Rectangle.NO_BORDER);
c1.setHorizontalAlignment(Element.ALIGN_CENTER);

c2=new PdfPCell(new Phrase("(b) Prezzi Medi RID",font_titolo_p11));
c2.setBorder(Rectangle.NO_BORDER);

tabella_gse.addCell(c1);
tabella_gse.addCell(c2);

document.add(tabella_gse);


/* PRIVACY */
p=new Paragraph(
    "Dichiara, inoltre, di essere informato, ai sensi e per gli effetti di cui all’art.13 del D. Lgs. 30 giugno 2003, n.196, che i dati personali raccolti saranno trattati, anche con strumenti informatici, esclusivamente nell’ambito del procedimento per il quale la presente dichiarazione viene resa.",
    font_piccolo_p11
);
p.setAlignment(Element.ALIGN_JUSTIFIED);
p.setLeading(13);
p.setSpacingBefore(18);
p.setSpacingAfter(6);
document.add(p);

p=new Paragraph(
    "Allegare fotocopia di un documento d’identità in corso di validità del dichiarante.",
    font_corsivo_p11
);
p.setSpacingAfter(55);
document.add(p);


/* DATA E FIRMA */
PdfPTable tabella_firma=new PdfPTable(2);
tabella_firma.setWidthPercentage(100);
tabella_firma.setWidths(new float[]{50,50});

PdfPCell data_cell=new PdfPCell(new Phrase("Data _____"+Utility.converti_data_formato_it(d.getData())+"_____",font_bold_p11));
data_cell.setBorder(Rectangle.NO_BORDER);
tabella_firma.addCell(data_cell);

PdfPCell firma_cell=new PdfPCell();
firma_cell.setBorder(Rectangle.NO_BORDER);

Paragraph firma_titolo=new Paragraph("Firma del dichiarante",font_bold_p11);
firma_titolo.setAlignment(Element.ALIGN_CENTER);
firma_cell.addElement(firma_titolo);

String firma_cliente=Utility.elimina_null(d.getFirma_cliente());
if(!d.isMandante_cliente())
    firma_cliente=Utility.elimina_null(d.getFirma_mandante());

if(!firma_cliente.equals("")){
    if(firma_cliente.contains(","))
        firma_cliente=firma_cliente.substring(firma_cliente.indexOf(",")+1);

    try{
        byte[] firma_bytes=java.util.Base64.getDecoder().decode(firma_cliente);
        Image img_firma=Image.getInstance(firma_bytes);
        img_firma.scaleToFit(160,70);
        img_firma.setAlignment(Image.ALIGN_CENTER);
        firma_cell.addElement(img_firma);
    }catch(Exception e){
        System.out.println("Errore firma cliente pagina 11: "+e.getMessage());
    }
}else{
    Paragraph riga_firma=new Paragraph("____________________________",font_normale_p11);
    riga_firma.setAlignment(Element.ALIGN_CENTER);
    firma_cell.addElement(riga_firma);
}

tabella_firma.addCell(firma_cell);

document.add(tabella_firma);
%>