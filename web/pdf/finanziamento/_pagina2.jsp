<%@page import="beans.Documento"%>
<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="utility.Utility"%>
<%@page import="com.itextpdf.text.pdf.BaseFont"%>
<%@page import="com.itextpdf.text.Image"%>
<%@page import="com.itextpdf.text.Rectangle"%>
<%@page import="com.itextpdf.text.pdf.PdfContentByte"%>
<%@page import="com.itextpdf.text.pdf.PdfWriter"%>
<%@page import="com.itextpdf.text.Document"%>
<%@page import="beans.Finanziamento"%>
<%@page import="com.itextpdf.text.pdf.*"%>
<%@page import="com.itextpdf.text.*"%>
<%@page import="java.util.Base64"%>
<%@page import="beans.Finanziamento"%>
<%@page import="utility.Utility"%>

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
    
    private void scrivi(PdfContentByte canvas,String valore,float x,float y,float dimensione,float larghezza) throws Exception{
        String testo=Utility.elimina_null(valore).trim();
        if(testo.equals("")) return;

        BaseFont font=BaseFont.createFont(BaseFont.HELVETICA,BaseFont.WINANSI,BaseFont.NOT_EMBEDDED);
        float size=dimensione;

        while(font.getWidthPoint(testo,size)>larghezza && size>5) size-=0.25f;

        canvas.saveState();
        canvas.beginText();
        canvas.setColorFill(BaseColor.BLACK);
        canvas.setFontAndSize(font,size);
        canvas.setTextMatrix(x,y);
        canvas.showText(testo);
        canvas.endText();
        canvas.restoreState();
    }

    private void checkbox(PdfContentByte canvas,String valore,String atteso,float x,float y) throws Exception{
        if(!atteso.equalsIgnoreCase(Utility.elimina_null(valore))) return;

        BaseFont font=BaseFont.createFont(BaseFont.HELVETICA_BOLD,BaseFont.WINANSI,BaseFont.NOT_EMBEDDED);

        canvas.saveState();
        canvas.beginText();
        canvas.setColorFill(BaseColor.BLACK);
        canvas.setFontAndSize(font,11);
        canvas.setTextMatrix(x,y);
        canvas.showText("X");
        canvas.endText();
        canvas.restoreState();
    }
    
private void firma(PdfContentByte sopra,String firma,float x,float y,float larghezza,float altezza){
    firma=Utility.elimina_null(firma).trim();
    if(firma.equals("")) return;

    try{
        if(firma.contains(",")) firma=firma.substring(firma.indexOf(",")+1);

        byte[] bytes=Base64.getDecoder().decode(firma);

        java.awt.image.BufferedImage originale=javax.imageio.ImageIO.read(new java.io.ByteArrayInputStream(bytes));
        if(originale==null){
            System.out.println("Firma PDF: immagine non valida");
            return;
        }

        java.awt.image.BufferedImage trasparente=new java.awt.image.BufferedImage(originale.getWidth(),originale.getHeight(),java.awt.image.BufferedImage.TYPE_INT_ARGB);

        for(int yy=0;yy<originale.getHeight();yy++){
            for(int xx=0;xx<originale.getWidth();xx++){

                int rgb=originale.getRGB(xx,yy);

                int a=(rgb>>>24)&0xff;
                int r=(rgb>>>16)&0xff;
                int g=(rgb>>>8)&0xff;
                int b=rgb&0xff;

                // Mantiene la trasparenza originale
                if(a==0){
                    trasparente.setRGB(xx,yy,0x00000000);
                    continue;
                }

                // Calcola la luminosita media
                int luminosita=(r+g+b)/3;

                // Sfondo bianco completamente trasparente
                if(r>245 && g>245 && b>245){
                    trasparente.setRGB(xx,yy,0x00000000);
                    continue;
                }

                // Mantiene i tratti della firma
                int opacita=a;

                // Sfumatura per eliminare i bordi bianchi
                if(luminosita>210){
                    opacita=(int)(a*(245.0-luminosita)/35.0);
                    opacita=Math.max(0,Math.min(255,opacita));
                }

                trasparente.setRGB(xx,yy,(opacita<<24)|(r<<16)|(g<<8)|b);
            }
        }

        java.io.ByteArrayOutputStream output=new java.io.ByteArrayOutputStream();
        javax.imageio.ImageIO.write(trasparente,"png",output);

        Image img=Image.getInstance(output.toByteArray());

        img.scaleToFit(larghezza,altezza);

        float posizione_x=x+(larghezza-img.getScaledWidth())/2;
        float posizione_y=y+(altezza-img.getScaledHeight())/2;

        img.setAbsolutePosition(posizione_x,posizione_y);

        sopra.addImage(img);

        System.out.println("Firma PDF inserita correttamente: "+posizione_x+" - "+posizione_y);

    }catch(Exception e){
        System.out.println("Errore firma PDF: "+e.getMessage());
        e.printStackTrace();
    }
}

%>


<%
    Finanziamento f=(Finanziamento)request.getAttribute("finanziamento");
    Documento d=(Documento)request.getAttribute("documento");
    Document pdf=(Document)request.getAttribute("pdf");
    PdfWriter writer=(PdfWriter)request.getAttribute("writer");

    // DIMENSIONI PAGINA
    Rectangle pagina=pdf.getPageSize();
    float larghezza=pagina.getWidth();
    float altezza=pagina.getHeight();

    // IMMAGINE ORIGINALE COME SFONDO
    String percorso=application.getRealPath("/pdf/finanziamento/img/pagina2.png");

    Image sfondo=Image.getInstance(percorso);
    sfondo.scaleAbsolute(larghezza,altezza);
    sfondo.setAbsolutePosition(0,0);

    PdfContentByte canvas=writer.getDirectContentUnder();
    canvas.addImage(sfondo);

    // CONTENUTO DA SOVRAPPORRE
    PdfContentByte sopra=writer.getDirectContent();
    //disegnaGriglia(sopra,larghezza,altezza);
    
    // =====================================================
    // LUOGO E DATA
    // =====================================================
    scrivi(sopra,f.getLuogo(),45,440,8,245);
    scrivi(sopra,Utility.converti_data_formato_it(f.getData()+""),175,440,8,245);
    
    // =====================================================
    // DATI RICHIEDENTE
    // =====================================================

    scrivi(sopra,Utility.elimina_null(f.getCognome())+" "+Utility.elimina_null(f.getNome()),43,665,8,245);
    scrivi(sopra,f.getCf(),43,645,8,245);
    scrivi(sopra,Utility.elimina_null(f.getLuogo_nascita())+" - "+Utility.converti_data_formato_it(f.getData_nascita()+""),43,625,8,245);

    // =====================================================
    // DATI COOBBLIGATO / GARANTE
    // =====================================================

    if(f.is_garante_presente()){
        scrivi(sopra,f.getGarante_nome(),316,665,8,105);
        scrivi(sopra,f.getGarante_cognome(),430,665,8,125);
        scrivi(sopra,f.getGarante_cf(),316,645,8,240);
        scrivi(sopra,Utility.elimina_null(f.getGarante_luogo_nascita())+" - "+Utility.converti_data_formato_it(f.getGarante_data_nascita()+""),316,625,8,240);
    }

    // =====================================================
    // DATI FINANZIARI
    // =====================================================

    scrivi(sopra,Utility.formatta_prezzo_no_valuta(f.getImporto())+"",43,580,9,115);
    scrivi(sopra,f.getNumero_rate()+"",165,580,9,105);

    // =====================================================
    // FIRME PRINCIPALI
    // =====================================================

    // FIRMA RICHIEDENTE
    firma(sopra,d.getFirma_cliente(),135,395,140,20);

    if(d.getOtp_data_ora_verifica()!=null){
        scrivi(sopra,"Firma OTP: "+Utility.converti_datetime_formato_it(d.getOtp_data_ora_verifica()),195,405,6,220);
        scrivi(sopra,"IP: "+Utility.elimina_null(d.getOtp_ip()),195,395,6,220);
    }

    // FIRMA GARANTE
    if(f.is_garante_presente()){
        firma(sopra,f.getFirma_garante(),395,395,140,20);

        if(f.getOtp_data_ora_verifica_garante()!=null){
            scrivi(sopra,"Firma OTP: "+Utility.converti_datetime_formato_it(f.getOtp_data_ora_verifica_garante()),460,405,6,175);
            scrivi(sopra,"IP: "+Utility.elimina_null(f.getOtp_ip_garante()),460,395,6,175);
        }
    }

    // =====================================================
    // CONSENSI RICHIEDENTE
    // =====================================================

    checkbox(sopra,f.getConsenso1(),"si",65,318);
    checkbox(sopra,f.getConsenso1(),"no",185,318);

    checkbox(sopra,f.getConsenso2(),"si",65,269);
    checkbox(sopra,f.getConsenso2(),"no",185,269);

    checkbox(sopra,f.getConsenso3(),"si",65,220);
    checkbox(sopra,f.getConsenso3(),"no",185,220);

    checkbox(sopra,f.getConsenso4(),"si",65,163);
    checkbox(sopra,f.getConsenso4(),"no",185,163);

    // =====================================================
    // CONSENSI GARANTE
    // =====================================================

    if(f.is_garante_presente()){
        checkbox(sopra,f.getConsenso5(),"si",345,318);
        checkbox(sopra,f.getConsenso5(),"no",465,318);

        checkbox(sopra,f.getConsenso6(),"si",345,269);
        checkbox(sopra,f.getConsenso6(),"no",465,269);

        checkbox(sopra,f.getConsenso7(),"si",345,220);
        checkbox(sopra,f.getConsenso7(),"no",465,220);

        checkbox(sopra,f.getConsenso8(),"si",345,163);
        checkbox(sopra,f.getConsenso8(),"no",465,163);
    }

    // =====================================================
    // FIRME PRIVACY
    // =====================================================

    // FIRMA RICHIEDENTE
    firma(sopra,d.getFirma_cliente(),135,113,140,18);

    if(d.getOtp_data_ora_verifica()!=null){
        scrivi(sopra,"Firma OTP: "+Utility.converti_datetime_formato_it(d.getOtp_data_ora_verifica()),195,125,5.5f,190);
        scrivi(sopra,"IP: "+Utility.elimina_null(d.getOtp_ip()),195,115,5.5f,190);
    }

    // FIRMA GARANTE
    if(f.is_garante_presente()){
        firma(sopra,f.getFirma_garante(),420,113,140,18);

        if(f.getOtp_data_ora_verifica_garante()!=null){
            scrivi(sopra,"Firma OTP: "+Utility.converti_datetime_formato_it(f.getOtp_data_ora_verifica_garante()),460,125,5.5f,190);
            scrivi(sopra,"IP: "+Utility.elimina_null(f.getOtp_ip_garante()),460,115,5.5f,190);
        }
    }
%>


