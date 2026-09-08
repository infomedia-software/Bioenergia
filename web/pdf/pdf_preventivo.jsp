<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="com.itextpdf.text.Element"%>
<%@page import="com.itextpdf.text.Font"%>
<%@page import="com.itextpdf.text.FontFactory"%>
<%@page import="com.itextpdf.text.Image"%>
<%@page import="com.itextpdf.text.PageSize"%>
<%@page import="com.itextpdf.text.Paragraph"%>
<%@page import="com.itextpdf.text.Phrase"%>
<%@page import="com.itextpdf.text.Rectangle"%>
<%@page import="com.itextpdf.text.pdf.ColumnText"%>
<%@page import="com.itextpdf.text.pdf.PdfContentByte"%>
<%@page import="com.itextpdf.text.pdf.PdfPCell"%>
<%@page import="com.itextpdf.text.pdf.PdfPTable"%>
<%@page import="com.itextpdf.text.pdf.PdfPageEventHelper"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.DecimalFormatSymbols"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Locale"%>
<%@page import="beans.Preventivo"%>
<%@page import="beans.PreventivoJob"%>
<%@page import="beans.PreventivoJobTiratura"%>
<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestionePreventivo"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="utility.Utility"%>
<%@page contentType="application/pdf" pageEncoding="UTF-8"%>

<%!
    /*
     * COLORI
     * Per modificare la grafica del PDF intervieni principalmente qui.
     */
    private static final BaseColor COLORE_TESTO = new BaseColor(20, 20, 20);
    private static final BaseColor COLORE_TESTO_SECONDARIO = new BaseColor(90, 90, 90);
    private static final BaseColor COLORE_LINEA = new BaseColor(190, 190, 190);
    private static final BaseColor COLORE_INTESTAZIONE_TABELLA = new BaseColor(242, 242, 242);
    private static final BaseColor COLORE_RIGA_ALTERNATA = new BaseColor(249, 249, 249);

    /*
     * TESTI
     */
    private String testo(String valore){
        return valore==null ? "" : valore.trim();
    }

    /*
     * Converte i semplici tag HTML usati nelle textarea in caratteri leggibili
     * nel PDF.
     */
    private String testo_pdf(String valore){
        valore = testo(valore);
        valore = valore.replaceAll("(?i)<br\\s*/?>", "\n");
        valore = valore.replaceAll("(?i)</p>", "\n");
        valore = valore.replaceAll("(?i)<p[^>]*>", "");
        valore = valore.replaceAll("<[^>]+>", "");
        valore = valore.replace("&nbsp;", " ");
        valore = valore.replace("&amp;", "&");
        valore = valore.replace("&quot;", "\"");
        valore = valore.replace("&#39;", "'");
        valore = valore.replace("&lt;", "<");
        valore = valore.replace("&gt;", ">");
        return valore.trim();
    }

    /*
     * CELLA SENZA BORDO
     */
    private PdfPCell cella_senza_bordo(Phrase contenuto, int allineamento){
        PdfPCell cella = new PdfPCell(contenuto);
        cella.setBorder(Rectangle.NO_BORDER);
        cella.setHorizontalAlignment(allineamento);
        cella.setVerticalAlignment(Element.ALIGN_TOP);
        cella.setPadding(0);
        return cella;
    }

    /*
     * CELLA DELLA TABELLA TIRATURE
     */
    private PdfPCell cella_tiratura(Phrase contenuto, int allineamento, BaseColor sfondo, int bordo){
        PdfPCell cella = new PdfPCell(contenuto);
        cella.setHorizontalAlignment(allineamento);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cella.setPaddingTop(4);
        cella.setPaddingBottom(4);
        cella.setPaddingLeft(5);
        cella.setPaddingRight(5);
        cella.setBackgroundColor(sfondo);
        cella.setBorder(bordo);
        cella.setBorderColor(COLORE_LINEA);
        return cella;
    }

    /*
     * FORMATTAZIONE IMPORTI
     * Gli importi interi vengono mostrati senza decimali.
     */
    private String formatta_importo(double valore, DecimalFormat formato_intero, DecimalFormat formato_decimale){
        if(Math.abs(valore-Math.rint(valore))<0.00001)
            return formato_intero.format(valore);
        return formato_decimale.format(valore);
    }

    /*
     * FOOTER
     */
    private static class EventoPagina extends PdfPageEventHelper{
        private final Font font_footer = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, BaseColor.BLACK);
        private final Font font_footer_grassetto = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD, BaseColor.BLACK);
        private final Font font_pagina = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, new BaseColor(90, 90, 90));

        @Override
        public void onEndPage(PdfWriter writer, Document document){
            try{
                PdfContentByte canvas = writer.getDirectContent();
                float x_sinistra = document.left();
                float x_destra = document.right();
                float y_footer = 49;

                canvas.saveState();
                canvas.setColorStroke(COLORE_LINEA);
                canvas.setLineWidth(0.5f);
                canvas.moveTo(x_sinistra, y_footer+27);
                canvas.lineTo(x_destra, y_footer+27);
                canvas.stroke();
                canvas.restoreState();

                ColumnText.showTextAligned(
                    canvas,
                    Element.ALIGN_LEFT,
                    new Phrase("Bioenergia srl", font_footer_grassetto),
                    x_sinistra,
                    y_footer+15,
                    0
                );

                ColumnText.showTextAligned(
                    canvas,
                    Element.ALIGN_LEFT,
                    new Phrase("Via Vanoni, 9/11 - 41043 Formigine (MO) Italia - Tel. +39 059 556600 - www.golinelli.it - mail: goli@golinelli.it", font_footer),
                    x_sinistra,
                    y_footer+5,
                    0
                );

                ColumnText.showTextAligned(
                    canvas,
                    Element.ALIGN_LEFT,
                    new Phrase("Cod. Fisc. e P. IVA n. 00869310367 - Iscriz. R.E.A. MO n. 190751 - codice univoco 1N74KED", font_footer),
                    x_sinistra,
                    y_footer-5,
                    0
                );

                ColumnText.showTextAligned(
                    canvas,
                    Element.ALIGN_RIGHT,
                    new Phrase("Pagina "+writer.getPageNumber(), font_pagina),
                    x_destra,
                    y_footer-5,
                    0
                );
            }
            catch(Exception e){
                e.printStackTrace();
            }
        }
    }
%>

<%
    /*
     * RECUPERO PREVENTIVO
     */
    String id_preventivo = Utility.elimina_null(request.getParameter("id_preventivo"));

    if(id_preventivo.equals("")){
        response.reset();
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().print("Preventivo non valido");
        return;
    }

    Preventivo preventivo = GestionePreventivo.getIstanza().get_preventivo(id_preventivo);

    if(preventivo==null){
        response.reset();
        response.setContentType("text/plain;charset=UTF-8");
        response.getWriter().print("Preventivo non trovato");
        return;
    }

    Soggetto cliente = GestioneSoggetto.getIstanza().get_soggetto(preventivo.getCliente().getId());

    ArrayList<PreventivoJob> lista_preventivo_job =
        GestionePreventivo.getIstanza().ricerca_preventivo_job(
            "preventivo_job.id_preventivo='"+id_preventivo+"' AND preventivo_job.stato='1'",
            "preventivo_job.id ASC",
            -1
        );

    /*
     * RISPOSTA PDF
     */
    response.reset();
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "inline; filename=preventivo_"+id_preventivo+".pdf");
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
    response.setHeader("Pragma", "no-cache");

    OutputStream output_stream = response.getOutputStream();

    /*
     * MARGINI:
     * sinistro, destro, superiore, inferiore
     *
     * Il margine inferiore è maggiore per lasciare spazio al footer.
     */
    Document documento = new Document(PageSize.A4, 58, 58, 40, 90);
    PdfWriter writer = PdfWriter.getInstance(documento, output_stream);
    writer.setPageEvent(new EventoPagina());

    documento.addTitle("Preventivo "+testo(preventivo.getNumero()));
    documento.addCreator(Utility.nome_software);
    documento.open();

    /*
     * FONT
     */
    Font font_dati_etichetta = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, Font.NORMAL, COLORE_TESTO);
    Font font_dati_valore = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, Font.BOLD, COLORE_TESTO);
    Font font_cliente = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, COLORE_TESTO);
    Font font_cliente_grassetto = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, COLORE_TESTO);
    Font font_job_numero = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, COLORE_TESTO_SECONDARIO);
    Font font_job_titolo = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD, COLORE_TESTO);
    Font font_descrizione = FontFactory.getFont(FontFactory.HELVETICA, 9.5f, Font.NORMAL, COLORE_TESTO);
    Font font_tabella_titolo = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, Font.BOLD, COLORE_TESTO);
    Font font_tabella = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, Font.NORMAL, COLORE_TESTO);
    Font font_tabella_grassetto = FontFactory.getFont(FontFactory.HELVETICA, 8.5f, Font.BOLD, COLORE_TESTO);
    Font font_note_titolo = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, COLORE_TESTO);
    Font font_note = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, COLORE_TESTO);

    /*
     * FORMATI NUMERICI
     */
    DecimalFormatSymbols simboli = new DecimalFormatSymbols(Locale.ITALY);
    DecimalFormat formato_importo_intero = new DecimalFormat("#,##0", simboli);
    DecimalFormat formato_importo_decimale = new DecimalFormat("#,##0.00", simboli);
    DecimalFormat formato_unitario = new DecimalFormat("#,##0.00000", simboli);

    /*
     * INTESTAZIONE CON LOGO
     */
    PdfPTable intestazione = new PdfPTable(1);
    intestazione.setWidthPercentage(100);
    intestazione.setSpacingAfter(18);

    PdfPCell cella_logo = new PdfPCell();
    cella_logo.setBorder(Rectangle.NO_BORDER);
    cella_logo.setPadding(0);

    try{
        String percorso_logo = application.getRealPath("/img/golinelli.jpg");
        Image logo = Image.getInstance(percorso_logo);
        logo.scaleToFit(175, 60);
        logo.setAlignment(Element.ALIGN_LEFT);
        cella_logo.addElement(logo);
    }
    catch(Exception e){
        Paragraph nome_azienda = new Paragraph("Bioenergia", FontFactory.getFont(FontFactory.HELVETICA, 27, Font.BOLD, BaseColor.BLACK));
        nome_azienda.setSpacingAfter(0);
        cella_logo.addElement(nome_azienda);
    }

    intestazione.addCell(cella_logo);
    documento.add(intestazione);

    /*
     * DATI DOCUMENTO E CLIENTE
     */
    PdfPTable dati_testata = new PdfPTable(2);
    dati_testata.setWidthPercentage(100);
    dati_testata.setWidths(new float[]{44, 56});
    dati_testata.setSpacingAfter(28);

    PdfPTable dati_documento = new PdfPTable(2);
    dati_documento.setWidthPercentage(100);
    dati_documento.setWidths(new float[]{43, 57});

    dati_documento.addCell(cella_senza_bordo(new Phrase("Cod. Cliente:", font_dati_etichetta), Element.ALIGN_RIGHT));
    dati_documento.addCell(cella_senza_bordo(new Phrase(cliente!=null ? testo(cliente.getCodice()) : "", font_dati_valore), Element.ALIGN_LEFT));

    dati_documento.addCell(cella_senza_bordo(new Phrase("Data:", font_dati_etichetta), Element.ALIGN_RIGHT));
    dati_documento.addCell(cella_senza_bordo(new Phrase(Utility.converti_data_formato_it(preventivo.getData()), font_dati_valore), Element.ALIGN_LEFT));

    dati_documento.addCell(cella_senza_bordo(new Phrase("Offerta nr.:", font_dati_etichetta), Element.ALIGN_RIGHT));
    dati_documento.addCell(cella_senza_bordo(new Phrase(testo(preventivo.getNumero()), font_dati_valore), Element.ALIGN_LEFT));

    PdfPCell contenitore_documento = new PdfPCell(dati_documento);
    contenitore_documento.setBorder(Rectangle.NO_BORDER);
    contenitore_documento.setPadding(0);
    dati_testata.addCell(contenitore_documento);

    PdfPCell cella_cliente = new PdfPCell();
    cella_cliente.setBorder(Rectangle.NO_BORDER);
    cella_cliente.setPadding(0);

    Paragraph riga_cliente = new Paragraph();
    riga_cliente.setAlignment(Element.ALIGN_RIGHT);
    riga_cliente.setLeading(12);
    riga_cliente.add(new Phrase("Spett./Sig.  ", font_cliente));
    riga_cliente.add(new Phrase(cliente!=null ? testo(cliente.getRagione_sociale()) : "", font_cliente_grassetto));
    cella_cliente.addElement(riga_cliente);

    if(cliente!=null){
        String indirizzo_cliente = testo(cliente.getIndirizzo());

        String comune_cliente = testo(cliente.getCap());

        if(!testo(cliente.getComune()).equals(""))
            comune_cliente += (comune_cliente.equals("") ? "" : " ")+testo(cliente.getComune());

        if(!testo(cliente.getProvincia()).equals(""))
            comune_cliente += " ("+testo(cliente.getProvincia())+")";

        if(!indirizzo_cliente.equals("")){
            Paragraph indirizzo = new Paragraph(indirizzo_cliente, font_cliente);
            indirizzo.setAlignment(Element.ALIGN_RIGHT);
            indirizzo.setLeading(12);
            indirizzo.setSpacingBefore(8);
            cella_cliente.addElement(indirizzo);
        }

        if(!comune_cliente.equals("")){
            Paragraph comune = new Paragraph(comune_cliente, font_cliente);
            comune.setAlignment(Element.ALIGN_RIGHT);
            comune.setLeading(12);
            cella_cliente.addElement(comune);
        }
    }

    dati_testata.addCell(cella_cliente);
    documento.add(dati_testata);

    /*
     * JOB
     */
    int numero_job = 0;

    for(PreventivoJob preventivo_job : lista_preventivo_job){
        numero_job++;

        ArrayList<PreventivoJobTiratura> lista_tiratura =
            GestionePreventivo.getIstanza().ricerca_preventivo_job_tiratura(
                "preventivo_job_tiratura.id_preventivo_job='"+preventivo_job.getId()+"' AND preventivo_job_tiratura.stato='1'",
                "preventivo_job_tiratura.tiratura ASC, preventivo_job_tiratura.id ASC",
                -1
            );

        /*
         * CONTENITORE DEL JOB
         *
         * Non viene forzato keepTogether, così un Job grande può continuare
         * correttamente nella pagina successiva.
         */
        PdfPTable blocco_job = new PdfPTable(1);
        blocco_job.setWidthPercentage(100);
        blocco_job.setSplitLate(false);
        blocco_job.setSplitRows(true);
        blocco_job.setSpacingBefore(numero_job==1 ? 0 : 8);
        blocco_job.setSpacingAfter(13);

        /*
         * LINEA DI SEPARAZIONE
         */
        PdfPCell cella_linea = new PdfPCell(new Phrase(""));
        cella_linea.setBorder(Rectangle.TOP);
        cella_linea.setBorderColor(COLORE_LINEA);
        cella_linea.setBorderWidthTop(0.7f);
        cella_linea.setFixedHeight(numero_job==1 ? 4 : 8);
        cella_linea.setPadding(0);
        blocco_job.addCell(cella_linea);

        /*
         * NUMERO JOB E TITOLO
         */
        PdfPTable testata_job = new PdfPTable(2);
        testata_job.setWidthPercentage(100);
        testata_job.setWidths(new float[]{12, 88});

        PdfPCell cella_numero_job = cella_senza_bordo(
            new Phrase("JOB "+numero_job, font_job_numero),
            Element.ALIGN_LEFT
        );
        cella_numero_job.setPaddingTop(2);
        testata_job.addCell(cella_numero_job);

        String titolo_job = testo_pdf(preventivo_job.getTitolo());

        if(titolo_job.equals(""))
            titolo_job = "Senza titolo";

        PdfPCell cella_titolo_job = cella_senza_bordo(
            new Phrase(titolo_job.toUpperCase(), font_job_titolo),
            Element.ALIGN_LEFT
        );
        cella_titolo_job.setPaddingTop(0);
        testata_job.addCell(cella_titolo_job);

        PdfPCell contenitore_testata_job = new PdfPCell(testata_job);
        contenitore_testata_job.setBorder(Rectangle.NO_BORDER);
        contenitore_testata_job.setPadding(0);
        blocco_job.addCell(contenitore_testata_job);

        /*
         * DESCRIZIONE
         *
         * È allineata al titolo e non presenta più il grande spazio inutile
         * sulla sinistra.
         */
        String descrizione_job = testo_pdf(preventivo_job.getDescrizione());

        if(!descrizione_job.equals("")){
            Paragraph descrizione = new Paragraph(descrizione_job, font_descrizione);
            descrizione.setLeading(0, 1.28f);
            descrizione.setSpacingBefore(5);
            descrizione.setSpacingAfter(8);

            PdfPCell cella_descrizione = new PdfPCell();
            cella_descrizione.setBorder(Rectangle.NO_BORDER);
            cella_descrizione.setPaddingTop(0);
            cella_descrizione.setPaddingBottom(0);
            cella_descrizione.setPaddingLeft(0);
            cella_descrizione.setPaddingRight(0);
            cella_descrizione.addElement(descrizione);
            blocco_job.addCell(cella_descrizione);
        }

        /*
         * TABELLA TIRATURE
         *
         * Usiamo tutta la larghezza disponibile.
         */
        PdfPTable tabella_tirature = new PdfPTable(3);
        tabella_tirature.setWidthPercentage(100);
        tabella_tirature.setWidths(new float[]{24, 32, 44});
        tabella_tirature.setHeaderRows(1);
        tabella_tirature.setSplitLate(false);

        PdfPCell titolo_copie = cella_tiratura(
            new Phrase("Copie", font_tabella_titolo),
            Element.ALIGN_LEFT,
            COLORE_INTESTAZIONE_TABELLA,
            Rectangle.BOTTOM
        );
        titolo_copie.setBorderWidthBottom(0.6f);
        tabella_tirature.addCell(titolo_copie);

        PdfPCell titolo_unitario = cella_tiratura(
            new Phrase("EUR cad.", font_tabella_titolo),
            Element.ALIGN_RIGHT,
            COLORE_INTESTAZIONE_TABELLA,
            Rectangle.BOTTOM
        );
        titolo_unitario.setBorderWidthBottom(0.6f);
        tabella_tirature.addCell(titolo_unitario);

        PdfPCell titolo_totale = cella_tiratura(
            new Phrase("Totale EUR", font_tabella_titolo),
            Element.ALIGN_RIGHT,
            COLORE_INTESTAZIONE_TABELLA,
            Rectangle.BOTTOM
        );
        titolo_totale.setBorderWidthBottom(0.6f);
        tabella_tirature.addCell(titolo_totale);

        if(lista_tiratura.size()==0){
            PdfPCell nessuna_tiratura = new PdfPCell(new Phrase("Nessuna tiratura inserita", font_tabella));
            nessuna_tiratura.setColspan(3);
            nessuna_tiratura.setBorder(Rectangle.NO_BORDER);
            nessuna_tiratura.setPaddingTop(5);
            nessuna_tiratura.setPaddingBottom(5);
            nessuna_tiratura.setHorizontalAlignment(Element.ALIGN_LEFT);
            tabella_tirature.addCell(nessuna_tiratura);
        }
        else{
            int numero_riga = 0;

            for(PreventivoJobTiratura tiratura : lista_tiratura){
                numero_riga++;

                int quantita = tiratura.getTiratura();
                double totale = tiratura.getTotale_vendita();
                double prezzo_unitario = quantita>0 ? totale/quantita : 0;

                BaseColor sfondo_riga = numero_riga%2==0
                    ? COLORE_RIGA_ALTERNATA
                    : BaseColor.WHITE;

                tabella_tirature.addCell(
                    cella_tiratura(
                        new Phrase(String.valueOf(quantita), font_tabella_grassetto),
                        Element.ALIGN_LEFT,
                        sfondo_riga,
                        Rectangle.NO_BORDER
                    )
                );

                tabella_tirature.addCell(
                    cella_tiratura(
                        new Phrase(formato_unitario.format(prezzo_unitario), font_tabella),
                        Element.ALIGN_RIGHT,
                        sfondo_riga,
                        Rectangle.NO_BORDER
                    )
                );

                tabella_tirature.addCell(
                    cella_tiratura(
                        new Phrase(
                            formatta_importo(
                                totale,
                                formato_importo_intero,
                                formato_importo_decimale
                            ),
                            font_tabella_grassetto
                        ),
                        Element.ALIGN_RIGHT,
                        sfondo_riga,
                        Rectangle.NO_BORDER
                    )
                );
            }
        }

        PdfPCell contenitore_tirature = new PdfPCell(tabella_tirature);
        contenitore_tirature.setBorder(Rectangle.NO_BORDER);
        contenitore_tirature.setPaddingTop(2);
        contenitore_tirature.setPaddingBottom(0);
        contenitore_tirature.setPaddingLeft(0);
        contenitore_tirature.setPaddingRight(0);
        blocco_job.addCell(contenitore_tirature);

        documento.add(blocco_job);
    }

    /*
     * NOTE FINALI
     */
    String note_preventivo = testo_pdf(preventivo.getNote());

    if(!note_preventivo.equals("")){
        PdfPTable tabella_note = new PdfPTable(1);
        tabella_note.setWidthPercentage(100);
        tabella_note.setSpacingBefore(7);

        PdfPCell linea_note = new PdfPCell(new Phrase(""));
        linea_note.setBorder(Rectangle.TOP);
        linea_note.setBorderColor(COLORE_LINEA);
        linea_note.setBorderWidthTop(0.7f);
        linea_note.setFixedHeight(10);
        linea_note.setPadding(0);
        tabella_note.addCell(linea_note);

        PdfPCell titolo_note = new PdfPCell(new Phrase("NOTE", font_note_titolo));
        titolo_note.setBorder(Rectangle.NO_BORDER);
        titolo_note.setPadding(0);
        titolo_note.setPaddingBottom(4);
        tabella_note.addCell(titolo_note);

        PdfPCell contenuto_note = new PdfPCell(new Phrase(note_preventivo, font_note));
        contenuto_note.setBorder(Rectangle.NO_BORDER);
        contenuto_note.setPadding(0);
        tabella_note.addCell(contenuto_note);

        documento.add(tabella_note);
    }

    /*
     * CHIUSURA
     */
    documento.close();
    output_stream.flush();
    output_stream.close();
%>