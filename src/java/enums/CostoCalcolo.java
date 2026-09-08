package enums;

public enum CostoCalcolo {

    FISSO("Fisso","fa-euro-sign","#16a34a"),
    COPIA("Per copia","fa-copy","#2563eb"),
    FOGLIO("Per foglio","fa-file-lines","#7c3aed"),
    CLICK("Click macchina","fa-computer-mouse","#ea580c");

    private String nome;
    private String icona;
    private String colore;

    private CostoCalcolo(String nome,String icona,String colore){
        this.nome=nome;
        this.icona=icona;
        this.colore=colore;
    }

    public String getNome(){
        return nome;
    }

    public String getIcona(){
        return icona;
    }

    public String getColore(){
        return colore;
    }

}