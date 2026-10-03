# Codex Custom Skills

Raccolta di skill riutilizzabili per Codex, pensata sia per persone sia per agenti. La repository contiene le skill create finora, ciascuna isolata nella propria cartella con istruzioni, riferimenti e script di supporto.

## Skill incluse

- `futbin-futhunter-player-lists`: crea squadre Futbin, liste FutHunter e assegna o avvia account.
- `futhunter-stop-accounts`: arresta tutti gli account FutHunter o una selezione verificata.
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

Mantieni ogni skill autonoma, evita credenziali e dati personali, e verifica gli script prima del commit. Quando la raccolta verrà resa pubblica, aggiungi una licenza esplicita e una breve guida ai contributi.

