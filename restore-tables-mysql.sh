#!/bin/bash

# restore-tables-mysql.sh
# Descr: Восстанавливает таблицы БД из архивов.
# Usage: Run without args for usage info.
# Author: @Zooleen
  

[ $# -lt 2 ] && echo "Usage: $(basename $0) <Source> <Destination>" && exit 1

SOURCE=$1
DEST=$2


tbl_count=0

for file in `ls $SOURCE | grep ".gz"`;
do
	gzip -d -c $SOURCE/$file > $DEST/${file%.gz};
	tbl_count=$(( tbl_count + 1 ))
done

echo "$tbl_count таблиц восстановлено из '$SOURCE' в '$DEST'"
