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
    String percorso=application.getRealPath("/pdf/conto_termico/img/pagina3_pdc.png");

    Image sfondo=Image.getInstance(percorso);
    sfondo.scaleAbsolute(larghezza,altezza);
    sfondo.setAbsolutePosition(0,0);

    PdfContentByte canvas=writer.getDirectContentUnder();
    canvas.addImage(sfondo);

    // CONTENUTO DA SOVRAPPORRE
    PdfContentByte sopra=writer.getDirectContent();
    //disegnaGriglia(sopra,larghezza,altezza);

    boolean azienda=Utility.elimina_null(d.getCliente_privato_azienda()).equalsIgnoreCase("azienda");
   
    // ================================================
    // LUOGO E DATA - CONCLUSIONE INTERVENTO
    // ================================================

    testo(sopra,d.getLuogo()+" "+Utility.converti_data_formato_it(d.getData()),100,40,9);
    
    // ================================================
    // FIRMA - CONCLUSIONE INTERVENTO
    // ================================================
    String firma=azienda && !Utility.elimina_null(d.getFirma_mandante()).equals("") ? d.getFirma_mandante() : d.getFirma_cliente();
    firma(sopra,firma,400,20,160,50);

    String otp_data=azienda ? Utility.elimina_null(d.getOtp_data_ora_verifica_mandante()) : Utility.elimina_null(d.getOtp_data_ora_verifica());
    String otp_ip=azienda ? Utility.elimina_null(d.getOtp_ip_mandante()) : Utility.elimina_null(d.getOtp_ip());

    if(!otp_data.equals("")){
        String data_otp=Utility.converti_datetime_formato_it(otp_data);
        testo(sopra,"Firma OTP: "+data_otp,395,24,6);
        testo(sopra,"IP: "+otp_ip,395,16,6);
    }
%>
