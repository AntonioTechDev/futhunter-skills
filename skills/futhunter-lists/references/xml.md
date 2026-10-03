# Liste FutHunter tramite XML

Usa questo metodo per lotti di liste quando FutHunter è chiuso. Se l'app o gli account sono in esecuzione, lavora dall'interfaccia. La struttura è stata ricontrollata su FutHunter 18.1.2; dopo un aggiornamento crea un esempio nella UI e confronta lo schema prima di riutilizzarla.

Il file `FUTHunter_AccountSettings.xml` contiene anche credenziali e proxy. Lavoraci solo localmente, con backup datato e sostituzione atomica. Riavvia l'app e verifica il risultato nella griglia.

`AccountSettings/FiltersList/FiltersList` contiene `FilterListName` e un `ListFiltersToSearch/FiltersToSearch` per ciascun giocatore. Crea almeno una lista pilota nell'interfaccia, salvala e riaprila; clona solo filtri di card con la stessa versione e rarità. Per card base comuni, i campi osservati sono:

| Campo | Contenuto |
| --- | --- |
| `FilterName`, `PlayerName` | Nome mostrato da FutHunter |
| `PlayerBaseId`, `PlayerId` | EA ID della card |
| `MinRangePrice`, `MaxRangePrice` | Fascia della card |
| `SellPrice`, `SellPrice95` | Prezzo di mercato e suo 95% |
| `MaxBuyPrice`, `GS_MaxBIN_MaxRange` | Prezzo massimo di acquisto |
| `MinProfit` | `SellPrice95 − MaxBuyPrice` |

Lo [script Snipe](../scripts/create_lists.ps1) accetta un JSON ordinato di liste con `listName`, `cap` e un array `cards`. Ogni card richiede `name`, `eaId`, `sellPrice`, `rangeMin`, `rangeMax`. Supporta soltanto card base comuni corrispondenti al modello UI.

Lo [script Global Bid](../scripts/create_global_bid_lists.ps1) accetta un JSON ordinato con `listName` e `filters`. Clona un filtro Global Bid creato dalla UI nella stessa versione, forza `AutoBuyer=false`, `GlobalBids=true`, `GlobalSniping=false` e aggiorna soltanto i campi dichiarati nel manifest. Non usa una lista Snipe come modello.

Lo [script per i tipi avanzati](../scripts/create_advanced_lists.ps1) accetta lo stesso contenitore `listName`/`filters` e richiede `-Mode GlobalSniping59th` oppure `-Mode AutoBidder`. Clona soltanto un filtro pilota creato dalla UI con lo stesso tipo. Per Global Sniping forza `GlobalSniping=true` e disattiva gli altri motori; per AutoBidder forza `AutoBidder=true`, `GlobalBids=true`, `AutoBuyer=false` e `GlobalSniping=false`, combinazione osservata nei filtri salvati dall'app.

Prima di sostituire il file, ricarica il temporaneo e confronta numero di liste, filtri e identificativi. Dopo il riavvio controlla nomi, tipi, versioni e prezzi nella UI.
