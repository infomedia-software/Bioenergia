<%@page import="utility.Utility"%>

<%
    String idrif=Utility.elimina_null(request.getParameter("idrif"));
    String rif=Utility.elimina_null(request.getParameter("rif"));    
%>

<script type='text/javascript'>
    
  $(function () {
    $("#fileupload_<%=rif%>_<%=idrif%>").fileupload({
        add: function (e, data) {
            var maxFileSize = 10 * 1024 * 1024; // 10 MB in byte
            var allowedExtensions = /(\.pdf|\.doc|\.docx|\.xls|\.xlsx|\.csv|\.jpg|\.jpeg|\.gif|\.webp|\.png|\.mp4|\.mov|\.avi|\.mkv)$/i;

            var isValid = true;

            $.each(data.files, function (index, file) {
                if (file.size > maxFileSize) {
                    alert("Il file è troppo grande (max 10 MB).");
                    isValid = false;
                    location.reload();
                    return false; // esce dal ciclo each
                }
                if (!allowedExtensions.exec(file.name)) {
                    alert("Formato file non supportato. Sono accettati solo .pdf, .doc, .docx, .xls, .xlsx, .csv, .jpg, .jpeg, .gif, .webp, .png, .mp4, .mov, .avi, .mkv.");
                    isValid = false;
                    location.reload();
                    return false;
                }
            });

            if (!isValid) return;

            mostra_loader("Caricamento Allegato in corso...");
            data.submit();
        },
        done: function (e, data) {
            $.each(data.files, function (index, file) {
                var nomefile = data.result;
                $.ajax({
                    type: "POST",
                    url: "<%=Utility.url%>/__nuovo_allegato.jsp",
                    data: "idrif=<%=idrif%>&rif=<%=rif%>&url=" + encodeURIComponent(String(nomefile)),
                    dataType: "html",
                    success: function (msg) {
                        aggiorna_allegati<%=rif%>_<%=idrif%>();
                    },
                    error: function () {
                        alert("IMPOSSIBILE EFFETTUARE L'OPERAZIONE fileupload");
                    }
                });
            });
        },
        disableImageResize: /Android(?!.*Chrome)|Opera/.test(window.navigator && navigator.userAgent),
        imageMaxWidth: 1920,
        imageMaxHeight: 1080,
        imageCrop: false,
        progressall: function (e, data) {
            mostra_loader("Caricamento Allegato in corso...");
        }
    });
});

    function uploadclick_<%=rif%>_<%=idrif%>(){
        document.getElementById('fileupload_<%=rif%>_<%=idrif%>').click();
    }
</script>
<input type='hidden' id='idrif' value='<%=idrif%>'>   
<input id="fileupload_<%=rif%>_<%=idrif%>" style='display:none' type="file" name="files[]" data-url="<%=Utility.url%>/__upload.jsp" multiple >

<button class='pulsante_medium float-right pulsante_upload' onclick="uploadclick_<%=rif%>_<%=idrif%>();"><i class="fa-solid fa-plus"></i>Allega</button>
<div class="height-10"></div>
