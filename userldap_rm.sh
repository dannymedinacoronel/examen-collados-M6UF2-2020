#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
##################RECOLLINT DADES###############################################
echo "PROGRAMA PER ESBORRAR UNA USUARI CREAT AMB userldap.sh O MANUALMENT" 
echo
echo -n "Indica el nom del nou usuari del domini: "
read nom_uid
echo -n "Indica el nom del domini de nivell superior: "
read dns
echo -n "Indica el nom del domini de segon nivell: "
read dsn
echo -n "Indica el nom de l'unitat organitzativa: "
read ou
###############ESBORRANT L'USUARI I EL FITXER LDIF######################
ldapdelete -h localhost -x -D "cn=admin,dc=$dsn,dc=$dns" -W "uid=$nom_uid,ou=$ou,dc=$dsn,dc=$dns"
if (( $? != 0 ))
then
	echo "L'USUARI $nom_uid NO HA ESTAT ESBORRAT"
	exit 1
fi
rm user.ldif
################MOSTRANT LA BASE DE DADES LDAP#########################
slapcat
########################FINALITZANT###################################
exit 0
