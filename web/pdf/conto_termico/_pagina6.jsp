
<%@page import="java.util.Base64"%>
<%@page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@page import="beans.Documento"%>
<%@page import="utility.Utility"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%! private void firma(PdfContentByte sopra,String firma,float x,float y,float larghezza,float altezza){
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

    PdfContentByte sopra=writer.getDirectContent();

    Font normale6=new Font(Font.FontFamily.HELVETICA,9,Font.NORMAL,BaseColor.BLACK);
    Font grassetto6=new Font(Font.FontFamily.HELVETICA,9,Font.BOLD,BaseColor.BLACK);
    Font sezione6=new Font(Font.FontFamily.HELVETICA,10,Font.BOLD,BaseColor.BLACK);
    Font piccolo6=new Font(Font.FontFamily.HELVETICA,7,Font.NORMAL,BaseColor.GRAY);

    // =====================================================
    // LOGO GSE
    // =====================================================

    String percorsoLogo6=application.getRealPath("/pdf/conto_termico/img/gse.png");

    Image logo6=Image.getInstance(percorsoLogo6);
    logo6.scaleToFit(110,65);
    logo6.setAbsolutePosition(35,735);
    sopra.addImage(logo6);

    // =====================================================
    // RICHIESTA CODICE IDENTIFICATIVO
    // =====================================================

    ColumnText.showTextAligned(sopra,Element.ALIGN_RIGHT,new Phrase("RICHIESTA CODICE",grassetto6),560,780,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_RIGHT,new Phrase("IDENTIFICATIVO",grassetto6),560,766,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_RIGHT,new Phrase("n.: ....................",normale6),560,745,0);

    // Linea intestazione
    sopra.saveState();
    sopra.setColorStroke(BaseColor.GRAY);
    sopra.setLineWidth(2);
    sopra.moveTo(35,715);
    sopra.lineTo(560,715);
    sopra.stroke();
    sopra.restoreState();

    // =====================================================
    // ARTICOLO 3
    // =====================================================

    ColumnText.showTextAligned(sopra,Element.ALIGN_CENTER,new Phrase("Art. 3 - Invio di comunicazioni",sezione6),297,685,0);

    ColumnText ct6=new ColumnText(sopra);
    ct6.setSimpleColumn(35,640,560,670);
    ct6.setLeading(13);
    ct6.addText(new Phrase("Le comunicazioni inerenti al presente contratto dovranno essere effettuate in forma scritta ed inviate con lettera raccomandata ai seguenti indirizzi:",normale6));
    ct6.go();

    // =====================================================
    // INDIRIZZI COMUNICAZIONI
    // =====================================================

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Se diretta al Mandante: in ............................... (...), Via ............................... n. ..........",normale6),35,620,0);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Se diretta al Mandatario: in ............................... (...), Via ............................... n. ..........",normale6),35,597,0);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Se diretta al Gestore dei Servizi Energetici - GSE S.p.A.: in Viale Maresciallo Pilsudski 92, 00197 Roma",normale6),35,574,0);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("ovvero a mezzo posta elettronica, ai seguenti indirizzi:",normale6),35,551,0);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Mandante: (inserire indirizzo posta elettronica) ...............................",normale6),35,528,0);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Mandatario: (inserire indirizzo posta elettronica) GSE@BIOENERGIA.SRL",normale6),35,505,0);

    // =====================================================
    // TIMBRO MANDATARIO
    // =====================================================

    String percorsoTimbro=application.getRealPath("/pdf/conto_termico/img/timbro.png");

    Image timbro=Image.getInstance(percorsoTimbro);
    timbro.scaleToFit(180,100);
    timbro.setAbsolutePosition(340,415);
    sopra.addImage(timbro);

    // =====================================================
    // FIRME
    // =====================================================

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("................................. , .............",normale6),35,440,0);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("................................. , .............",normale6),35,385,0);

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("...................................................",normale6),340,385,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("(firma del Mandante)",normale6),340,372,0);

    // =====================================================
    // ALLEGATI
    // =====================================================

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Allegati: copia documenti d'identità del Mandatario",grassetto6),35,340,0);
    String luogo_data=Utility.elimina_null(d.getLuogo())+", "+Utility.elimina_null(Utility.converti_data_formato_it(d.getData()));
    // PRIMA RIGA - MANDATARIO
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase(luogo_data,normale6),35,442,0);

    // SECONDA RIGA - MANDANTE
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase(luogo_data,normale6),35,387,0);

    // FIRMA MANDANTE
    String firma_mandante=Utility.elimina_null(d.getFirma_mandante());

    // Se non presente, utilizza la firma cliente
    if(firma_mandante.equals(""))
        firma_mandante=Utility.elimina_null(d.getFirma_cliente());

    // Firma grafica a destra, sopra la linea
    firma(sopra,firma_mandante,330,360,200,60);
    
    // OTP MANDANTE
    String otp_data=Utility.elimina_null(d.getOtp_data_ora_verifica_mandante());
    String otp_ip=Utility.elimina_null(d.getOtp_ip_mandante());

    // Se non è presente una firma OTP del mandante, usa quella del cliente
    if(otp_data.equals("")){
        otp_data=Utility.elimina_null(d.getOtp_data_ora_verifica());
        otp_ip=Utility.elimina_null(d.getOtp_ip());
    }

    if(!otp_data.equals("")){
        ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Firma OTP: "+Utility.converti_datetime_formato_it(otp_data),piccolo6),340,362,0);
        ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("IP: "+otp_ip,piccolo6),340,350,0);
    }
    
    // =====================================================
    // FOOTER
    // =====================================================

    sopra.saveState();
    sopra.setColorStroke(BaseColor.GRAY);
    sopra.setLineWidth(2);
    sopra.moveTo(35,75);
    sopra.lineTo(560,75);
    sopra.stroke();
    sopra.restoreState();

    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Gestore dei Servizi Energetici - GSE S.p.A.",piccolo6),35,62,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Socio Unico Ministero dell'Economia e delle Finanze - Sede Legale: 00197 Roma, V.le Maresciallo Pilsudski, 92",piccolo6),35,52,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Reg. Imprese di Roma, P.IVA e C.F. 05754381001 - R.E.A. di Roma n. 918934 - Cap. Sociale euro 26.000.000,00 i.v.",piccolo6),35,42,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_LEFT,new Phrase("Tel. +39.0680111 - Fax +39.0680114720 - info@gse.it - www.gse.it - Numero Verde: 800.16.16.16",piccolo6),35,32,0);
    ColumnText.showTextAligned(sopra,Element.ALIGN_RIGHT,new Phrase("Pagina 2 di 2",piccolo6),560,32,0);
%>
