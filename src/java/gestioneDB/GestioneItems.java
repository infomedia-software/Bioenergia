package gestioneDB;

import beans.Item;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import utility.GestioneErrori;
import utility.Utility;


public class GestioneItems {

    private static GestioneItems istanza;

    
    public static GestioneItems getIstanza(){
        if(istanza==null){
            istanza=new GestioneItems();
        }
        return istanza;
    }
    
    
     public Map<String,String> mappa_id_valore(String tabella, String campo){
        Map<String,String> toReturn=new HashMap<String,String>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM items "
                + "WHERE stato='1' AND tabella="+Utility.is_null(tabella)+" AND campo="+Utility.is_null(campo)
                + "ORDER BY ordinamento ASC, valore ASC";            
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            
            
            while(rs.next()){
                String id=rs.getString("id");
                String valore=rs.getString("valore");
                toReturn.put(id,valore);
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneItems", "mappa_id_valore", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneItems", "mappa_id_valore", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;
    }
 
    public Item get_item(String id_item){
        Item i=null;
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM items "
                + "WHERE id="+id_item+" AND stato='1' "
                + "ORDER BY ordinamento ASC, valore ASC";
            System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){
                i=new Item();
                i.setCampo(rs.getString("campo"));
                i.setId(rs.getString("id"));
                i.setOrdinamento(rs.getInt("ordinamento"));
                i.setStato(rs.getString("stato"));
                i.setColore(rs.getString("colore"));
                i.setValore(rs.getString("valore"));
                i.setImmagine(rs.getString("immagine"));
                i.setTabella(rs.getString("tabella"));           
                i.setBloccato(rs.getString("bloccato"));
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneItems", "get_item", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneItems", "get_item", ex);
        } finally {
            DBUtility.closeQuietly(rs);
            DBUtility.closeQuietly(stmt);
            DBConnection.releaseConnection(conn);   
        }                    
        return i;
    }
    
    public ArrayList<Item> ricerca(String tabella,String campo){
        ArrayList<Item> toReturn=new ArrayList<Item>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM items "
                + "WHERE tabella="+Utility.is_null(tabella)+" AND campo="+Utility.is_null(campo)+" AND stato='1' "
                + "ORDER BY ordinamento ASC, valore ASC";
            System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){
                Item i=new Item();
                i.setCampo(rs.getString("campo"));
                i.setId(rs.getString("id"));
                i.setImmagine(rs.getString("immagine"));
                i.setOrdinamento(rs.getInt("ordinamento"));
                i.setColore(rs.getString("colore"));
                i.setStato(rs.getString("stato"));
                i.setValore(rs.getString("valore"));
                i.setTabella(rs.getString("tabella"));
                i.setBloccato(rs.getString("bloccato"));
                toReturn.add(i);
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneItems", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneItems", "ricerca", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;
    }
    
    public ArrayList<String> ricerca_return_valori(String tabella,String campo){
        ArrayList<String> toReturn=new ArrayList<String>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM items "
                + "WHERE tabella="+Utility.is_null(tabella)+" AND campo="+Utility.is_null(campo)+" AND stato='1' "
                + "ORDER BY ordinamento ASC, valore ASC";
            System.out.println(query);
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){
                toReturn.add(rs.getString("valore"));
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneItems", "ricerca_return_valori", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneItems", "ricerca_return_valori", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;
    }
    
    public Map<String,Item> mappa(String tabella,String campo){
        Map<String,Item> toReturn=new LinkedHashMap<String,Item>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM items "
                + "WHERE stato='1' AND tabella="+Utility.is_null(tabella)+" AND campo="+Utility.is_null(campo)
                + "ORDER BY ordinamento ASC, valore ASC";                       
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            while(rs.next()){
                String id=rs.getString("id");
                Item i=new Item();
                i.setCampo(rs.getString("campo"));
                i.setId(rs.getString("id"));
                i.setOrdinamento(rs.getInt("ordinamento"));
                i.setColore(rs.getString("colore"));
                i.setStato(rs.getString("stato"));
                i.setValore(rs.getString("valore"));
                i.setTabella(rs.getString("tabella"));
                i.setImmagine(rs.getString("immagine"));
                i.setBloccato(rs.getString("bloccato"));
                toReturn.put(id,i);
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneItems", "ricerca", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneItems", "ricerca", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;
    }
    
    public Map<String,Item> mappa_valori(){
        Map<String,Item> toReturn=new HashMap<String,Item>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM items "
                + "WHERE stato='1' "
                + "ORDER BY ordinamento ASC, valore ASC";            
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            
            
            while(rs.next()){
                String id=rs.getString("id");
                Item i=new Item();
                i.setCampo(rs.getString("campo"));
                i.setId(rs.getString("id"));
                i.setOrdinamento(rs.getInt("ordinamento"));
                i.setColore(rs.getString("colore"));
                i.setStato(rs.getString("stato"));
                i.setValore(rs.getString("valore"));
                i.setTabella(rs.getString("tabella"));
                i.setImmagine(rs.getString("immagine"));
                i.setBloccato(rs.getString("bloccato"));
                toReturn.put(rs.getString("valore"),i);
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneItems", "mappa_valori", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneItems", "mappa_valori", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;
    }
    
    public Map<String,Item> mappa_valori(String tabella, String campo){
        Map<String,Item> toReturn=new HashMap<String,Item>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try{
            String query="SELECT * FROM items "
                + "WHERE stato='1' AND tabella="+Utility.is_null(tabella)+" AND campo="+Utility.is_null(campo)
                + "ORDER BY ordinamento ASC, valore ASC";            
            conn=DBConnection.getConnection();            
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);
            
            
            
            while(rs.next()){
                String id=rs.getString("id");
                Item i=new Item();
                i.setCampo(rs.getString("campo"));
                i.setId(rs.getString("id"));
                i.setOrdinamento(rs.getInt("ordinamento"));
                i.setColore(rs.getString("colore"));
                i.setStato(rs.getString("stato"));
                i.setValore(rs.getString("valore"));
                i.setTabella(rs.getString("tabella"));
                i.setImmagine(rs.getString("immagine"));
                i.setBloccato(rs.getString("bloccato"));
                toReturn.put(rs.getString("valore"),i);
            }                   
            
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneItems", "mappa_valori", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneItems", "mappa_valori", ex);
        } finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;
    }
    
    
     
  
    
}
