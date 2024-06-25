#!/bin/bash

#set -x #echo on

BASEDIR=$(dirname $0)

echo "Script location: ${PWD}/${BASEDIR}"
echo $hostname
echo $port
echo $username
echo $database
echo $PGPASSWORD

FILE_NAME=test_database_backup_01_NOV_2020.sql
FILE_NAME=EMPTY_SCHEMA.sql

FILE_PATH=../../../../../main/resources/db/restore/sql/$FILE_NAME

FILE_SIZE=$( ls -lah "$FILE_PATH" | awk '{ print $5 }')


echo "**************** FILE SIZE $FILE_SIZE. This make take some time ****************"
echo "**************** PSQL DATABAES RESTORE STARTED ****************"

/usr/bin/psql -h $hostname -p $port -U $username -d $database -f $FILE_PATH

exit_status=$?

PGPASSWORD=''
export PGPASSWORD

if [ $exit_status -eq 1 ]; then
	echo "**************** PSQL DATABAES RESTORE COMPLETED SUCCESSFULLY ****************"
else
	echo "**************** PSQL DATABAES RESTORE COMPLETED WITH SOME ERROR OR WARNING ****************"
fi
exit $exit_status

