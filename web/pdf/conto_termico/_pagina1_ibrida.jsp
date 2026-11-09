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
    
      public void disegnaGriglia(PdfContentByte canvas,float larghezza,float altezza) throws Exception{

        BaseFont font=BaseFont.createFont(BaseFont.HELVETICA,BaseFont.WINANSI,BaseFont.NOT_EMBEDDED);

        canvas.saveState();
        canvas.setLineWidth(0.3f);

        // LINEE VERTICALI - X
        for(int x=0;x<=larghezza;x+=25){
            canvas.setColorStroke(new BaseColor(255,100,100));
            canvas.moveTo(x,0);
            canvas.lineTo(x,altezza);
            canvas.stroke();

            canvas.beginText();
            canvas.setColorFill(BaseColor.RED);
            canvas.setFontAndSize(font,7);
            canvas.setTextMatrix(x+2,altezza-12);
            canvas.showText(""+x);
            canvas.endText();
        }

        // LINEE ORIZZONTALI - Y
        for(int y=0;y<=altezza;y+=25){
            canvas.setColorStroke(new BaseColor(50,100,255));
            canvas.moveTo(0,y);
            canvas.lineTo(larghezza,y);
            canvas.stroke();

            canvas.beginText();
            canvas.setColorFill(BaseColor.BLUE);
            canvas.setFontAndSize(font,7);
            canvas.setTextMatrix(3,y+3);
            canvas.showText(""+y);
            canvas.endText();
        }

        canvas.restoreState();
    }
    

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

    private void testo(PdfContentByte sopra,String valore,float x,float y,float dimensione){
        valore=Utility.elimina_null(valore).trim();
        if(valore.equals("")) return;

        try{
            BaseFont bf=BaseFont.createFont(BaseFont.HELVETICA,BaseFont.CP1252,BaseFont.NOT_EMBEDDED);
            sopra.beginText();
            sopra.setFontAndSize(bf,dimensione);
            sopra.setColorFill(BaseColor.BLACK);
            sopra.setTextMatrix(x,y);
            sopra.showText(valore);
            sopra.endText();
        }catch(Exception e){
            System.out.println("Errore testo PDF Conto Termico: "+e.getMessage());
        }
    }

   
private void firma(PdfContentByte sopra,String firma,float x,float y,float larghezza,float altezza){
    firma=Utility.elimina_null(firma).trim();
    if(firma.equals("")) return;

    try{
        if(firma.contains(",")) firma=firma.substring(firma.indexOf(",")+1);

        byte[] bytes=Base64.getDecoder().decode(firma);

        java.awt.image.BufferedImage originale=javax.imageio.ImageIO.read(new java.io.ByteArrayInputStream(bytes));
        if(originale==null) return;

        java.awt.image.BufferedImage trasparente=new java.awt.image.BufferedImage(originale.getWidth(),originale.getHeight(),java.awt.image.BufferedImage.TYPE_INT_ARGB);

        for(int yy=0;yy<originale.getHeight();yy++){
            for(int xx=0;xx<originale.getWidth();xx++){
                int rgb=originale.getRGB(xx,yy);

                int a=(rgb>>>24)&0xff;
                int r=(rgb>>>16)&0xff;
                int g=(rgb>>>8)&0xff;
                int b=rgb&0xff;

                // Rende trasparente il bianco e i colori quasi bianchi
                int luminosita=Math.min(r,Math.min(g,b));
                int opacita=(int)(a*(255-luminosita)/255.0);

                trasparente.setRGB(xx,yy,(opacita<<24)|(r<<16)|(g<<8)|b);
            }
        }

        java.io.ByteArrayOutputStream output=new java.io.ByteArrayOutputStream();
        javax.imageio.ImageIO.write(trasparente,"png",output);

        Image img=Image.getInstance(output.toByteArray());
        img.scaleToFit(larghezza,altezza);
        img.setAbsolutePosition(x+(larghezza-img.getScaledWidth())/2,y+(altezza-img.getScaledHeight())/2);

        sopra.addImage(img);

    }catch(Exception e){
        System.out.println("Errore firma PDF Conto Termico: "+e.getMessage());
    }
}

%>
<%
    Documento d=(Documento)request.getAttribute("documento");
    Document pdf=(Document)request.getAttribute("pdf");
    PdfWriter writer=(PdfWriter)request.getAttribute("writer");

    // DIMENSIONI PAGINA
    Rectangle pagina=pdf.getPageSize();
    float larghezza=pagina.getWidth();
    float altezza=pagina.getHeight();

    // IMMAGINE ORIGINALE COME SFONDO
    String percorso=application.getRealPath("/pdf/conto_termico/img/pagina1_ibrida.png");

    Image sfondo=Image.getInstance(percorso);
    sfondo.scaleAbsolute(larghezza,altezza);
    sfondo.setAbsolutePosition(0,0);

    PdfContentByte canvas=writer.getDirectContentUnder();
    canvas.addImage(sfondo);

    // CONTENUTO DA SOVRAPPORRE
    PdfContentByte sopra=writer.getDirectContent();
    //disegnaGriglia(sopra,larghezza,altezza);


    boolean azienda=Utility.elimina_null(d.getCliente_privato_azienda()).equalsIgnoreCase("azienda");

    String luogo=Utility.elimina_null(d.getLuogo());
    String data=Utility.elimina_null(d.getData());

    String cliente_nome=Utility.elimina_null(d.getCliente_nome());
    String cliente_cognome=Utility.elimina_null(d.getCliente_cognome());
    String cliente_cf=Utility.elimina_null(d.getCliente_cf());
    String cliente_piva=Utility.elimina_null(d.getCliente_piva());
    String cliente_ragione_sociale=Utility.elimina_null(d.getCliente_ragione_sociale());
    String cliente_indirizzo=Utility.elimina_null(d.getCliente_indirizzo());
    String cliente_comune=Utility.elimina_null(d.getCliente_comune());
    String cliente_cap=Utility.elimina_null(d.getCliente_cap());
    String cliente_provincia=Utility.elimina_null(d.getCliente_provincia());
    String mandante_nome=Utility.elimina_null(d.getMandante_nome());
    String mandante_cognome=Utility.elimina_null(d.getMandante_cognome());
    String mandante_cf=Utility.elimina_null(d.getMandante_cf());

    // ================================================
    // PERSONA FISICA
    // ================================================

    if(d.isMandante_cliente()){

        testo(sopra,cliente_nome+" "+cliente_cognome,95,695,8);
        testo(sopra,d.getCliente_luogo_nascita(),330,695,8);
        
        testo(sopra,Utility.converti_data_formato_it(d.getCliente_data_nascita()),140,677,8);
        testo(sopra,cliente_indirizzo,275,677,8);
        
        testo(sopra,cliente_comune,100,660,8);
        testo(sopra,cliente_provincia,318,660,8);
        testo(sopra,cliente_cf,425,660,8);
        
    }else{
        // RAPPRESENTANTE AZIENDA = MANDANTE
        testo(sopra,mandante_nome+" "+mandante_cognome,95,695,8);
        testo(sopra,d.getMandante_luogo_nascita(),330,695,8);
        
        testo(sopra,Utility.converti_data_formato_it(d.getMandante_data_nascita()),140,677,8);
        testo(sopra,d.getMandante_indirizzo(),275,677,8);
        
        testo(sopra,d.getMandante_comune(),100,660,8);
        testo(sopra,d.getMandante_provincia(),318,660,8);
        testo(sopra,mandante_cf,420,660,8);
    }

    // ================================================
    // LUOGO E DATA - PRIMA DICHIARAZIONE
    // ================================================

    testo(sopra,luogo+" "+Utility.converti_data_formato_it(data),100,545,9);

    // ================================================
    // FIRMA - PRIMA DICHIARAZIONE
    // ================================================

    String firma=azienda && !Utility.elimina_null(d.getFirma_mandante()).equals("")
        ? d.getFirma_mandante()
        : d.getFirma_cliente();

    firma(sopra,firma,395,498,160,50);

    // ================================================
    // LUOGO E DATA - CONCLUSIONE INTERVENTO
    // ================================================

    testo(sopra,luogo+" "+Utility.converti_data_formato_it(data),100,115,9);

    // ================================================
    // FIRMA - CONCLUSIONE INTERVENTO
    // ================================================

    firma(sopra,firma,395,60,160,50);

    // ================================================
    // OTP
    // ================================================

    String otp_data=azienda ? Utility.elimina_null(d.getOtp_data_ora_verifica_mandante()) : Utility.elimina_null(d.getOtp_data_ora_verifica());
    String otp_ip=azienda ? Utility.elimina_null(d.getOtp_ip_mandante()) : Utility.elimina_null(d.getOtp_ip());

    if(!otp_data.equals("")){
        String data_otp=Utility.converti_datetime_formato_it(otp_data);

        // Prima firma
        testo(sopra,"Firma OTP: "+data_otp+" IP: "+otp_ip,395,500,6);

        // Seconda firma
        testo(sopra,"Firma OTP: "+data_otp,395,46,6);
        testo(sopra,"IP: "+otp_ip,395,40,6);
    }
%>
