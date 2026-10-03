---
name: futhunter-transactions
description: Estrai tutte le transazioni FutHunter o quelle di un periodo e prepara dati CSV per analisi di acquisti, vendite e sniping persi.
---

# Transazioni FutHunter

FutHunter mostra lo storico nella pagina `Transactions` della sidebar e lo conserva in `Transactions.dat` nella cartella dell'app. Il file verificato è UTF-8: una riga per transazione, 15 campi separati da `||`, con `DateTime` nel formato `yyyy-MM-dd HH:mm:ss` dell'orologio della VPS. La colonna `Lost` corrisponde al campo booleano 9; le righe rosse nell'interfaccia lo mostrano selezionato.

## Estrai

1. Apri `Transactions` e individua `Transactions.dat` accanto all'eseguibile dell'istanza FutHunter in uso. Confronta le prime righe del file con la griglia: data, giocatore, prezzo e `Lost` devono corrispondere. Se l'app è chiusa, usa il percorso dell'ultima installazione verificata e indica che hai estratto una copia locale senza controllo della vista corrente.
2. Esegui [scripts/export_transactions.ps1](scripts/export_transactions.ps1) con `-OutputPath` per **tutto lo storico disponibile**. Aggiungi `-Start` e/o `-End` per un periodo; accettano `yyyy-MM-dd` o `yyyy-MM-ddTHH:mm:ss`, inclusi entrambi gli estremi. Una data `-End` comprende l'intera giornata. Passa `-SourcePath` se ci sono più installazioni o l'app è chiusa.
3. Controlla il riepilogo dello script: righe sorgente, righe esportate, prima e ultima data. Per un periodo, confronta almeno una riga del periodo con la griglia; per tutto lo storico, verifica che il CSV contenga tante righe quanto il file sorgente. Se il file contiene righe malformate, l'estrazione deve fallire esplicitamente: non presentare un CSV parziale come completo.

Il CSV mantiene console, nome filtro, account, giocatore, prezzi, profitto, `Auction`, `Lost`, lista, numero di offerte, ID interno, numero di rilanci, data vendita e numero della riga sorgente. `SoldAt = 0001-01-01 00:00:00` è il valore vuoto dell'app, non una vendita. Usa `Lost`, non il solo profitto zero, per contare gli sniping persi. Riporta sempre il periodo coperto dal file: “tutto” significa tutte le righe **disponibili in quell'installazione**, non una garanzia sulla storia remota. I dati degli account restano nel file locale; nelle risposte mostra solo gli identificativi necessari all'analisi richiesta.

