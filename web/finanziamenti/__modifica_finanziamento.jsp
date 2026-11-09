<%@page import="beans.Finanziamento"%>
<%@page import="gestioneDB.GestionePagamento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    String id_finanziamento=Utility.elimina_null(request.getParameter("id_finanziamento"));
    String campo_da_modificare=Utility.elimina_null(request.getParameter("campo_da_modificare"));
    String new_valore=Utility.elimina_null(request.getParameter("new_valore"));

    Utility.getIstanza().query("UPDATE finanziamento SET "+campo_da_modificare+"="+Utility.is_null(new_valore)+" WHERE id="+Utility.is_null(id_finanziamento));
    if(campo_da_modificare.equals("tipo") && new_valore.equals(Finanziamento.TIPO_TASSO_0))
        Utility.getIstanza().query("UPDATE finanziamento SET prima_rata=30 WHERE id="+Utility.is_null(id_finanziamento));
    
    if(campo_da_modificare.equals("tipo")){
        String id_documento=Utility.getIstanza().query_select("SELECT id_documento FROM finanziamento WHERE id="+Utility.is_null(id_finanziamento), "id_documento");
        Utility.getIstanza().query("UPDATE documento SET contratto_finanziamento="+Utility.is_null(new_valore)+" WHERE id="+Utility.is_null(id_documento));
    }
    
    if(campo_da_modificare.equals("stato") && new_valore.equals("-1")){
        String id_documento=Utility.getIstanza().query_select("SELECT id_documento FROM finanziamento WHERE id="+Utility.is_null(id_finanziamento), "id_documento");
        Utility.getIstanza().query("UPDATE documento SET contratto_finanziamento='' WHERE id="+Utility.is_null(id_documento));
    }

%>