<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    String id_pagamento=Utility.elimina_null(request.getParameter("id_pagamento"));
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    String campo_da_modificare=Utility.elimina_null(request.getParameter("campo_da_modificare"));
    String new_valore=Utility.elimina_null(request.getParameter("new_valore"));

    Utility.getIstanza().query("UPDATE pagamento SET "+campo_da_modificare+"="+Utility.is_null(new_valore)+" WHERE id="+Utility.is_null(id_pagamento));

    if(campo_da_modificare.equals("percentuale")){
        Documento documento=GestioneDocumento.getIstanza().get_documento(id_documento);
        double percentuale=Utility.converti_stringa_double(new_valore);
        double importo=Math.round((documento.getTotale()*percentuale/100)*100.0)/100.0;

        Utility.getIstanza().query("UPDATE pagamento SET importo="+importo+" WHERE id="+Utility.is_null(id_pagamento));
    }
%>