<%@page import="beans.DashboardPreventivo"%>
<%@page import="beans.DashboardAutore"%>
<%@page import="beans.DashboardVoce"%>
<%@page import="beans.DashboardHome"%>
<%@page import="gestioneDB.GestioneDashboard"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Locale"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    int anno_corrente=Calendar.getInstance().get(Calendar.YEAR);
    int anno=anno_corrente;
    try{
        if(request.getParameter("anno")!=null)anno=Integer.parseInt(request.getParameter("anno"));
    }catch(Exception e){anno=anno_corrente;}
    GestioneDashboard gestione_dashboard=new GestioneDashboard();
    DashboardHome dashboard=gestione_dashboard.carica_dashboard(anno);
    NumberFormat formato_euro=NumberFormat.getCurrencyInstance(Locale.ITALY);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <jsp:include page="_importazioni.jsp"></jsp:include>
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
</head>
<body>
    
    
<div id="container">
    <jsp:include page="_menu.jsp"></jsp:include>
    <div id="content">
        
<div class="dashboard">
    <div class="dashboard_header">
        <div>
            <h1>Dashboard preventivi</h1>
            <p>Situazione generale dei preventivi dell'anno selezionato.</p>
        </div>
        <form method="get" class="dashboard_filtro">
            <label for="anno">Anno</label>
            <select name="anno" id="anno" onchange="this.form.submit()">
                <%for(int anno_opzione=anno_corrente;anno_opzione>=anno_corrente-5;anno_opzione--){%>
                    <option value="<%=anno_opzione%>" <%=anno_opzione==anno ? "selected" : ""%>><%=anno_opzione%></option>
                <%}%>
            </select>
        </form>
    </div>
    <div class="dashboard_kpi">
        <div class="kpi"><div class="kpi_icona blu"><i class="fa-regular fa-file-lines"></i></div><div class="kpi_testo"><span>Preventivi</span><strong><%=dashboard.getPreventivi_totali()%></strong><small>Totali nel <%=anno%></small></div></div>
        <div class="kpi"><div class="kpi_icona arancio"><i class="fa-solid fa-pen-ruler"></i></div><div class="kpi_testo"><span>Da lavorare</span><strong><%=dashboard.getPreventivi_preparazione()%></strong><small>Bozza o preparazione</small></div></div>
        <div class="kpi"><div class="kpi_icona verde"><i class="fa-solid fa-circle-check"></i></div><div class="kpi_testo"><span>Accettati</span><strong><%=dashboard.getPreventivi_accettati()%></strong><small>Conversione <%=dashboard.getConversione()%>%</small></div></div>
        <div class="kpi"><div class="kpi_icona viola"><i class="fa-solid fa-euro-sign"></i></div><div class="kpi_testo"><span>Valore preventivato</span><strong class="kpi_importo"><%=formato_euro.format(dashboard.getTotale_vendita())%></strong><small>Accettato <%=formato_euro.format(dashboard.getTotale_accettato())%></small></div></div>
    </div>
    <div class="dashboard_riga">
        <section class="dashboard_box">
            <div class="box_header"><div><h2>Preventivi per situazione</h2><p>Distribuzione degli stati nel <%=anno%>.</p></div></div>
            <div class="barre">
                <%if(dashboard.getSituazioni().isEmpty()){%><div class="dashboard_vuoto">Nessun preventivo presente.</div><%}%>
                <%for(DashboardVoce voce:dashboard.getSituazioni()){%>
                    <div class="barra_riga"><div class="barra_info"><span><%=voce.getNome()%></span><strong><%=voce.getQuantita()%></strong></div><div class="barra_sfondo"><div class="barra_valore" style="width:<%=voce.getPercentuale()%>%"></div></div></div>
                <%}%>
            </div>
        </section>
        <section class="dashboard_box">
            <div class="box_header"><div><h2>Categorie di prodotto</h2><p>Tipologie di job maggiormente preventivate.</p></div></div>
            <div class="barre">
                <%if(dashboard.getCategorie().isEmpty()){%><div class="dashboard_vuoto">Nessuna categoria presente.</div><%}%>
                <%for(DashboardVoce voce:dashboard.getCategorie()){%>
                    <div class="barra_riga"><div class="barra_info"><span><%=voce.getNome()%></span><strong><%=voce.getQuantita()%></strong></div><div class="barra_sfondo"><div class="barra_valore categoria" style="width:<%=voce.getPercentuale()%>%"></div></div></div>
                <%}%>
            </div>
        </section>
    </div>
    <div class="dashboard_riga">
        <section class="dashboard_box">
            <div class="box_header"><div><h2>Risultati per autore</h2><p>Confronto sintetico tra gli operatori.</p></div></div>
            <div class="autori">
                <%if(dashboard.getAutori().isEmpty()){%><div class="dashboard_vuoto">Nessun autore presente.</div><%}%>
                <%for(DashboardAutore autore:dashboard.getAutori()){%>
                    <div class="autore_riga"><div class="autore_avatar"><%=autore.getIniziali()%></div><div class="autore_dati"><strong><%=autore.getNome()%></strong><span><%=autore.getPreventivi()%> preventivi · <%=autore.getAccettati()%> accettati</span></div><div class="autore_valori"><strong><%=autore.getConversione()%>%</strong><span><%=formato_euro.format(autore.getTotale_accettato())%></span></div></div>
                <%}%>
            </div>
        </section>
        <section class="dashboard_box dashboard_economico">
            <div class="box_header"><div><h2>Riepilogo economico</h2><p>Valori complessivi dei preventivi.</p></div></div>
            <div class="economico_riga"><span>Valore preventivato</span><strong><%=formato_euro.format(dashboard.getTotale_vendita())%></strong></div>
            <div class="economico_riga"><span>Costi di produzione</span><strong><%=formato_euro.format(dashboard.getTotale_produzione())%></strong></div>
            <div class="economico_riga evidenza"><span>Margine potenziale</span><strong><%=formato_euro.format(dashboard.getMargine())%></strong></div>
            <div class="economico_riga"><span>Margine percentuale</span><strong><%=dashboard.getMargine_percentuale()%>%</strong></div>
            <div class="economico_riga"><span>Valore accettato</span><strong><%=formato_euro.format(dashboard.getTotale_accettato())%></strong></div>
        </section>
    </div>
    <section class="dashboard_box dashboard_ultimi">
        <div class="box_header"><div><h2>Ultimi preventivi</h2><p>Gli ultimi preventivi inseriti o modificati.</p></div><a class="box_link" href="preventivi.jsp">Vedi tutti <i class="fa-solid fa-arrow-right"></i></a></div>
        <div class="tabella_scroll">
            <table>
                <thead><tr><th>Preventivo</th><th>Cliente</th><th>Oggetto</th><th>Autore</th><th>Situazione</th><th class="destra">Totale</th></tr></thead>
                <tbody>
                    <%if(dashboard.getUltimi_preventivi().isEmpty()){%><tr><td colspan="6" class="dashboard_vuoto">Nessun preventivo presente.</td></tr><%}%>
                    <%for(DashboardPreventivo preventivo:dashboard.getUltimi_preventivi()){%>
                        <tr onclick="location.href='preventivo.jsp?id=<%=preventivo.getId()%>'">
                            <td><strong>n. <%=preventivo.getNumero()%><%=preventivo.getRevisione()>0 ? " rev. "+preventivo.getRevisione() : ""%></strong><span><%=preventivo.getData()==null ? "" : preventivo.getData()%></span></td>
                            <td><%=preventivo.getCliente()%></td><td><%=preventivo.getOggetto()%></td><td><%=preventivo.getAutore()%></td>
                            <td><span class="situazione situazione_<%=preventivo.getSituazione().toLowerCase()%>"><%=gestione_dashboard.nome_situazione(preventivo.getSituazione())%></span></td>
                            <td class="destra"><strong><%=formato_euro.format(preventivo.getTotale())%></strong></td>
                        </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
    </section>
</div>
</div>
</div>
</body>
</html>
