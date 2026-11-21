
package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Collections;
import java.util.IdentityHashMap;
import java.util.Set;
import java.util.Vector;

public class ConnectionPool {

    private static ConnectionPool connection_pool=null;

    private final Vector<Connection> free_connections;
    private final Set<Connection> all_connections;

    private String db_url;
    private String db_driver;
    private String db_login;
    private String db_password;

    private static final int MAX_CONNECTIONS=20;
    private static final long TIMEOUT_ATTESA=15000;

    private int numero_connessioni=0;
    private int thread_in_attesa=0;
    private boolean chiuso=false;

    private ConnectionPool() throws ConnectionPoolException {
        free_connections=new Vector<Connection>();
        all_connections=Collections.newSetFromMap(new IdentityHashMap<Connection,Boolean>());
        load_parameters();
        load_driver();
    }

    private void load_parameters() {
        db_driver="com.mysql.jdbc.Driver";
        db_url="jdbc:mysql://195.231.15.77:3306/bioenergia";
        db_login="infomedia_new";
        db_password="Comisetti.2024!";

        if(db_password==null)
            db_password="";
    }

    private void load_driver() throws ConnectionPoolException {
        try{
            Class.forName(db_driver);
        }catch(Exception e){
            throw new ConnectionPoolException("Errore caricamento driver MySQL: "+e.getMessage());
        }
    }

    public static synchronized ConnectionPool getConnectionPool() throws ConnectionPoolException {
        if(connection_pool==null)
            connection_pool=new ConnectionPool();

        return connection_pool;
    }

    public synchronized Connection getConnection() throws ConnectionPoolException {

        long scadenza=System.currentTimeMillis()+TIMEOUT_ATTESA;

        while(true){

            if(chiuso)
                throw new ConnectionPoolException("ConnectionPool chiuso");

            // Recupera una connessione libera
            while(!free_connections.isEmpty()){

                Connection con=free_connections.remove(0);

                if(is_connection_valid(con))
                    return con;

                elimina_connection(con);
            }

            // Crea una nuova connessione se possibile
            if(numero_connessioni<MAX_CONNECTIONS){

                Connection con=new_connection();

                all_connections.add(con);
                numero_connessioni++;

                return con;
            }

            // Tutte le connessioni sono occupate
            long tempo_rimanente=scadenza-System.currentTimeMillis();

            if(tempo_rimanente<=0){
                String messaggio="ConnectionPool: timeout dopo "+TIMEOUT_ATTESA+" ms. "+getStatoPool();
                System.err.println(messaggio);
                throw new ConnectionPoolException(messaggio);
            }

            try{
                thread_in_attesa++;
                wait(tempo_rimanente);
            }catch(InterruptedException e){
                Thread.currentThread().interrupt();
                throw new ConnectionPoolException("Attesa connessione interrotta");
            }finally{
                thread_in_attesa--;
            }
        }
    }

    private boolean is_connection_valid(Connection con) {

        if(con==null)
            return false;

        try{
            if(con.isClosed())
                return false;

            return con.isValid(3);

        }catch(SQLException e){
            return false;
        }catch(AbstractMethodError e){
            return test_connection(con);
        }
    }

    private boolean test_connection(Connection con) {

        java.sql.Statement statement=null;

        try{
            statement=con.createStatement();
            statement.execute("SELECT 1");
            return true;
        }catch(SQLException e){
            return false;
        }finally{
            if(statement!=null){
                try{
                    statement.close();
                }catch(SQLException e){
                }
            }
        }
    }

    private Connection new_connection() throws ConnectionPoolException {

        try{
            String url=db_url+
                    "?zeroDateTimeBehavior=convertToNull"+
                    "&useUnicode=true"+
                    "&characterEncoding=UTF-8"+
                    "&connectTimeout=10000"+
                    "&socketTimeout=30000";

            return DriverManager.getConnection(url,db_login,db_password);

        }catch(SQLException e){
            throw new ConnectionPoolException("Errore connessione database: "+e.getMessage());
        }
    }

    public synchronized void releaseConnection(Connection con) {

        if(con==null)
            return;

        // Connessione non appartenente al pool
        if(!all_connections.contains(con)){
            System.err.println("ConnectionPool: tentativo di rilascio di una connessione sconosciuta");
            return;
        }

        // Evita doppio rilascio
        if(free_connections.contains(con)){
            System.err.println("ConnectionPool: doppio rilascio connessione");
            return;
        }

        // Pool già chiuso
        if(chiuso){
            elimina_connection(con);
            notifyAll();
            return;
        }

        if(is_connection_valid(con)){

            try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }

                if(con.isReadOnly())
                    con.setReadOnly(false);

                con.clearWarnings();

                free_connections.add(con);

            }catch(SQLException e){
                elimina_connection(con);
                System.err.println("ConnectionPool: errore rilascio connessione: "+e.getMessage());
            }

        }else{
            elimina_connection(con);
        }

        notifyAll();
    }

    private void elimina_connection(Connection con) {

        if(con==null)
            return;

        free_connections.remove(con);

        if(all_connections.remove(con)){
            numero_connessioni--;
        }

        close_connection(con);
    }

    public synchronized String getStatoPool() {

        int libere=free_connections.size();
        int occupate=numero_connessioni-libere;

        return "Totali: "+numero_connessioni+
                " | Libere: "+libere+
                " | Occupate: "+occupate+
                " | In attesa: "+thread_in_attesa+
                " | Massimo: "+MAX_CONNECTIONS;
    }

    public synchronized int getNumeroConnessioni(){
        return numero_connessioni;
    }

    public synchronized int getConnessioniLibere(){
        return free_connections.size();
    }

    public synchronized int getConnessioniOccupate(){
        return numero_connessioni-free_connections.size();
    }

    public synchronized int getThreadInAttesa(){
        return thread_in_attesa;
    }

    public synchronized void closeAllConnections() {

        chiuso=true;

        for(Connection con : all_connections)
            close_connection(con);

        free_connections.clear();
        all_connections.clear();

        numero_connessioni=0;

        notifyAll();

        System.out.println("ConnectionPool: tutte le connessioni sono state chiuse");
    }

    private void close_connection(Connection con) {

        if(con==null)
            return;

        try{
            if(!con.isClosed())
                con.close();
        }catch(SQLException e){
            System.err.println("ConnectionPool: errore chiusura connessione: "+e.getMessage());
        }
    }
}
