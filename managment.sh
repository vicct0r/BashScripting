#!/bin/bash

TEMPDIR="/tmp/webfiles"
URL="https://www.tooplate.com/zip-templates/2135_mini_finance.zip"
FILE="2135_mini_finance"
SIP=$(hostname -I | awk '{print $1}')

yum --help &> /dev/null

if [ $? -eq 0 ]; then
	# Variaveis para CentOS
	PACKAGE="httpd wget unzip"
	SERVICE="httpd"
	CM="yum"
	echo "Running setup on CentOS"
	echo "Installing packages..."
	clear
	sudo $CM install $PACKAGE 1> /dev/null
	
	echo "Starting and enabling $SERVICE..."
	sudo systemctl start $SERVICE && sudo systemctl enable $SERVICE
	
	echo "Preparing HTML files..."
	mkdir $TEMPDIR
	cd $TEMPDIR
    wget $URL

	unzip $FILE.zip
	cp -r $FILE/* /var/www/html
	
	echo "Files are done."
	clear
	echo "Restarting Httpd service..."	
	sudo systemctl restart $SERVICE 1> /dev/null

	if [ $? -eq 0 ]; then
		echo "Service is now running on $SIP:80"
	else
		if [ $(ls -d /var/www/html) -eq 0 ]; then
			echo "Something went wrong on the Httpd file settings!"
		else
			echo "Unknown error! Contact the Admin!"
		fi
	fi
else
    PACKAGE="apache2 wget unzip"
    SERVICE="apache2"

    echo "Starting $SERVICE..."
    sudo systemctl start $SERVICE && sudo systemctl enable $SERVICE 1> /dev/null
    clear

    mkdir $TEMPDIR
    cd $TEMPDIR
    echo "Downloading the assets..."

    wget $URL
    unzip $FILE.zip
    cp -r $FILE/* /var/www/html
    sudo systemctl restart $SERVICE 1> /dev/null

    if [ $? -eq 0 ]; then
        echo "The service was successfully configured!"
        clear
        echo "Service is running on $SIP:80"
    else
        echo "Something went wrong!"
        if [ $(ls -d /var/www/html) -eq 0 ]; then
            echo "Something went wrong when moving assets to the config file!"
        else
            echo "Unknown error! Contact the Admin!"
        fi
    fi
fi