package enums;

public enum Situazione {

    BOZZA("Bozza", "#94A3B8"),
    INVIATO("Inviato", "#2563EB"),
    IN_TRATTATIVA("In trattativa", "#F59E0B"),
    ACCETTATO("Accettato", "#16A34A"),
    RIFIUTATO("Rifiutato", "#DC2626"),
    SCADUTO("Scaduto", "#7C2D12"),
    ANNULLATO("Annullato", "#6B7280");

    private final String nome;
    private final String colore;

    private Situazione(String nome, String colore) {
        this.nome = nome;
        this.colore = colore;
    }

    public String getNome() {
        return nome;
    }

    public String getColore() {
        return colore;
    }

    @Override
    public String toString() {
        return nome;
    }
}