package utility;

import java.util.Date;

public class GestioneErrori {
    
    public static void errore(String classe,String metodo,Exception ex){
        System.out.println("");
        System.out.println("---------------------------------------\nXXX BIOENERGIA XXX\nSi è verificato un errore in ->"+classe+"."+metodo+"<-");
        System.out.println(new Date()+" - "+ex.getMessage().toString());        
        System.out.println("---------------------------------------");
        System.out.println("");
    }
    
}
