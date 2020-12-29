#!/bin/bash

# restore-tables-mysql-enc.sh
# Descr: Восстанавливает таблицы БД из зашифрованных архивов.
# Usage: Run without args for usage info.
# Author: @Zooleen
  

[ $# -lt 2 ] && echo "Usage: $(basename $0) <Source> <Destination> [<Keyfile>]" && exit 1

SOURCE=$1
DEST=$2
KEYFILE=$3

tbl_count=0

for file in `ls $SOURCE | grep ".enc"`;
do
	openssl enc -aes-256-cbc -d -pass file:${KEYFILE:=/root/.zln-dumper/encryption_key} \
	-in $SOURCE/$file | gzip -d -c > $DEST/${file%.gz.enc};
	tbl_count=$(( tbl_count + 1 ))
done

echo "$tbl_count таблиц восстановлено из '$SOURCE' в '$DEST'"
