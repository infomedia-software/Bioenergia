<%@page import="beans.Pagamento"%>
<%@page import="gestioneDB.GestionePagamento"%>
<%@page import="beans.Riga"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Documento"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="utility.Utility"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="beans.Documento"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Soggetto utente=(Soggetto)request.getAttribute("utente");
    String id_documento=(String)request.getAttribute("id_documento");
    Documento documento=(Documento)request.getAttribute("documento");

    Document pdf=(Document)request.getAttribute("pdf");
    PdfWriter writer=(PdfWriter)request.getAttribute("writer");

    BaseColor AZZURRO=(BaseColor)request.getAttribute("AZZURRO");
    BaseColor GRIGIO=(BaseColor)request.getAttribute("GRIGIO");

    Font font_normale=(Font)request.getAttribute("font_normale");
    Font font_piccolo=(Font)request.getAttribute("font_piccolo");
    Font font_bold=(Font)request.getAttribute("font_bold");
    Font font_titolo=(Font)request.getAttribute("font_titolo");
    Font font_totale=(Font)request.getAttribute("font_totale");
    
    ArrayList<Riga> righe=GestioneDocumento.getIstanza().get_righe_documento(id_documento);
    String cliente="";

    if(Utility.elimina_null(documento.getCliente_privato_azienda()).equalsIgnoreCase("azienda"))
        cliente=Utility.elimina_null(documento.getCliente_ragione_sociale());
    else
        cliente=(Utility.elimina_null(documento.getCliente_cognome())+" "+Utility.elimina_null(documento.getCliente_nome())).trim();

    if(cliente.equals(""))
        cliente=Utility.elimina_null(documento.getCliente_ragione_sociale());

    String localita=Utility.elimina_null(documento.getCliente_localita());

    if(localita.equals(""))
        localita=Utility.elimina_null(documento.getCliente_comune());

    String cf_piva="";

    if(!Utility.elimina_null(documento.getCliente_cf()).equals(""))
        cf_piva=Utility.elimina_null(documento.getCliente_cf());

    if(!Utility.elimina_null(documento.getCliente_piva()).equals("")){
        if(!cf_piva.equals(""))
            cf_piva+=" / ";

        cf_piva+=Utility.elimina_null(documento.getCliente_piva());
    }
%>

<%!
    public PdfPCell cellaCampo(String label,String valore,Font font_piccolo,Font font_normale,BaseColor grigio){

        Paragraph p=new Paragraph();
        p.setLeading(8);

        p.add(new Chunk(label+"\n",font_piccolo));
        p.add(new Chunk(Utility.elimina_null(valore),font_normale));

        PdfPCell cella=new PdfPCell(p);

        cella.setBorder(Rectangle.BOTTOM);
        cella.setBorderColorBottom(grigio);
        cella.setPaddingLeft(1);
        cella.setPaddingRight(8);
        cella.setPaddingTop(2);
        cella.setPaddingBottom(2);
        cella.setMinimumHeight(24);

        return cella;
    }

    public PdfPCell cellaFirma(String titolo,String valore,Font font_piccolo,Font font_normale,BaseColor grigio){

        Paragraph p=new Paragraph();
        p.setLeading(8);
        p.add(new Chunk(titolo+"\n",font_piccolo));
        if(!Utility.elimina_null(valore).equals(""))
            p.add(new Chunk(valore,font_normale));

        PdfPCell cella=new PdfPCell(p);

        cella.setBorder(Rectangle.BOTTOM);
        cella.setBorderColorBottom(grigio);
        cella.setPaddingTop(2);
        cella.setPaddingBottom(4);
        cella.setMinimumHeight(25);

        return cella;
    }
%>

<%
    /*
     * INTESTAZIONE
     */
    String pathIntestazione=application.getRealPath("/img/header_pagina1.png");

    Image imgIntestazione=Image.getInstance(pathIntestazione);

    imgIntestazione.scaleToFit(540,100);
    imgIntestazione.setAlignment(Image.ALIGN_CENTER);
    imgIntestazione.setSpacingAfter(8);

    pdf.add(imgIntestazione);

    /*
     * CLIENTE
     */
    PdfPTable titolo_cliente=new PdfPTable(1);
    titolo_cliente.setWidthPercentage(100);

    PdfPCell titolo_cliente_cella=new PdfPCell(new Phrase("CLIENTE",font_titolo));
    titolo_cliente_cella.setBorder(Rectangle.BOTTOM);
    titolo_cliente_cella.setBorderColorBottom(AZZURRO);
    titolo_cliente_cella.setBorderWidthBottom(0.8f);
    titolo_cliente_cella.setPaddingBottom(2);

    titolo_cliente.addCell(titolo_cliente_cella);
    pdf.add(titolo_cliente);


    PdfPTable tabella_cliente=new PdfPTable(2);
    tabella_cliente.setWidthPercentage(100);
    tabella_cliente.setWidths(new float[]{50,50});
    tabella_cliente.setSpacingAfter(7);

    PdfPCell nominativo=cellaCampo(
        "Cognome - Nome / Azienda",
        cliente,
        font_piccolo,
        font_normale,
        GRIGIO
    );

    nominativo.setColspan(2);
    tabella_cliente.addCell(nominativo);

    tabella_cliente.addCell(
        cellaCampo(
            "Via",
            documento.getCliente_indirizzo(),
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    tabella_cliente.addCell(
        cellaCampo(
            "Cap",
            documento.getCliente_cap(),
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    tabella_cliente.addCell(
        cellaCampo(
            "Località",
            localita,
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    tabella_cliente.addCell(
        cellaCampo(
            "Provincia",
            documento.getCliente_provincia(),
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    tabella_cliente.addCell(
        cellaCampo(
            "Telefono casa",
            documento.getCliente_telefono(),
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    tabella_cliente.addCell(
        cellaCampo(
            "Cellulare",
            documento.getCliente_cellulare(),
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    tabella_cliente.addCell(
        cellaCampo(
            "E-mail",
            documento.getCliente_email(),
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    tabella_cliente.addCell(
        cellaCampo(
            "C.F. / P.IVA",
            cf_piva,
            font_piccolo,
            font_normale,
            GRIGIO
        )
    );

    pdf.add(tabella_cliente);


    /*
     * OGGETTO DEL CONTRATTO
     */
    PdfPTable titolo_oggetto=new PdfPTable(1);
    titolo_oggetto.setWidthPercentage(100);

    PdfPCell titolo_oggetto_cella=new PdfPCell(new Phrase("OGGETTO DEL CONTRATTO",font_titolo));
    titolo_oggetto_cella.setBorder(Rectangle.BOTTOM);
    titolo_oggetto_cella.setBorderColorBottom(AZZURRO);
    titolo_oggetto_cella.setBorderWidthBottom(0.8f);
    titolo_oggetto_cella.setPaddingBottom(2);

    titolo_oggetto.addCell(titolo_oggetto_cella);
    pdf.add(titolo_oggetto);

    String testo_oggetto=
        "Il Cliente conferisce a Bioenergia S.r.l. l'incarico per l'installazione chiavi in mano "
        +"dell'impianto fotovoltaico e/o degli eventuali altri prodotti legati all'efficientamento "
        +"energetico aventi le caratteristiche descritte di seguito e per lo svolgimento dei servizi "
        +"descritti agli articoli 1.1 e 1.2 delle condizioni generali di contratto qui allegate. "
        +"Le condizioni generali di contratto qui allegate formano parte integrante e sostanziale "
        +"del presente contratto.";

    Paragraph oggetto=new Paragraph(testo_oggetto,font_normale);
    oggetto.setLeading(8);
    oggetto.setSpacingBefore(3);
    oggetto.setSpacingAfter(5);

    pdf.add(oggetto);


    /*
     * DESCRIZIONE PRODOTTI E SERVIZI
     */
    PdfPTable titolo_prodotti=new PdfPTable(1);
    titolo_prodotti.setWidthPercentage(100);

    PdfPCell titolo_prodotti_cella=new PdfPCell(new Phrase("DESCRIZIONE DEI PRODOTTI E SERVIZI",font_titolo));
    titolo_prodotti_cella.setBorder(Rectangle.BOTTOM);
    titolo_prodotti_cella.setBorderColorBottom(AZZURRO);
    titolo_prodotti_cella.setPaddingBottom(2);
    titolo_prodotti_cella.setBorderWidthBottom(0.8f);

    titolo_prodotti.addCell(titolo_prodotti_cella);
    pdf.add(titolo_prodotti);


    PdfPTable tabella_prodotti=new PdfPTable(2);
    tabella_prodotti.setWidthPercentage(100);
    tabella_prodotti.setWidths(new float[]{80,20});

    PdfPCell articolo_header=new PdfPCell(new Phrase("Articolo",font_bold));
    articolo_header.setBorder(Rectangle.BOTTOM | Rectangle.RIGHT);
    articolo_header.setBorderColorBottom(AZZURRO);
    articolo_header.setBorderColorRight(AZZURRO);
    articolo_header.setPaddingBottom(3);

    PdfPCell prezzo_header=new PdfPCell(new Phrase("Prezzo IVA inclusa",font_bold));
    prezzo_header.setHorizontalAlignment(Element.ALIGN_RIGHT);
    prezzo_header.setBorder(Rectangle.BOTTOM);
    prezzo_header.setBorderColorBottom(AZZURRO);
    prezzo_header.setPaddingBottom(3);

    tabella_prodotti.addCell(articolo_header);
    tabella_prodotti.addCell(prezzo_header);

    for(Riga riga:righe){
        PdfPCell descrizione=new PdfPCell(new Phrase(riga.getDescrizione(),font_normale));
        descrizione.setBorder(Rectangle.BOTTOM | Rectangle.RIGHT);
        descrizione.setBorderColorBottom(new BaseColor(210,210,210));
        descrizione.setBorderColorRight(AZZURRO);
        descrizione.setMinimumHeight(18);
        descrizione.setVerticalAlignment(Element.ALIGN_MIDDLE);

        PdfPCell totale_riga=new PdfPCell(
            new Phrase(
                String.format("%.2f",riga.getTotale())+" €",
                font_normale
            )
        );

        totale_riga.setBorder(Rectangle.BOTTOM);
        totale_riga.setBorderColorBottom(new BaseColor(210,210,210));
        totale_riga.setMinimumHeight(18);
        totale_riga.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totale_riga.setVerticalAlignment(Element.ALIGN_MIDDLE);

        tabella_prodotti.addCell(descrizione);
        tabella_prodotti.addCell(totale_riga);
    }


    PdfPCell totale_label=new PdfPCell(new Phrase("TOTALE €",font_totale));
    totale_label.setBorder(Rectangle.NO_BORDER);
    totale_label.setHorizontalAlignment(Element.ALIGN_RIGHT);
    totale_label.setPaddingTop(5);

    PdfPCell totale_valore=new PdfPCell(new Phrase(String.format("%.2f",documento.getTotale())+" €",font_totale));

    totale_valore.setBorder(Rectangle.BOX);
    totale_valore.setBorderColor(AZZURRO);
    totale_valore.setHorizontalAlignment(Element.ALIGN_RIGHT);
    totale_valore.setMinimumHeight(22);

    tabella_prodotti.addCell(totale_label);
    tabella_prodotti.addCell(totale_valore);

    pdf.add(tabella_prodotti);


    /*
     * MODALITA PAGAMENTO
     */
    PdfPTable titolo_pagamenti=new PdfPTable(1);
    titolo_pagamenti.setWidthPercentage(100);
    titolo_pagamenti.setSpacingBefore(5);

    PdfPCell titolo_pagamenti_cella=new PdfPCell(new Phrase("MODALITÀ E TERMINI DI PAGAMENTO",font_titolo));
    titolo_pagamenti_cella.setBorder(Rectangle.BOTTOM);
    titolo_pagamenti_cella.setBorderColorBottom(AZZURRO);
    titolo_pagamenti_cella.setBorderWidthBottom(0.8f);
    titolo_pagamenti_cella.setPaddingBottom(2);

    titolo_pagamenti.addCell(titolo_pagamenti_cella);
    pdf.add(titolo_pagamenti);

    Paragraph pagamenti=new Paragraph();
    pagamenti.setFont(font_normale);
    pagamenti.setLeading(10);

    if(documento.getPagamento().contains("pagamento")){
        pagamenti.add("X "+documento.getModalita_pagamento().toUpperCase()+" intestato a \"Bioenergia S.r.l.\"\n");
    for(Pagamento p:GestionePagamento.getIstanza().ricerca_pagamento(" percentuale>0 AND finanziamento='' AND id_documento="+id_documento, "", -1)){
        pagamenti.add("\u00A0\u00A0\u00A0\u00A0- "+Utility.elimina_zero(p.getPercentuale())+"% "+p.getDescrizione()+"\n");
        }
    }else{
        //pagamenti.add("◦ "+documento.getModalita_pagamento().toUpperCase()+" intestato a \"Bioenergia S.r.l.\"\n");
    }

    if(documento.getPagamento().contains("finanziamento")){
        pagamenti.add("X Erogazione in favore di “Bioenergia S.r.l.” del finanziamento sottoscritto dal cliente.\n");
        for(Pagamento p:GestionePagamento.getIstanza().ricerca_pagamento(" percentuale>0 AND finanziamento='si' AND id_documento="+id_documento, "", -1)){
            pagamenti.add("\u00A0\u00A0\u00A0\u00A0- "+Utility.elimina_zero(p.getPercentuale())+"% "+p.getDescrizione()+"\n");
        }
    }else{
        pagamenti.add("Nessuna Erogazione in favore di “Bioenergia S.r.l.” del finanziamento sottoscritto dal cliente.\n");
    }

    pdf.add(pagamenti);


    /*
     * DIRITTO DI RECESSO
     */
    PdfPTable titolo_recesso=new PdfPTable(1);
    titolo_recesso.setWidthPercentage(100);
    titolo_recesso.setSpacingBefore(5);

    PdfPCell titolo_recesso_cella=new PdfPCell(new Phrase("DIRITTO DI RECESSO",font_titolo));

    titolo_recesso_cella.setBorder(Rectangle.BOTTOM);
    titolo_recesso_cella.setBorderColorBottom(AZZURRO);
    titolo_recesso_cella.setBorderWidthBottom(0.8f);
    titolo_recesso_cella.setPaddingBottom(2);

    titolo_recesso.addCell(titolo_recesso_cella);
    pdf.add(titolo_recesso);

    Paragraph recesso=new Paragraph(
        "Ai sensi degli art. 64 e 67 del decreto legislativo del 6 settembre 2005 n. 206, "
        +"il Cliente ha diritto di recedere dal presente contratto senza alcuna penalità "
        +"e senza specificarne il motivo, entro il termine di 14 giorni di calendario "
        +"dalla data di sottoscrizione del presente contratto.",
        font_piccolo
    );

    recesso.setLeading(7);
    recesso.setSpacingBefore(3);
    recesso.setSpacingAfter(4);

    pdf.add(recesso);

    /*
     * LUOGO - DATA - FIRME
     */
    PdfPTable firme=new PdfPTable(2);
    firme.setWidthPercentage(100);
    firme.setWidths(new float[]{50,50});
    firme.setSpacingBefore(3);
    firme.setSpacingAfter(8);

    PdfPCell luogo=new PdfPCell();
    luogo.setBorder(Rectangle.BOTTOM);
    luogo.setBorderColorBottom(new BaseColor(120,120,120));
    luogo.setPaddingLeft(0);
    luogo.setPaddingBottom(3);
    luogo.setMinimumHeight(22);

    Paragraph p_luogo=new Paragraph();
    p_luogo.setLeading(9);
    p_luogo.add(new Chunk("Luogo\n",font_normale));
    p_luogo.add(new Chunk(Utility.elimina_null(documento.getLuogo()),font_normale));
    luogo.addElement(p_luogo);

    PdfPCell data=new PdfPCell();
    data.setBorder(Rectangle.BOTTOM);
    data.setBorderColorBottom(new BaseColor(120,120,120));
    data.setPaddingLeft(0);
    data.setPaddingBottom(3);
    data.setMinimumHeight(22);

    Paragraph p_data=new Paragraph();
    p_data.setLeading(9);
    p_data.add(new Chunk("Data\n",font_normale));
    p_data.add(new Chunk(Utility.elimina_null(Utility.converti_data_formato_it(documento.getData())),font_normale));
    data.addElement(p_data);

    firme.addCell(luogo);
    firme.addCell(data);


    /*
     * FIRMA CLIENTE
     */
    PdfPCell cliente_firma=new PdfPCell();
    cliente_firma.setBorder(Rectangle.BOTTOM);
    cliente_firma.setBorderColorBottom(new BaseColor(120,120,120));
    cliente_firma.setPaddingLeft(0);
    cliente_firma.setPaddingTop(3);
    cliente_firma.setPaddingBottom(2);
    cliente_firma.setMinimumHeight(42);

    cliente_firma.addElement(new Paragraph("Il Cliente",font_normale));

    String firma_cliente=Utility.elimina_null(documento.getFirma_cliente());

    if(!firma_cliente.equals("")){
        try{
            if(firma_cliente.contains(","))
                firma_cliente=firma_cliente.substring(firma_cliente.indexOf(",")+1);

            byte[] firmaBytes=java.util.Base64.getDecoder().decode(firma_cliente);

            Image imgFirma=Image.getInstance(firmaBytes);
            imgFirma.scaleToFit(130,28);
            imgFirma.setAlignment(Image.ALIGN_LEFT);
            imgFirma.setSpacingBefore(2);

            cliente_firma.addElement(imgFirma);

        }catch(Exception ex){
            // firma non valida: lascio vuoto
        }
    }


    /*
    * CONSULENTE
    */
    PdfPCell consulente=new PdfPCell();
    consulente.setBorder(Rectangle.BOTTOM);
    consulente.setBorderColorBottom(new BaseColor(120,120,120));
    consulente.setPaddingLeft(0);
    consulente.setPaddingTop(3);
    consulente.setPaddingBottom(2);
    consulente.setMinimumHeight(42);

    consulente.addElement(new Paragraph("Il vostro Consulente",font_normale));

    String nome_consulente=(Utility.elimina_null(documento.getAutore().getCognome())+" "+Utility.elimina_null(documento.getAutore().getNome()));
    consulente.addElement(new Paragraph(nome_consulente,font_normale));

    firme.addCell(cliente_firma);
    firme.addCell(consulente);

    pdf.add(firme);


    /*
     * LINEA CELESTE SOPRA INFORMATIVE
     */
    PdfPTable linea_informative=new PdfPTable(1);
    linea_informative.setWidthPercentage(100);

    PdfPCell linea=new PdfPCell(new Phrase(""));
    linea.setBorder(Rectangle.TOP);
    linea.setBorderColorTop(AZZURRO);
    linea.setBorderWidthTop(1.2f);
    linea.setFixedHeight(4);

    linea_informative.addCell(linea);

    pdf.add(linea_informative);


    /*
     * INFORMATIVE - 3 COLONNE
     */
    PdfPTable informative=new PdfPTable(3);
    informative.setWidthPercentage(100);
    informative.setWidths(new float[]{26,38,36});
    informative.setSpacingBefore(0);

    Font font_titolo_informativa=new Font(Font.FontFamily.HELVETICA,4.7f,Font.BOLD,new BaseColor(0,110,150));
    Font font_testo_informativa=new Font(Font.FontFamily.HELVETICA,4.3f,Font.NORMAL,BaseColor.DARK_GRAY);


    /*
     * COLONNA 1
     */
    Paragraph inf1=new Paragraph();
    inf1.setLeading(5.1f);
    inf1.add(new Chunk("INFORMATIVA  ",font_titolo_informativa));
    inf1.add(new Chunk(
        "Il Cliente dichiara di essere stato adeguatamente informato in ordine alle caratteristiche tecniche "
        +"dell'offerta, affidabilità e durata dell'impianto, alle specifiche del vigente meccanismo di "
        +"incentivazione c.d. Scambio sul Posto così come, in caso di installazione di prodotti diversi, "
        +"in ordine alle caratteristiche dei prodotti medesimi.",
        font_testo_informativa
    ));

    PdfPCell c1=new PdfPCell(inf1);
    c1.setBorder(Rectangle.RIGHT);
    c1.setBorderColorRight(AZZURRO);
    c1.setPaddingLeft(0);
    c1.setPaddingRight(7);
    c1.setPaddingTop(2);
    c1.setPaddingBottom(5);
    c1.setVerticalAlignment(Element.ALIGN_TOP);

    informative.addCell(c1);


    /*
     * COLONNA 2
     */
    Paragraph inf2=new Paragraph();
    inf2.setLeading(5.1f);

    inf2.add(new Chunk(
        "AUTORIZZAZIONE AL TRATTAMENTO DEI DATI PERSONALI:  ",
        font_titolo_informativa
    ));

    inf2.add(new Chunk(
        "Il Cliente autorizza altresì il trattamento dei propri dati personali sia da parte di Bioenergia S.r.l. "
        +"che da parte dei terzi da questa incaricati della predisposizione delle pratiche connesse alla fornitura "
        +"e installazione, dichiarando di esserne per gli effetti di cui all'art. 13 del D.Lgs. 196/2003, "
        +"di essere stato edotto che i dati personali saranno utilizzati per dare esecuzione alla presente proposta "
        +"e che il loro trattamento potrà avvenire mediante strumenti manuali, informatici o telematici in modo "
        +"strettamente correlato alle finalità del presente ordine. Il conferimento dei dati da parte del Cliente "
        +"è obbligatorio ed un eventuale rifiuto non consentirà a Bioenergia S.r.l. di dare esecuzione alla presente "
        +"proposta. Il Cliente potrà esercitare tutti i diritti di cui all'art. 7 del D.Lgs. n. 196/2003 e, in particolare, "
        +"accedere ai propri dati chiedendone la correzione, l'integrazione e motivatamente il blocco o la cancellazione "
        +"scrivendo al titolare del trattamento: Bioenergia S.r.l. - Via Retrone, 30 - 35135 Padova.",
        font_testo_informativa
    ));

    PdfPCell c2=new PdfPCell(inf2);
    c2.setBorder(Rectangle.RIGHT);
    c2.setBorderColorRight(AZZURRO);
    c2.setPaddingLeft(7);
    c2.setPaddingRight(7);
    c2.setPaddingTop(2);
    c2.setPaddingBottom(5);
    c2.setVerticalAlignment(Element.ALIGN_TOP);

    informative.addCell(c2);


    /*
     * COLONNA 3
     */
    Paragraph inf3=new Paragraph();
    inf3.setLeading(5.1f);

    inf3.add(new Chunk(
        "APPROVAZIONE AI SENSI DEGLI ARTICOLI 1341 E 1342 DEL CODICE CIVILE E DEGLI ARTICOLI 33 E 34 DEL CODICE DEL CONSUMO (D.Lgs. n. 206/2005):  ",
        font_titolo_informativa
    ));

    inf3.add(new Chunk(
        "Ai sensi di quanto previsto dagli artt. 1341 e 1342 del codice civile e negli articoli 33 e 34 del Codice "
        +"del Consumo (D.Lgs. n. 206/2005), il Cliente dichiara di avere letto, esaminato e approvato espressamente "
        +"quanto riportato nei seguenti articoli del presente contratto, dichiarando contestualmente che gli stessi "
        +"articoli sono stati specificamente discussi e sono stati oggetto di trattativa individuale: 1.2.3 e 1.2.4 "
        +"servizio di progettazione, assistenza pratiche autorizzative e connessione dell'impianto - 2.1 modalità di "
        +"esecuzione - 5 garanzia - 6 rinuncia - 7 foro competente.",
        font_testo_informativa
    ));

    PdfPCell c3=new PdfPCell(inf3);
    c3.setBorder(Rectangle.NO_BORDER);
    c3.setPaddingLeft(7);
    c3.setPaddingRight(0);
    c3.setPaddingTop(2);
    c3.setPaddingBottom(5);
    c3.setVerticalAlignment(Element.ALIGN_TOP);

    informative.addCell(c3);

    pdf.add(informative);


    /*
     * FIRME SOTTO LE 3 INFORMATIVE
     */
    PdfPTable firme_informative=new PdfPTable(3);
    firme_informative.setWidthPercentage(100);
    firme_informative.setWidths(new float[]{26,38,36});
    firme_informative.setSpacingBefore(3);

    for(int i=0;i<3;i++){

        PdfPCell firma_inf=new PdfPCell();

        firma_inf.setBorder(Rectangle.BOTTOM);
        firma_inf.setBorderColorBottom(new BaseColor(120,120,120));
        firma_inf.setPaddingLeft(i==0 ? 0 : 7);
        firma_inf.setPaddingRight(i==2 ? 0 : 7);
        firma_inf.setPaddingTop(0);
        firma_inf.setPaddingBottom(2);
        firma_inf.setMinimumHeight(25);

        firma_inf.addElement(new Paragraph("Il Cliente",font_piccolo));

        /*
         * Inserisco la stessa firma cliente sotto ogni informativa
         */
        if(!Utility.elimina_null(documento.getFirma_cliente()).equals("")){
            String firma=Utility.elimina_null(documento.getFirma_cliente());
            if(firma.contains(","))
                firma=firma.substring(firma.indexOf(",")+1);
            byte[] bytes=java.util.Base64.getDecoder().decode(firma);
            Image img=Image.getInstance(bytes);
            img.scaleToFit(85,17);
            img.setAlignment(Image.ALIGN_LEFT);
            firma_inf.addElement(img);
        }
        firme_informative.addCell(firma_inf);
    }
    pdf.add(firme_informative);
%>