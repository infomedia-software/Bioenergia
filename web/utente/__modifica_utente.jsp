<%@page import="utility.Utility"%>
<%
    String id_utente = Utility.elimina_null(request.getParameter("id_utente"));
    String campo_da_modificare = Utility.elimina_null(request.getParameter("campo_da_modificare"));
    String new_valore = Utility.elimina_null(request.getParameter("new_valore"));

    Utility.getIstanza().query(
        "UPDATE soggetto SET "
        + campo_da_modificare + "=" + Utility.is_null(new_valore)
        + " WHERE id=" + id_utente
    );
%>