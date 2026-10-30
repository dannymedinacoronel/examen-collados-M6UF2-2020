#!/bin/bash
#
######FUNCIONS#############

function crgrup {
	clear
	echo "CREACIO DE GRUPS D'USUARIS"
	echo
	echo "Dona el nom del nou grup d'usuaris:"
	read nom_grup
	echo "Dona el GID del nou grup d'usuaris: "
	read gid 
	groupadd -g $gid $nom_grup > /dev/null 2>&1 # Redireccionem els missatges informatius i d'error de l'ordre groupadd a /dev/null 
	if [ $? -ne 0 ]
	then
		echo "No s'ha pogut crear el grup"
	fi
	return 0
}

function afegrup {
	clear
	echo "Dona el nom de l'usuari:"
	read nom_usuari
	echo "Indica el grup al qual s'ha d'afegir l'usuari:"
	read nom_grup
	gpasswd -a $nom_usuari $nom_grup > /dev/null 2>&1 # Redireccionem els missatges informatius i d'error de l'ordre gpasswd a /dev/null 
	if [ $? -ne 0 ]
	then
		echo "No s'ha pogut afegir l'usuari al grup demanat"
	fi
	return 0
}

function esbgrup {
	clear
	echo "Dona el nom de l'usuari:"
	read nom_usuari
	echo "Indica el grup al qual s'ha d'afegir l'usuari:"
	read nom_grup
	gpasswd -d $nom_usuari $nom_grup > /dev/null 2>&1  # Redireccionem els missatges informatius i d'error de l'ordre gpasswd a /dev/null 
	if [ $? -ne 0 ]
	then
		echo "No s'ha pogut esborrar l'usuari del grup demanat"
	fi
	return 0
}

function menu {
	clear
	echo "OPCIONS  A ESCOLLIR:"
	echo "a) Crea un grup"
	echo "b) Afegeix un usuari a un grup"
	echo "c) Treu un usuari d'un grup"
	echo -n "Selecciona una opció: "
	read opc
	case $opc in
		a) crgrup;;
		b) afegrup;;
		c) esbgrup;;
		*) echo "Opció incorrecta";;
	esac	
	return 0
}
####PROGRAMA PRINCIPAL#########
#
# COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 1  # Finalització del script si l'usuari que l'executa no té privilegis de root. L'enunciat no diu res i he escollit sortir amb un codi de retorn igual a 1
fi
# CRIDANT A FUNCIONS
cont='s'
while [ $cont == 's' ]
do
	menu
	echo 
	echo -n "Vols continuar (s/n): "
	read cont
done
#SORTINT AMB UN CODI DE RETORN IGUAL A 5
exit 5
