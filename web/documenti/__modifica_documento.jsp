<%@page import="beans.Documento"%>
<%@page import="gestioneDB.GestioneDocumento"%>
<%@page import="gestioneDB.GestioneSoggetto"%>
<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String id_documento=Utility.elimina_null(request.getParameter("id_documento"));
    String campo_da_modificare=Utility.elimina_null(request.getParameter("campo_da_modificare"));
    String new_valore=Utility.elimina_null(request.getParameter("new_valore"));

    // PAGAMENTO
    if(campo_da_modificare.equals("pagamento") ){
        Documento d=GestioneDocumento.getIstanza().get_documento(id_documento);
        String pagamento=d.getPagamento();
        String id_soggetto=d.getId_soggetto()+"";
        
        // inserisce rate pagamento senza finanziamento
        if(new_valore.contains("pagamento") && !pagamento.contains("pagamento")){
            Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto, id_autore, descrizione, stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento della stipula del presente contratto','1')");
            Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto,id_autore,descrizione,stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento dell''avviso della merce pronta','1')");
            Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto, id_autore, descrizione, stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento della fine installazione-montaggio','1')");
        }
        // inserisce pagamento con finanziamento
        if(new_valore.contains("finanziamento") && !pagamento.contains("finanziamento")){
            Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,finanziamento,id_documento,id_soggetto, id_autore, descrizione, stato) VALUES ('entrata','si',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'','1')");
        }
        if(!new_valore.contains("pagamento"))
            Utility.getIstanza().query("DELETE FROM pagamento WHERE id_documento="+Utility.is_null(id_documento)+" AND finanziamento='' ");
        if(!new_valore.contains("finanziamento"))
            Utility.getIstanza().query("DELETE FROM pagamento WHERE id_documento="+Utility.is_null(id_documento)+" AND finanziamento='si' ");
        
        // aggiorno il campo "pagamento"
        Utility.getIstanza().query("UPDATE documento SET "+campo_da_modificare+"="+Utility.is_null(new_valore)+" WHERE id="+Utility.is_null(id_documento));
        return;
    }

    
    
    Utility.getIstanza().query("UPDATE documento SET "+campo_da_modificare+"="+Utility.is_null(new_valore)+" WHERE id="+Utility.is_null(id_documento));
    
    if(campo_da_modificare.equals("cliente_privato_azienda")){
        String id_soggetto=Utility.getIstanza().query_select("SELECT id_soggetto FROM documento WHERE id="+Utility.is_null(id_documento),"id_soggetto");
        if(new_valore.equals("privato")){
            Utility.getIstanza().query("UPDATE documento SET cliente_ragione_sociale='' WHERE id="+Utility.is_null(id_documento));
            if(!id_soggetto.equals("") && !id_soggetto.equals("0")) Utility.getIstanza().query("UPDATE soggetto SET privato_azienda='privato',ragione_sociale='' WHERE id="+Utility.is_null(id_soggetto));
        }else if(new_valore.equals("azienda")){
            Utility.getIstanza().query("UPDATE documento SET cliente_nome='',cliente_cognome='' WHERE id="+Utility.is_null(id_documento));
            if(!id_soggetto.equals("") && !id_soggetto.equals("0")) Utility.getIstanza().query("UPDATE soggetto SET privato_azienda='azienda',nome='',cognome='' WHERE id="+Utility.is_null(id_soggetto));
        }
    }
    
    if(campo_da_modificare.equals("id_soggetto")){
        Soggetto cliente=GestioneSoggetto.getIstanza().get_soggetto(new_valore);

        if(cliente!=null){
            Utility.getIstanza().query(
                "UPDATE documento SET "+
                "cliente_nome="+Utility.is_null(cliente.getNome())+","+
                "cliente_cognome="+Utility.is_null(cliente.getCognome())+","+
                "cliente_ragione_sociale="+Utility.is_null(cliente.getRagione_sociale())+","+
                "cliente_cf="+Utility.is_null(cliente.getCf())+","+
                "cliente_piva="+Utility.is_null(cliente.getPiva())+","+
                "cliente_indirizzo="+Utility.is_null(cliente.getIndirizzo())+","+
                "cliente_cap="+Utility.is_null(cliente.getCap())+","+
                "cliente_comune="+Utility.is_null(cliente.getComune())+","+
                "cliente_provincia="+Utility.is_null(cliente.getProvincia())+","+
                "cliente_telefono="+Utility.is_null(cliente.getTelefono())+","+
                "cliente_cellulare="+Utility.is_null(cliente.getCellulare())+","+
                "cliente_email="+Utility.is_null(cliente.getEmail())+", "+
                "cliente_data_nascita="+Utility.is_null(cliente.getData_nascita())+", "+
                "cliente_luogo_nascita="+Utility.is_null(cliente.getLuogo_nascita())+" "+
                "WHERE id="+Utility.is_null(id_documento)
            );
        }
    }else{
        String campo_soggetto="";

        if(campo_da_modificare.equals("cliente_nome")) campo_soggetto="nome";
        else if(campo_da_modificare.equals("cliente_cognome")) campo_soggetto="cognome";
        else if(campo_da_modificare.equals("cliente_ragione_sociale")) campo_soggetto="ragione_sociale";
        else if(campo_da_modificare.equals("cliente_cf")) campo_soggetto="cf";
        else if(campo_da_modificare.equals("cliente_piva")) campo_soggetto="piva";
        else if(campo_da_modificare.equals("cliente_indirizzo")) campo_soggetto="indirizzo";
        else if(campo_da_modificare.equals("cliente_cap")) campo_soggetto="cap";
        else if(campo_da_modificare.equals("cliente_comune")) campo_soggetto="comune";
        else if(campo_da_modificare.equals("cliente_provincia")) campo_soggetto="provincia";
        else if(campo_da_modificare.equals("cliente_telefono")) campo_soggetto="telefono";
        else if(campo_da_modificare.equals("cliente_cellulare")) campo_soggetto="cellulare";
        else if(campo_da_modificare.equals("cliente_email")) campo_soggetto="email";
        else if(campo_da_modificare.equals("cliente_data_nascita")) campo_soggetto="data_nascita";
        else if(campo_da_modificare.equals("cliente_luogo_nascita")) campo_soggetto="luogo_nascita";

        if(!campo_soggetto.equals("")){
            String id_soggetto=Utility.getIstanza().query_select("SELECT id_soggetto FROM documento WHERE id="+Utility.is_null(id_documento),"id_soggetto");
            if(!id_soggetto.equals("") && !id_soggetto.equals("0"))
                Utility.getIstanza().query("UPDATE soggetto SET "+campo_soggetto+"="+Utility.is_null(new_valore)+" WHERE id="+Utility.is_null(id_soggetto));
        }
    }
    
    if(campo_da_modificare.equals("stato")){
        Utility.getIstanza().query("UPDATE riga SET "+campo_da_modificare+"="+new_valore+" WHERE id_documento="+id_documento);
        Utility.getIstanza().query("UPDATE pagamento SET "+campo_da_modificare+"="+new_valore+" WHERE id_documento="+id_documento);
    }
    
  
%>