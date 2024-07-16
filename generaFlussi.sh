#!/bin/bash

. ./setEnv.sh

rm Tedisftp.log 

DATE_DIR=$(date '+%Y-%m-%d')


java -cp TediInterface.jar it.archibus.tedi.FlussiForTEDI >> interfacciaTedi.log 2>&1 

touch Tedisftp.log

cd /data_mount/batch/InterfacciaTEDI/test/

touch  siti_$DATE_DIR.csv.ok
touch  immobili_$DATE_DIR.csv.ok
touch  edifici_$DATE_DIR.csv.ok

/usr/bin/expect << EOF >> /data_mount/batch/InterfacciaTEDI/Tedisftp.log 2>&1

spawn /usr/bin/sftp -o Port=$PORT $USER@$HOST
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR\r"
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR/realestate_fabbricato\r"
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR/realestate_immobile\r"
expect "sftp>"
send "mkdir $TARGET_DIR/$DATE_DIR/realestate_sito\r"
expect "sftp>"
send "put edifici_$DATE_DIR.csv $TARGET_DIR/$DATE_DIR/realestate_fabbricato\r"
expect "sftp>"
send "put edifici_$DATE_DIR.csv.ok $TARGET_DIR/$DATE_DIR/realestate_fabbricato\r"
expect "sftp>"
send "put immobili_$DATE_DIR.csv $TARGET_DIR/$DATE_DIR/realestate_immobile\r"
expect "sftp>"
send "put immobili_$DATE_DIR.csv.ok $TARGET_DIR/$DATE_DIR/realestate_immobile\r"
expect "sftp>"
send "put siti_$DATE_DIR.csv $TARGET_DIR/$DATE_DIR/realestate_sito\r"
expect "sftp>"
send "put siti_$DATE_DIR.csv.ok $TARGET_DIR/$DATE_DIR/realestate_sito\r"
expect "sftp>"
send "bye\r"
EOF

rm siti_$DATE_DIR.csv.ok
rm immobili_$DATE_DIR.csv.ok
rm edifici_$DATE_DIR.csv.ok
