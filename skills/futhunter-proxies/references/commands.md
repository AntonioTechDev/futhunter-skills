# Proxy: percorsi UI

Catalogo per FutHunter 18.1.2. Apri il riquadro `Proxy`. L'inventario dell'eseguibile conferma i controlli: aggiungi, modifica, elimina, import rapido, import IPRoyal, export, filtro, controllo e assegnazione casuale.

## Aggiunta manuale

1. Apri `Proxy` → `Add Proxy` / `Aggiungi Proxy`.
2. Compila nome, address/host, porta e credenziali solo se il provider usa autenticazione username/password.
3. Salva e verifica che appaia una sola riga con il nome atteso.
4. Avvia `Check Proxy` sulla nuova riga e attendi lo stato finale. Non assegnare un proxy fallito.

Sono supportati proxy HTTP/HTTPS con autorizzazione dell'IP oppure username/password. Non convertire automaticamente SOCKS in HTTP.

## Import CSV

Usa `Fast Import` / `Importazione Massiva Proxy`. Il dialogo dell'app richiede quattro colonne, corrispondenti alla struttura persistita: `ProxyName`, `ProxyAddress`, `ProxyPort`, `ProxyCredentials`. Prima dell'import:

- rileva il delimitatore dal file e conferma l'anteprima a quattro colonne;
- rifiuta righe con nome/host vuoto o porta fuori da `1–65535`;
- non stampare la colonna credenziali;
- importa una volta e confronta `importati/totale` con il numero di righe valide.

Dopo l'import filtra i nomi appena aggiunti, esegui `Check Proxy` e riporta riusciti/falliti. Il CSV a sei colonne appartiene all'import account (`Email;Password;Console;AppAuthKey;BackupCodes;Proxy`), non all'import proxy.

## Import IPRoyal

1. Apri `Import from IPRoyal` dalla pagina `Proxy`.
2. Incolla o carica esclusivamente il formato prodotto dal pannello IPRoyal richiesto dal dialogo corrente.
3. Controlla l'anteprima: ogni record deve risolversi in host, porta, username e password; non invertire username/host.
4. Importa, confronta il conteggio e testa tutte le nuove righe.

Se il formato IPRoyal non viene riconosciuto, non correggere per tentativi nell'app: normalizzalo localmente in CSV a quattro colonne e usa l'import CSV.

## Assegnazione

- **Dalla pagina Proxy:** seleziona i proxy consentiti, usa `Assign Random Proxy`, poi scegli `Use Selected Proxy` o `Use All Proxy` e `Apply Selected Accounts`, `Apply All Accounts` oppure `Apply No Proxy Accounts` secondo la richiesta. Ricontrolla il numero di proxy e account nel dialogo prima di applicare.
- **Dalla pagina Accounts:** seleziona esattamente gli account, apri `Massive Actions` → `Set Proxy`, scegli un proxy esplicito e applica. Verifica la colonna `Proxy` riga per riga.

Non usare assegnazione casuale quando l'utente ha fornito una mappa account→proxy. Non cambiare account già assegnati quando è richiesto soltanto `senza proxy`.

## Export ed eliminazione

L'export può contenere credenziali: salvalo solo in un percorso locale dichiarato e non allegarlo alla repo. L'eliminazione richiede la selezione precisa e la conferma immediatamente prima; dopo la rimozione verifica anche gli account che usavano quel proxy.
