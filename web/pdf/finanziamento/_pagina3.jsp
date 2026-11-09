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

    private void firma(PdfContentByte canvas,String firma,float x,float y,float larghezza,float altezza) throws Exception{
        String base64=Utility.elimina_null(firma);
        if(base64.equals("")) return;

        if(base64.contains(",")) base64=base64.substring(base64.indexOf(",")+1);

        byte[] bytes=Base64.getDecoder().decode(base64);
        Image img=Image.getInstance(bytes);
        img.scaleToFit(larghezza,altezza);
        img.setAbsolutePosition(x,y);
        canvas.addImage(img);
    }
%>

<%
    Finanziamento f=(Finanziamento)request.getAttribute("finanziamento");
    Documento d=(Documento)request.getAttribute("documento");
    Document pdf=(Document)request.getAttribute("pdf");
    PdfWriter writer=(PdfWriter)request.getAttribute("writer");

    Rectangle pagina=pdf.getPageSize();
    // DIMENSIONI PAGINA
    float larghezza=pagina.getWidth();
    float altezza=pagina.getHeight();

    String percorso=application.getRealPath("/pdf/finanziamento/img/pagina3.png");

    Image sfondo=Image.getInstance(percorso);
    sfondo.scaleAbsolute(pagina.getWidth(),pagina.getHeight());
    sfondo.setAbsolutePosition(0,0);

    PdfContentByte canvas=writer.getDirectContentUnder();
    canvas.addImage(sfondo);

    PdfContentByte sopra=writer.getDirectContent();

    //disegnaGriglia(sopra,larghezza,altezza);
    
    // NUMERO PRATICA
    scrivi(sopra,f.getNumero()+"",345,250,8,90);

    // DATI RICHIEDENTE
    scrivi(sopra,Utility.elimina_null(f.getNome())+" "+Utility.elimina_null(f.getCognome()),80,230,8,230);
    scrivi(sopra,f.getEmail(),320,230,8,140);
    scrivi(sopra,f.getCellulare(),480,230,8,90);

    // DATI GARANTE
    if(f.is_garante_presente()){
        scrivi(sopra,Utility.elimina_null(f.getGarante_nome())+" "+Utility.elimina_null(f.getGarante_cognome()),80,215,8,230);
        scrivi(sopra,f.getGarante_email(),320,212,8,140);
        scrivi(sopra,f.getGarante_cellulare(),480,212,8,90);
    }

    // LUOGO E DATA
    scrivi(sopra,f.getLuogo(),45,140,8,125);
    scrivi(sopra,Utility.converti_data_formato_it(f.getData()+""),180,140,8,100);

    // FIRMA RICHIEDENTE
    firma(sopra,d.getFirma_cliente(),100,85,150,20);

    if(d.getOtp_data_ora_verifica()!=null){
        scrivi(sopra,"Firma OTP: "+Utility.converti_datetime_formato_it(d.getOtp_data_ora_verifica()),190,95,6,250);
        scrivi(sopra,"IP: "+Utility.elimina_null(d.getOtp_ip()),190,85,6,250);
    }

    // FIRMA GARANTE
    if(f.is_garante_presente()){
        firma(sopra,f.getFirma_garante(),100,47,150,20);

        if(f.getOtp_data_ora_verifica_garante()!=null){
            scrivi(sopra,"Firma OTP:"+Utility.converti_datetime_formato_it(f.getOtp_data_ora_verifica_garante()),190,60,6,250);
            scrivi(sopra,"IP: "+Utility.elimina_null(f.getOtp_ip_garante()),190,50,6,250);
        }
    }
%>
