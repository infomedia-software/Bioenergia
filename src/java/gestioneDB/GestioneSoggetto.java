package gestioneDB;

import beans.Soggetto;
import enums.SoggettoTipologia;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;

public class GestioneSoggetto {

    private static GestioneSoggetto istanza;

    public static GestioneSoggetto getIstanza() {
        if (istanza == null) {
            istanza = new GestioneSoggetto();
        }
        return istanza;
    }

    public Soggetto get_soggetto(String id_soggetto) {

        Soggetto toReturn = null;

        ArrayList<Soggetto> temp = ricerca_soggetto(
                "soggetto.id=" + id_soggetto + " AND soggetto.stato='1'",
                "",
                -1
        );

        if (temp.size() == 1) {
            toReturn = temp.get(0);
        }

        return toReturn;
    }

    public ArrayList<Soggetto> ricerca_soggetto(String query_input, String ordinamento, int offset) {

        ArrayList<Soggetto> toReturn = new ArrayList<Soggetto>();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;


        try {

            String query =
                    "SELECT * FROM soggetto WHERE 1=1 ";

            if (query_input != null && !query_input.trim().equals("")) {
                query += " AND " + query_input;
            }

            if (ordinamento != null && !ordinamento.trim().equals("")) {
                query += " ORDER BY " + ordinamento;
            }

            if (offset >= 0) {
                query += " LIMIT " + offset+","+Utility.righe_pagina;
            }

            conn = DBConnection.getConnection();

            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();
            while (rs.next()) {

                Soggetto soggetto = new Soggetto();

                soggetto.setId(rs.getString("id"));
                soggetto.setCodice(rs.getString("codice"));
                soggetto.setNome_utente(rs.getString("nome_utente"));
                soggetto.setPassword(rs.getString("password"));

                String tipologia = rs.getString("tipologia");
                if (tipologia != null && !tipologia.trim().equals("")) {
                    soggetto.setTipologia(SoggettoTipologia.valueOf(tipologia));
                }
                soggetto.setPrivato_azienda(rs.getString("privato_azienda"));
                soggetto.setData_nascita(rs.getString("data_nascita"));
                soggetto.setLuogo_nascita(rs.getString("luogo_nascita"));
                soggetto.setRuolo(rs.getString("ruolo"));
                soggetto.setRagione_sociale(rs.getString("ragione_sociale"));
                soggetto.setAlias(rs.getString("alias"));
                soggetto.setNome(rs.getString("nome"));
                soggetto.setCognome(rs.getString("cognome"));
                soggetto.setReferente(rs.getString("referente"));
                soggetto.setPiva(rs.getString("piva"));
                soggetto.setCf(rs.getString("cf"));
                soggetto.setIndirizzo(rs.getString("indirizzo"));
                soggetto.setCap(rs.getString("cap"));
                soggetto.setComune(rs.getString("comune"));
                soggetto.setProvincia(rs.getString("provincia"));
                soggetto.setRegione(rs.getString("regione"));
                soggetto.setNazione(rs.getString("nazione"));
                soggetto.setTelefono(rs.getString("telefono"));
                soggetto.setCellulare(rs.getString("cellulare"));
                soggetto.setEmail(rs.getString("email"));
                soggetto.setPec(rs.getString("pec"));
                soggetto.setSdi(rs.getString("sdi"));
                soggetto.setFax(rs.getString("fax"));
                soggetto.setSito(rs.getString("sito"));
                soggetto.setCondizioni_pagamento(rs.getString("condizioni_pagamento"));
                soggetto.setBanca(rs.getString("banca"));
                soggetto.setIban(rs.getString("iban"));
                soggetto.setBic(rs.getString("bic"));
                soggetto.setRegime_iva(rs.getString("regime_iva"));
                soggetto.setSeparazione_iva(rs.getString("separazione_iva"));
                soggetto.setRitenuta(rs.getDouble("ritenuta"));
                soggetto.setIva_abituale(rs.getDouble("iva_abituale"));
                soggetto.setSconto(rs.getDouble("sconto"));
                soggetto.setCosto_orario(rs.getDouble("costo_orario"));
                soggetto.setImmagine(rs.getString("immagine"));
                soggetto.setFirma(rs.getString("firma"));
                soggetto.setCampo1(rs.getString("campo1"));
                soggetto.setCampo2(rs.getString("campo2"));
                soggetto.setCampo3(rs.getString("campo3"));
                soggetto.setCampo4(rs.getString("campo4"));
                soggetto.setCampo5(rs.getString("campo5"));
                soggetto.setCampo6(rs.getString("campo6"));
                soggetto.setCampo7(rs.getString("campo7"));
                soggetto.setCampo8(rs.getString("campo8"));
                soggetto.setCampo9(rs.getString("campo9"));
                soggetto.setCampo10(rs.getString("campo10"));
                soggetto.setAttivo(rs.getString("attivo"));
                soggetto.setNote(rs.getString("note"));
                soggetto.setStato(rs.getString("stato"));

                toReturn.add(soggetto);
            }

          } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestioneMacchinaListino", "ricerca_macchina_listino", ex);
            } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);
            }

        return toReturn;
    }
}