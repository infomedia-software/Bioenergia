<%@page import="beans.Riga"%>
<%@page import="beans.Documento"%>
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
    String contratto_tipologia=Utility.elimina_null(request.getParameter("contratto_tipologia")).trim();
    String conto_termico_tipo=Utility.elimina_null(request.getParameter("conto_termico_tipo")).trim();

    if(id_soggetto.equals("") || id_soggetto.equals("0")){
        id_soggetto=Utility.getIstanza().query_insert("INSERT INTO soggetto(tipologia,privato_azienda,nome,cognome,ragione_sociale,indirizzo,cap,comune,provincia,telefono,cellulare,email,cf,piva,stato) VALUES("+Utility.is_null("CLIENTE")+","+Utility.is_null(privato_azienda)+","+Utility.is_null(nome)+","+Utility.is_null(cognome)+","+Utility.is_null(ragione_sociale)+","+Utility.is_null(indirizzo)+","+Utility.is_null(cap)+","+Utility.is_null(comune)+","+Utility.is_null(provincia)+","+Utility.is_null(telefono)+","+Utility.is_null(cellulare)+","+Utility.is_null(email)+","+Utility.is_null(cf)+","+Utility.is_null(piva)+","+Utility.is_null("1")+")");
    }

    int numero=GestioneDocumento.getIstanza().get_ultimo_numero(tipo);

    String id_documento=Utility.getIstanza().query_insert("INSERT INTO documento(contratto_tipologia,conto_termico_tipo,id_autore,id_soggetto,pagamento,tipo,numero,data,"
            + "cliente_privato_azienda,cliente_nome,cliente_cognome,cliente_ragione_sociale,cliente_cf,cliente_piva,cliente_indirizzo,cliente_cap,cliente_comune,cliente_provincia,cliente_telefono,cliente_cellulare,cliente_email,stato) "
            + "VALUES("+Utility.is_null(contratto_tipologia)+","+Utility.is_null(conto_termico_tipo)+","+Utility.is_null(utente.getId())+","+Utility.is_null(id_soggetto)+",'pagamento',"+Utility.is_null(tipo)+","+numero+",CURDATE(),"
            + Utility.is_null(privato_azienda)+","+Utility.is_null(nome)+","+Utility.is_null(cognome)+","+Utility.is_null(ragione_sociale)+","+Utility.is_null(cf)+","+Utility.is_null(piva)+","+Utility.is_null(indirizzo)+","+Utility.is_null(cap)+","+Utility.is_null(comune)+","+Utility.is_null(provincia)+","+Utility.is_null(telefono)+","+Utility.is_null(cellulare)+","+Utility.is_null(email)+","+Utility.is_null("1")+")");

    
    // Righe
    if(tipo.equals(Documento.TIPO_CONTRATTO)){
        for(int i=0; i<5; i++){
            Utility.getIstanza().query_insert("INSERT INTO riga(id_documento,stato) VALUES ("+Utility.is_null(id_documento)+",'1')");
        }
    }
    
    if(tipo.equals(Documento.TIPO_PREVENTIVO)){
        for(int i=0; i<2; i++){
            String tipo_riga="";
            String descrizione="";
            if(i>0){
                tipo_riga=Riga.TIPO_DESCRITTIVA;
                descrizione=""
                    + "<p><strong>NOTE</strong></p>"
                    + "<p><strong>Limiti di Fornitura</strong></p>"
                    + "<p>Per garantire la massima trasparenza e la corretta esecuzione dei lavori, specifichiamo di seguito le condizioni tecniche incluse nell'offerta:</p>"

                    + "<p><strong>Cablaggio di Stringa (Lato DC):</strong></p>"
                    + "<p>Sono inclusi fino a 20 metri di linea elettrica dedicata (cavo solare di stringa) per il collegamento tra i pannelli fotovoltaici e l'inverter. Eventuali distanze superiori verranno quantificate separatamente.</p>"

                    + "<p><strong>Impianto Elettrico Esistente:</strong></p>"
                    + "<p>L'offerta prevede il collegamento del nuovo impianto fotovoltaico al quadro elettrico generale. Non sono comprese modifiche, adeguamenti o riparazioni dell'impianto elettrico preesistente dell'abitazione, né interventi sulla messa a terra esistente (che si assume a norma e idonea a ricevere il nuovo collegamento). L'offerta non prevede interventi al cavo montante esistente (il collegamento principale tra il contatore del distributore e l'interruttore generale dell'abitazione). Qualora, a seguito di verifiche tecniche fosse necessario l'adeguamento o l'aumento della sezione di tale cavo, l'intervento verrà quantificato a parte previa accettazione di un preventivo integrativo.</p>"

                    + "<p><strong>Opere Murarie:</strong></p>"
                    + "<p>Sono escluse tutte le opere murarie (tracce, fori passanti di grandi dimensioni, ripristini di intonaco o tinteggiatura, scavi per posa canalizzazioni interrate). Il passaggio dei cavi avverrà, dove possibile, utilizzando le predisposizioni esistenti. Qualora fosse necessario l'utilizzo di canaline esterne, queste verranno posate con la massima cura per rispettare il decoro architettonico dell'abitazione, minimizzando l'impatto visivo.</p>"

                    + "<p>L’installazione avverrà sulla copertura nello stato di fatto in cui si trova al momento del sopralluogo. Sono esclusi lavori di rifacimento, impermeabilizzazione o consolidamento strutturale del tetto. La struttura di fissaggio verrà installata previa verifica della solidità della copertura; qualora in fase di montaggio emergessero criticità strutturali non rilevate precedentemente, i lavori verranno sospesi per permettere la messa in sicurezza a carico del cliente. Eventuali interventi di ripristino o sostituzione di tegole, coppi o guaine deteriorati o non idonei (e non direttamente interessati o danneggiati dai lavori di posa dell'impianto) restano a esclusivo carico del cliente.</p>"

                    + "<p><strong>Adeguamenti Normativi Pregressi:</strong> Qualora l'impianto dell'immobile non risultasse a norma per ricevere il fotovoltaico (es. mancanza di messa a terra o quadri vetusti), gli interventi di adeguamento saranno quotati a parte.</p>"

                    + "<p><strong>Wallbox (Colonnina di Ricarica):</strong></p>"
                    + "<p>Compreso di installazione standard su presa già predisposta con cablaggio di adeguate dimensioni. Massimo 5 mt dalla linea/presa esistente.</p>"

                    + "<p><strong>ESCLUSIONI:</strong></p>"
                    + "<p>- Costi del Gestore di Rete: Diritti fissi e oneri per la connessione alla rete pubblica (es. preventivo Enel/E-Distribuzione) si intendono a carico del cliente.</p>"
                    + "<p>- Eventuali diritti di segreteria.</p>"
                    + "<p>- Tutto ciò che non è indicato in preventivo.</p>";
            }
            Utility.getIstanza().query_insert("INSERT INTO riga(descrizione,id_documento,tipo,stato) VALUES ("+Utility.is_null(descrizione)+","+Utility.is_null(id_documento)+","+Utility.is_null(tipo_riga)+",'1')");
        }
        Utility.getIstanza().query("UPDATE documento SET id_situazione=8,validita='7 giorni', modalita_pagamento="+Utility.is_null("30% acconto<br>70% entro 7 giorni da installazione")+" WHERE id="+Utility.is_null(id_documento));
    }
    
    // Pagamenti
    Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto, id_autore, descrizione, stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento della stipula del presente contratto','1')");
    Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto,id_autore,descrizione,stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento dell''avviso della merce pronta','1')");
    Utility.getIstanza().query_insert("INSERT INTO pagamento(entrata_uscita,id_documento,id_soggetto, id_autore, descrizione, stato) VALUES ('entrata',"+Utility.is_null(id_documento)+","+Utility.is_null(id_soggetto)+","+Utility.is_null(utente.getId())+",'al momento della fine installazione-montaggio','1')");
    out.print(id_documento);
%>