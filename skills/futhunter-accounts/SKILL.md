---
name: futhunter-accounts
description: "Opera sugli account FutHunter selezionati o su tutti: avvio, pausa/arresto, assegnazioni, Loop Resell, pack, preview e SBC."
---

# Account FutHunter

Esegui le azioni runtime dall'interfaccia. Prima dell'azione leggi indici, righe evidenziate, numero di selezionati, `Open Accounts`, `Status` e `List Name`; dopo l'azione verifica gli stessi indicatori fino a un risultato terminale. Gli indici sono sempre quelli mostrati nella griglia corrente.

Per il percorso esatto e la verifica leggi [references/commands.md](references/commands.md), poi usa soltanto il ramo richiesto dall'utente. Non aprire menu non necessari e non trasformare una richiesta su account selezionati in un'azione `All`.

## Selezione

- **Selezionati:** evidenzia esattamente gli indici richiesti e controlla il conteggio prima di aprire il comando.
- **Tutti:** usa il comando esplicito `All`; non simulare “tutti” con una selezione incompleta.
- Per intervalli contigui puoi usare `Shift+Down`; per indici separati usa la selezione multipla disponibile nella griglia.

## Completamento

Riporta quanti account hanno completato l'azione, quali non l'hanno completata e il loro stato visibile. Non ripetere l'azione sugli account già riusciti.

Per assegnazioni massive a FutHunter chiuso puoi usare [scripts/assign_lists.ps1](scripts/assign_lists.ps1) dopo aver letto [references/xml.md](references/xml.md). Start, stop, pausa, login, modalità operative, pack e SBC rimangono sempre azioni UI. Non pubblicare screenshot, XML, CSV o log che contengano email, password, backup code, token o credenziali proxy.
