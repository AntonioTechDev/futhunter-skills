# Accounts: catalogo dei comandi

Catalogo per FutHunter 18.1.2. `UI` indica un menu osservato; `Risorsa` indica un controllo presente nell'eseguibile che deve essere localizzato nella UI corrente prima dell'uso. Le coordinate non sono stabili: identifica sempre il controllo dal testo e verifica la selezione.

## Inventario della pagina

Il menu `Accounts` osservato contiene: `Add New` (`Ctrl+N`), `Fast Import from CSV` (`Ctrl+I`), `Fast Edit Accounts Data`, `Filter Accounts Grid` (`Ctrl+F`), `Delete` (`Ctrl+D`), `Account Colors`, `Accounts Columns`, `Load Accounts Order`, `Save Accounts Order`, `Create Backup`, `Restore Backup`, `Export Account Statistics`, `Export Selected Accounts Data`.

Il menu `Massive Actions` osservato contiene: `Reset Timers`, `Update Settings`, `Update Packs Settings`, `Set Filters`, `Set Proxy`, `Update API Settings`, `Include-Exclude Profit`, `Sync API Providers`, `API Sell`, `Set Scheduling`, `Set Notes`, `Change Mode`.

Altri controlli censiti nell'eseguibile: login di tutti/selezionati e override; apertura/chiusura browser di tutti/selezionati; pulizia cache di tutti/selezionati; rimozione istanze fantasma; download driver; cambio password; gestione App Authenticator e backup code; refresh Web App; resell; pack; obiettivi; SBC. Localizzali nella pagina corrente prima di agire.

## Sessioni e selezione

| Operazione | Ambito | Stato | Verifica |
| --- | --- | --- | --- |
| `Run` → `Start Selected` | selezionati | UI/risorsa `smStartSelectedAccounts` | gli indici richiesti entrano nello stato avviato e `Open Accounts` aumenta coerentemente |
| `Run` → `Start All` | tutti | Risorsa `smStartAllAccounts` | ogni riga richiesta raggiunge uno stato avviato oppure espone un errore identificabile |
| `Stop` → `Stop Selected` | selezionati | UI/risorsa `smStopSelectedAccounts` | le righe escono da `Running`/`Stopping`; le altre non cambiano |
| `Stop` → `Stop All` | tutti | UI/risorsa `smStopAllAccounts` | tutte le righe sono ferme; se richiesta la chiusura completa, `Open Accounts` arriva a zero |
| `Pause` | selezionati o tutti secondo il menu | Risorsa: `iaccs_pause`, `UseAPIOnPause`, `CloseWebApponPause` | lo stato visibile distingue pausa da arresto e rispetta l'impostazione di chiusura Web App |

`Stopped - LightMode` conferma la routine ferma ma può lasciare una sessione aperta. Per “ferma tutto” controlla anche `Open Accounts`; per un arresto selettivo conserva lo stato degli account non selezionati.

## Assegnazioni e impostazioni massive

| Operazione | Ambito | Stato | Nota |
| --- | --- | --- | --- |
| `Massive Actions` → `Set Filters` / `Assegna Lista Filtri` | selezionati | UI | controlla il nome lista su ogni riga dopo l'applicazione |
| `Assegna Liste Filtri Random` | selezionati/tutti secondo dialogo | Risorsa | registra il criterio e verifica ogni assegnazione prodotta |
| `Massive Actions` → `Set Proxy` | selezionati | UI | scegli un proxy esplicito e verifica la colonna `Proxy`; il dettaglio è in `futhunter-proxies` |
| `Massive Actions` → `Update Settings` | selezionati | UI | registra tutte le impostazioni mostrate prima di applicare |
| `Massive Actions` → `Update Packs Settings` | selezionati | UI | verifica che i parametri pack visibili cambino solo sulle righe richieste |

## Modalità operative

| Operazione | Ambito | Stato | Verifica |
| --- | --- | --- | --- |
| `Resell Items` → resell | tutti/selezionati | Risorse `smResellForAll`, `smResellForSelected` | ogni riga richiesta mostra l'attività di resell o un errore |
| `Resell Items` → loop resell | tutti/selezionati | Risorse `smLoopResellForAll`, `smLoopResellForSelected` | ogni riga idonea entra in loop; annota quelle escluse |
| `Packs + Club` → `Buy Packs` | tutti/selezionati | UI | stato pack e contatori cambiano soltanto sulle righe richieste |
| `Packs + Club` → `Open My Packs` | tutti/selezionati | UI | controlla apertura e inventario; le risorse distinguono pack scambiabili |
| `Packs + Club` → `Open Preview Pack` | tutti/selezionati | UI | verifica tipo Gold/Silver, profitto minimo e prossimo tempo disponibile |
| `SBC` → `Start SBC` | tutti/selezionati | UI | stato SBC, nome sfida e contatore completato |
| Avvia SBC simultaneamente | tutti/idonei | Risorsa: `SBC_StartAllSameTime`, `SBC_StartIfRunning` | verifica ogni account separatamente |
| Ferma SBC | selezionati/idonei | Risorsa `miStopSBC` | nessun account richiesto resta nello stato SBC in esecuzione |

Il menu `Packs + Club` osservato contiene inoltre `Packs History`, `Wipe Club`, `Claim Objectives Rewards`, `Packs Profit` e i toggle `Include Not Logged` e `Close After Action`. Il menu `SBC` osservato contiene inoltre `Reset Data`, `Remove SBC`, `Remove Expired`, `SBC Daily Report` e `SBC Price`. Queste voci non fanno parte di una richiesta di pack opening o avvio SBC salvo indicazione esplicita.

## Sequenza operativa comune

1. Porta in vista gli account e leggi indici, stato e conteggi.
2. Seleziona l'ambito richiesto e ricontrollalo immediatamente prima del comando.
3. Apri il menu nominato nella tabella; se l'etichetta non è presente, interrompi senza sostituirla con una voce simile.
4. Avvia una sola volta e osserva lo stato fino a successo o errore identificabile.
5. Ritenta soltanto sugli account non riusciti; non rilanciare in blocco quelli già completati.

## Inventario ancora obbligatorio

Quando una versione dell'app cambia, ricontrolla ogni menu della pagina Accounts e aggiorna eventuali pulsanti, voci contestuali e dialoghi condizionali con: prerequisito, ambito, effetto, verifica e recupero. Ometti dalla documentazione dati identificativi degli account.
