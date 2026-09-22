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

document.setMargins(40,40,35,35);
document.newPage();

Font font_normale_p12=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.BLACK);
Font font_valore_p12=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.BLACK);
Font font_bold_p12=new Font(Font.FontFamily.HELVETICA,9,Font.BOLD,BaseColor.BLACK);
Font font_x_p12=new Font(Font.FontFamily.HELVETICA,9,Font.BOLD,BaseColor.BLACK);
Font font_titolo_p12=new Font(Font.FontFamily.HELVETICA,12,Font.BOLD,BaseColor.BLACK);
Font font_piccolo_p12=new Font(Font.FontFamily.HELVETICA,7,Font.ITALIC,BaseColor.BLACK);

Paragraph p;


/* ALLEGATO */
p=new Paragraph("Allegato C alla DGRV 827 del 15.05.2012",font_bold_p12);
p.setAlignment(Element.ALIGN_RIGHT);
p.setSpacingAfter(3);
document.add(p);

PdfPTable linea=new PdfPTable(1);
linea.setWidthPercentage(100);

PdfPCell cell_linea=new PdfPCell();
cell_linea.setBorder(Rectangle.BOTTOM);
cell_linea.setBorderWidthBottom(1f);
cell_linea.setFixedHeight(2);

linea.addCell(cell_linea);
document.add(linea);


/* TITOLO */
p=new Paragraph("MODELLO INFORMATIVO IMPIANTO",font_titolo_p12);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingBefore(18);
p.setSpacingAfter(15);
document.add(p);


/* TABELLA PRINCIPALE */
PdfPTable tabella=new PdfPTable(2);
tabella.setWidthPercentage(100);
tabella.setWidths(new float[]{34,66});


/* FOTOVOLTAICO */
PdfPCell titolo=new PdfPCell(new Phrase("FOTOVOLTAICO",font_titolo_p12));
titolo.setColspan(2);
titolo.setHorizontalAlignment(Element.ALIGN_CENTER);
titolo.setBackgroundColor(new BaseColor(255,255,180));
titolo.setPadding(7);
tabella.addCell(titolo);


/* PROCEDURA */
PdfPCell c=new PdfPCell(new Phrase("Tipologia di procedura",font_bold_p12));
c.setVerticalAlignment(Element.ALIGN_MIDDLE);
c.setPadding(6);
tabella.addCell(c);

String procedura=Utility.elimina_null(d.getImpianto_procedura());
String intervento_edilizio=Utility.elimina_null(d.getImpianto_intervento_edilizio());

PdfPTable tblProcedura=new PdfPTable(2);
tblProcedura.setWidthPercentage(100);
tblProcedura.setWidths(new float[]{5,95});

String[] procValori={"DIA","PAS","comunicazione al comune","intervento edilizio"};
String[] procTesti={
    "DIA (solo nei casi previsti dall’art.5 della L.R. 14/2009 e s. m. e i.)",
    "Procedura Autorizzativa Semplificata (PAS)",
    "Comunicazione al Comune",
    "Impianto realizzato nell’ambito di intervento edilizio"+(!intervento_edilizio.equals("") ? " - "+intervento_edilizio : "")
};

for(int i=0;i<procValori.length;i++){
    PdfPCell cx=new PdfPCell(new Phrase(procedura.contains(procValori[i]) ? "X" : "",font_x_p12));
    cx.setBorder(Rectangle.NO_BORDER);
    cx.setHorizontalAlignment(Element.ALIGN_CENTER);
    cx.setVerticalAlignment(Element.ALIGN_MIDDLE);
    cx.setPadding(1);
    tblProcedura.addCell(cx);

    PdfPCell ct=new PdfPCell(new Phrase(procTesti[i],font_normale_p12));
    ct.setBorder(Rectangle.NO_BORDER);
    ct.setPadding(1);
    tblProcedura.addCell(ct);
}

c=new PdfPCell(tblProcedura);
c.setPadding(5);
tabella.addCell(c);

/* TIPOLOGIA */
c=new PdfPCell(new Phrase("Tipologia di impianto",font_bold_p12));
c.setVerticalAlignment(Element.ALIGN_MIDDLE);
c.setPadding(6);
tabella.addCell(c);

String tipologia=Utility.elimina_null(d.getImpianto_tipologia());

PdfPTable tblTipologia=new PdfPTable(2);
tblTipologia.setWidthPercentage(100);
tblTipologia.setWidths(new float[]{5,95});

String[] tipoValori={
    "A - su edifici",
    "B - tettoie, serre o pensiline",
    "C - moduli collocati a terra"
};

for(int i=0;i<tipoValori.length;i++){
    PdfPCell cx=new PdfPCell(new Phrase(tipologia.equals(tipoValori[i]) ? "X" : "",font_x_p12));
    cx.setBorder(Rectangle.NO_BORDER);
    cx.setHorizontalAlignment(Element.ALIGN_CENTER);
    cx.setPadding(1);
    tblTipologia.addCell(cx);

    PdfPCell ct=new PdfPCell(new Phrase(tipoValori[i],font_normale_p12));
    ct.setBorder(Rectangle.NO_BORDER);
    ct.setPadding(1);
    tblTipologia.addCell(ct);
}

c=new PdfPCell(tblTipologia);
c.setPadding(5);
tabella.addCell(c);

/* SUPERFICIE */
c=new PdfPCell(new Phrase("Superficie dei moduli (mq)",font_bold_p12));
c.setPadding(6);
tabella.addCell(c);

c=new PdfPCell(new Phrase(Utility.elimina_zero(d.getImpianto_superficie_moduli()),font_normale_p12));
c.setPadding(6);
tabella.addCell(c);


/* DATI IDENTIFICATIVI DEL PROPONENTE */
c=new PdfPCell(new Phrase("Dati identificativi del proponente",font_bold_p12));
c.setVerticalAlignment(Element.ALIGN_MIDDLE);
c.setPadding(6);
tabella.addCell(c);

String cliente="";
if(d.getCliente_privato_azienda().equals("azienda"))
    cliente=Utility.elimina_null(d.getCliente_ragione_sociale());
else
    cliente=Utility.elimina_null(d.getCliente_cognome())+" "+Utility.elimina_null(d.getCliente_nome());

PdfPTable proponente=new PdfPTable(4);
proponente.setWidthPercentage(100);
proponente.setWidths(new float[]{20,30,12,38});

/* NOME E COGNOME */
PdfPCell pc=new PdfPCell(new Phrase(d.getCliente_privato_azienda().equals("azienda") ? "Ragione Sociale" : "Nome e Cognome",font_normale_p12));
pc.setPadding(4);
proponente.addCell(pc);

pc=new PdfPCell(new Phrase(cliente,font_valore_p12));
pc.setColspan(3);
pc.setPadding(4);
proponente.addCell(pc);

/* INDIRIZZO */
pc=new PdfPCell(new Phrase("Indirizzo",font_valore_p12));
pc.setPadding(4);
proponente.addCell(pc);

pc=new PdfPCell(new Phrase(Utility.elimina_null(d.getCliente_indirizzo()),font_normale_p12));
pc.setColspan(3);
pc.setPadding(4);
proponente.addCell(pc);


pc=new PdfPCell(new Phrase("Tel",font_normale_p12));
pc.setPadding(4);
proponente.addCell(pc);

pc=new PdfPCell(new Phrase(Utility.elimina_null(d.getCliente_cellulare()),font_valore_p12));
pc.setPadding(4);
proponente.addCell(pc);

pc=new PdfPCell(new Phrase("e-mail",font_normale_p12));
pc.setPadding(4);
proponente.addCell(pc);

pc=new PdfPCell(new Phrase(Utility.elimina_null(d.getCliente_email()),font_valore_p12));
pc.setPadding(4);
pc.setNoWrap(true);
proponente.addCell(pc);

pc=new PdfPCell(new Phrase(Utility.elimina_null(d.getCliente_email()),font_normale_p12));
pc.setPadding(4);
proponente.addCell(pc);

/* CONTENITORE */
c=new PdfPCell(proponente);
c.setPadding(0);
tabella.addCell(c);

/* LOCALIZZAZIONE */
c=new PdfPCell(new Phrase("Localizzazione dell’impianto",font_bold_p12));
c.setVerticalAlignment(Element.ALIGN_MIDDLE);
c.setPadding(6);
tabella.addCell(c);

PdfPTable localizzazione=new PdfPTable(4);
localizzazione.setWidthPercentage(100);
localizzazione.setWidths(new float[]{20,30,12,38});

/* LOCALITA */
PdfPCell lc=new PdfPCell(new Phrase("Indirizzo",font_normale_p12));
lc.setPadding(4);
localizzazione.addCell(lc);

lc=new PdfPCell(new Phrase(Utility.elimina_null(d.getCliente_indirizzo()),font_normale_p12));
lc.setColspan(3);
lc.setPadding(4);
localizzazione.addCell(lc);

/* COMUNE */
lc=new PdfPCell(new Phrase("Comune",font_normale_p12));
lc.setPadding(4);
localizzazione.addCell(lc);

lc=new PdfPCell(new Phrase(Utility.elimina_null(d.getCliente_comune()),font_normale_p12));
lc.setColspan(3);
lc.setPadding(4);
localizzazione.addCell(lc);

/* FOGLIO */
lc=new PdfPCell(new Phrase("Foglio/i catastale/i",font_normale_p12));
lc.setPadding(4);
localizzazione.addCell(lc);

lc=new PdfPCell(new Phrase(Utility.elimina_null(d.getImpianto_foglio_catastale()),font_normale_p12));
lc.setPadding(4);
localizzazione.addCell(lc);

/* PARTICELLA */
lc=new PdfPCell(new Phrase("Particella/e",font_normale_p12));
lc.setPadding(4);
localizzazione.addCell(lc);

lc=new PdfPCell(new Phrase(Utility.elimina_null(d.getImpianto_particella()),font_normale_p12));
lc.setPadding(4);
localizzazione.addCell(lc);

/* COORDINATE */
lc=new PdfPCell(new Phrase(
    "Coordinate Gauss Boaga, fuso ovest,\ndel centroide del poligono che\nracchiude l’impianto",
    font_normale_p12
));
lc.setColspan(2);
lc.setPadding(4);
lc.setVerticalAlignment(Element.ALIGN_MIDDLE);
localizzazione.addCell(lc);

lc=new PdfPCell(new Phrase(Utility.elimina_null(d.getImpianto_coordinate()),font_normale_p12));
lc.setColspan(2);
lc.setPadding(4);
lc.setVerticalAlignment(Element.ALIGN_MIDDLE);
localizzazione.addCell(lc);

/* CELLA CONTENITORE */
c=new PdfPCell(localizzazione);
c.setPadding(0);
tabella.addCell(c);


/* DATA ENTRATA ESERCIZIO */
c=new PdfPCell(new Phrase("Data prevista di entrata in esercizio dell’impianto",font_bold_p12));
c.setPadding(6);
tabella.addCell(c);

c=new PdfPCell(new Phrase(Utility.converti_data_formato_it(d.getImpianto_data_entrata_esercizio()),font_normale_p12));
c.setPadding(6);
tabella.addCell(c);


/* POTENZA */
c=new PdfPCell(new Phrase("Potenza elettrica installata (kW)",font_bold_p12));
c.setPadding(6);
tabella.addCell(c);

c=new PdfPCell(new Phrase(Utility.elimina_zero(d.getImpianto_potenza_kw()),font_normale_p12));
c.setPadding(6);
tabella.addCell(c);


/* PRODUCIBILITA */
c=new PdfPCell(new Phrase("Producibilità annua attesa (kWh/anno)",font_bold_p12));
c.setPadding(6);
tabella.addCell(c);

c=new PdfPCell(new Phrase(Utility.elimina_zero(d.getImpianto_producibilita_annua()),font_normale_p12));
c.setPadding(6);
tabella.addCell(c);

document.add(tabella);


/* NOTE */
p=new Paragraph();
p.add(new Chunk("Nota: ",font_normale_p12));
p.add(new Chunk(Utility.elimina_null(d.getImpianto_note()),font_normale_p12));
p.setLeading(13);
p.setSpacingBefore(14);
p.setSpacingAfter(24);
document.add(p);


/* DATA */
p=new Paragraph("Data ____"+Utility.converti_data_formato_it(d.getData())+"____",font_normale_p12);
p.setSpacingAfter(25);
document.add(p);


/* FIRME */
PdfPTable firme=new PdfPTable(2);
firme.setWidthPercentage(100);
firme.setWidths(new float[]{50,50});

PdfPCell firma_cliente_cell=new PdfPCell();
firma_cliente_cell.setBorder(Rectangle.NO_BORDER);

p=new Paragraph("Il dichiarante\n(firma per esteso e leggibile)",font_normale_p12);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingAfter(5);
firma_cliente_cell.addElement(p);


/* FIRMA CLIENTE BASE64 */
String firma_cliente=Utility.elimina_null(d.getFirma_cliente());
if(!d.isMandante_cliente())
    firma_cliente=Utility.elimina_null(d.getFirma_mandante());

if(!firma_cliente.equals("")){
    if(firma_cliente.contains(","))
        firma_cliente=firma_cliente.substring(firma_cliente.indexOf(",")+1);

    try{
        byte[] firma_bytes=Base64.getDecoder().decode(firma_cliente);

        Image img_firma=Image.getInstance(firma_bytes);
        img_firma.scaleToFit(160,70);
        img_firma.setAlignment(Image.ALIGN_CENTER);

        firma_cliente_cell.addElement(img_firma);
    }catch(Exception e){
        System.out.println("Errore firma cliente pagina 12: "+e.getMessage());
    }
}

firme.addCell(firma_cliente_cell);


/* TECNICO */
PdfPCell tecnico_cell=new PdfPCell();
tecnico_cell.setBorder(Rectangle.NO_BORDER);

p=new Paragraph("Il tecnico incaricato\n(Timbro e firma)",font_normale_p12);
p.setAlignment(Element.ALIGN_CENTER);
p.setSpacingAfter(5);
tecnico_cell.addElement(p);

if(d.getTecnico()!=null){
    //String firma_tecnico=Utility.elimina_null(d.getTecnico().getFirma());
    String firma_tecnico="firma_tecnico.PNG";
    if(!firma_tecnico.equals("")){
        try{
            Image img_firma_tecnico=Image.getInstance(application.getRealPath("/img/"+firma_tecnico));
            img_firma_tecnico.scaleToFit(160,70);
            img_firma_tecnico.setAlignment(Image.ALIGN_CENTER);
            tecnico_cell.addElement(img_firma_tecnico);
        }catch(Exception e){
            System.out.println("Errore firma tecnico pagina 12: "+e.getMessage());
        }
    }
}

firme.addCell(tecnico_cell);
document.add(firme);
/* NOTE FINALI */
p=new Paragraph(
    "1 In caso affermativo, specificare se si tratta di nuova costruzione, ristrutturazione rilevante o altro.\n"+
    "2 Richiesta solo in caso di interventi edilizi per nuove costruzioni e/o ristrutturazioni rilevanti o per moduli a terra.",
    font_piccolo_p12
);
p.setSpacingBefore(30);
p.setLeading(10);
document.add(p);
%>