# Proxy tramite XML

Usa XML soltanto con FutHunter chiuso. `FUTHunter_AccountSettings.xml` contiene account, password, token, backup code e credenziali proxy: lavorane una copia locale, non mostrarla e non inserirla nella repository.

`AccountSettings/ProxyList/Proxy` contiene `ProxyId`, `ProxyName`, `ProxyAddress`, `ProxyPort`, `ProxyCredentials`, `ProxyStatus`. Gli account sono in `AccountSettings/settings/Settings` e persistono l'assegnazione in `Proxy_Use`, `Proxy_Address`, `Proxy_Port`, `Proxy_Credentials`.

Gli script creano un backup accanto al file, rifiutano l'XML attivo di un processo FutHunter e convalidano la copia serializzata prima della sostituzione atomica. Dopo la riapertura esegui comunque `Check Proxy` e verifica la colonna `Proxy` degli account interessati.
