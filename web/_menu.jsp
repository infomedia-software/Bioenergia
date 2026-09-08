<%@page import="beans.Soggetto"%>
<%@page import="utility.Utility"%>
<%
    
    Soggetto utente=(Soggetto)session.getAttribute("utente");
    String pagina=request.getRequestURI();
    String tipologia=Utility.elimina_null(request.getParameter("tipologia"));
    String nome_utente=Utility.elimina_null(utente.getNome())+" "+Utility.elimina_null(utente.getCognome());
    
    boolean menu_anagrafiche=pagina.endsWith("lista_soggetto.jsp") || pagina.endsWith("lista_utente.jsp");
    boolean menu_configurazione=pagina.endsWith("macchine.jsp") || pagina.endsWith("lavorazioni.jsp") || pagina.endsWith("lista_job_categoria.jsp") || pagina.endsWith("lavorazione_categorie.jsp") || pagina.endsWith("carta_categorie.jsp") || pagina.endsWith("impostazioni.jsp");
    boolean menu_cliente=pagina.endsWith("lista_soggetto.jsp") && tipologia.equals("CLIENTE");
    boolean menu_fornitore=pagina.endsWith("lista_soggetto.jsp") && tipologia.equals("FORNITORE");
%>
<jsp:include page="_loader.jsp"></jsp:include>

<div id="popup" class="popup" style="display:none;">
    <div class="popup_box">
        <div class="popup_header">
            <h2 id="popup_titolo"></h2>
            <button type="button" class="popup_chiudi" onclick="nascondi_popup();">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>
        <div id="popup_contenuto" class="popup_contenuto"></div>
    </div>
</div>

<button type="button" id="menu_toggle" onclick="toggle_menu();">
    <i class="fas fa-bars"></i>
</button>

<div id="menu_overlay" onclick="chiudi_menu();"></div>

<div id="menu">
    <div class="logo">                
        <img src="<%=Utility.url%>/img/bioenergia.png" alt="">
    </div>
    <div class="menu_utente">
        <div class="menu_utente_icona">
            <i class="fa-solid fa-user"></i>
        </div>
        <div class="menu_utente_testo">
            <span class="menu_utente_nome"><%=nome_utente%></span>
            <span class="menu_utente_ruolo"><%=utente.is_amministratore() ? "Amministratore" : "Dipendente"%></span>
        </div>
        <a href="<%=Utility.url%>/utente/__logout.jsp" class="menu_utente_logout" title="Logout">
            <i class="fa-solid fa-right-from-bracket"></i>
        </a>
    </div>
    <div class="menu_divisore"></div>
    

    <a href="<%=Utility.url%>/documenti/index.jsp?tipo=contratto" class="<%=pagina.endsWith("index.jsp?tipo=contratto") ? "attivo" : ""%>">
        <i class="fa-solid fa-file-invoice"></i>
        <span>Contratti</span>
    </a>
    <div class="menu-gruppo <%=menu_anagrafiche ? "aperto" : ""%>">
        <a href="javascript:void(0);" class="menu-voce" onclick="$(this).closest('.menu-gruppo').toggleClass('aperto');">
            <i class="fa-solid fa-address-book"></i>
            <span>Anagrafiche</span>
            <i class="fa-solid fa-chevron-down menu-freccia"></i>
        </a>
        <div class="sottomenu">
            <a href="<%=Utility.url%>/soggetto/lista_soggetto.jsp?tipologia=CLIENTE" class="<%=menu_cliente ? "attivo" : ""%>">
                <i class="fa-solid fa-users"></i>
                <span>Clienti</span>
            </a>
            
            <%if(utente.is_amministratore()){%>
            <a href="<%=Utility.url%>/utente/lista_utente.jsp" class="<%=pagina.endsWith("lista_utente.jsp") ? "attivo" : ""%>">
                <i class="fa-solid fa-user-group"></i>
                <span>Utenti</span>
            </a>
            <%}%>
        </div>
    </div>
    
    <%if(utente.is_amministratore()){%>
    <div class="menu-gruppo <%=menu_configurazione ? "aperto" : ""%>">
        <a href="javascript:void(0);" class="menu-voce" style="display: none;" onclick="$(this).closest('.menu-gruppo').toggleClass('aperto');">
            <i class="fa-solid fa-sliders"></i>
            <span>Configurazione</span>
            <i class="fa-solid fa-chevron-down menu-freccia"></i>
        </a>
        <div class="sottomenu">
            <a href="<%=Utility.url%>/macchina/macchine.jsp" class="<%=pagina.endsWith("macchine.jsp") ? "attivo" : ""%>">
                <i class="fa-solid fa-print"></i>
                <span>Macchine</span>
            </a>
            
        </div>
    </div>
    <%}%>
</div>