# Codex Custom Skills

Raccolta di skill riutilizzabili per Codex, pensata sia per persone sia per agenti. La repository contiene le skill create finora, ciascuna isolata nella propria cartella con istruzioni, riferimenti e script di supporto.

## Skill incluse

- `futbin-squad-builder`: crea e verifica squadre Futbin; non gestisce l'import in FutHunter.
- `futhunter-accounts`: avvia, ferma e gestisce account selezionati o tutti, inclusi resell, pack, preview e SBC.
- `futhunter-lists`: crea, importa, esporta e verifica liste Snipe o Global Bid singole/multiple.
- `futhunter-proxies`: importa, controlla e assegna proxy manuali, CSV o IPRoyal.
- `futhunter-transactions`: esporta e controlla le transazioni FutHunter in CSV.
- `writing-for-agents`: linee guida per scrivere skill e documenti destinati agli agenti.

## Installazione

Clona la repository, poi esegui:

```powershell
./install.ps1 -List
./install.ps1 -Skill all
```

Per installare una sola skill usa `./install.ps1 -Skill nome-skill`. La destinazione predefinita è `$CODEX_HOME/skills`, oppure `%USERPROFILE%/.codex/skills` quando `CODEX_HOME` non è definita. Aggiungi `-Force` per sostituire una copia esistente.

## Struttura

Ogni skill vive in `skills/<nome>/` e contiene almeno `SKILL.md`. Eventuali file di supporto restano accanto alla skill in `scripts/`, `references/` o `agents/`, così i percorsi relativi continuano a funzionare dopo l'installazione.

## Contribuire

Mantieni ogni skill autonoma, evita credenziali e dati personali, e verifica gli script prima del commit. Le automazioni XML richiedono FutHunter chiuso, creano un backup e devono essere ricontrollate nell'interfaccia dopo ogni aggiornamento dell'app. Quando la raccolta verrà resa pubblica, aggiungi una licenza esplicita e una breve guida ai contributi.
