#!/usr/bin/env bash

if [ "$(whoami)" != "hadoop" ]
then
	echo "command needs to be run as hadoop user"
	exit 1
fi

source /home/hadoop/.bashrc

exec 9>/tmp/logs2hive.lock
if ! flock -n 9  ; then
	echo "another instance is running";
	exit 1
fi


QUEUE="/home/hadoop/log-drop"


# transfer logs to a random datanode
for LOG in $(ls $QUEUE | grep bz2$)
do
	echo "hive import: $LOG"
	DS=$(echo $LOG | sed 's/^[^-]*-\(....\)-\(..\)-\(..\).*$/\1-\2-\3/')
	HR=$(echo $LOG | sed 's/^[^-]*-....-..-..-\(..\).*$/\1/')
	
	QRY="LOAD DATA LOCAL INPATH '$QUEUE/$LOG' INTO TABLE logs PARTITION(ds='$DS', hr='$HR')"
	/usr/local/hive/bin/hive -e "$QRY"
	if [ "$?" != "0" ]
	then
		logger -s "hive error: unable to execute: $QRY"
	else
		rm $QUEUE/$LOG
	fi
done


echo "Done"
exit 0