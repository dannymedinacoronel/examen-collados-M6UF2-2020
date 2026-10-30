#!/bin/bash
#
##################COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
	zenity --error --text="Aquest script s'ha d'executar amb privilegis de l'usuari root"
	exit 1 
fi
##########################################################################################
#
###FORMULARI I ASSIGNACIÓ DE DADES A VARIABLES##############################
mltusr=$(zenity --forms --title="PROGRAMA DE CREACIO AUTOMÀTICA DE MULTIPLES D'USUARIS" --text="Dóna les dades bàsiques dels usuaris a crear" \
        --add-entry="Dóna el nombre d'usuaris que es vol crear"  --add-entry="Dóna un nom base pels usuaris" \
        --add-entry="Dóna el valor inicial de l'UID pels nous usuaris creats")
n_usr=$(echo $mltusr | cut -d '|' -f 1)
nom_base=$(echo $mltusr | cut -d '|' -f 2)
uid=$(echo $mltusr | cut -d '|' -f 3)
########CREANT USUARIS I EL FITXER AMB LA LLISTA D'USUARIS, CONTRASENYES I UID######
echo "LLISTA D'USUARIS" > /root/$nom_base
for (( num=1; num<=$n_usr; num++ )) 
do
	ctsnya=$(pwgen 15 1)
	nom_usr=$nom_base$num.fje
	echo "$nom_usr  $ctsnya  $uid" >> /root/$nom_base
	useradd $nom_usr -u $uid -g users -d /home/$nom_usr -m -s /bin/bash -p $(mkpasswd $ctsnya)
	if [[ $? -ne 0 ]]
	then
		echo "Problema creant els usuaris"
		exit 2 # Ho demana l'enunciat
	fi
	(( uid++ )) # Incrementa en 1 el valor d'uid   
done
#############MOSTRANT EL FITXER D'USUARIS, CONTRASENYES I UID#############
zenity title="Fitxer d'usuaris, contrasenyes i uid" --text-info --filename=/root/$nom_base --width 800 --height 800
##########################################################################
exit 0
