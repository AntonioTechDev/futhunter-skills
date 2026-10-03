---
name: futhunter-lists
description: Crea, modifica, importa, esporta e assegna liste Sniping, AutoBidder, Global Bids o Global Sniping 59th in FutHunter, con uno o più filtri.
---

# Liste FutHunter

Determina prima il tipo richiesto: **Sniping**, **AutoBidder**, **Global Bids**, **Global Sniping 59th**, import Futbin/FutGG, export oppure gestione di una lista esistente. L'import Futbin/FutGG appartiene al ramo Sniping. Leggi il ramo corrispondente in [references/commands.md](references/commands.md), i modelli Global Bids in [references/global-bid.md](references/global-bid.md) e i parametri dei due tipi avanzati in [references/global-sniping-auto-bidder.md](references/global-sniping-auto-bidder.md).

Quando FutHunter è aperto o esistono account in esecuzione, usa l'interfaccia. Per lotti Sniping offline puoi usare [scripts/create_lists.ps1](scripts/create_lists.ps1); per lotti Global Bids usa [scripts/create_global_bid_lists.ps1](scripts/create_global_bid_lists.ps1); per Global Sniping 59th o AutoBidder usa [scripts/create_advanced_lists.ps1](scripts/create_advanced_lists.ps1). Gli script richiedono FutHunter chiuso, un modello dello stesso tipo creato dalla stessa versione dell'app, backup e verifica dopo la riapertura. Leggi prima [references/xml.md](references/xml.md).

## Criterio di completamento

Riapri ogni lista modificata e verifica nome, tipo, numero e ordine dei filtri, identità/parametri di ogni filtro e valori economici. Un import o salvataggio non è riuscito finché la lista non appare correttamente nella griglia.

Per l'assegnazione agli account passa alla skill `futhunter-accounts`; per la sola costruzione della squadra sul sito usa `futbin-squad-builder`.
