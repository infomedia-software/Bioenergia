<%@page import="beans.Soggetto"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="utility.Utility"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");

    String tipo=Utility.elimina_null(request.getParameter("tipo")).trim();
    String id_soggetto=Utility.elimina_null(request.getParameter("id_soggetto")).trim();
    String ragione_sociale=Utility.elimina_null(request.getParameter("ragione_sociale")).trim();
    String privato_azienda=Utility.elimina_null(request.getParameter("privato_azienda")).trim();
    String nome=Utility.elimina_null(request.getParameter("nome")).trim();
    String cognome=Utility.elimina_null(request.getParameter("cognome")).trim();
    String indirizzo=Utility.elimina_null(request.getParameter("indirizzo")).trim();
    String cap=Utility.elimina_null(request.getParameter("cap")).trim();
    String comune=Utility.elimina_null(request.getParameter("comune")).trim();
    String provincia=Utility.elimina_null(request.getParameter("provincia")).trim();
    String telefono=Utility.elimina_null(request.getParameter("telefono")).trim();
    String cellulare=Utility.elimina_null(request.getParameter("cellulare")).trim();
    String email=Utility.elimina_null(request.getParameter("email")).trim();
    String cf=Utility.elimina_null(request.getParameter("cf")).trim();
    String piva=Utility.elimina_null(request.getParameter("piva")).trim();

    if(id_soggetto.equals("") || id_soggetto.equals("0")){
        id_soggetto=Utility.getIstanza().query_insert("INSERT INTO soggetto(tipologia,privato_azienda,nome,cognome,ragione_sociale,indirizzo,cap,comune,provincia,telefono,cellulare,email,cf,piva,stato) VALUES("+Utility.is_null("CLIENTE")+","+Utility.is_null(privato_azienda)+","+Utility.is_null(nome)+","+Utility.is_null(cognome)+","+Utility.is_null(ragione_sociale)+","+Utility.is_null(indirizzo)+","+Utility.is_null(cap)+","+Utility.is_null(comune)+","+Utility.is_null(provincia)+","+Utility.is_null(telefono)+","+Utility.is_null(cellulare)+","+Utility.is_null(email)+","+Utility.is_null(cf)+","+Utility.is_null(piva)+","+Utility.is_null("1")+")");
    }

    int numero=GestioneDocumento.getIstanza().get_ultimo_numero(tipo);

    String id_documento=Utility.getIstanza().query_insert("INSERT INTO documento(id_autore,id_soggetto,pagamento,tipo,numero,data,"
            + "cliente_privato_azienda,cliente_nome,cliente_cognome,cliente_ragione_sociale,cliente_cf,cliente_piva,cliente_indirizzo,cliente_cap,cliente_comune,cliente_provincia,cliente_telefono,cliente_cellulare,cliente_email,stato) "
            + "VALUES("+Utility.is_null(utente.getId())+","+Utility.is_null(id_soggetto)+",'pagamento',"+Utility.is_null(tipo)+","+numero+",CURDATE(),"
            + Utility.is_null(privato_azienda)+","+Utility.is_null(nome)+","+Utility.is_null(cognome)+","+Utility.is_null(ragione_sociale)+","+Utility.is_null(cf)+","+Utility.is_null(piva)+","+Utility.is_null(indirizzo)+","+Utility.is_null(cap)+","+Utility.is_null(comune)+","+Utility.is_null(provincia)+","+Utility.is_null(telefono)+","+Utility.is_null(cellulare)+","+Utility.is_null(email)+","+Utility.is_null("1")+")");

    
    // Righe
    for(int i=0; i<5; i++){
        Utility.getIstanza().query_insert("INSERT INTO riga(id_documento,stato) VALUES ("+Utility.is_null(id_documento)+",'1')");
    }
    
    // Pagamenti
    Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto, id_autore, descrizione, stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento della stipula del presente contratto','1')");
    Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto,id_autore,descrizione,stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento dell''avviso della merce pronta','1')");
    Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto, id_autore, descrizione, stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento della fine installazione-montaggio','1')");
    
    
    out.print(id_documento);
%>