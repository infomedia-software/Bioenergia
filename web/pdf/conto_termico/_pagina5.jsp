
<%@page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>

<%!
    private PdfPCell cellaTesto(String testo,Font font,int allineamento){
        PdfPCell c=new PdfPCell(new Phrase(testo,font));
        c.setBorder(Rectangle.NO_BORDER);
        c.setPadding(0);
        c.setHorizontalAlignment(allineamento);
        return c;
    }

    private void aggiungiParagrafo(Document pdf,String testo,Font font,float prima,float dopo,int allineamento) throws DocumentException{
        Paragraph p=new Paragraph(testo,font);
        p.setAlignment(allineamento);
        p.setSpacingBefore(prima);
        p.setSpacingAfter(dopo);
        p.setLeading(14);
        pdf.add(p);
    }

    private void rigaOrizzontale(PdfContentByte cb,float y){
        cb.saveState();
        cb.setColorStroke(BaseColor.GRAY);
        cb.setLineWidth(2);
        cb.moveTo(35,y);
        cb.lineTo(560,y);
        cb.stroke();
        cb.restoreState();
    }
%>

<%
    Documento d=(Documento)request.getAttribute("documento");
    Document pdf=(Document)request.getAttribute("pdf");
    PdfWriter writer=(PdfWriter)request.getAttribute("writer");

    PdfContentByte sopra=writer.getDirectContent();

    Font normale=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.BLACK);
    Font grassetto=new Font(Font.FontFamily.HELVETICA,9,Font.BOLD,BaseColor.BLACK);
    Font titolo=new Font(Font.FontFamily.HELVETICA,14,Font.BOLD,BaseColor.BLACK);
    Font sottotitolo=new Font(Font.FontFamily.HELVETICA,10,Font.BOLDITALIC,BaseColor.BLACK);
    Font sezione=new Font(Font.FontFamily.HELVETICA,10,Font.BOLD,BaseColor.BLACK);
    Font piccolo=new Font(Font.FontFamily.HELVETICA,7,Font.NORMAL,BaseColor.GRAY);

    // =====================================================
    // DATI MANDANTE (CLIENTE)
    // =====================================================

    boolean azienda=Utility.elimina_null(d.getCliente_privato_azienda()).equalsIgnoreCase("azienda");

    String cliente=azienda ? Utility.elimina_null(d.getCliente_ragione_sociale()) : (Utility.elimina_null(d.getCliente_nome())+" "+Utility.elimina_null(d.getCliente_cognome())).trim();

    String indirizzo=Utility.elimina_null(d.getCliente_indirizzo());
    String comune=Utility.elimina_null(d.getCliente_comune());
    String cap=Utility.elimina_null(d.getCliente_cap());
    String cf=Utility.elimina_null(d.getCliente_cf());
    String piva=Utility.elimina_null(d.getCliente_piva());

    String luogo_nascita=Utility.elimina_null(d.getCliente_luogo_nascita());
    String data_nascita=Utility.elimina_null(Utility.converti_data_formato_it(d.getCliente_data_nascita()));

    // =====================================================
    // DATI MANDATARIO (DA VERIFICARE)
    // =====================================================

    String mandatario="BIOENERGIA S.R.L.";
    String mandatario_indirizzo="VIA PETRONE N. 33";
    String mandatario_comune="PADOVA";
    String mandatario_provincia="PD";
    String mandatario_piva="04543770285";
    String mandatario_cf="04543770285";
    String mandatario_rappresentante="Massimiliano Tignola";
    String mandatario_luogo_nascita="Padova";
    String mandatario_data_nascita="02/10/1973";
    String mandatario_iban="IT23O0503412100000000000711";

    // =====================================================
    // INTESTAZIONE
    // =====================================================

    PdfPTable intestazione=new PdfPTable(new float[]{60,40});
    intestazione.setWidthPercentage(100);

    String percorsoLogo=application.getRealPath("/pdf/conto_termico/img/gse.png");
    Image logoGSE=Image.getInstance(percorsoLogo);
    logoGSE.scaleToFit(110,65);
    logoGSE.setAlignment(Image.ALIGN_LEFT);

    PdfPCell logo=new PdfPCell();
    logo.setBorder(Rectangle.NO_BORDER);
    logo.setPadding(0);
    logo.setMinimumHeight(70);
    logo.addElement(logoGSE);

    intestazione.addCell(logo);

    PdfPCell richiesta=cellaTesto("RICHIESTA CODICE\nIDENTIFICATIVO\n\nn.: ....................",grassetto,Element.ALIGN_RIGHT);
    intestazione.addCell(richiesta);

    pdf.add(intestazione);

    rigaOrizzontale(sopra,730);

    // =====================================================
    // TITOLO
    // =====================================================

    aggiungiParagrafo(pdf,"MANDATO IRREVOCABILE ALL'INCASSO",titolo,20,2,Element.ALIGN_CENTER);
    aggiungiParagrafo(pdf,"(Incentivi ai sensi del D.M. 07/08/2025)",sottotitolo,0,22,Element.ALIGN_CENTER);

    aggiungiParagrafo(pdf,"TRA",sezione,0,18,Element.ALIGN_CENTER);

    // =====================================================
    // MANDANTE
    // =====================================================

    String testoMandante;

    if(azienda){
        testoMandante="La società "+cliente+", con sede in "+indirizzo+", comune di "+comune+" ("+d.getCliente_provincia()+"), partita IVA "+piva+", codice fiscale "+cf+", rappresentata da "+Utility.elimina_null(d.getMandante_nome())+" "+Utility.elimina_null(d.getMandante_cognome())+", di seguito denominata per brevità \"Mandante\".";
    }else{
        testoMandante="Il/la sottoscritto/a "+cliente+", nato/a a "+luogo_nascita+" il "+data_nascita+", residente in Via "+indirizzo+", comune di "+comune+" ("+d.getCliente_provincia()+"), codice fiscale "+cf+", di seguito denominato/a per brevità \"Mandante\".";
    }

    aggiungiParagrafo(pdf,testoMandante,normale,0,15,Element.ALIGN_JUSTIFIED);

    aggiungiParagrafo(pdf,"E",sezione,0,15,Element.ALIGN_CENTER);

    // =====================================================
    // MANDATARIO
    // =====================================================

    String testoMandatario=mandatario
        +" con sede in "+mandatario_indirizzo
        +", comune di "+mandatario_comune
        +" ("+mandatario_provincia+")"
        +", partita IVA "+mandatario_piva
        +", codice fiscale "+mandatario_cf
        +", rappresentata da "+mandatario_rappresentante
        +", nato/a a "+mandatario_luogo_nascita
        +" il "+mandatario_data_nascita
        +" nella qualità di legale rappresentante, di seguito denominato/a per brevità \"Mandatario\".";

    aggiungiParagrafo(pdf,testoMandatario,normale,0,18,Element.ALIGN_JUSTIFIED);

    // =====================================================
    // PREMESSE
    // =====================================================

    aggiungiParagrafo(pdf,
        "Premesso che il Mandante ha realizzato interventi per l'incremento dell'efficienza energetica e per la produzione di energia termica per i quali presenterà Richiesta di Concessione Incentivi al GSE ai sensi del DM del 07/08/2025;",
        normale,0,14,Element.ALIGN_JUSTIFIED);

    aggiungiParagrafo(pdf,"ciò premesso e considerato, le parti convengono che:",grassetto,0,22,Element.ALIGN_LEFT);

    // =====================================================
    // ARTICOLO 1
    // =====================================================

    aggiungiParagrafo(pdf,"Art. 1 - Oggetto",sezione,0,12,Element.ALIGN_CENTER);

    aggiungiParagrafo(pdf,
        "Il Mandante, ai sensi dell'art. 1723, comma 2, c.c., conferisce a favore del Mandatario mandato irrevocabile ad incassare tutti i crediti dal medesimo vantati verso il GSE che deriveranno dall'accoglimento da parte di GSE della Richiesta di Concessione Incentivi di cui alle premesse.",
        normale,0,20,Element.ALIGN_JUSTIFIED);

    // =====================================================
    // ARTICOLO 2
    // =====================================================

    aggiungiParagrafo(pdf,"Art. 2 - Destinazione delle somme incassate",sezione,0,12,Element.ALIGN_CENTER);

    aggiungiParagrafo(pdf,
        "Il GSE provvederà a pagare il credito, al netto dei corrispettivi spettanti al GSE, ai sensi del DM del 07/08/2025, direttamente in favore del Mandatario, mediante bonifico bancario sul seguente codice IBAN: "+mandatario_iban,
        normale,0,10,Element.ALIGN_JUSTIFIED);

    // =====================================================
    // FOOTER
    // =====================================================

    rigaOrizzontale(sopra,75);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Gestore dei Servizi Energetici - GSE S.p.A.",piccolo),35,62,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Sede legale: 00197 Roma, V.le Maresciallo Pilsudski, 92",piccolo),35,51,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("www.gse.it",piccolo),35,40,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_RIGHT,new Phrase("Pagina 1 di 2",piccolo),560,40,0);
%>
