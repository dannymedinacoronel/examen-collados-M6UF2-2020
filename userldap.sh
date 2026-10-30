#!/bin/bash
clear
#######COMPROVANT SI L'ARXIU DE GUIÓ L'EXECUTA L'USUARI ROOT###################
if (( EUID != 0 ))
then
  echo "Aquest script s'ha d'executar amb prilegis de l'usuari root"
  exit 9 # He posat aquest número per assegurar-me que no coincideix amb cap altre valor de retorn
fi
##################RECOLLINT DADES###############################################
echo -n "Indica el nom del nou usuari del domini: "
read nom_uid
echo -n "Indica el nom del domini de nivell superior: "
read dnsup
echo -n "Indica el nom del domini de segon nivell: "
read dsn
echo -n "Indica el nom de l'unitat organitzativa: "
read ou
echo -n "Indica el valor de l'atribut sn: "
read sn
echo -n "Indica el valor de l'atribut cn: "
read cn
echo -n "Indica el valor de l'UID de l'usuari: "
read num_uid
echo -n "Indica el valor del GID del grup per defecte de l'usuari: "
read gid
echo -n "Indica el directori personal de l'usuari: "
read dir
echo -n "Indica el shell per defecte de l'usuari: "
read shell
################CREANT EL FITXER LDIF###################################
echo "dn: uid=$nom_uid,ou=$ou,dc=$dsn,dc=$dnsup" > user.ldif
echo "objectClass: top" >> user.ldif
echo "objectClass: person" >> user.ldif
echo "objectClass: organizationalPerson" >> user.ldif
echo "objectClass: inetOrgPerson" >> user.ldif
echo "objectClass: posixAccount" >> user.ldif
echo "objectClass: shadowAccount" >> user.ldif
echo "uid: $nom_uid" >> user.ldif
echo "cn: $cn" >> user.ldif
echo "sn: $sn" >> user.ldif
echo "uidNumber: $num_uid" >> user.ldif
echo "gidNumber: $gid" >> user.ldif
echo "homeDirectory: $dir" >> user.ldif
echo "loginShell;lang-ca-es: $shell" >> user.ldif
#####################CREANT L'USUARI#######################################
ldapadd -h localhost -x -D "cn=admin,dc=$dsn,dc=$dnsup" -W -f user.ldif
if (( $? != 0 ))
then
	echo "L'USUARI $nom_uid NO HA ESTAT CREAT"
	exit 1
fi	
################MOSTRANT LA BASE DE DADES LDAP#########################
slapcat
########################FINALITZANT###################################
exit 0
