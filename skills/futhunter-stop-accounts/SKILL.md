---
name: futhunter-stop-accounts
description: Ferma tutti gli account FutHunter o solo quelli selezionati e verifica che l'arresto sia effettivo.
---

# Arrestare account FutHunter

## Individua l'ambito

Apri `Accounts` e leggi gli indici della griglia, `N Sel.`, `Open Accounts` e gli stati. Se la richiesta riguarda alcuni account, usa esattamente gli indici forniti dall'utente; non ricavare la selezione dall'ordine di un lavoro precedente. Prima di fermarli, registra quali sono in esecuzione e quali sono già fermi.

## Ferma

- **Tutti:** usa `Stop` → `Stop All`.
- **Selezionati:** seleziona solo le righe richieste. Per un intervallo contiguo puoi usare `Shift+Down`; per indici separati usa la selezione multipla disponibile nella griglia. Controlla che `N Sel.` e gli indici evidenziati coincidano con la richiesta, poi usa `Stop` → `Stop Selected`.

Attendi l'uscita da `Running` o `Stopping` e verifica lo stato di ogni account interessato nella griglia. Per un arresto selettivo, verifica anche che gli altri account mantengano lo stato precedente. Se qualcuno resta attivo o segnala un errore, identifica l'indice e riprova solo la parte non completata.

## Verifica le sessioni

`Stopped - LightMode` conferma che la routine è ferma, ma può lasciare una sessione ancora aperta: leggi anche `Open Accounts`. Quando l'utente chiede di fermare **tutto** e `Stop All` lascia sessioni aperte, chiudi normalmente FutHunter e riaprilo senza premere `Run`; la verifica finale è `Open Accounts: 0` e gli account interessati `NotLogged Stopped - LightMode`. Per un arresto selettivo mantieni aperta l'app, così gli account non selezionati possono proseguire.

Riporta quanti account sono stati fermati, quanti restano aperti e gli eventuali indici ancora attivi. Considera l'operazione completata solo quando gli account richiesti risultano fermi nell'interfaccia.

