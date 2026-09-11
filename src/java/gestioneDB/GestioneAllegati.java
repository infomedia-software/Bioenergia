package gestioneDB;

import beans.Allegato;
import connection.ConnectionPoolException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import utility.GestioneErrori;


public class GestioneAllegati {

    private static GestioneAllegati istanza;
    
    public static GestioneAllegati getIstanza(){
        if(istanza==null)  
            istanza=new GestioneAllegati();
        return istanza;
    }
    
    /**
     * Metodo per ricercare gli allegati
     * @param q
     * @return 
     */
    public synchronized ArrayList<Allegato> ricercaAllegati(String q){
        ArrayList<Allegato> toReturn=new ArrayList<Allegato>();
        Connection conn=null;
        PreparedStatement stmt=null;
        ResultSet rs=null;
        try {                        
            conn=DBConnection.getConnection();            
            String query="SELECT * FROM allegati WHERE "+q;                        
            stmt=conn.prepareStatement(query);
            rs=stmt.executeQuery(query);   
            while(rs.next()){      
                Allegato temp=new Allegato();
                temp.setId(rs.getInt("allegati.id"));
                temp.setIdrif(rs.getString("allegati.idrif"));
                temp.setRif(rs.getString("allegati.rif"));
                temp.setUrl(rs.getString("allegati.url"));
                temp.setDescrizione(rs.getString("allegati.descrizione"));
                temp.setData(rs.getString("allegati.data"));
                temp.setStato(rs.getString("allegati.stato"));
                toReturn.add(temp);
            }                       
           
            return toReturn;
        } catch (ConnectionPoolException ex) {
            GestioneErrori.errore("GestioneAllegati", "ricercaAllegati", ex);
        } catch (SQLException ex) {
            GestioneErrori.errore("GestioneAllegati", "ricercaAllegati", ex);
        }
        finally {
                DBUtility.closeQuietly(rs);
                DBUtility.closeQuietly(stmt);
                DBConnection.releaseConnection(conn);   
        }                    
        return toReturn;        
    }
    
            
}
