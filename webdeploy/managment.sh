#!/bin/bash

TEMPDIR="/tmp/webfiles"
URL="https://www.tooplate.com/zip-templates/2135_mini_finance.zip"
FILE="2135_mini_finance"
SIP=$(hostname -I | awk '{print $1}')

yum --help &> /dev/null

if [ $? -eq 0 ]; then
	echo "Ambiente autal: Red Hat."
	PACKAGE="httpd wget unzip"
	SERVICE="httpd"
	echo "Iniciando instalações..."
	sudo yum install $PACKAGE -y 1> /dev/null
	
	if [ $? -eq 0 ]; then
		echo "Instalação concluída com sucesso!"
		sudo systemctl start $SERVICE && sudo systemctl enable $SERVICE 1> /dev/null
	else
		echo "Um erro ocorreu durante a instalação!"
	fi
	
	echo "Baixando assets do serviço..."
	mkdir $TEMPDIR && cd $TEMPDIR

	wget $URL 1> /dev/null

	unzip $FILE.zip
	cp -r $FILE/* /var/www/html
	
	echo "Reiniciando serviço $SERVICE..."
	sudo systemctl restart $SERVICE 1> /dev/null

	if [ $? -eq 0 ]; then
		echo "Serviço rodando na porta: $SIP:80"
	else
		echo "Um erro aconteceu! Contate o Admin!"
	fi
else
	echo "Ambiente Debian reconhecido!"
	PACKAGE="apache2 wget unzip"
	SERVICE="apache2"

	echo "Atualizando pacotes..."
	sudo apt update -y 1> /dev/null
	sudo apt install $PACKAGE -y 1> /dev/null

	echo "Iniciando $SERVICE..."
	sudo systemctl start $SERVICE && sudo systemctl enable $SERVICE 1> /dev/null

	mkdir $TEMPDIR && cd $TEMPDIR
	echo "Baixando assets..."
	wget $URL 1> /dev/null

	unzip $FILE.zip 1> /dev/null
	cp -r $FILE/* /var/www/html

	sudo systemctl restart $SERVICE 1> /dev/null
	
	if [ $? -eq 0 ]; then
		echo "Sucesso! Serviço está rodando: $SIP:80"
	else
		echo "Um erro ocorreu! Contate o Admin!"
	fi
fi