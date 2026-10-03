# Assegnazioni account tramite XML

Usa il file locale soltanto per assegnazioni massive quando FutHunter è chiuso. Il documento contiene anche credenziali e proxy: lavorane una copia locale e non mostrarne il contenuto.

`AccountSettings/settings/Settings` contiene gli account nell'ordine serializzato. Prima della scrittura confronta tale ordine con gli indici 1-based della griglia. L'assegnazione di una lista aggiorna `FiltersListName` e copia i relativi nodi `FiltersToSearch` dentro `filtersToSearch` dell'account.

[Lo script di assegnazione](../scripts/assign_lists.ps1) richiede una mappa JSON esplicita con `accountIndex` e `listName`, rifiuta indici duplicati o liste mancanti, salva un backup e convalida il risultato serializzato. Dopo la riapertura verifica ogni riga interessata. La modifica XML non avvia né arresta account.
