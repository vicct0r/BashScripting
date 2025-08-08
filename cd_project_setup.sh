#!/bin/bash
IPV4=18.229.117.211
DIRETORIO=/home/$USER/CD-API-Service
sudo apt update -y
sudo apt install -y python3-venv python3-dev git libpq-dev postgresql postgresql-contrib nginx curl

sudo systemctl start postgresql && sudo systemctl enable postgresql

sudo -u postgres psql <<EOF
CREATE DATABASE cd_database;
CREATE USER victor WITH PASSWORD '12345Victor';
ALTER ROLE victor SET client_encoding TO 'utf8';
ALTER ROLE victor SET default_transaction_isolation TO 'read committed';
ALTER ROLE victor SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE cd_database TO victor;
EOF

git clone https://github.com/vicct0r/CD-API-Service.git
sudo chown -R $USER:www-data $DIRETORIO
cd $DIRETORIO

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
pip install gunicorn psycopg2-binary

cat > .env <<EOF
DJANGO_SETTINGS_MODULE=config.settings.local
DATABASE_URL="postgresql://victor:12345Victor@localhost:5432/cd_database"
EOF

python manage.py makemigrations
python manage.py migrate
python manage.py collectstatic --noinput
deactivate

sudo tee /etc/systemd/system/gunicorn.socket <<EOF
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
EOF

sudo tee /etc/systemd/system/gunicorn.service <<EOF
[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=$USER
Group=www-data
WorkingDirectory=$DIRETORIO
ExecStart=$DIRETORIO/venv/bin/gunicorn \
          --access-logfile - \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          config.wsgi:application
EnvironmentFile=$DIRETORIO/.env
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 640 $DIRETORIO/.env
sudo chown $USER:www-data $DIRETORIO/.env

sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket

sudo tee /etc/nginx/sites-available/CD-API-Service <<EOF
server {
    listen 80;
    server_name $IPV4;

    location = /favicon.ico { access_log off; log_not_found off; }
    location /staticfiles/ {
        root $DIRETORIO;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/CD-API-Service /etc/nginx/sites-enabled

sudo systemctl restart nginx
sudo ufw allow 'Nginx Full'

