<%@page import="gestioneDB.GestionePagamento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    String id_riga=Utility.elimina_null(request.getParameter("id_riga"));
    String campo_da_modificare=Utility.elimina_null(request.getParameter("campo_da_modificare"));
    String new_valore=Utility.elimina_null(request.getParameter("new_valore"));

    Utility.getIstanza().query("UPDATE riga SET "+campo_da_modificare+"="+Utility.is_null(new_valore)+" WHERE id="+Utility.is_null(id_riga));
    String id_documento=Utility.getIstanza().query_select("SELECT id_documento FROM riga WHERE id="+Utility.is_null(id_riga), "id_documento");

    if(campo_da_modificare.equals("totale")){
        double aliquota=Utility.getIstanza().query_select_double("SELECT aliquota FROM riga WHERE id="+Utility.is_null(id_riga), "aliquota");
        double totale=Utility.converti_stringa_double(new_valore);
        double imponibile=totale/(1+(aliquota/100));
        double iva=totale-imponibile;
        Utility.getIstanza().query("UPDATE riga SET imponibile="+imponibile+",iva="+iva+" WHERE id="+Utility.is_null(id_riga));
        GestioneDocumento.getIstanza().aggiorna_totali_documento(id_documento);
        GestionePagamento.getIstanza().aggiorna_importi_pagamenti(id_documento);
    }

%>