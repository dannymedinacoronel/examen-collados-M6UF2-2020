#!/bin/bash
#
##################COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
	zenity --error --text="Aquest script s'ha d'executar amb privilegis de l'usuari root" --width=400
	exit 1  #Finalització del script si l'usuari que l'executa no té privilegis de root. L'enunciat no diu res i he escollit sortir amb un codi de retorn igual a 1
fi
##########################################################################################
#
###FORMULARI
usuari=$(zenity --forms --title="Afegeix un usuari" --text="Dóna les dades del nou usuari" \
        --add-entry="Nom de l'usuari"  --add-entry="Identificador d'Usuari - UID" \
        --add-entry="Grup per defecte" --add-entry="Directori personal de l'usuari" \
        --add-entry="Interpret d'ordres" --add-password="Contrasenya de l'usuari")
nom=$(echo $usuari | cut -d '|' -f 1)
uid=$(echo $usuari | cut -d '|' -f 2)
grup=$(echo $usuari | cut -d '|' -f 3)
dir=$(echo $usuari | cut -d '|' -f 4)
shell=$(echo $usuari | cut -d '|' -f 5)
ctrsnya=$(echo $usuari | cut -d '|' -f 6)
#
####CREACIÓ DE l'USUARI
useradd $nom -u $uid -g $grup -d $dir -m -s $shell -p $(mkpasswd $ctrsnya)  2> /dev/null # Els missatges d'errors no es mostren en terminal
if [[ $? -ne 0 ]]
then
	zenity --title="Programa de creació d'usuaris" --info --text="No s'han pogut crear l'usuari" --width=400
	exit 2 #Finalització del script si l'usuari no s'ha pogut crear. L'enunciat no diu res i he escollit sortir amb un codi de retorn igual a 2
else
	zenity --title="Programa de creació d'usuaris" --info --text="L'usuari s'ha creat amb exit" --width=400
	exit 0
fi
