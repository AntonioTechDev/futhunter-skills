# Lists: catalogo dei comandi

Catalogo per FutHunter 18.1.2. La pagina è raggiungibile dal riquadro `Filters`. Le etichette provenienti dalle risorse dell'eseguibile devono essere confermate nella UI corrente prima dell'azione.

## Liste e filtri

| Comando o risorsa | Effetto da verificare |
| --- | --- |
| `Aggiungi Lista Filtri` / `Crea Lista Filtri` | crea il contenitore nominato della lista |
| `Elimina Lista Filtri` | rimuove la lista scelta; richiede conferma immediatamente prima dell'eliminazione |
| `AddNewFilter` / `Aggiungi` | apre il modulo per un nuovo filtro |
| `EditFilter` | modifica il filtro selezionato |
| `DuplicateFilter` / `CopyList` | duplica filtro o lista secondo il contesto visibile |
| `DeleteFilters` / `DeletePlayers` | elimina gli elementi selezionati; verifica numero e identità prima di confermare |
| `EnableFilters` / `DisableFilters` | cambia lo stato operativo senza perdere i parametri |
| `UpFilter` / `DownFilter` | cambia l'ordine dei filtri |
| `AddPlayer` | seleziona nome, ID e versione della card |
| `Assegna Lista Filtri` / `Assegna Liste Filtri Random` | demanda la verifica per account a `futhunter-accounts` |

L'inventario dell'eseguibile conferma inoltre: modifica nome lista, modifica multipla, unione liste, aggiornamento prezzi, spostamento lista/filtro sopra o sotto, import XML, import Futbin/FutGG, export selezionati, export completo, abilitazione/disabilitazione di tutti o dei selezionati. Se una voce non è visibile nella versione corrente, non sostituirla con un comando dal nome simile.

## Lista Snipe

Una lista Snipe osservata usa filtri con `AutoBuyer=true` e `GlobalBids=false`. Per ogni giocatore seleziona la card esatta, quindi imposta prezzi e `Minimum Profit`; verifica che il `Buy Price` calcolato non superi il limite richiesto.

Per importare una squadra usa `Importa Filtri` → `Nuova Lista Filtri da Futbin-FutGG`, incolla l'URL salvato e controlla la lista risultante. L'import deve produrre una lista Snipe: verifica `AutoBuyer=true`, `GlobalBids=false`, identità e versione di ogni card. Se il controllo prezzi fallisce, verifica l'impostazione `Futbin-FutGG Proxy`, salva l'eventuale modifica e ripeti `Check Prices`; in alternativa crea i filtri dalla UI.

## Lista Global Bid

Un filtro Global Bid osservato usa `GlobalBids=true`, `AutoBuyer=false` e `GlobalSniping=false`. Compila i criteri globali mostrati dal modulo, inclusi qualità, rarità, intervallo rating, nazionalità/campionato/club/posizione quando richiesti, `Offer Limit`, pagine, carte per ricerca, prezzo di vendita e profitto minimo. Leggi [global-bid.md](global-bid.md) per i due riferimenti verificati.

- **Filtro singolo:** `85 GOLD RARE` è il riferimento con rating 85 e `OfferLimit=3200`.
- **Filtri multipli:** `GOLD NOT RARE ANY COUNTRY` contiene otto filtri distinti per Brasile, Francia, Inghilterra, Portogallo, Croazia, Paesi Bassi, Argentina e Marocco.

Per una lista multi-filtro crea prima la lista, poi aggiungi un filtro per criterio/nazione nell'ordine richiesto. Riapri ogni filtro dopo il salvataggio. Clona soltanto un filtro UI dello stesso tipo e sovrascrivi i campi richiesti. Il valore anomalo `RatingTo=1` osservato nel filtro Brasile non è un modello: convalida sempre gli intervalli nella UI.

## Global Sniping 59th e AutoBidder

Il form `Edit Filter` di FutHunter 18.1.2 mostra cinque tipi distinti e mutuamente selezionabili: `Sniping`, `AutoBidder`, `Global Bids`, `Global Sniping 59th` e `Coins Transfer`. Non trattare Global Sniping come una variante nominale di Sniping e non trattare AutoBidder come un semplice Global Bid: seleziona il pulsante esatto e verifica il tipo dopo il salvataggio.

- **Global Sniping 59th:** usa criteri globali come rarità, qualità, rating, posizione, nazionalità, campionato, club e PlayStyles; completa prezzi, profitto minimo, limite offerte e i parametri `GS_*` mostrati dalla versione corrente.
- **AutoBidder:** usa gli stessi criteri globali, ma completa anche massimo acquisto, scadenza minima, limiti watchlist, tempi di inserimento/offerta, provider prezzo, limiti dopo le offerte e permanenza in watchlist.

Il cambio tipo può essere bloccato quando l'account è in esecuzione. Non fermare un account senza richiesta esplicita: usa un account già inattivo oppure prepara un filtro pilota quando l'operatore può metterlo in pausa. Per i nomi XML e la procedura offline leggi [global-sniping-auto-bidder.md](global-sniping-auto-bidder.md).

## Import ed export

Le risorse disponibili includono `Importa Filtri`, `Nuova Lista Filtri da Futbin-FutGG`, `Esporta Filtri Selezionati` ed `Esporta tutti i Filtri`.

- **Interfaccia:** seleziona le liste esatte, usa l'export selettivo o completo e scegli una cartella di destinazione non condivisa.
- **XML:** lavora soltanto a FutHunter chiuso; non esportare l'intero `FUTHunter_AccountSettings.xml`, perché contiene account, token e credenziali proxy. Usa invece l'export filtri dell'app oppure estrai esclusivamente `FiltersList` in un file locale dedicato.
- **Verifica:** confronta nomi, numero di liste, numero/ordine filtri e campi chiave. Dopo un import riapri tutte le liste aggiunte e controlla collisioni di nome.

## Inventario ancora obbligatorio

Quando una versione dell'app cambia, ricontrolla menu, menu contestuali e dialoghi condizionali della pagina `Filters`. Aggiorna ogni voce variata con ambito, prerequisito, campi, risultato, verifica e recupero, senza dedurre il comportamento dal solo nome interno.
