package connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Vector;

public class ConnectionPool {

    private static ConnectionPool connection_pool=null;
    private final Vector<Connection> free_connections;
    private String db_url;
    private String db_driver;
    private String db_login;
    private String db_password;
    private static final int MAX_CONNECTIONS=20;
    private int numero_connessioni=0;

    private ConnectionPool() throws ConnectionPoolException {
        free_connections=new Vector<Connection>();
        load_parameters();
        load_driver();
    }

    private void load_parameters() {
        db_driver="com.mysql.jdbc.Driver";
        db_url="jdbc:mysql://195.231.15.77:3306/bioenergia";
        db_login="infomedia_new";
        db_password="Comisetti.2024!";
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
        while(!free_connections.isEmpty()){
            Connection con=free_connections.remove(0);
            if(is_connection_valid(con))
                return con;
            close_connection(con);
            numero_connessioni--;
        }

        if(numero_connessioni<MAX_CONNECTIONS){
            Connection con=new_connection();
            numero_connessioni++;
            return con;
        }

        try{
            wait(5000);
        }catch(InterruptedException e){
            Thread.currentThread().interrupt();
            throw new ConnectionPoolException("Attesa connessione interrotta");
        }

        return getConnection();
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
                    "?user="+db_login+
                    "&password="+db_password+
                    "&zeroDateTimeBehavior=convertToNull"+
                    "&autoReconnect=true"+
                    "&useUnicode=true"+
                    "&characterEncoding=UTF-8";

            return DriverManager.getConnection(url);
        }catch(SQLException e){
            throw new ConnectionPoolException("Errore connessione database: "+e.getMessage());
        }
    }

    public synchronized void releaseConnection(Connection con) {
        if(con==null)
            return;

        if(is_connection_valid(con)){
            try{
                if(!con.getAutoCommit()){
                    con.rollback();
                    con.setAutoCommit(true);
                }
                con.clearWarnings();
                free_connections.add(con);
            }catch(SQLException e){
                close_connection(con);
                numero_connessioni--;
            }
        }else{
            close_connection(con);
            numero_connessioni--;
        }

        notifyAll();
    }

    public synchronized void closeAllConnections() {
        for(Connection con : free_connections)
            close_connection(con);

        free_connections.clear();
        numero_connessioni=0;
    }

    private void close_connection(Connection con) {
        if(con==null)
            return;

        try{
            con.close();
        }catch(SQLException e){
        }
    }
}