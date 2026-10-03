# Transactions: comandi UI

Catalogo per FutHunter 18.1.2. Apri il riquadro `Transactions`. L'eseguibile conferma i comandi contestuali `Recalculate Price`, `Remove` e `Set Action`, oltre alla creazione di filtri da transazioni e al download/export delle transazioni.

## Lettura ed export

1. Applica eventuali filtri visibili solo se l'utente ha chiesto un periodo o sottoinsieme.
2. Per l'export UI usa il comando download/export della pagina e attendi il messaggio di completamento.
3. Confronta conteggio e intervallo date con la griglia. Se l'interfaccia tronca lo storico, dichiaralo e usa `Transactions.dat` per tutto il contenuto locale disponibile.

## Azioni contestuali

- `Recalculate Price`: usa soltanto sulle righe richieste e confronta prezzo/profitto prima e dopo.
- `Set Action`: registra l'azione precedente, applica quella richiesta e verifica tutte le righe selezionate.
- `Create Filters from Transactions`: passa la selezione alla skill `futhunter-lists` e verifica la lista creata prima di usarla.
- `Remove`: è distruttivo; verifica identità e numero delle righe e chiedi conferma immediatamente prima dell'eliminazione.

Non usare un comando contestuale durante una semplice richiesta di export o analisi.
