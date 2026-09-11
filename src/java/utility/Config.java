package utility;

import java.io.InputStream;
import java.util.Properties;

public class Config {

    private static final Properties properties=new Properties();

    static{
        try{
            InputStream input=Config.class.getResourceAsStream("/utility/config.properties");
            if(input==null) throw new RuntimeException("File config.properties non trovato");
            properties.load(input);
            input.close();
        }catch(Exception e){
            throw new RuntimeException("Errore caricamento config.properties",e);
        }
    }

    public static String get(String chiave){
        return properties.getProperty(chiave,"");
    }
}