---
name: futhunter-lists
description: Crea, modifica, importa, esporta e assegna liste Snipe o Global Bid in FutHunter, con uno o più filtri.
---

# Liste FutHunter

Determina prima il tipo richiesto: **Snipe**, **Global Bid**, import Futbin/FutGG, export oppure gestione di una lista esistente. L'import Futbin/FutGG appartiene al ramo Snipe. Leggi il ramo corrispondente in [references/commands.md](references/commands.md) e, per Global Bid, i modelli verificati in [references/global-bid.md](references/global-bid.md).

Quando FutHunter è aperto o esistono account in esecuzione, usa l'interfaccia. Per lotti Snipe offline puoi usare [scripts/create_lists.ps1](scripts/create_lists.ps1); per lotti Global Bid usa [scripts/create_global_bid_lists.ps1](scripts/create_global_bid_lists.ps1). Entrambi richiedono FutHunter chiuso, un modello creato dalla stessa versione dell'app, backup e verifica dopo la riapertura. Leggi prima [references/xml.md](references/xml.md).

## Criterio di completamento

Riapri ogni lista modificata e verifica nome, tipo, numero e ordine dei filtri, identità/parametri di ogni filtro e valori economici. Un import o salvataggio non è riuscito finché la lista non appare correttamente nella griglia.

Per l'assegnazione agli account passa alla skill `futhunter-accounts`; per la sola costruzione della squadra sul sito usa `futbin-squad-builder`.
