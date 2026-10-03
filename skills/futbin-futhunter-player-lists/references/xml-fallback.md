# FutHunter: modifica XML a app ferma

Usa questo metodo per lotti di liste o assegnazioni quando nessun account è in esecuzione. Se account sono in esecuzione, applica liste e assegnazioni dall'interfaccia per preservare la sessione. La struttura qui descritta è stata verificata in FutHunter 18.1.1: dopo aggiornamenti, crea un esempio nell'interfaccia e confronta lo schema prima di riusarlo.

Il file `FUTHunter_AccountSettings.xml` nella directory dell'app contiene anche credenziali e proxy. Lavoraci solo localmente, ad app chiusa, con backup e sostituzione atomica. Riavvia l'app e verifica il risultato nella griglia.

## Liste

`AccountSettings/FiltersList/FiltersList` contiene `FilterListName` e un `ListFiltersToSearch/FiltersToSearch` per ciascun giocatore. Crea almeno una lista pilota nell'interfaccia, salvala e riaprila; clona solo filtri di card con la stessa versione e rarità. Per card base comuni, i campi osservati sono:

| Campo | Contenuto |
| --- | --- |
| `FilterName`, `PlayerName` | Nome mostrato da FutHunter |
| `PlayerBaseId`, `PlayerId` | EA ID della card |
| `MinRangePrice`, `MaxRangePrice` | Fascia della card |
| `SellPrice`, `SellPrice95` | Prezzo di mercato e suo 95% |
| `MaxBuyPrice`, `GS_MaxBIN_MaxRange` | Prezzo massimo di acquisto |
| `MinProfit` | `SellPrice95 − MaxBuyPrice` |

Lo [script di creazione](../scripts/create_lists.ps1) accetta un JSON ordinato di liste con `listName`, `cap` e un array `cards` di lunghezza variabile. Ogni card richiede `name`, `eaId`, `sellPrice`, `rangeMin`, `rangeMax`. Lo script supporta card base comuni con modello UI corrispondente. Controlla nomi, versioni e prezzi nell'app dopo il riavvio.

## Assegnazioni

`AccountSettings/settings/Settings` contiene gli account nell'ordine del file. Verifica nell'interfaccia che tale ordine corrisponda agli indici visualizzati prima di scrivere. L'assegnazione UI modifica `FiltersListName` e copia tutti i `FiltersToSearch` della lista in `filtersToSearch` dell'account; `Filters in Random Order` può cambiare l'ordine dei filtri copiati.

Lo [script di assegnazione](../scripts/assign_accounts.ps1) prende un JSON con una riga `{ "accountIndex": 1, "listName": "Nome lista" }` per ogni account richiesto. Gli indici sono 1-based, corrispondono alla colonna numerata di `Accounts` e devono essere espliciti. Dopo il riavvio verifica nell'app ciascun indice e il nome della lista. L'avvio degli account si esegue sempre nell'interfaccia.

