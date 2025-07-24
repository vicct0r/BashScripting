#!/bin/bash

usr="devops"

for host in $(cat remote_host); do
	echo "Connecting to $host..."
	echo "#################################"
	scp managment.sh $usr@$host:/tmp/
	ssh $usr@$host sudo /tmp/managment.sh
done