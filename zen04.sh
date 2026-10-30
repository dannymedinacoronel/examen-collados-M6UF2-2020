#!/bin/bash
#
##################COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
	zenity --error --text="Aquest script s'ha d'executar amb privilegis de l'usuari root"
	exit 1 #Finalització del script si l'usuari que l'executa no té privilegis de root. L'enunciat no diu res i he escollit sortir amb un codi de retorn igual a 1
fi
##########################################################################################
#
EXT=$(zenity --entry --text="Escriu l'extensió dels fitxers dels quals s'ha de fer un backup:" --title="dialog4.sh: Extensió dels fitxers" --width 100)
DIR_ORIG=$(zenity --file-selection --filename=$HOME --directory --title="dialog4.sh: Selecciona la carpeta a on es troben els fitxers dels quals s'ha de fer un backup:" --width 1000)
NOM_BACKUP=$(zenity --entry --text="Escriu el nom del fitxer de backup:" --title="dialog4.sh: Nom del backup" --width 100)
DATA=$(zenity --calendar --title="dialog4.sh: Seleciona la data del backup" --text="Click a sobre d'una data per seleccionar-la" --width=320 --height=100 --date-format=20%y%m%d)
DIR_DEST=$(zenity --file-selection --filename=$HOME --directory --title="dialog4.sh: Selecciona la carpeta a on es desarà el backup:" --width 1000)
cd $DIR_ORIG;tar cf $DIR_DEST/$NOM_BACKUP.$DATA.tar *.$EXT 
# Són 2 ordres en 1 línia. Primer canvia al directori a on es troben el fitxers dels quals volem fer un backup i després fa el backup.
# D'aquesta manera l'ordre tar només té en compte els fitxer. Si no es fa així, també tindria en compte el directori.
gzip $DIR_DEST/$NOM_BACKUP.$DATA.tar
exit 0 


