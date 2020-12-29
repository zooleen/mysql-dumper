#!/bin/bash

# dump-tables-mysql-enc.sh
# Descr: Dump MySQL table data into separate SQL files for a specified database.
# Usage: Run without args for usage info.
# Author: @Trutane
# Editor: github.com/zooleen
# Ref: http://stackoverflow.com/q/3669121/138325
# Notes:
#  * Output files are compressed and saved in the current working dir, unless DIR is
#    specified on command-line.

[ $# -lt 4 ] && echo "Usage: $(basename $0) <DB_HOST> <DB_USER> <DB_PASS> <DB_NAME> [<DIR>]" && exit 1

DB_host=$1
DB_user=$2
DB_pass=$3
DB=$4
DIR=$5

[ -n "$DIR" ] || DIR=.
test -d $DIR || mkdir -p $DIR

echo "Dumping tables into separate SQL command files for database '$DB' into dir=$DIR"

tbl_count=0

for t in $(mysql -NBA -h $DB_host -u $DB_user -p$DB_pass -D $DB -e 'show tables')
do
    echo "DUMPING TABLE: $DB.$t"
    mysqldump --skip-lock-tables -h $DB_host -u $DB_user -p$DB_pass $DB $t | gzip | openssl enc -salt -aes-256-cbc -pass file:"/root/.zln-dumper/encryption_key" >  $DIR/$DB.$t.sql.gz.enc
    tbl_count=$(( tbl_count + 1 ))
done

echo "$tbl_count tables dumped from database '$DB' into dir=$DIR"
