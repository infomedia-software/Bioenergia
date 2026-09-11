<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page trimDirectiveWhitespaces="true"%>

<%
Document document=(Document)request.getAttribute("pdf");
document.setMargins(50,50,55,55);
Font font_normale_p6=new Font(Font.FontFamily.HELVETICA,11,Font.NORMAL,BaseColor.BLACK);
Font font_bold_p6=new Font(Font.FontFamily.HELVETICA,11,Font.BOLD,BaseColor.BLACK);
Font font_corsivo_p6=new Font(Font.FontFamily.HELVETICA,11,Font.ITALIC,BaseColor.BLACK);

document.newPage();

Paragraph p;

p=new Paragraph("oppure",font_normale_p6);
p.setSpacingAfter(14);
document.add(p);

p=new Paragraph();
p.add(new Chunk("alla ditta ",font_normale_p6));
p.add(new Chunk("BIOENERGIA SRL",font_normale_p6));
p.add(new Chunk(".........................",font_normale_p6));
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph();
p.add(new Chunk("codice fiscale .............. partita iva...... ",font_normale_p6));
p.add(new Chunk("04543770285",font_normale_p6));
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph();
p.add(new Chunk("sede legale.... ",font_normale_p6));
p.add(new Chunk("VIA RETRONE",font_normale_p6));
p.add(new Chunk("........ comune.... ",font_normale_p6));
p.add(new Chunk("PADOVA",font_normale_p6));
p.add(new Chunk("........ cap.... ",font_normale_p6));
p.add(new Chunk("35135",font_normale_p6));
p.add(new Chunk("........",font_normale_p6));
p.setSpacingAfter(12);
document.add(p);

p=new Paragraph();
p.add(new Chunk("iscritta registro imprese.. ",font_normale_p6));
p.add(new Chunk("PD",font_normale_p6));
p.add(new Chunk("..... R.E.A.... ",font_normale_p6));
p.add(new Chunk("398253",font_normale_p6));
p.add(new Chunk("........",font_normale_p6));
p.setSpacingAfter(14);
document.add(p);

p=new Paragraph("(di seguito mandatario).",font_corsivo_p6);
p.setSpacingAfter(34);
document.add(p);

p=new Paragraph("Il sottoscritto in qualità di mandante dichiara inoltre:",font_normale_p6);
p.setSpacingAfter(14);
document.add(p);

// primo punto
List lista=new List(List.UNORDERED);
lista.setIndentationLeft(22);
lista.setSymbolIndent(10);

ListItem item1=new ListItem(
    "di essere a conoscenza che ogni atto e azione compiuta dal mandatario nell’ambito dell’iter di connessione alla rete elettrica tramite Portale, sarà inteso da e-distribuzione come eseguito direttamente a nome e nell’interesse del mandante;",
    font_normale_p6
);
item1.setAlignment(Element.ALIGN_JUSTIFIED);
item1.setLeading(17);
item1.setSpacingAfter(4);
lista.add(item1);

// secondo punto con sottoelenco
ListItem item2=new ListItem(
    "di essere consapevole che il mandatario ha ogni potere e facoltà per gestire in nome e per conto del mandante tutti gli atti e adempimenti necessari per l’iter di connessione alla rete elettrica, tra i quali rientrano, a titolo esemplificativo e non esaustivo:",
    font_normale_p6
);
item2.setAlignment(Element.ALIGN_JUSTIFIED);
item2.setLeading(17);

List sottoLista=new List(List.ORDERED);
sottoLista.setIndentationLeft(24);
sottoLista.setSymbolIndent(12);

ListItem s1=new ListItem("Richiesta di connessione alla rete ed effettuazione dei relativi pagamenti;",font_normale_p6);
s1.setLeading(17);
sottoLista.add(s1);

ListItem s2=new ListItem("Stipulazione di eventuale atto di cessione, in forma notarile, dell’impianto di rete per la connessione;",font_normale_p6);
s2.setLeading(17);
sottoLista.add(s2);

ListItem s3=new ListItem("Stipulazione dell’eventuale contratto di realizzazione delle opere di rete;",font_normale_p6);
s3.setLeading(17);
sottoLista.add(s3);

ListItem s4=new ListItem("Accettazione del preventivo di connessione ed effettuazione dei relativi pagamenti;",font_normale_p6);
s4.setLeading(17);
sottoLista.add(s4);

ListItem s5=new ListItem("Accettazione del regolamento di esercizio dell’impianto di produzione;",font_normale_p6);
s5.setLeading(17);
sottoLista.add(s5);

ListItem s6=new ListItem("Sottoscrizione e invio di dichiarazioni, atti e documenti richiesti per l’iter di connessione alla rete.",font_normale_p6);
s6.setLeading(17);
sottoLista.add(s6);

item2.add(sottoLista);
lista.add(item2);

// terzo punto
ListItem item3=new ListItem(
    "di impegnarsi a fornire al mandatario tutte le informazioni e i documenti necessari per la gestione dell’iter di connessione alla rete elettrica dell’impianto di produzione sopraindicato;",
    font_normale_p6
);
item3.setAlignment(Element.ALIGN_JUSTIFIED);
item3.setLeading(17);
lista.add(item3);

document.add(lista);
%>