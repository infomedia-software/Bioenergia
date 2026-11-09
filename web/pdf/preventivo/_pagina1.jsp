<%@page import="com.itextpdf.text.html.simpleparser.HTMLWorker"%>
<%@page import="java.io.StringReader"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.nio.charset.StandardCharsets"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Riga"%>
<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="utility.Utility"%>
<%@page trimDirectiveWhitespaces="true"%>
<%
    Document pdf=(Document)request.getAttribute("pdf");
    Documento d=(Documento)request.getAttribute("documento");
    String id_documento=(String)request.getAttribute("id_documento");

    Font normale=(Font)request.getAttribute("font_normale");
    Font piccolo=(Font)request.getAttribute("font_piccolo");
    Font bold=(Font)request.getAttribute("font_bold");
    Font totaleFont=(Font)request.getAttribute("font_totale");
    BaseColor grigioChiaro=new BaseColor(240,240,240);

    ArrayList<Riga> righe=GestioneDocumento.getIstanza().get_righe_documento(id_documento);

    // DESTINATARIO
    PdfPTable destinatario=new PdfPTable(2);
    destinatario.setWidthPercentage(100);
    destinatario.setWidths(new float[]{55,45});

    PdfPCell vuota=new PdfPCell(new Phrase(""));
    vuota.setBorder(Rectangle.NO_BORDER);
    vuota.setMinimumHeight(65);
    destinatario.addCell(vuota);

    PdfPCell cliente=new PdfPCell();
    cliente.setBorder(Rectangle.TOP);
    cliente.setBorderColor(BaseColor.LIGHT_GRAY);
    cliente.setPaddingTop(8);
    cliente.setPaddingBottom(20);
    
    // DATI CLIENTE
    cliente.addElement(new Paragraph("DESTINATARIO",piccolo));
    Paragraph nominativo=new Paragraph(d.getCliente_nominativo(),bold);
    nominativo.setSpacingBefore(5);
    cliente.addElement(nominativo);

    String indirizzo=Utility.elimina_null(d.getCliente_indirizzo());
    String cap=Utility.elimina_null(d.getCliente_cap());
    String comune=Utility.elimina_null(d.getCliente_comune());
    String provincia=Utility.elimina_null(d.getCliente_provincia());
    String telefono=Utility.elimina_null(d.getCliente_telefono());
    String cellulare=Utility.elimina_null(d.getCliente_cellulare());
    String email=Utility.elimina_null(d.getCliente_email());
    String cf=Utility.elimina_null(d.getCliente_cf());
    String piva=Utility.elimina_null(d.getCliente_piva());

    if(!indirizzo.equals(""))cliente.addElement(new Paragraph(indirizzo,normale));

    String localita=(cap+" "+comune).trim();
    if(!provincia.equals(""))localita+=" ("+provincia+")";
    if(!localita.trim().equals(""))cliente.addElement(new Paragraph(localita.trim(),normale));

    if(!telefono.equals(""))cliente.addElement(new Paragraph("Tel: "+telefono,normale));
    if(!cellulare.equals(""))cliente.addElement(new Paragraph("Cell: "+cellulare,normale));
    if(!email.equals(""))cliente.addElement(new Paragraph("Email: "+email,normale));
    if(!cf.equals(""))cliente.addElement(new Paragraph("C.F.: "+cf,normale));
    if(!piva.equals(""))cliente.addElement(new Paragraph("P.IVA: "+piva,normale));

    destinatario.addCell(cliente);
    pdf.add(destinatario);

    // PRODOTTI E SERVIZI
    PdfPTable prodotti=new PdfPTable(2);
    prodotti.setWidthPercentage(100);
    prodotti.setWidths(new float[]{85,15});
    prodotti.setSpacingBefore(10);
    prodotti.setSpacingAfter(15);
    prodotti.setHeaderRows(1);

    PdfPCell h1=new PdfPCell(new Phrase("DESCRIZIONE",bold));
    h1.setPadding(7);
    h1.setBorder(Rectangle.TOP|Rectangle.BOTTOM);
    h1.setBorderColor(BaseColor.LIGHT_GRAY);
    prodotti.addCell(h1);

    PdfPCell h2=new PdfPCell(new Phrase("IMPORTO",bold));
    h2.setPadding(7);
    h2.setHorizontalAlignment(Element.ALIGN_RIGHT);
    h2.setBorder(Rectangle.TOP|Rectangle.BOTTOM);
    h2.setBorderColor(BaseColor.LIGHT_GRAY);
    prodotti.addCell(h2);

    int numeroRighe=0;
    for(Riga r:righe){
        if(r.is_descrittiva())continue;

        BaseColor sfondo=numeroRighe%2==0?grigioChiaro:BaseColor.WHITE;

        PdfPCell c1=new PdfPCell(new Phrase(r.getDescrizione(),normale));
        c1.setPadding(8);
        c1.setBorder(Rectangle.BOTTOM);
        c1.setBorderColor(BaseColor.LIGHT_GRAY);
        c1.setBackgroundColor(sfondo);
        prodotti.addCell(c1);

        PdfPCell c2=new PdfPCell(new Phrase("€ "+Utility.formatta_prezzo_no_valuta(r.getTotale()),normale));
        c2.setPadding(8);
        c2.setHorizontalAlignment(Element.ALIGN_RIGHT);
        c2.setBorder(Rectangle.BOTTOM);
        c2.setBorderColor(BaseColor.LIGHT_GRAY);
        c2.setBackgroundColor(sfondo);
        prodotti.addCell(c2);

        numeroRighe++;
    }

    if(numeroRighe>0)pdf.add(prodotti);

    // RIGHE DESCRITTIVE CKEDITOR
    for(Riga r:righe){
        if(!r.is_descrittiva())continue;

        String html=Utility.elimina_null(r.getDescrizione());
        if(html.trim().equals(""))continue;

        try{
            List<Element> elementi=HTMLWorker.parseToList(new StringReader(html),null);
            java.util.regex.Matcher matcherTag=java.util.regex.Pattern.compile("<(h[1-3]|p|ul|ol)\\b",java.util.regex.Pattern.CASE_INSENSITIVE).matcher(html);
            for(Element elemento:elementi){

                if(elemento instanceof Paragraph){
                    Paragraph p=(Paragraph)elemento;

                    String tag="p";
                    if(matcherTag.find())tag=matcherTag.group(1).toLowerCase();

                    float dimensione=10;
                    boolean titolo=false;

                    if(tag.equals("h1")){
                        dimensione=14;
                        titolo=true;
                    }else if(tag.equals("h2")){
                        dimensione=12;
                        titolo=true;
                    }else if(tag.equals("h3")){
                        dimensione=11;
                        titolo=true;
                    }

                    p.setAlignment(titolo?Element.ALIGN_LEFT:Element.ALIGN_JUSTIFIED);
                    p.setLeading(dimensione+3);
                    p.setSpacingBefore(titolo?7:0);
                    p.setSpacingAfter(titolo?5:7);

                    for(Chunk chunk:p.getChunks()){
                        chunk.getFont().setSize(dimensione);
                        if(titolo)chunk.getFont().setStyle(Font.BOLD);
                    }
                }
                else if(elemento instanceof com.itextpdf.text.List){
                    com.itextpdf.text.List lista=(com.itextpdf.text.List)elemento;
                    boolean numerata=html.contains("<ol");
                    int numero=1;

                    PdfPTable tabellaLista=new PdfPTable(2);
                    tabellaLista.setWidthPercentage(100);
                    tabellaLista.setWidths(new float[]{4,96});
                    tabellaLista.setSpacingBefore(0);
                    tabellaLista.setSpacingAfter(7);
                    tabellaLista.setSplitLate(false);

                    for(Element voce:lista.getItems()){
                        if(!(voce instanceof ListItem))continue;

                        ListItem item=(ListItem)voce;
                        Font fontLista=new Font(Font.FontFamily.HELVETICA,10,Font.NORMAL,BaseColor.DARK_GRAY);
                        String simbolo=numerata?(numero++)+".":"-";

                        PdfPCell cellaSimbolo=new PdfPCell(new Phrase(simbolo,fontLista));
                        cellaSimbolo.setBorder(Rectangle.NO_BORDER);
                        cellaSimbolo.setPadding(0);
                        cellaSimbolo.setPaddingLeft(8);
                        tabellaLista.addCell(cellaSimbolo);

                        Paragraph testo=new Paragraph();
                        testo.setLeading(13);
                        testo.setAlignment(Element.ALIGN_JUSTIFIED);

                        for(Chunk chunk:item.getChunks()){
                            chunk.getFont().setSize(10);
                            testo.add(chunk);
                        }

                        PdfPCell cellaTesto=new PdfPCell(testo);
                        cellaTesto.setBorder(Rectangle.NO_BORDER);
                        cellaTesto.setPadding(0);
                        cellaTesto.setPaddingBottom(2);
                        tabellaLista.addCell(cellaTesto);
                    }

                    pdf.add(tabellaLista);
                    continue;
                }
                else{
                    for(Chunk chunk:elemento.getChunks()){
                        chunk.getFont().setSize(10);
                    }
                }

                pdf.add(elemento);
            }
        }catch(Exception e){
            Paragraph fallback=new Paragraph(html.replaceAll("<[^>]*>",""),piccolo);
            fallback.setAlignment(Element.ALIGN_JUSTIFIED);
            fallback.setLeading(13);
            fallback.setSpacingAfter(7);
            pdf.add(fallback);
        }
    }
    
    // VALIDITA PREVENTIVO
    String validita=Utility.elimina_null(d.getValidita());
    if(!validita.equals("")){
        Paragraph validitaTitolo=new Paragraph("Validità preventivo:",bold);
        validitaTitolo.setSpacingBefore(5);
        pdf.add(validitaTitolo);

        Paragraph validitaTesto=new Paragraph(validita,normale);
        validitaTesto.setSpacingAfter(5);
        pdf.add(validitaTesto);
    }


    // MODALITA PAGAMENTO
    Paragraph pagamentoTitolo=new Paragraph("Pagamento:",bold);
    pagamentoTitolo.setSpacingBefore(5);
    pdf.add(pagamentoTitolo);

    Paragraph pagamento=new Paragraph(Utility.elimina_null(d.getModalita_pagamento().replaceAll("<br>", "\n")),normale);
    pagamento.setSpacingAfter(5);
    pdf.add(pagamento);
// FIRMA PER ACCETTAZIONE
PdfPTable tabellaFirma=new PdfPTable(2);
tabellaFirma.setWidthPercentage(100);
tabellaFirma.setWidths(new float[]{23,77});
tabellaFirma.setSpacingBefore(25);
tabellaFirma.setSpacingAfter(15);
tabellaFirma.setKeepTogether(true);

PdfPCell cellaTitolo=new PdfPCell(new Phrase("FIRMA PER ACCETTAZIONE",bold));
cellaTitolo.setBorder(Rectangle.NO_BORDER);
cellaTitolo.setVerticalAlignment(Element.ALIGN_MIDDLE);
cellaTitolo.setPadding(0);
tabellaFirma.addCell(cellaTitolo);

PdfPCell cliente_firma=new PdfPCell();
cliente_firma.setBorder(Rectangle.NO_BORDER);
cliente_firma.setPadding(0);
cliente_firma.setVerticalAlignment(Element.ALIGN_MIDDLE);

String firma_cliente=Utility.elimina_null(d.getFirma_cliente());
boolean firmaPresente=false;

// FIRMA GRAFICA
if(!firma_cliente.equals("")){
    try{
        if(firma_cliente.contains(","))firma_cliente=firma_cliente.substring(firma_cliente.indexOf(",")+1);

        byte[] firmaBytes=java.util.Base64.getDecoder().decode(firma_cliente);
        Image imgFirma=Image.getInstance(firmaBytes);
        imgFirma.scaleToFit(200,65);
        imgFirma.setAlignment(Image.ALIGN_LEFT);

        cliente_firma.addElement(imgFirma);
        firmaPresente=true;
    }catch(Exception ex){
        System.err.println("Errore firma PDF: "+ex.getMessage());
    }
}

// VERIFICA OTP
if(d.getOtp_data_ora_verifica()!=null){
    Paragraph dataFirma=new Paragraph("Firmato con OTP da "+d.getCliente_nominativo()+" il "+Utility.converti_datetime_formato_it(d.getOtp_data_ora_verifica())+"\nIP: "+Utility.elimina_null(d.getOtp_ip_string()),piccolo);
    dataFirma.setLeading(9);
    dataFirma.setSpacingBefore(2);
    cliente_firma.addElement(dataFirma);
    firmaPresente=true;
}

// TRATTINO SE NON FIRMATO
if(!firmaPresente){
    cliente_firma.addElement(new Paragraph("________________________________________",bold));
}

tabellaFirma.addCell(cliente_firma);


// RIEPILOGO IVA E TOTALE
PdfPTable riepilogo=new PdfPTable(2);
riepilogo.setWidthPercentage(100);
riepilogo.setWidths(new float[]{60,40});
riepilogo.setSpacingBefore(5);
riepilogo.setKeepTogether(true);

// COLONNA SINISTRA - RIEPILOGO IVA
PdfPCell cellaIva=new PdfPCell();
cellaIva.setBorder(Rectangle.TOP|Rectangle.RIGHT|Rectangle.BOTTOM);
cellaIva.setBorderColor(BaseColor.LIGHT_GRAY);
cellaIva.setPaddingTop(12);
cellaIva.setPaddingBottom(85);
cellaIva.setPaddingLeft(0);
cellaIva.setPaddingRight(12);

PdfPTable tabellaIva=new PdfPTable(3);
tabellaIva.setWidthPercentage(100);
tabellaIva.setWidths(new float[]{55,25,20});

PdfPCell hIva=new PdfPCell(new Phrase("RIEPILOGO IVA",piccolo));
PdfPCell hImponibile=new PdfPCell(new Phrase("IMPONIBILE",piccolo));
PdfPCell hImposte=new PdfPCell(new Phrase("IMPOSTE",piccolo));

for(PdfPCell c:new PdfPCell[]{hIva,hImponibile,hImposte}){
    c.setBorder(Rectangle.NO_BORDER);
    c.setPadding(0);
    c.setPaddingBottom(7);
}
hImponibile.setHorizontalAlignment(Element.ALIGN_RIGHT);
hImposte.setHorizontalAlignment(Element.ALIGN_RIGHT);

tabellaIva.addCell(hIva);
tabellaIva.addCell(hImponibile);
tabellaIva.addCell(hImposte);

PdfPCell vIva=new PdfPCell(new Phrase(Utility.elimina_zero(d.getAliquota())+"%",normale));
PdfPCell vImponibile=new PdfPCell(new Phrase(Utility.formatta_prezzo_no_valuta(d.getImponibile()),normale));
PdfPCell vImposte=new PdfPCell(new Phrase("€ "+Utility.formatta_prezzo_no_valuta(d.getAliquota()*d.getImponibile()/100),normale));

for(PdfPCell c:new PdfPCell[]{vIva,vImponibile,vImposte}){
    c.setBorder(Rectangle.NO_BORDER);
    c.setPadding(0);
}
vImponibile.setHorizontalAlignment(Element.ALIGN_RIGHT);
vImposte.setHorizontalAlignment(Element.ALIGN_RIGHT);

tabellaIva.addCell(vIva);
tabellaIva.addCell(vImponibile);
tabellaIva.addCell(vImposte);

cellaIva.addElement(tabellaIva);
riepilogo.addCell(cellaIva);


// COLONNA DESTRA - TOTALI
PdfPCell cellaTotali=new PdfPCell();
cellaTotali.setBorder(Rectangle.TOP|Rectangle.BOTTOM);
cellaTotali.setBorderColor(BaseColor.LIGHT_GRAY);
cellaTotali.setPadding(12);
cellaTotali.setPaddingRight(0);
cellaTotali.setVerticalAlignment(Element.ALIGN_BOTTOM);

PdfPTable tabellaTotali=new PdfPTable(2);
tabellaTotali.setWidthPercentage(100);
tabellaTotali.setWidths(new float[]{65,35});

PdfPCell t1=new PdfPCell(new Phrase("Imponibile",normale));
PdfPCell t2=new PdfPCell(new Phrase("€ "+Utility.formatta_prezzo_no_valuta(d.getImponibile()),normale));
PdfPCell t3=new PdfPCell(new Phrase("Totale IVA",normale));
PdfPCell t4=new PdfPCell(new Phrase("€ "+Utility.formatta_prezzo_no_valuta(d.getImponibile()*d.getAliquota()/100),normale));

for(PdfPCell c:new PdfPCell[]{t1,t2,t3,t4}){
    c.setBorder(Rectangle.NO_BORDER);
    c.setPadding(2);
}
t2.setHorizontalAlignment(Element.ALIGN_RIGHT);
t4.setHorizontalAlignment(Element.ALIGN_RIGHT);

tabellaTotali.addCell(t1);
tabellaTotali.addCell(t2);
tabellaTotali.addCell(t3);
tabellaTotali.addCell(t4);

cellaTotali.addElement(tabellaTotali);

Paragraph totaleFinale=new Paragraph("€ "+Utility.formatta_prezzo_no_valuta(d.getTotale()),new Font(Font.FontFamily.HELVETICA,23,Font.BOLD,BaseColor.DARK_GRAY));
totaleFinale.setAlignment(Element.ALIGN_RIGHT);
totaleFinale.setSpacingBefore(10);
cellaTotali.addElement(totaleFinale);

riepilogo.addCell(cellaTotali);


// BLOCCO FINALE UNICO
PdfPTable bloccoFinale=new PdfPTable(1);
bloccoFinale.setWidthPercentage(100);
bloccoFinale.setKeepTogether(true);
bloccoFinale.setSplitRows(false);

PdfPCell contenitoreFirma=new PdfPCell();
contenitoreFirma.setBorder(Rectangle.NO_BORDER);
contenitoreFirma.setPadding(0);
contenitoreFirma.addElement(tabellaFirma);
bloccoFinale.addCell(contenitoreFirma);

PdfPCell contenitoreRiepilogo=new PdfPCell();
contenitoreRiepilogo.setBorder(Rectangle.NO_BORDER);
contenitoreRiepilogo.setPadding(0);
contenitoreRiepilogo.addElement(riepilogo);
bloccoFinale.addCell(contenitoreRiepilogo);

pdf.add(bloccoFinale);
%>