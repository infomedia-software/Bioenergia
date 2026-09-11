/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package gestioneDB;


import beans.Pagamento;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import utility.GestioneErrori;
import utility.Utility;

public class GestionePagamento {

    private static GestionePagamento istanza;

    public static GestionePagamento getIstanza() {
        if (istanza == null) {
            istanza = new GestionePagamento();
        }
        return istanza;
    }

    private GestionePagamento() {
    }


    public ArrayList<Pagamento> ricerca_pagamento(String query_input, String ordinamento, int offset) {

        ArrayList<Pagamento> toReturn = new ArrayList<Pagamento>();

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {

            String query = "SELECT * FROM pagamento WHERE pagamento.stato='1' ";

            if (query_input != null && !query_input.trim().equals("")) {
                query += " AND " + query_input;
            }

            if (ordinamento != null && !ordinamento.trim().equals("")) {
                query += " ORDER BY " + ordinamento;
            }

            if (offset >= 0) {
                query += " LIMIT " + offset + "," + Utility.righe_pagina;
            }

            conn = DBConnection.getConnection();

            stmt = conn.prepareStatement(query);
            rs = stmt.executeQuery();

            while (rs.next()) {

                Pagamento pagamento = new Pagamento();

                pagamento.setId(rs.getInt("id"));
                pagamento.setId_documento(rs.getInt("id_documento"));
                pagamento.setId_soggetto(rs.getInt("id_soggetto"));
                pagamento.setId_autore(rs.getInt("id_autore"));
                pagamento.setDescrizione(rs.getString("descrizione"));
                pagamento.setEntrata_uscita(rs.getString("entrata_uscita"));
                pagamento.setFinanziamento(rs.getString("finanziamento"));
                pagamento.setImporto(rs.getDouble("importo"));
                pagamento.setPercentuale(rs.getDouble("percentuale"));
                pagamento.setData_saldo(rs.getString("data_saldo"));
                pagamento.setData_scadenza(rs.getString("data_scadenza"));

                pagamento.setMetodo(rs.getString("metodo"));
                pagamento.setSaldato(rs.getString("saldato"));
                pagamento.setStato(rs.getString("stato"));

                pagamento.setData_creazione(rs.getString("data_creazione"));
                pagamento.setData_modifica(rs.getString("data_modifica"));

                toReturn.add(pagamento);
            }

        } catch (ConnectionPoolException | SQLException ex) {
            GestioneErrori.errore("GestionePagamento", "ricerca_pagamento", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);
        }

        return toReturn;
    }


    public Pagamento get_pagamento(int id_pagamento) {

        ArrayList<Pagamento> pagamenti = ricerca_pagamento("id=" + id_pagamento, "", -1);

        if (pagamenti.size() > 0) {
            return pagamenti.get(0);
        }

        return null;
    }
    
    public String aggiorna_importi_pagamenti(String id_documento){
        double totale=Utility.getIstanza().query_select_double("SELECT totale FROM documento WHERE id="+Utility.is_null(id_documento),"totale");

        Utility.getIstanza().query(
            "UPDATE pagamento SET importo=ROUND("+totale+"*percentuale/100,2) " +
            "WHERE id_documento="+Utility.is_null(id_documento)
        );

        return "";
    }
    
}