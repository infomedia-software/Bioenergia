<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true"%>
<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="beans.Finanziamento"%>
<%@page import="utility.Utility"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="java.util.Base64"%>

<%!
    private PdfPTable tabella(float... larghezze) throws DocumentException{
        PdfPTable t=new PdfPTable(larghezze);
        t.setWidthPercentage(100);
        t.setSpacingBefore(0);
        t.setSpacingAfter(0);
        t.setSplitRows(false);
        return t;
    }

    private PdfPCell cella(String testo,Font font){
        PdfPCell c=new PdfPCell(new Phrase(testo,font));
        c.setBorder(Rectangle.NO_BORDER);
        c.setPadding(1);
        c.setPaddingTop(3);
        c.setPaddingBottom(3);
        c.setMinimumHeight(20);
        c.setVerticalAlignment(Element.ALIGN_MIDDLE);
        return c;
    }

    private PdfPCell campo(String etichetta,String valore,Font font) throws DocumentException{
        PdfPCell c=new PdfPCell();
        c.setBorder(Rectangle.NO_BORDER);
        c.setPaddingLeft(1);
        c.setPaddingRight(5);
        c.setPaddingTop(3);
        c.setPaddingBottom(3);
        c.setMinimumHeight(20);;
        c.setVerticalAlignment(Element.ALIGN_MIDDLE);

        float larghezzaEtichetta=etichetta.length()*font.getSize()*0.55f+6;

        PdfPTable interno=new PdfPTable(2);
        interno.setWidthPercentage(100);
        interno.setWidths(new float[]{larghezzaEtichetta,100});
        interno.setSpacingBefore(0);
        interno.setSpacingAfter(0);

        PdfPCell label=new PdfPCell(new Phrase(etichetta+" ",font));
        label.setBorder(Rectangle.NO_BORDER);
        label.setPadding(0);
        label.setNoWrap(true);
        label.setVerticalAlignment(Element.ALIGN_MIDDLE);

        PdfPCell valoreCella=new PdfPCell(new Phrase(Utility.elimina_null(valore),font));
        valoreCella.setBorder(Rectangle.BOTTOM);
        valoreCella.setBorderWidthBottom(0.5f);
        valoreCella.setPaddingTop(2);
        valoreCella.setPaddingBottom(4);
        valoreCella.setNoWrap(true);
        valoreCella.setVerticalAlignment(Element.ALIGN_MIDDLE);

        interno.addCell(label);
        interno.addCell(valoreCella);
        c.addElement(interno);
        return c;
    }

    private PdfPCell check(String etichetta,boolean selezionato,Font font) throws DocumentException{
        PdfPCell c=new PdfPCell();
        c.setBorder(Rectangle.NO_BORDER);
        c.setPadding(1);
        c.setPaddingTop(3);
        c.setPaddingBottom(3);
        c.setMinimumHeight(20);
        c.setVerticalAlignment(Element.ALIGN_MIDDLE);

        PdfPTable interno=new PdfPTable(2);
        interno.setWidthPercentage(100);
        interno.setWidths(new float[]{14,100});

        PdfPCell quadrato=new PdfPCell(new Phrase(selezionato?"X":"",font));
        quadrato.setFixedHeight(12);
        quadrato.setBorder(Rectangle.BOX);
        quadrato.setBorderWidth(0.8f);
        quadrato.setHorizontalAlignment(Element.ALIGN_CENTER);
        quadrato.setVerticalAlignment(Element.ALIGN_MIDDLE);
        quadrato.setPadding(0);

        PdfPCell descrizione=new PdfPCell(new Phrase(etichetta,font));
        descrizione.setBorder(Rectangle.NO_BORDER);
        descrizione.setPaddingLeft(4);
        descrizione.setVerticalAlignment(Element.ALIGN_MIDDLE);

        interno.addCell(quadrato);
        interno.addCell(descrizione);
        c.addElement(interno);
        return c;
    }

    private PdfPCell cellaFirma(String titolo,String firma,Font font){
        PdfPCell c=new PdfPCell();
        c.setBorder(Rectangle.NO_BORDER);
        c.setPadding(4);
        c.setHorizontalAlignment(Element.ALIGN_CENTER);

        Paragraph p=new Paragraph(titolo,font);
        p.setAlignment(Element.ALIGN_CENTER);
        p.setSpacingAfter(6);
        c.addElement(p);

        PdfPTable spazioFirma=new PdfPTable(1);
        spazioFirma.setWidthPercentage(75);

        PdfPCell area=new PdfPCell();
        area.setBorder(Rectangle.BOTTOM);
        area.setBorderWidthBottom(0.6f);
        area.setFixedHeight(43);
        area.setHorizontalAlignment(Element.ALIGN_CENTER);
        area.setVerticalAlignment(Element.ALIGN_BOTTOM);
        area.setPadding(1);

        String firmaBase64=Utility.elimina_null(firma);

        if(!firmaBase64.equals("")){
            try{
                if(firmaBase64.contains(",")) firmaBase64=firmaBase64.substring(firmaBase64.indexOf(",")+1);
                Image img=Image.getInstance(Base64.getDecoder().decode(firmaBase64));
                img.scaleToFit(155,38);
                img.setAlignment(Image.ALIGN_CENTER);
                area.addElement(img);
            }catch(Exception e){
                System.out.println("Errore firma finanziamento: "+e.getMessage());
            }
        }

        spazioFirma.addCell(area);
        c.addElement(spazioFirma);
        return c;
    }

    private void aggiungiTitolo(Document pdf,String testo,Font font,float prima,float dopo) throws DocumentException{
        Paragraph p=new Paragraph(testo,font);
        p.setSpacingBefore(prima);
        p.setSpacingAfter(dopo);
        pdf.add(p);
    }
%>

<%
    Finanziamento f=(Finanziamento)request.getAttribute("finanziamento");
    Documento d=(Documento)request.getAttribute("documento");
    Document pdf=(Document)request.getAttribute("pdf");

    Font normale=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.BLACK);
    Font piccolo=new Font(Font.FontFamily.HELVETICA,8.5f,Font.NORMAL,BaseColor.BLACK);
    Font grassetto=new Font(Font.FontFamily.HELVETICA,9.5f,Font.BOLD,BaseColor.BLACK);
    Font titolo=new Font(Font.FontFamily.HELVETICA,13,Font.BOLD,BaseColor.BLACK);

    // INTESTAZIONE

    Paragraph intestazione=new Paragraph("MODULO RACCOLTA DATI CLIENTE - AVVERA",titolo);
    intestazione.setAlignment(Element.ALIGN_CENTER);
    intestazione.setSpacingAfter(15);
    pdf.add(intestazione);

    // IMPORTO

    PdfPTable importo=tabella(1);
    importo.addCell(campo("IMPORTO RICHIESTO DA FINANZIARE","€ "+Utility.formatta_prezzo_no_valuta(f.getImporto()),grassetto));
    pdf.add(importo);

    // TIPO FINANZIAMENTO

    PdfPTable finanziamento=tabella(2,2,2,1);
    finanziamento.setSpacingBefore(8);
    finanziamento.setSpacingAfter(10);
    
    if(f.is_tipo_standard())
        finanziamento.addCell(check("TASSO STANDARD",true,normale));
    else
        finanziamento.addCell(check("TASSO ZERO",true,normale));
    finanziamento.addCell(campo("NUMERO RATE      ",f.getNumero_rate()+"",normale));
    finanziamento.addCell(cella("PRIMA RATA A",normale));

    PdfPCell primaRata=new PdfPCell();
    primaRata.setBorder(Rectangle.NO_BORDER);
    primaRata.setPadding(0);

    PdfPTable opzioniRata=tabella(1);
    opzioniRata.addCell(check("30 GIORNI","30".equals(f.getPrima_rata()),normale));
    if(f.is_tipo_standard())
        opzioniRata.addCell(check("120 GIORNI","120".equals(f.getPrima_rata()),normale));

    primaRata.addElement(opzioniRata);
    finanziamento.addCell(primaRata);

    pdf.add(finanziamento);

    // DATI RICHIEDENTE

    aggiungiTitolo(pdf,"DATI RICHIEDENTE",grassetto,6,5);

    PdfPTable riga1=tabella(2,2,3);
    riga1.addCell(campo("Cognome",f.getCognome(),normale));
    riga1.addCell(campo("Nome",f.getNome(),normale));
    riga1.addCell(campo("Codice Fiscale",f.getCf(),normale));
    pdf.add(riga1);

    PdfPTable riga2=tabella(2,3,1,3);
    riga2.addCell(campo("Nato il",Utility.converti_data_formato_it(f.getData_nascita())+"",normale));
    riga2.addCell(campo("A",f.getLuogo_nascita(),normale));
    riga2.addCell(campo("Prov.      ",f.getProvincia_nascita(),normale));
    riga2.addCell(campo("Cittadinanza",f.getCittadinanza(),normale));
    pdf.add(riga2);

    PdfPTable riga3=tabella(3,3,2);
    riga3.addCell(campo("Seconda cittadinanza",f.getSeconda_cittadinanza(),normale));
    riga3.addCell(campo("Doc. identità",f.getDocumento_tipo(),normale));
    riga3.addCell(campo("N.",f.getDocumento_numero(),normale));
    pdf.add(riga3);

    PdfPTable riga4=tabella(3,2,3);
    riga4.addCell(campo("Rilasciato da",f.getDocumento_rilasciato_da(),normale));
    riga4.addCell(campo("Il",Utility.converti_data_formato_it(f.getDocumento_rilasciato_il()),normale));
    riga4.addCell(campo("Numero cellulare",f.getCellulare(),normale));
    pdf.add(riga4);

    PdfPTable riga5=tabella(3,4,1);
    riga5.addCell(campo("E-mail",f.getEmail(),normale));
    riga5.addCell(campo("Indirizzo residenza",f.getIndirizzo(),normale));
    riga5.addCell(campo("N.","",normale));
    pdf.add(riga5);

    PdfPTable riga6=tabella(2,4,2,2);
    riga6.addCell(campo("Cap.",f.getCap(),normale));
    riga6.addCell(campo("Località",f.getLocalita(),normale));
    riga6.addCell(campo("Prov.",f.getProvincia(),normale));
    riga6.addCell(campo("Dal",f.getIndirizzo_dal(),normale));
    pdf.add(riga6);

    PdfPTable riga7=tabella(1);
    riga7.addCell(campo("Indirizzo precedente",f.getIndirizzo_precedente(),normale));
    pdf.add(riga7);

    // RESIDENZA

    PdfPTable residenza=tabella(1,1,2,1,1);
    residenza.setSpacingBefore(3);
    residenza.setSpacingAfter(3);

    residenza.addCell(check("Proprietà","Proprietà".equalsIgnoreCase(f.getResidenza()),piccolo));
    residenza.addCell(check("Affitto","Affitto".equalsIgnoreCase(f.getResidenza()),piccolo));
    residenza.addCell(check("Presso genitori/terzi","Presso genitori/terzi".equalsIgnoreCase(f.getResidenza()),piccolo));
    residenza.addCell(check("Uso gratuito","Uso gratuito".equalsIgnoreCase(f.getResidenza()),piccolo));
    residenza.addCell(check("Altro","Altro".equalsIgnoreCase(f.getResidenza()),piccolo));
    pdf.add(residenza);

    // CONTRATTO LAVORO

    PdfPTable contratto1=tabella(2,3,3);
    contratto1.addCell(cella("Tipo di contratto lavoro:",normale));
    contratto1.addCell(check("Tempo indeterminato","Tempo indeterminato".equalsIgnoreCase(f.getTipo_contratto()),normale));
    contratto1.addCell(campo("(MM/AA)","",normale));
    pdf.add(contratto1);

    PdfPTable contratto2=tabella(2,3,3);
    contratto2.addCell(cella("",normale));
    contratto2.addCell(check("Tempo determinato","Tempo determinato".equalsIgnoreCase(f.getTipo_contratto()),normale));
    contratto2.addCell(campo("Scadenza (MM/AA)",f.getScadenza_contratto(),normale));
    pdf.add(contratto2);

    PdfPTable lavoro1=tabella(1,1);
    lavoro1.addCell(campo("Professione",f.getProfessione(),normale));
    lavoro1.addCell(campo("Settore attività",f.getProfessione_settore(),normale));
    pdf.add(lavoro1);

    PdfPTable lavoro2=tabella(1,1);
    lavoro2.addCell(campo("Datore di lavoro",f.getDatore_lavoro(),normale));
    lavoro2.addCell(campo("Reddito (mensile netto)",f.getReddito(),normale));
    pdf.add(lavoro2);

    // STATO CIVILE

    PdfPTable famiglia=tabella(1,1,1,2,1);
    famiglia.setSpacingBefore(5);
    famiglia.setSpacingAfter(5);

    famiglia.addCell(check("Celibe","Celibe/Nubile".equalsIgnoreCase(f.getStato_civile()),piccolo));
    famiglia.addCell(check("Sposato","Sposato/a".equalsIgnoreCase(f.getStato_civile()),piccolo));
    famiglia.addCell(check("Convivente","Convivente".equalsIgnoreCase(f.getStato_civile()),piccolo));
    famiglia.addCell(check("Separato/divorziato","Separato/a".equalsIgnoreCase(f.getStato_civile()) || "Divorziato/a".equalsIgnoreCase(f.getStato_civile()),piccolo));
    famiglia.addCell(campo("Nr. figli",f.getNumero_figli(),piccolo));
    pdf.add(famiglia);

    // IBAN

    PdfPTable iban=tabella(1);
    iban.setSpacingBefore(5);
    iban.setSpacingAfter(8);
    iban.addCell(campo("IBAN",f.getIban(),normale));
    pdf.add(iban);

   
    
    // DATI GARANTE
    boolean garante_presente=f.is_garante_presente();
    aggiungiTitolo(pdf,"DATI GARANTE (coniuge/convivente)",grassetto,6,5);

    PdfPTable garante1=tabella(2,2,3);
    garante1.addCell(campo("Nome",garante_presente?f.getGarante_nome():"",normale));
    garante1.addCell(campo("Cognome",garante_presente?f.getGarante_cognome():"",normale));
    garante1.addCell(campo("Nato il",garante_presente && f.getGarante_data_nascita()!=null?Utility.converti_data_formato_it(f.getGarante_data_nascita()+""):"",normale));
    pdf.add(garante1);

    PdfPTable garante2=tabella(2,2,3);
    garante2.addCell(campo("A",garante_presente?f.getGarante_luogo_nascita():"",normale));
    garante2.addCell(campo("Cittadinanza",garante_presente?f.getGarante_cittadinanza():"",normale));
    garante2.addCell(campo("Codice Fiscale",garante_presente?f.getGarante_cf():"",normale));
    pdf.add(garante2);

    PdfPTable garante3=tabella(3,2,2,2);
    garante3.addCell(campo("Documento d'identità",garante_presente?f.getGarante_documento_tipo():"",normale));
    garante3.addCell(campo("Nr.",garante_presente?f.getGarante_documento_numero():"",normale));
    garante3.addCell(campo("Ril. il",garante_presente?Utility.converti_data_formato_it(f.getGarante_documento_rilasciato_il()):"",normale));
    garante3.addCell(campo("Da",garante_presente?f.getGarante_documento_rilasciato_da():"",normale));
    pdf.add(garante3);

    PdfPTable garante4=tabella(1,1);
    garante4.addCell(campo("Professione",garante_presente?f.getGarante_professione():"",normale));
    garante4.addCell(campo("Reddito (netto mensile)",garante_presente?f.getGarante_reddito():"",normale));
    pdf.add(garante4);

    PdfPTable garante5=tabella(1,1);
    garante5.addCell(campo("Numero cellulare",garante_presente?f.getGarante_cellulare():"",normale));
    garante5.addCell(campo("Email",garante_presente?f.getGarante_email():"",normale));
    pdf.add(garante5);

    // PERSONA POLITICAMENTE ESPOSTA

    PdfPTable esposto=tabella(5,1,1);
    esposto.setSpacingBefore(12);
    esposto.setSpacingAfter(8);

    esposto.addCell(cella("Dichiaro di essere una persona politicamente esposta",normale));
    esposto.addCell(check("SI",garante_presente && "si".equalsIgnoreCase(f.getGarante_esposto()),normale));
    esposto.addCell(check("NO",garante_presente && "no".equalsIgnoreCase(f.getGarante_esposto()),normale));
    pdf.add(esposto);

    // FIRME
    PdfPTable firme=tabella(1,1);
    firme.setSpacingBefore(12);
    firme.setKeepTogether(true);

    PdfPCell cliente_firma=cellaFirma("Firma richiedente",Utility.elimina_null(d.getFirma_cliente()),normale);

    if(d.getOtp_data_ora_verifica()!=null){
        Paragraph data_firma=new Paragraph("Firmato con OTP da "+Utility.elimina_null(f.getCognome())+" "+Utility.elimina_null(f.getNome())+" il "+Utility.converti_datetime_formato_it(d.getOtp_data_ora_verifica())+"\nIP: "+Utility.elimina_null(d.getOtp_ip()),piccolo);
        data_firma.setAlignment(Element.ALIGN_CENTER);
        data_firma.setSpacingBefore(5);
        cliente_firma.addElement(data_firma);
    }

    firme.addCell(cliente_firma);

    PdfPCell garante_firma=cellaFirma("Firma garante",garante_presente?Utility.elimina_null(f.getFirma_garante()):"",normale);

    if(f.is_garante_presente() && f.getOtp_data_ora_verifica_garante()!=null){
        Paragraph data_firma_garante=new Paragraph("Firmato con OTP da "+Utility.elimina_null(f.getGarante_cognome())+" "+Utility.elimina_null(f.getGarante_nome())+" il "+Utility.converti_datetime_formato_it(f.getOtp_data_ora_verifica_garante())+"\nIP: "+Utility.elimina_null(f.getOtp_ip_garante()),piccolo);
        data_firma_garante.setAlignment(Element.ALIGN_CENTER);
        data_firma_garante.setSpacingBefore(5);
        garante_firma.addElement(data_firma_garante);
    }

    firme.addCell(garante_firma);

    pdf.add(firme);

%>
