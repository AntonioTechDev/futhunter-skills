---
name: futbin-futhunter-player-lists
description: Crea squadre Futbin con le card giocatore richieste, configura liste FutHunter e assegna o avvia account usando gli indici indicati dall'utente.
---

# Giocatori Futbin e liste FutHunter

Per ogni lista acquisisci nome, giocatori nell'ordine richiesto, card esatte quando sono forniti i link e limiti di acquisto. Acquisisci separatamente gli indici degli account da assegnare e quelli da avviare. Il numero di giocatori per squadra e gli indici dipendono dalla richiesta corrente: non ricavare una distribuzione da lavori precedenti. Registra in un manifesto squadre salvate, card, prezzi e assegnazioni senza credenziali o dati degli account.

## Squadra Futbin

1. Apri lo squad builder dell'edizione richiesta. Per ogni giocatore, clicca uno slot vuoto e premi `Clear All` nel selettore: rimuove il filtro `Role`/ruolo imposto dallo slot, che altrimenti nasconde giocatori con altre posizioni. Cerca con un nome semplice, senza trattini; scegli la versione identificata dal link della card, se fornito. Ripeti per tutti i giocatori richiesti, nell'ordine dato.
2. Inserisci il nome in `Squad Name`, premi il `Save` accanto al campo e registra l'URL `/squad/NUMERO`. Riapri l'URL e verifica che tutte le card richieste siano presenti nella versione giusta. La squadra è pronta solo dopo questa verifica.

## Lista FutHunter

1. Guarda gli stati degli account in `Accounts`. Se qualcuno è in esecuzione, lavora dall'interfaccia, senza riavviare l'app. Se nessuno è in esecuzione e il lotto è grande, puoi scegliere il [metodo XML](references/xml-fallback.md) dopo aver creato e verificato una lista pilota dall'interfaccia; applica il file solo ad app chiusa. Per card speciali usa un modello della stessa versione o l'interfaccia.
2. Per importare una squadra salvata usa `Filters` → `Import` → `Import Futbin-FutGG` e incolla l'URL della squadra. Se i controlli Futbin/FutGG sono rossi, in `Settings` spegni `Futbin-FutGG Proxy` e salva, riaccendilo e salva, poi usa `Check Prices`. Se l'import fallisce, crea la lista dall'interfaccia: `Filters` → `Add New`, assegna il nome; nella lista usa `Add` → `Add New`, compila `Filter Name`, `Add Player`, seleziona la card per nome, ID e versione, quindi `Save`. Ripeti il filtro per ogni giocatore. Usa il `Save` della schermata liste quando presente.
3. Per ogni filtro imposta `Minimum Profit` e controlla il `Buy Price` calcolato dall'app. Il limite richiesto è soddisfatto solo se `Buy Price ≤ limite` per ciascun giocatore; dopo il salvataggio riapri la lista e verifica nome, numero e identità delle card e prezzi. Non considerare riuscito un import che non appare nella griglia.

## Assegnazione e avvio

1. In `Accounts` usa gli indici 1, 2, 3… mostrati dalla griglia per associare a ogni account la lista indicata dall'utente. Con account in esecuzione usa `Massive Actions` → `Set Filters` sui soli indici interessati. A app ferma puoi usare lo [script di assegnazione](scripts/assign_accounts.ps1) con una mappa esplicita indice→lista, dopo aver confrontato ordine del file e indici della griglia. Verifica nell'interfaccia ogni assegnazione richiesta.
2. Se l'utente chiede l'avvio, seleziona esattamente gli indici indicati; per intervalli contigui puoi usare `Shift+Down`. Controlla `N Sel.`, poi `Run` → `Start Selected`, conferma il numero e osserva `Open Accounts` e gli stati fino all'esito di ciascuno. Riporta gli account bloccati e il relativo errore; non dichiarare completato l'avvio finché tutti gli indici richiesti non risultano avviati.

