package enums;

import java.util.ArrayList;

public enum TipoCosto {

    // STAMPA
    STAMPA_INTERNO("Stampa interno", "#2563EB", true),
    STAMPA_COPERTINA("Stampa copertina", "#1D4ED8", true),

    // CARTA
    CARTA_INTERNO("Carta interno", "#A16207", false),
    CARTA_COPERTINA("Carta copertina", "#854D0E", false),

    // PANTONI
    PANTONE_INTERNO("Pantone interno", "#9333EA", true),
    PANTONE_COPERTINA("Pantone copertina", "#7E22CE", true),

    // BIANCO
    BIANCO_INTERNO("Bianco interno", "#94A3B8", true),
    BIANCO_COPERTINA("Bianco copertina", "#64748B", true),

    // VERNICI
    VERNICE_INTERNO("Vernice interno", "#0D9488", true),
    VERNICE_COPERTINA("Vernice copertina", "#0F766E", true),

    // PLASTIFICAZIONE
    PLASTIFICAZIONE_INTERNO("Plastificazione interno", "#16A34A", true),
    PLASTIFICAZIONE_COPERTINA("Plastificazione copertina", "#15803D", true),

    // LAVORAZIONI
    SERIGRAFIA("Serigrafia", "#DC2626", true),
    FUSTELLATURA("Fustellatura", "#7C3AED", true),
    CARTOTECNICA("Cartotecnica", "#16A34A", true),
    PIEGA("Piega", "#2563EB", true),
    CELLOPHANATURA("Cellophanatura", "#0891B2", true),
    
    
    // RILEGATURA
    RILEGATURA("Rilegatura", "#7C3AED", true),

    // DORSO
    DORSO("Dorso", "#A855F7", true),

    
    
    // NOBILITAZIONI
    LAMINA_ORO("Lamina oro", "#EAB308", true),
    LAMINA_ARGENTO("Lamina argento", "#94A3B8", true),
    STAMPA_A_CALDO("Stampa a caldo", "#EA580C", true),
    RILIEVO("Rilievo", "#92400E", true),
    DEBOSS("Deboss", "#B45309", true),
    UV_SELETTIVA("UV selettiva", "#06B6D4", true),

    // TRASPORTO
    TRASPORTO("Trasporto", "#F97316", true),

    // ALTRE LAVORAZIONI
    ACCOPPIATURA("Accoppiatura", "#65A30D", true),
    CONFEZIONAMENTO("Confezionamento", "#CA8A04", true),
    CONTROLLO_QUALITA("Controllo qualità", "#0F766E", true),
    CORDONATURA("Cordonatura", "#0284C7", true),
    CUCITURA("Cucitura", "#9333EA", true),
    FORATURA("Foratura", "#64748B", true),
    INCOLLAGGIO("Incollaggio", "#C2410C", true),
    OCCHIELLATURA("Occhiellatura", "#DB2777", true),
    RIFINITURA("Rifinitura", "#475569", true),
    TAGLIO("Taglio", "#DC2626", true),
    
    // ALTRO
    ALTRO("Altro", "#6B7280", false);

    private final String nome;
    private final String colore;
    private final boolean visibile;

    private TipoCosto(String nome, String colore, boolean visibile){
        this.nome=nome;
        this.colore=colore;
        this.visibile=visibile;
    }

    public String getNome(){
        return nome;
    }

    public String getColore(){
        return colore;
    }

    public boolean is_visibile(){
        return visibile;
    }

    public static TipoCosto[] values_visibili(){
      ArrayList<TipoCosto> lista=new ArrayList<TipoCosto>();

      for(TipoCosto tipo_costo : values()){
          if(tipo_costo.is_visibile())
              lista.add(tipo_costo);
      }

      java.util.Collections.sort(lista, new java.util.Comparator<TipoCosto>(){
          @Override
          public int compare(TipoCosto a, TipoCosto b){
              return a.getNome().compareToIgnoreCase(b.getNome());
          }
      });

      return lista.toArray(new TipoCosto[lista.size()]);
  }
    @Override
    public String toString(){
        return nome;
    }
}
