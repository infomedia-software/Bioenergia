
<%@page import="connection.ConnectionPool"%>
<%@page import="beans.Soggetto"%>
<%@page contentType="text/html" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
    Soggetto utente=(Soggetto)session.getAttribute("utente");

    if(utente==null){
        response.sendError(401,"Sessione scaduta");
        return;
    }

    // IMPORTANTE: aggiungere qui il controllo del ruolo amministratore
    // secondo i permessi effettivi di Bioenergia.

    ConnectionPool pool=ConnectionPool.getConnectionPool();

    if("si".equals(request.getParameter("ajax"))){

        response.setContentType("application/json;charset=UTF-8");

        int totali=pool.getNumeroConnessioni();
        int libere=pool.getConnessioniLibere();
        int occupate=pool.getConnessioniOccupate();
        int attesa=pool.getThreadInAttesa();

        String stato="OK";

        if(occupate>=20 || attesa>0)
            stato="CRITICO";
        else if(occupate>=15)
            stato="ATTENZIONE";

        out.print("{\"totali\":"+totali+",\"libere\":"+libere+",\"occupate\":"+occupate+",\"attesa\":"+attesa+",\"massimo\":20,\"stato\":\""+stato+"\"}");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Monitor connessioni - Bioenergia</title>

<style>
*{box-sizing:border-box}
body{font-family:Arial,sans-serif;background:#f3f6fa;margin:0;padding:25px;color:#253246}
.monitor{max-width:1000px;margin:auto}
.header{display:flex;justify-content:space-between;align-items:center;gap:15px;margin-bottom:25px}
h1{font-size:25px;margin:0 0 7px}
.subtitle{color:#778397;font-size:13px}
.badge{padding:9px 15px;border-radius:20px;background:#e5e7eb;color:#374151;font-weight:bold;font-size:12px}
.badge.ok{background:#dcfce7;color:#166534}
.badge.attenzione{background:#fef3c7;color:#92400e}
.badge.critico{background:#fee2e2;color:#991b1b}
.cards{display:grid;grid-template-columns:repeat(4,1fr);gap:15px}
.card{background:white;padding:23px;border-radius:13px;box-shadow:0 2px 10px #0000000b}
.card .label{font-size:13px;color:#718096;margin-bottom:12px}
.card .numero{font-size:38px;font-weight:bold}
.card.libere .numero{color:#16a34a}
.card.occupate .numero{color:#2563eb}
.card.attesa .numero{color:#dc2626}
.panel{background:white;border-radius:13px;padding:25px;margin-top:20px;box-shadow:0 2px 10px #0000000b}
.panel-title{font-size:17px;font-weight:bold;margin-bottom:18px}
.progress{height:17px;background:#e5e7eb;border-radius:20px;overflow:hidden}
.progress-bar{height:100%;width:0;background:#16a34a;transition:width .4s}
.progress-info{display:flex;justify-content:space-between;font-size:13px;color:#64748b;margin-top:10px}
.info{margin-top:18px;padding:15px;background:#eff6ff;color:#1e40af;border-radius:8px;font-size:13px;line-height:1.6}
.footer{margin-top:20px;color:#64748b;font-size:12px;text-align:center}
@media(max-width:700px){body{padding:12px}.cards{grid-template-columns:repeat(2,1fr)}.card{padding:16px}.card .numero{font-size:30px}.header{align-items:flex-start;flex-direction:column}}
</style>
</head>

<body>
<div class="monitor">

    <div class="header">
        <div>
            <h1>Monitor connessioni MySQL</h1>
            <div class="subtitle">Bioenergia - ConnectionPool</div>
        </div>
        <span id="stato" class="badge">Caricamento...</span>
    </div>

    <div class="cards">
        <div class="card">
            <div class="label">Connessioni totali</div>
            <div class="numero" id="totali">-</div>
        </div>

        <div class="card libere">
            <div class="label">Connessioni libere</div>
            <div class="numero" id="libere">-</div>
        </div>

        <div class="card occupate">
            <div class="label">Connessioni occupate</div>
            <div class="numero" id="occupate">-</div>
        </div>

        <div class="card attesa">
            <div class="label">Richieste in attesa</div>
            <div class="numero" id="attesa">-</div>
        </div>
    </div>

    <div class="panel">
        <div class="panel-title">Utilizzo del pool</div>
        <div class="progress">
            <div class="progress-bar" id="barra"></div>
        </div>
        <div class="progress-info">
            <span id="percentuale">0%</span>
            <span id="utilizzo">0 / 20 connessioni</span>
        </div>

        <div class="info" id="messaggio">
            Caricamento dello stato delle connessioni...
        </div>
    </div>

    <div class="footer">
        Ultimo aggiornamento: <span id="aggiornamento">-</span>
        | Aggiornamento automatico ogni 5 secondi
    </div>

</div>

<script>
function aggiornaMonitor(){

    fetch(window.location.pathname+"?ajax=si",{cache:"no-store",credentials:"same-origin"})
    .then(function(response){
        if(!response.ok)
            throw new Error("HTTP "+response.status);
        return response.json();
    })
    .then(function(d){

        document.getElementById("totali").textContent=d.totali;
        document.getElementById("libere").textContent=d.libere;
        document.getElementById("occupate").textContent=d.occupate;
        document.getElementById("attesa").textContent=d.attesa;

        var percentuale=d.massimo>0?Math.round(d.occupate/d.massimo*100):0;

        document.getElementById("barra").style.width=percentuale+"%";
        document.getElementById("percentuale").textContent=percentuale+"%";
        document.getElementById("utilizzo").textContent=d.occupate+" / "+d.massimo+" connessioni occupate";

        var barra=document.getElementById("barra");
        var stato=document.getElementById("stato");
        var messaggio=document.getElementById("messaggio");

        stato.className="badge "+d.stato.toLowerCase();
        stato.textContent=d.stato;

        if(d.stato==="CRITICO"){
            barra.style.background="#dc2626";
            messaggio.textContent="ATTENZIONE: pool saturo o richieste in attesa. Verificare eventuali query lente o connessioni non rilasciate.";
        }else if(d.stato==="ATTENZIONE"){
            barra.style.background="#f59e0b";
            messaggio.textContent="Il numero di connessioni occupate è elevato. Monitorare la situazione.";
        }else{
            barra.style.background="#16a34a";
            messaggio.textContent="Il pool sta funzionando regolarmente e sono disponibili connessioni.";
        }

        document.getElementById("aggiornamento").textContent=new Date().toLocaleTimeString("it-IT");
    })
    .catch(function(errore){
        document.getElementById("stato").className="badge critico";
        document.getElementById("stato").textContent="NON DISPONIBILE";
        document.getElementById("messaggio").textContent="Impossibile aggiornare il monitor: "+errore.message;
    });
}

aggiornaMonitor();
setInterval(aggiornaMonitor,5000);
</script>
</body>
</html>
