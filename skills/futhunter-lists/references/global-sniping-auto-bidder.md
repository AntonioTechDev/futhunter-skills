# Global Sniping 59th e AutoBidder

Riferimento verificato sul form `Edit Filter` di FutHunter 18.1.2. Il form espone i pulsanti `Sniping`, `AutoBidder`, `Global Bids`, `Global Sniping 59th` e `Coins Transfer`, oltre a rarità, qualità, chemistry, posizione, nazionalità, campionato, club, PlayStyles, prezzi e profitto. I campi sotto descrivono la serializzazione osservata; non sono consigli economici.

I quattro prezzi visibili sono serializzati così: `minBidPrice` → `MinBid_MaxRange`, `maxBidPrice` → `SellPrice`, `minBuyNowPrice` → `MinBuyPrice`, `maxBuyNowPrice` → `MaxBuyPrice`. Il valore `0` può rappresentare `Max` nell'interfaccia; conservalo solo quando il filtro pilota lo conferma. `sellPrice` resta disponibile come alias XML di `maxBidPrice`, ma non specificarli entrambi nello stesso filtro.

## Global Sniping 59th

Un filtro pilota valido deve avere `GlobalSniping=true`, `AutoBuyer=false`, `AutoBidder=false`, `GlobalBids=false` e `CoinsTransfer=false`. I parametri specifici serializzati sono:

| Manifest | XML | Significato UI |
| --- | --- | --- |
| `gsMinBinMaxRange` | `GS_MinBIN_MaxRange` | limite minimo del range BIN |
| `gsMaxBinMaxRange` | `GS_MaxBIN_MaxRange` | limite massimo del range BIN |
| `useAccountCoins` | `MaxBIN_UseAccountCoins` | usa i crediti disponibili per il massimo BIN |
| `syncTiming` | `GS_SyncTiming` | sincronizzazione della ricerca |
| `maxSearchesNo59th` | `GS_MaxSearchesNo59th` | ricerche massime senza risultato 59th |
| `disableFilterNo59th` | `GS_DisableFilterNo59th` | disabilita il filtro se non trova il 59th |
| `increaseSearches` | `IncreaseSearches` | incremento delle ricerche |

## AutoBidder

Nei due filtri salvati osservati, AutoBidder usa `AutoBidder=true`, `GlobalBids=true`, `AutoBuyer=false`, `GlobalSniping=false` e `CoinsTransfer=false`. Non correggere `GlobalBids=true`: è la combinazione prodotta dall'app per questo tipo.

| Manifest | XML |
| --- | --- |
| `autoBidderMaxBuyPrice` | `AutoBidder_MaxBuyPrice` |
| `minToExpire` | `AutoBidder_MinToExpire` |
| `maxCardsWatching` | `AutoBidder_MaxCardsWatching` |
| `secondsToWatchlist` | `AutoBidder_SecondsToWL` |
| `secondsToBid` | `AutoBidder_SecondsToBid` |
| `excludeLastToWatchlist` | `AutoBidder_ExcludeLastToWL` |
| `excludeRarities` | `AutoBidder_ExcludeRarities` |
| `providers` | `AutoBidder_Providers` |
| `providerMinutes` | `AutoBidder_ProviderMinutes` |
| `maxOfferAfterBids` | `AutoBidder_MaxOfferAfterBids` |
| `maxOfferAfterBidsPercent` | `AutoBidder_MaxOfferAfterBidsPerc` |
| `secondsWaitAfterWatchlist` | `AutoBidder_SecsWaitAfterWL` |
| `skipLastBid` | `AutoBidder_SkipLastBid` |
| `stayWatchlistCards` | `AutoBidder_StayWLCards` |
| `stayWatchlistSeconds` | `AutoBidder_StayWLSeconds` |

Un esempio osservato usa scadenza minima `3`, massimo `10` carte in watchlist, `60` secondi per la watchlist, `4` secondi per l'offerta, provider `Futwiz,FutGG`, finestra provider `30`, massimo `6` offerte al `96%`, attesa `30` secondi e permanenza `1` carta per `120` secondi. Conservali solo se il filtro pilota e la richiesta corrente li confermano.

## Procedura

1. Con un account inattivo, apri `Filters` → `Add` e crea un filtro pilota scegliendo il pulsante esatto.
2. Salva, riapri e verifica tipo, criteri, prezzi e parametri specifici.
3. Chiudi FutHunter. Esegui `create_advanced_lists.ps1` su una copia o sul file attivo chiuso, indicando la lista pilota.
4. Riapri l'app e controlla ogni filtro nell'ordine del manifest prima di assegnarlo o avviarlo.

Lo script rifiuta un modello di tipo diverso e lascia invariati i campi non presenti nel manifest. Questo è intenzionale: evita di inventare default dipendenti dalla versione.
