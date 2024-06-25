#!/bin/bash
clear

SCHEMA_NAME='test-database-restore';
API_LOGIN_USER='kkpatel';
API_LOGIN_USER_PASSWORD='sadmin@123'
API_HOST_URL='http://localhost:8181'
export PGPASSWORD=argusadmin;

TODAY_DATE=$(date +"%d-%m-%Y-%H-%M-%S")
ACTUAL_FILE_NAME=BACKUP_$SCHEMA_NAME-$TODAY_DATE;

todayFileName=$ACTUAL_FILE_NAME
data=$(curl  --data 'grant_type=password&username='$API_LOGIN_USER'&password='$API_LOGIN_USER_PASSWORD'&loginas=&client_id=imtecho-ui' -H "Authorization:Basic aW10ZWNoby11aTppbXRlY2hvLXVpLXNlY3JldA=="  ${API_HOST_URL}/oauth/token)
echo $data;
token=$( echo $data |  jq --raw-output '.access_token');
echo $token
wget --content-disposition -O $todayFileName ${API_HOST_URL}/api/database/download --header="Authorization:Bearer "$token ;
mkdir $todayFileName'-unzip';
tar -xf $todayFileName --directory $todayFileName'-unzip';
dataDir=$(ls $todayFileName'-unzip'|head -n 1);
echo $dataDir;
echo $SCHEMA_NAME
psql -U postgres -h localhost -d postgres -c "DROP DATABASE \"$SCHEMA_NAME\";"
psql -U postgres -h localhost -d postgres -c "CREATE DATABASE \"$SCHEMA_NAME\";"
pg_restore -d $SCHEMA_NAME $todayFileName'-unzip'/$dataDir -U postgres;
