<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.OutputStream"%>

<%@page import="java.awt.Graphics2D"%>
<%@page import="java.awt.RenderingHints"%>
<%@page import="java.awt.Color"%>
<%@page import="java.awt.image.BufferedImage"%>

<%@page import="javax.imageio.ImageIO"%>
<%@page import="javax.imageio.ImageWriter"%>
<%@page import="javax.imageio.ImageWriteParam"%>
<%@page import="javax.imageio.IIOImage"%>
<%@page import="javax.imageio.stream.ImageOutputStream"%>

<%@page import="java.nio.file.Files"%>
<%@page import="java.nio.file.StandardCopyOption"%>
<%@page import="java.util.Iterator"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page trimDirectiveWhitespaces="true"%>

<%!
    private void comprimiImmagine(File file) throws Exception {

        if(file == null || !file.exists() || !file.isFile())
            return;

        String nomeFile = file.getName().toLowerCase();

        boolean jpeg = nomeFile.endsWith(".jpg") || nomeFile.endsWith(".jpeg");
        boolean png = nomeFile.endsWith(".png");

        if(!jpeg && !png)
            return;

        BufferedImage immagineOriginale = ImageIO.read(file);

        if(immagineOriginale == null)
            return;

        int larghezzaOriginale = immagineOriginale.getWidth();
        int altezzaOriginale = immagineOriginale.getHeight();

        int larghezzaNuova = larghezzaOriginale;
        int altezzaNuova = altezzaOriginale;
        int dimensioneMassima = 1920;

        if(larghezzaOriginale > dimensioneMassima || altezzaOriginale > dimensioneMassima) {

            double rapporto = Math.min(
                (double)dimensioneMassima / larghezzaOriginale,
                (double)dimensioneMassima / altezzaOriginale
            );

            larghezzaNuova = (int)Math.round(larghezzaOriginale * rapporto);
            altezzaNuova = (int)Math.round(altezzaOriginale * rapporto);
        }

        /*
         * Per i PNG già entro 1920 px non facciamo nulla:
         * una nuova codifica potrebbe aumentare il peso.
         */
        if(png && larghezzaNuova == larghezzaOriginale && altezzaNuova == altezzaOriginale)
            return;

        int tipoImmagine = jpeg ? BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB;

        BufferedImage immagineNuova = new BufferedImage(
            larghezzaNuova,
            altezzaNuova,
            tipoImmagine
        );

        Graphics2D grafica = immagineNuova.createGraphics();

        try {

            grafica.setRenderingHint(
                RenderingHints.KEY_INTERPOLATION,
                RenderingHints.VALUE_INTERPOLATION_BICUBIC
            );

            grafica.setRenderingHint(
                RenderingHints.KEY_RENDERING,
                RenderingHints.VALUE_RENDER_QUALITY
            );

            grafica.setRenderingHint(
                RenderingHints.KEY_ANTIALIASING,
                RenderingHints.VALUE_ANTIALIAS_ON
            );

            if(jpeg) {
                grafica.setColor(Color.WHITE);
                grafica.fillRect(0, 0, larghezzaNuova, altezzaNuova);
            }

            grafica.drawImage(
                immagineOriginale,
                0,
                0,
                larghezzaNuova,
                altezzaNuova,
                null
            );

        } finally {
            grafica.dispose();
        }

        File temporaneo = new File(
            file.getParentFile(),
            file.getName() + ".compressione.tmp"
        );

        try {

            if(jpeg)
                salvaJpeg(immagineNuova, temporaneo, 0.85f);
            else
                ImageIO.write(immagineNuova, "png", temporaneo);

            if(
                temporaneo.exists()
                && temporaneo.length() > 0
                && temporaneo.length() < file.length()
            ) {
                Files.move(
                    temporaneo.toPath(),
                    file.toPath(),
                    StandardCopyOption.REPLACE_EXISTING
                );
            } else {
                temporaneo.delete();
            }

        } finally {

            if(temporaneo.exists())
                temporaneo.delete();

            immagineNuova.flush();
            immagineOriginale.flush();
        }
    }

    private void salvaJpeg(
        BufferedImage immagine,
        File destinazione,
        float qualita
    ) throws IOException {

        Iterator<ImageWriter> writers = ImageIO.getImageWritersByFormatName("jpg");

        if(!writers.hasNext())
            throw new IOException("Writer JPEG non disponibile");

        ImageWriter writer = writers.next();
        ImageOutputStream output = null;

        try {

            output = ImageIO.createImageOutputStream(destinazione);

            writer.setOutput(output);

            ImageWriteParam parametri = writer.getDefaultWriteParam();

            if(parametri.canWriteCompressed()) {
                parametri.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
                parametri.setCompressionQuality(qualita);
            }

            writer.write(
                null,
                new IIOImage(immagine, null, null),
                parametri
            );

        } finally {

            if(output != null)
                output.close();

            writer.dispose();
        }
    }
%>

<%
    final int MAX_FILE_SIZE = 10 * 1024 * 1024;

    String saveFile = "";
    String nomeFile = "";

    String contentType = request.getContentType();

    if(contentType == null || contentType.indexOf("multipart/form-data") < 0) {
        out.print("ERRORE: richiesta multipart non valida.");
        return;
    }

    int formDataLength = request.getContentLength();

    if(formDataLength <= 0) {
        out.print("ERRORE: file non ricevuto.");
        return;
    }

    if(formDataLength > MAX_FILE_SIZE) {
        out.print("ERRORE: File troppo grande. Max consentito 10 MB.");
        return;
    }

    DataInputStream in = null;
    FileOutputStream fileOut = null;

    try {

        in = new DataInputStream(request.getInputStream());

        byte[] dataBytes = new byte[formDataLength];

        int byteRead;
        int totalBytesRead = 0;

        while(totalBytesRead < formDataLength) {

            byteRead = in.read(
                dataBytes,
                totalBytesRead,
                formDataLength - totalBytesRead
            );

            if(byteRead == -1)
                break;

            totalBytesRead += byteRead;
        }

        if(totalBytesRead <= 0) {
            out.print("ERRORE: nessun dato ricevuto.");
            return;
        }

        /*
         * ISO-8859-1 mantiene la corrispondenza 1 byte = 1 carattere,
         * necessaria per calcolare correttamente le posizioni nel multipart.
         */
        String file = new String(dataBytes, "ISO-8859-1");

        int filenameIndex = file.indexOf("filename=\"");

        if(filenameIndex < 0) {
            out.print("ERRORE: nome file non trovato.");
            return;
        }

        saveFile = file.substring(filenameIndex + 10);
        saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
        saveFile = saveFile.substring(
            saveFile.lastIndexOf("\\") + 1,
            saveFile.indexOf("\"")
        );

        /*
         * Evita che un percorso eventualmente inviato dal browser
         * venga utilizzato come nome del file.
         */
        saveFile = new File(saveFile).getName();

        if(saveFile.trim().equals("")) {
            out.print("ERRORE: nome file vuoto.");
            return;
        }

        String percorso = getServletContext().getRealPath("/") + "allegati/";

        File cartella = new File(percorso);

        if(!cartella.exists())
            cartella.mkdirs();

        saveFile = saveFile.replace(" ", "-");

        nomeFile = saveFile;

        int lastIndex = contentType.lastIndexOf("=");

        if(lastIndex < 0) {
            out.print("ERRORE: boundary multipart non trovato.");
            return;
        }

        String boundary = contentType.substring(lastIndex + 1).trim();

        if(
            boundary.startsWith("\"")
            && boundary.endsWith("\"")
            && boundary.length() > 1
        ) {
            boundary = boundary.substring(1, boundary.length() - 1);
        }

        int pos = file.indexOf("filename=\"");
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;
        pos = file.indexOf("\n", pos) + 1;

        int boundaryLocation = file.indexOf(boundary, pos) - 4;

        if(pos <= 0 || boundaryLocation <= pos) {
            out.print("ERRORE: contenuto del file non individuato.");
            return;
        }

        int startPos = file.substring(0, pos).getBytes("ISO-8859-1").length;
        int endPos = file.substring(0, boundaryLocation).getBytes("ISO-8859-1").length;

        String percorsoCompleto = percorso + File.separator + saveFile;
        String percorsoOriginale = percorsoCompleto;

        int indice = 1;
        File f = new File(percorsoCompleto);

        while(f.exists()) {

            int posizionePunto = percorsoOriginale.lastIndexOf(".");

            String nomeSenzaEstensione;
            String estensione;

            if(posizionePunto > percorsoOriginale.lastIndexOf(File.separator)) {
                nomeSenzaEstensione = percorsoOriginale.substring(0, posizionePunto);
                estensione = percorsoOriginale.substring(posizionePunto);
            } else {
                nomeSenzaEstensione = percorsoOriginale;
                estensione = "";
            }

            percorsoCompleto = nomeSenzaEstensione + "_" + indice + estensione;
            f = new File(percorsoCompleto);
            nomeFile = f.getName();

            indice++;
        }

        fileOut = new FileOutputStream(f);
        fileOut.write(dataBytes, startPos, endPos - startPos);
        fileOut.flush();
        fileOut.close();
        fileOut = null;

        /*
         * Compressione eseguita dopo il salvataggio.
         * In caso di errore il file originale resta disponibile.
         */
        try {
            comprimiImmagine(f);
        } catch(Exception ex) {
            ex.printStackTrace();
        }

        out.print(nomeFile);

    } catch(Exception ex) {

        ex.printStackTrace();
        out.print("ERRORE: " + ex.getMessage());

    } finally {

        if(fileOut != null) {
            try {
                fileOut.close();
            } catch(Exception ex) {
                ex.printStackTrace();
            }
        }

        if(in != null) {
            try {
                in.close();
            } catch(Exception ex) {
                ex.printStackTrace();
            }
        }
    }
%>