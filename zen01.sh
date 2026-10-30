#!/bin/bash
DIR=$(zenity --file-selection --filename=$HOME --directory --title="Selecciona una carpeta" --width 1000)
FILE_NAME=$(zenity --entry --text="Escriu el nom de fitxer:" --title="Introducció del nom del fitxer" --width 100)
FILE_EXT=$(zenity  --list --radiolist --column="Opc." --column "Extensions" 'FALSE' php 'FALSE' sh 'FALSE' conf --width 300 --height 200)
file=$DIR/$FILE_NAME.$FILE_EXT
zenity --text-info --title="Escriu el texte" --editable > $file --width=400
if [[ $FILE_EXT == "sh" ]]
then
	zenity --question --text="Vols fer executable el fitxer $file"
	if [[ $? == 0 ]]
	then 
		chmod a+x $file
	fi
fi
exit 0
