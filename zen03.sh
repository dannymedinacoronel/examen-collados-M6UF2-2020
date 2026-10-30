#!/bin/bash
#
##################COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
	zenity --error --text="Aquest script s'ha d'executar amb privilegis de l'usuari root" --width=400
	exit 1 #Finalització del script si l'usuari que l'executa no té privilegis de root. L'enunciat no diu res i he escollit sortir amb un codi de retorn igual a 1
fi
##########################################################################################
#
if [[ ! -e /etc/crontab.antic ]]
then
	cp /etc/crontab /etc/crontab.antic
fi 
hora=$(zenity --title="Hora d'execució del script" --list --radiolist --column="Opc." --column "Hores" 'FALSE' 00 'FALSE' 09 'FALSE' 15 'FALSE' 21 --width 450 --height 220)
min=$(zenity  --title="Minut d'execució del script" --list --radiolist --column="Opc." --column "Minuts" 'FALSE' 00 'FALSE' 20 'FALSE' 40 --width 450 --height 220)
script=$(zenity --file-selection --filename=$HOME --title="Selecció script a executar" --text="Selecciona script:")
zenity --title="Dia d'execució del script" --width=300 --calendar --text="Entra dia:" --date-format="$min $hora %d %m * root $script" >> /etc/crontab
zenity --title="Fitxer /etc/crontab" --text-info --filename=/etc/crontab --width 800 --height 600
exit 0	
