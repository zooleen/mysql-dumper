#!/bin/bash

# dump-tables-mysql-enc.sh
#
# Создает дамп таблиц базы данных MySQL в отдельные зашифрованные архивы.
# Использование: Запустить без аргументов, чтоб увидеть инфо.
# Author: @Trutane
# Editor: github.com/zooleen
# 

[ $# -lt 4 ] && echo "Usage: $(basename $0) <DB_HOST> <DB_USER> <DB_PASS> <DB_NAME> [<DIR>]" && exit 1

DB_host=$1
DB_user=$2
DB_pass=$3
DB=$4
DIR=$5

[ `date +%u` == 1 ] && prefix="weekly/"
[ `date +%u` != 1 ] && prefix="common/"

[ -n "$DIR" ] || DIR=.
test -d $DIR || mkdir -p $DIR

mkdir -p $DIR/$prefix

echo "Dumping tables into separate SQL command files for database '$DB' into dir=$DIR"

tbl_count=0

for t in $(mysql -NBA -h $DB_host -u $DB_user -p$DB_pass -D $DB -e 'show tables')
do
    echo "DUMPING TABLE: $DB.$t"
    mysqldump --skip-lock-tables -h $DB_host -u $DB_user -p$DB_pass $DB $t | gzip | openssl enc -salt -aes-256-cbc -pass file:"/root/.zln-dumper/encryption_key" >  $DIR/$prefix$DB.$t.sql.gz.enc
    tbl_count=$(( tbl_count + 1 ))
done

echo "$tbl_count таблиц создано из базы данных '$DB' в каталог: $DIR/$prefix"
