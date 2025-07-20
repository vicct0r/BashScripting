#!/bin/bash

echo "Instalando dependências..."
sudo yum install httpd unzip wget -y 1> /dev/null
echo 

echo "Iniciando serviço HTTPD"
sudo systemctl start httpd
sudo systemctl enable httpd
echo

echo "Baixando arquivos para template..."
mkdir /tmp/project
cd /tmp/project

wget https://www.tooplate.com/zip-templates/2134_gotto_job.zip > /dev/null
echo

echo "Descompactando o arquivo zip..."
unzip 2134_gotto_job.zip 1> /dev/null
echo

echo "Copiando arquivos para diretório HTTPD (html)..."
sudo cp -r 2134_gotto_job/* /var/www/html/
echo

echo "Reiniciando HTTPD Server..."
sudo systemctl restart httpd
sudo rm -rf /tmp/project
echo
