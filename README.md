# FutHunter Skills

Una raccolta di skill che permette a Codex o Claude di operare su FutHunter e Futbin seguendo procedure verificate. Le skill aiutano a creare liste, gestire account e proxy, esportare transazioni e costruire squadre Futbin senza dover ripetere manualmente ogni passaggio.

> La repository non contiene account, password, token, proxy o configurazioni personali.

Se questo progetto ti è utile, supportane lo sviluppo lasciando una ⭐ alla repository: aiuta altre persone a trovarlo e incoraggia la creazione di nuove skill.

## Requisiti

Prima di iniziare servono:

- un PC Windows;
- l'app Codex o Claude codeinstallata;
- FutHunter già installato e configurato per le operazioni che lo richiedono;
- PowerShell, già incluso in Windows.

Non è necessario conoscere Git o programmare.

## Quick Start

### 1. Scarica la raccolta

In questa pagina premi **Code**, poi **Download ZIP**. Apri il file scaricato ed estrai la cartella.

### 2. Apri il terminale nella cartella

Apri la cartella estratta, fai clic con il tasto destro in uno spazio vuoto e seleziona **Open in Terminal** o **Apri nel Terminale**.

### 3. Installa tutte le skill

Copia questo comando nel terminale e premi Invio:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Skill all
```

Quando compare `Done. Restart Codex to reload installed skills.`, chiudi e riapri Codex.

### 4. Chiedi a Codex cosa vuoi fare

Non devi avviare gli script manualmente. Scrivi una richiesta naturale, per esempio:

- `Usa futhunter-lists per creare una lista Global Bid 85 Gold Rare.`
- `Usa futhunter-accounts per mettere in pausa gli account selezionati.`
- `Usa futhunter-proxies per importare questo CSV e controllare i proxy.`
- `Usa futhunter-transactions per esportare le transazioni dell'ultima settimana.`
- `Usa futbin-squad-builder per creare una squadra con queste carte.`

Codex caricherà la skill adatta e ti chiederà soltanto le informazioni indispensabili. Le operazioni che avviano account, modificano dati o agiscono su più elementi devono essere confermate e verificate nell'interfaccia.

## Aggiornamento

Scarica nuovamente la repository, estraila e usa:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Skill all -Force
```

`-Force` sostituisce le copie installate in precedenza.

## Installazione di una sola skill

Per vedere i nomi disponibili:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -List
```

Per installarne soltanto una:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Skill futhunter-lists
```

Le skill vengono copiate in `%USERPROFILE%\.codex\skills`, oppure in `$CODEX_HOME\skills` se hai configurato `CODEX_HOME`.

## Skill incluse

- `futbin-squad-builder`: crea, salva e verifica squadre Futbin.
- `futhunter-accounts`: avvia, ferma e gestisce account selezionati o tutti, inclusi Loop Resell, Pack Opening, Pack Preview e SBC.
- `futhunter-lists`: crea, importa, esporta e verifica liste Sniping, AutoBidder, Global Bids e Global Sniping 59th.
- `futhunter-proxies`: importa, controlla e assegna proxy manualmente, da CSV o da IPRoyal.
- `futhunter-transactions`: esporta e controlla le transazioni FutHunter in CSV.
- `writing-for-agents`: linee guida per scrivere skill e documenti destinati agli agenti.

## Risoluzione rapida dei problemi

- **Il terminale non trova `install.ps1`**: riaprilo dentro la cartella estratta, quella che contiene il file.
- **La skill esiste già**: ripeti il comando aggiungendo `-Force`.
- **Codex non vede le nuove skill**: chiudi completamente Codex e riaprilo.
- **FutHunter non risponde ai comandi**: verifica che sia aperto, connesso e nello stato richiesto dalla skill.
- **Un'operazione XML viene rifiutata**: chiudi FutHunter; queste modifiche vengono eseguite soltanto a programma chiuso e con backup.

## Sicurezza

Non pubblicare né allegare `FUTHunter_AccountSettings.xml`: può contenere email, password, token, backup code e credenziali proxy. Gli script inclusi lavorano sui file locali indicati dall'utente, applicano controlli e creano backup quando previsto. Prima di azioni massive o che avviano attività reali, controlla sempre account e selezione.

## Per utenti Git

In alternativa al file ZIP:

```powershell
git clone https://github.com/AntonioTechDev/mcp-fut-hunter.git
cd mcp-fut-hunter
.\install.ps1 -Skill all
```

## Struttura e contributi

Ogni skill vive in `skills/<nome>/` e contiene un file `SKILL.md`. Script e riferimenti restano nelle cartelle `scripts/`, `references/` o `agents/`.

Mantieni ogni skill autonoma, non inserire credenziali o dati personali e prova gli script su copie prive di dati sensibili prima di proporre modifiche.
