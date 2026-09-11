<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="beans.Documento"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
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

    String osservazioni=Utility.elimina_null(documento.getOsservazioni());
    /*
     * HEADER
     */
    String pathHeader=application.getRealPath("/img/header_pagina2.png");
    Image imgHeader=Image.getInstance(pathHeader);
    imgHeader.scaleToFit(PageSize.A4.getWidth(),100);
    imgHeader.setAlignment(Image.ALIGN_CENTER);
    imgHeader.setSpacingAfter(8);

    pdf.add(imgHeader);


    /*
     * CLIENTE
     */
    String cliente="";

    if(Utility.elimina_null(documento.getCliente_privato_azienda()).equalsIgnoreCase("azienda"))
        cliente=Utility.elimina_null(documento.getCliente_ragione_sociale());
    else
        cliente=(Utility.elimina_null(documento.getCliente_cognome())+" "+Utility.elimina_null(documento.getCliente_nome())).trim();

    if(cliente.equals(""))
        cliente=Utility.elimina_null(documento.getCliente_ragione_sociale());


    PdfPTable titolo_cliente=new PdfPTable(1);
    titolo_cliente.setWidthPercentage(100);

    PdfPCell titolo_cliente_cella=new PdfPCell(new Phrase("CLIENTE",font_titolo));
    titolo_cliente_cella.setBorder(Rectangle.NO_BORDER);
    titolo_cliente_cella.setPaddingLeft(0);
    titolo_cliente_cella.setPaddingBottom(3);

    titolo_cliente.addCell(titolo_cliente_cella);
    pdf.add(titolo_cliente);


    PdfPTable tabella_cliente=new PdfPTable(1);
    tabella_cliente.setWidthPercentage(100);
    tabella_cliente.setSpacingAfter(8);

    Paragraph p_cliente=new Paragraph();
    p_cliente.setLeading(9);
    p_cliente.add(new Chunk("Cognome - Nome / Azienda\n",font_piccolo));
    p_cliente.add(new Chunk(cliente,font_normale));

    PdfPCell cliente_cella=new PdfPCell(p_cliente);
    cliente_cella.setBorder(Rectangle.BOTTOM);
    cliente_cella.setBorderColorBottom(GRIGIO);
    cliente_cella.setPaddingLeft(0);
    cliente_cella.setPaddingBottom(3);
    cliente_cella.setMinimumHeight(25);

    tabella_cliente.addCell(cliente_cella);
    pdf.add(tabella_cliente);


    /*
     * IL NOSTRO SERVIZIO
     */
    PdfPTable titolo_servizio=new PdfPTable(1);
    titolo_servizio.setWidthPercentage(100);

    PdfPCell titolo_servizio_cella=new PdfPCell(
        new Phrase("□  IL NOSTRO SERVIZIO",font_titolo)
    );

    titolo_servizio_cella.setBorder(Rectangle.BOTTOM);
    titolo_servizio_cella.setBorderColorBottom(AZZURRO);
    titolo_servizio_cella.setBorderWidthBottom(0.8f);
    titolo_servizio_cella.setPaddingLeft(0);
    titolo_servizio_cella.setPaddingBottom(3);

    titolo_servizio.addCell(titolo_servizio_cella);

    pdf.add(titolo_servizio);


    /*
     * SERVIZI
     */
    String servizi_inclusi=Utility.elimina_null(documento.getServizi_inclusi());
    String[] servizi={
        "Studio di fattibilità tecnico personalizzato",
        "Presentazione della pratica autorizzativa di inizio lavori",
        "Presentazione delle pratiche di connessione con il gestore di rete elettrica competente",
        "Presentazione delle pratiche per il finanziamento ove richiesto",
        "Sopralluogo tecnico di approvazione fattibilità",
        "Dimensionamento e progettazione dell’impianto con verifica fattibilità",
        "Piano operativo di sicurezza",
        "Installazione dell’impianto completo (installazione standard)",
        "Dichiarazione di conformità impianto",
        "Rilascio della documentazione necessaria per l’ottenimento della detrazione fiscale, ove spettante",
        "Assistenza nella gestione della pratica di Scambio sul Posto o ritiro dedicato"
    };

    PdfPTable tabella_servizi=new PdfPTable(1);
    tabella_servizi.setWidthPercentage(100);
    tabella_servizi.setSpacingAfter(8);

    BaseColor GRIGIO_RIGA=new BaseColor(235,235,235);
    String pallino_pieno="X"; // •
    String pallino_vuoto="";      // o
    for(int i=0;i<servizi.length;i++){

        String servizio=servizi[i];

        boolean incluso=false;
        
        for(String s:servizi_inclusi.split(",")){
            if(s.trim().equalsIgnoreCase(servizio)){
                incluso=true;
                break;
            }
        }
        
        String simbolo=incluso ? pallino_pieno : pallino_vuoto;

        PdfPCell cella=new PdfPCell(new Phrase(simbolo+"  "+servizio+";",font_normale));
        cella.setBorder(Rectangle.NO_BORDER);
        cella.setPaddingLeft(6);
        cella.setPaddingRight(5);
        cella.setPaddingTop(5);
        cella.setPaddingBottom(5);
        cella.setMinimumHeight(24);
        cella.setVerticalAlignment(Element.ALIGN_MIDDLE);

        if(i%2==0)
            cella.setBackgroundColor(GRIGIO_RIGA);

        tabella_servizi.addCell(cella);
    }

    pdf.add(tabella_servizi);

    /*
     * TESTO A CARICO DEL CLIENTE
     */
    Paragraph carico_cliente=new Paragraph();
    carico_cliente.setFont(font_piccolo);
    carico_cliente.setLeading(8);

    carico_cliente.add(
        "A carico del Cliente sarà:\n"
        +"- il contributo che Enel Distribuzione chiede al titolare dell'utenza elettrica per richiesta ed accettazione del preventivo di connessione;\n"
        +"- relazione paesaggistica ove necessaria.\n"
        +"- pratiche autorizzatorie diverse dall'autorizzazione di inizio lavori ed eventuali diritti di segreteria e oneri richiesti dagli enti preposti."
    );

    carico_cliente.setSpacingAfter(10);

    pdf.add(carico_cliente);


    /*
     * OSSERVAZIONI
     */
    PdfPTable titolo_osservazioni=new PdfPTable(1);
    titolo_osservazioni.setWidthPercentage(100);

    PdfPCell titolo_osservazioni_cella=new PdfPCell(new Phrase("OSSERVAZIONI",font_titolo));

    titolo_osservazioni_cella.setBorder(Rectangle.BOTTOM);
    titolo_osservazioni_cella.setBorderColorBottom(AZZURRO);
    titolo_osservazioni_cella.setBorderWidthBottom(0.8f);
    titolo_osservazioni_cella.setPaddingLeft(0);
    titolo_osservazioni_cella.setPaddingBottom(3);

    titolo_osservazioni.addCell(titolo_osservazioni_cella);

    pdf.add(titolo_osservazioni);


    /*
     * BOX OSSERVAZIONI
     */
    PdfPTable tabella_osservazioni=new PdfPTable(1);
    tabella_osservazioni.setWidthPercentage(100);
    tabella_osservazioni.setSpacingAfter(8);

    PdfPCell cella_osservazioni=new PdfPCell();

    cella_osservazioni.setBorder(Rectangle.BOX);
    cella_osservazioni.setBorderColor(AZZURRO);
    cella_osservazioni.setBorderWidth(0.8f);
    cella_osservazioni.setPaddingLeft(5);
    cella_osservazioni.setPaddingRight(5);
    cella_osservazioni.setPaddingTop(5);
    cella_osservazioni.setPaddingBottom(5);
    cella_osservazioni.setMinimumHeight(175);

    if(!osservazioni.equals("")){

        Paragraph p_osservazioni=new Paragraph(
            osservazioni,
            font_normale
        );

        p_osservazioni.setLeading(11);

        cella_osservazioni.addElement(p_osservazioni);

    }else{

        /*
         * Se non ci sono osservazioni creo le righe come nel modello
         */
        for(int i=0;i<8;i++){

            PdfPTable riga=new PdfPTable(1);
            riga.setWidthPercentage(100);

            PdfPCell riga_cella=new PdfPCell(new Phrase(" ",font_normale));
            riga_cella.setBorder(Rectangle.BOTTOM);
            riga_cella.setBorderColorBottom(new BaseColor(130,130,130));
            riga_cella.setFixedHeight(18);

            riga.addCell(riga_cella);

            cella_osservazioni.addElement(riga);
        }
    }

    tabella_osservazioni.addCell(cella_osservazioni);

    pdf.add(tabella_osservazioni);


    /*
     * FOOTER
     */
    String pathFooter=application.getRealPath("/img/footer_pagina2.png");
    Image imgFooter=Image.getInstance(pathFooter);
    imgFooter.scaleToFit(PageSize.A4.getWidth(),80);
    imgFooter.setAlignment(Image.ALIGN_CENTER);

    pdf.add(imgFooter);
%>