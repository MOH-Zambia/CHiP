#!/bin/bash
clear

# Edit below line and make HOME_DIR as your Linux system Home Directory
HOME_DIR="/home/techo/techo/db_backup"

mkdir $HOME_DIR > /dev/null 2>&1
if [ "$?" = "0"  ]; then
	echo "Back up Folder is created at $HOME_DIR"
	chmod 777 $HOME_DIR
else
	if [ -d "$HOME_DIR" ];
	 then
   		echo "Back UP Directory already exist at $HOME_DIR,back files will be stored in this detectory."
		#echo "Try again after removing $HOME_DIR direcory "
		#exit 1
	 else 
		echo "Error while creating Backup Directory $HOME_DIR"
		echo "Try using sudo.. or check HOME directory path ($HOME_DIR) or edit and make correct home 				folder.."
		exit 1
	fi
fi

# PostgresSQL Settings
SERVER_IP="172.17.31.222"
SERVER_PORT="5432"
USER_NAME="postgres"
SCHEMA_NAME="techo"
PGPASSFILE=/home/techo/pgpass.conf
export PGPASSWORD='q1w2e3R$';
MAX_BACKUP_FILES=5	


echo "************************************************"  
echo "IP   : $SERVER_IP"
echo "PORT : $SERVER_PORT"
echo "USER_NAME : $USER_NAME "
echo "DataBase Schema : $SCHEMA_NAME"
echo "Maximum Backup files : $MAX_BACKUP_FILES "
echo "************************************************"

TODAY_DATE=$(date +"%d-%m-%Y-%H-%M-%S")
ACTUAL_FILE_NAME=BACKUP_$SCHEMA_NAME-$TODAY_DATE;
BACKUP_FILE="$HOME_DIR/$ACTUAL_FILE_NAME"
TEMP_FILE=temp.txt

# print waiting message

echo "\nPlease wait,...This may take some Time,............"

# take backup of database schema and store in file 
pg_dump -h $SERVER_IP -p $SERVER_PORT -U $USER_NAME -Fd -b -v -j 5 -f $BACKUP_FILE $SCHEMA_NAME > $TEMP_FILE 2>&1

if [ "$?" = "0" ]; then
	echo "Back up have been taken succesfully at $BACKUP_FILE"
	echo "Creating zip...:"$ACTUAL_FILE_NAME
	tar -czvf $ACTUAL_FILE_NAME.tar.gz $ACTUAL_FILE_NAME
	echo "Zip Completed and now deleted actualy file..."
	echo "Deleteing: "$ACTUAL_FILE_NAME;
	rm -r $ACTUAL_FILE_NAME
	
else
	echo "Error while Taking backup,Please Try agin,....\n"
	echo "************************************************"
	cat $TEMP_FILE
	echo "************************************************"
	rm -f $BACKUP_FILE $TEMP_FILE
	exit 1
fi

# store all file name in file in order of date of created 
ls -ct -1 $HOME_DIR/*.gz  > myfile.txt
count=1
echo "\nLatest backup Files..."
echo "************************************************\n"
while read file_name;
do
if [ $count -le $MAX_BACKUP_FILES ]
	then 
		# print latest backup files 
		echo $file_name
	else 
		# delete old backup file
		rm -f $file_name
			if [ "$?" = "0" ]; then
				echo "--> NOTE:: Old BackUp file $HOME_DIR/$file_name have been deleted "
			else
				echo "NOTE : Error while deleting Old Backup File.. $HOME_DIR/$file_name"
			fi
fi
count=`expr $count + 1`
done < myfile.txt
echo "\n************************************************"
rm -f myfile.txt $TEMP_FILE
rm -f /home/techo/imtecho.txt
