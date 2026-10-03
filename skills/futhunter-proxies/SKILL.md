---
name: futhunter-proxies
description: Aggiunge, importa, controlla e assegna proxy FutHunter manualmente, da CSV o da IPRoyal, su account selezionati o senza proxy.
---

# Proxy FutHunter

Determina prima il ramo richiesto: aggiunta manuale, import CSV, import IPRoyal, controllo, assegnazione casuale dalla pagina `Proxy` oppure assegnazione esplicita dalla pagina `Accounts`. Leggi [references/commands.md](references/commands.md) e usa soltanto quel ramo.

Le credenziali proxy sono segreti. Non mostrarle nei messaggi, negli screenshot, nei log, nei commit o nei file di esempio. Nei risultati usa nome proxy, conteggi e stato del test; oscura indirizzo e credenziali.

Quando FutHunter è aperto usa l'interfaccia. Per lotti offline, a FutHunter chiuso, puoi usare [scripts/import_proxies.ps1](scripts/import_proxies.ps1) o [scripts/assign_proxies.ps1](scripts/assign_proxies.ps1) dopo aver letto [references/xml.md](references/xml.md).

## Completamento

Un'importazione è completa quando il numero di righe aggiunte coincide con l'origine, non esistono duplicati inattesi e il controllo nell'app ha uno stato terminale per ogni proxy. Un'assegnazione è completa quando la colonna `Proxy` degli account richiesti mostra il nome atteso e gli account fuori ambito non sono cambiati.
