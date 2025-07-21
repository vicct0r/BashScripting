#!/bin/bash

ls /var/run/httpd/httpd.pid &> /dev/null
SERVICE=httpd
STATUS=$(sudo systemctl is-enabled $SERVICE)

if [ $? -eq 0 ]; then
	echo "Httpd service is running!"
else
	echo "Httpd service is NOT running!"
	echo "Starting $SERVICE..."

	sudo systemctl start $SERVICE
fi


if [ $STATUS = "enabled" ]; then
	echo "Httpd is already enabled!"
	echo "Shutting down process..."
else
	echo "Httpd is not enabled!"
	read -p "Do you want to enable process? ([y]es [n]o): " CHOICE

	if [ $CHOICE = "y" ]; then
		echo "Enabling $SERVICE!"
		sudo systemctl enable $SERVICE &> /dev/null
		
		if [ $? -eq 0 ]; then
			echo "Httpd service is enabled!"
			echo "Shutting down the script."
		else
			echo "Something went wrong! Contact the admin!"
		fi
	else
		echo "Shutting down the script..."
	fi
fi
