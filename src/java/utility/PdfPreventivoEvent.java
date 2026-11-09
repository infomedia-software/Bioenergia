package utility;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

public class PdfPreventivoEvent extends PdfPageEventHelper {

    private final String numero;
    private final String data;
    private final String percorsoLogo;
    private PdfTemplate totalePagine;
    private BaseFont baseFont;

    public PdfPreventivoEvent(String numero,String data,String percorsoLogo){
        this.numero=numero;
        this.data=data;
        this.percorsoLogo=percorsoLogo;
    }

    @Override
    public void onOpenDocument(PdfWriter writer,Document document){
        totalePagine=writer.getDirectContent().createTemplate(30,12);
        try{
            baseFont=BaseFont.createFont(BaseFont.HELVETICA,BaseFont.CP1252,BaseFont.NOT_EMBEDDED);
        }catch(Exception e){
            throw new ExceptionConverter(e);
        }
    }

    @Override
    public void onEndPage(PdfWriter writer,Document document){
        PdfContentByte cb=writer.getDirectContent();
        float larghezza=document.getPageSize().getWidth();
        float altezza=document.getPageSize().getHeight();

        try{
            Image logo=Image.getInstance(percorsoLogo);
            logo.scaleToFit(230,65);
            logo.setAbsolutePosition(40,altezza-100);
            cb.addImage(logo);
        }catch(Exception e){
            System.err.println("Logo preventivo non disponibile: "+e.getMessage());
        }

        cb.beginText();
        cb.setFontAndSize(baseFont,8);
        cb.setColorFill(BaseColor.DARK_GRAY);

        cb.showTextAligned(Element.ALIGN_RIGHT,"BIOENERGIA S.R.L. unipersonale",larghezza-40,altezza-48,0);
        cb.showTextAligned(Element.ALIGN_RIGHT,"Via Retrone 30 - 35135 - Padova (PD)",larghezza-40,altezza-60,0);
        cb.showTextAligned(Element.ALIGN_RIGHT,"P.IVA 04543770285 - C.F. 04543770285",larghezza-40,altezza-72,0);

        cb.setFontAndSize(baseFont,11);
        cb.showTextAligned(Element.ALIGN_RIGHT,"PREVENTIVO nr. "+numero+" del "+data,larghezza-40,altezza-96,0);
        cb.endText();

        // Footer
        cb.beginText();
        cb.setFontAndSize(baseFont,7);
        cb.setColorFill(BaseColor.DARK_GRAY);

        String testo="Preventivo nr. "+numero+" del "+data+" - "+writer.getPageNumber()+" / ";
        cb.showTextAligned(Element.ALIGN_LEFT,testo,40,27,0);

        float x=40+baseFont.getWidthPoint(testo,7);
        cb.endText();
        cb.addTemplate(totalePagine,x,27);

        cb.beginText();
        cb.setFontAndSize(baseFont,7);
        cb.showTextAligned(Element.ALIGN_RIGHT,"BIOENERGIA S.R.L. unipersonale",larghezza-40,42,0);
        cb.showTextAligned(Element.ALIGN_RIGHT,"www.bioenergia.srl - info@bioenergia.srl",larghezza-40,32,0);
        cb.showTextAligned(Element.ALIGN_RIGHT,"tel: 049-2701192 - fax: 049-8591108",larghezza-40,22,0);
        cb.endText();
    }

    @Override
    public void onCloseDocument(PdfWriter writer,Document document){
        totalePagine.beginText();
        totalePagine.setFontAndSize(baseFont,7);
        totalePagine.setTextMatrix(0,0);
        totalePagine.showText(String.valueOf(writer.getPageNumber()-1));
        totalePagine.endText();
    }
}