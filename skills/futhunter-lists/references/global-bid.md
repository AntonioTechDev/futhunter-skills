# Global Bid: parametri verificati

Questi esempi provengono da FutHunter 18.1.2. Usali come riferimento di struttura, non come consiglio economico. Prima di avviare account, riapri ogni filtro e verifica che i valori salvati coincidano con la richiesta corrente.

## Filtro singolo `85 GOLD RARE`

Il filtro osservato usa: `AutoBuyer=false`, `GlobalBids=true`, `GlobalSniping=false`, rating `85–85`, `OfferLimit=3200`, `MinBuyPrice=10250`, `MinProfit=100`, `MaxBidsPerPage=20`, `MaxCardsPerSearch=3`, `PageTo=15`, `ListCardsTime=3600`, azione `SellItem`. Qualità, rarità, nazione, campionato, club e posizione risultano `Any` nel file osservato: se la richiesta impone `Gold Rare`, seleziona esplicitamente qualità e rarità nella UI e verifica il salvataggio invece di fidarti del nome della lista.

## Lista multipla `GOLD NOT RARE ANY COUNTRY`

La lista osservata contiene otto filtri, nell'ordine: Brasile, Francia, Inghilterra, Portogallo, Croazia, Paesi Bassi, Argentina, Marocco. I valori condivisi sono: qualità `Gold`, rarità serializzata `Any`, rating `75–88`, `OfferLimit=600`, `SellPrice=600`, `MinProfit=100`, `MaxBidsPerPage=20`, `MaxCardsPerSearch=4`, `PageTo=15`, `ListCardsTime=3600`, azione `SellItem`; campionato, club e posizione sono `Any`.

Il filtro Brasile osservato ha `RatingTo=1`, mentre gli altri hanno `RatingTo=88`. Trattalo come dato anomalo: non copiarlo automaticamente. Anche la rarità `Any` non dimostra `Not Rare`; seleziona la rarità richiesta nel modulo e verifica il valore dopo il salvataggio.

## Manifest offline

Ogni elemento di `filters` richiede almeno `name` e può specificare: `quality`, `rarity`, `ratingFrom`, `ratingTo`, `nationality`, `league`, `club`, `position`, `minBuyPrice`, `maxBuyPrice`, `sellPrice`, `offerLimit`, `minProfit`, `maxBidsPerPage`, `maxCardsPerSearch`, `pageTo`, `listCardsTime`. I campi omessi restano uguali al modello UI scelto.

```json
[
  {
    "listName": "GLOBAL BID EXAMPLE",
    "filters": [
      {
        "name": "FRANCE",
        "quality": "Gold",
        "rarity": "Any",
        "ratingFrom": 75,
        "ratingTo": 88,
        "nationality": "France",
        "sellPrice": 600,
        "offerLimit": 600
      }
    ]
  }
]
```
