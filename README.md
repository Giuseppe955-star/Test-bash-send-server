# Script di Automazione per il Trasferimento File via SFTP

## Descrizione
Questo script Bash automatizza il processo di generazione, preparazione e trasferimento di file CSV a un server remoto utilizzando **SFTP**. Lo script:
- Imposta le variabili di ambiente da un file esterno (`setEnv.sh`).
- Esegue un'operazione Java per generare dati.
- Crea file di controllo (`.ok`) per ciascun file CSV.
- Si connette a un server remoto tramite SFTP utilizzando `expect`.
- Crea le directory necessarie sul server.
- Trasferisce i file nelle rispettive directory.
- Rimuove i file di controllo locali dopo il trasferimento.

---

## Requisiti

### Software richiesto
- **Bash**
- **Java Runtime** (per eseguire il processo `TediInterface.jar`)
- **Expect** (per automatizzare l'interazione con SFTP)

### Variabili di Ambiente
Lo script utilizza un file `setEnv.sh` che deve definire almeno le seguenti variabili:
- `$PORT` → Porta di connessione SFTP
- `$USER` → Nome utente per l'autenticazione SFTP
- `$HOST` → Indirizzo del server SFTP
- `$TARGET_DIR` → Directory di destinazione sul server remoto
- `[Path]` → Percorso locale dove vengono generati i file

---

## Passaggi dello Script

### 1. Caricamento delle variabili di ambiente
```bash
. ./setEnv.sh
```

### 2. Pulizia file di log
```bash
rm Tedisftp.log
```

### 3. Creazione della variabile con la data corrente
```bash
DATE_DIR=$(date '+%Y-%m-%d')
```

### 4. Esecuzione del processo Java
```bash
java -cp TediInterface.jar it.archibus.tedi.FlussiForTEDI >> interfacciaTedi.log 2>&1
```

### 5. Creazione di file di controllo
```bash
touch siti_$DATE_DIR.csv.ok
touch immobili_$DATE_DIR.csv.ok
touch edifici_$DATE_DIR.csv.ok
```

### 6. Connessione e trasferimento file via SFTP
Lo script usa `expect` per automatizzare l'interazione con il server SFTP:
```bash
/usr/bin/expect << EOF >> [Path]/Tedisftp.log 2>&1

spawn /usr/bin/sftp -o Port=$PORT $USER@$HOST
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR\r"
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR/realestate_fabbricato\r"
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR/realestate_immobile\r"
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR/realestate_sito\r"

send "put edifici_$DATE_DIR.csv $TARGET_DIR/$DATE_DIR/realestate_fabbricato\r"
send "put edifici_$DATE_DIR.csv.ok $TARGET_DIR/$DATE_DIR/realestate_fabbricato\r"
send "put immobili_$DATE_DIR.csv $TARGET_DIR/$DATE_DIR/realestate_immobile\r"
send "put immobili_$DATE_DIR.csv.ok $TARGET_DIR/$DATE_DIR/realestate_immobile\r"
send "put siti_$DATE_DIR.csv $TARGET_DIR/$DATE_DIR/realestate_sito\r"
send "put siti_$DATE_DIR.csv.ok $TARGET_DIR/$DATE_DIR/realestate_sito\r"

send "bye\r"
EOF
```

### 7. Pulizia file di controllo locali
```bash
rm siti_$DATE_DIR.csv.ok
rm immobili_$DATE_DIR.csv.ok
rm edifici_$DATE_DIR.csv.ok
```

---

## Esecuzione dello Script
Eseguire lo script con:
```bash
chmod +x script.sh
./script.sh
```

---

## Debugging
Se si verificano problemi durante l'esecuzione:
1. Controllare i log:
   ```bash
   cat interfacciaTedi.log
   cat Tedisftp.log
   ```
2. Assicurarsi che `expect` sia installato con:
   ```bash
   which expect
   ```
3. Verificare le variabili di ambiente con:
   ```bash
   echo $PORT $USER $HOST $TARGET_DIR
   ```

