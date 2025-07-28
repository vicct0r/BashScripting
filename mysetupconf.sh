#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install wget gpg -y
# chaves GPG e repo vscode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg 1> /dev/null
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update -y

# instalação Steam
wget -P ~/Downloads https://repo.steampowered.com/steam/archive/precise/steam_latest.deb 1> /dev/null
sudo dpkg -i ~/Downloads/steam_latest.deb

# instalação ferramentas Python
sudo apt update -y
sudo apt install python3 python3-pip python3-venv build-essential code openssh-server openssh-client -y 1> /dev/null

# só pra garantir
sudo apt --fix-broken install -y
