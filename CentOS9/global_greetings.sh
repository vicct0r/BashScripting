#!/bin/bash

# Script global (roda em Ubuntu e CentOS)
# Guardando saídas de comandos em variáveis

echo "Bem-vindo $USER ao $HOSTNAME"
echo "--------------------------------"

FREE_RAM=$(free -m | grep Mem | awk '{print $4}')
LOAD=$(uptime | awk '{print $9}')
ROOTFREE=$(df -h | grep '/dev/sda1' | awk '{print $4}')

echo "--------------------------------"
echo "Memória Disponível: $FREERAM MB"
echo "--------------------------------"
echo "Load Average: $LOAD"
echo "--------------------------------"
echo "Partição Root: $ROOTFREE"
echo "--------------------------------" 