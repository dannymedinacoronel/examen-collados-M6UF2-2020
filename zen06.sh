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
###CÒPIA DE SEGURETAT DE /etc/dhcp/dhcpd.conf
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.$(date +20%y%m%d%H%M)
###AVÍS###########
zenity --question --text "Has afegit al fitxer /etc/default/isc-dhcp-server el nom de la teva interfície al paràmetre INTERFACESv4?"
if (( $? != 0 ))
then
	zenity --error --text="Primer heu de modificar /etc/default/isc-dhcp abans de poder executar aquest script" --width=400
	exit 2 # Finalització del script si no s'ha cponfigurat INTERFACESv4. He escollit sortir amb un codi de retorn igual a 2
fi
###FORMULARI I ASSIGNACIÓ DE DADES A VARIABLES
dhcp=$(zenity --forms --title="Configuració DHCP" --text="Dóna les dades de la configuració del servidor DHCP" \
        --add-entry="Nom del domini"  --add-entry="IP del servidor DNS primari" --add-entry="IP del servidor DNS secundari" \
        --add-entry="IP del Router" --add-entry="Temps de leasing per defecte" --add-entry="Temps de leasing màxim" \
        --add-entry="IP de la subxarxa" --add-entry="Màscara de la subxarxa" --add-entry="Primera adreça IP assignable" \
         --add-entry="Última adreça IP assignable")
DOM=$(echo $dhcp | cut -d '|' -f 1)
DOM=\"$DOM\"
DNS1=$(echo $dhcp | cut -d '|' -f 2)
DNS2=$(echo $dhcp | cut -d '|' -f 3)
GW=$(echo $dhcp | cut -d '|' -f 4)
TEMP_LEAS_DEF=$(echo $dhcp | cut -d '|' -f 5)
TEMP_LEAS_MAX=$(echo $dhcp | cut -d '|' -f 6)
IPSUBX=$(echo $dhcp | cut -d '|' -f 7)
MASC=$(echo $dhcp | cut -d '|' -f 8)
IP1=$(echo $dhcp | cut -d '|' -f 9)
IP2=$(echo $dhcp | cut -d '|' -f 10)
###CONFIGURACIÓ
echo "authoritative;" > /etc/dhcp/dhcpd.conf
echo "ddns-update-style none;" >> /etc/dhcp/dhcpd.conf
echo "option domain-name $DOM;" >> /etc/dhcp/dhcpd.conf
echo "option domain-name-servers $DNS1, $DNS2;" >> /etc/dhcp/dhcpd.conf
echo "option routers $GW;" >> /etc/dhcp/dhcpd.conf
echo "default-lease-time $TEMP_LEAS_DEF;" >> /etc/dhcp/dhcpd.conf
echo "max-lease-time $TEMP_LEAS_MAX;" >> /etc/dhcp/dhcpd.conf
echo "subnet $IPSUBX netmask $MASC {" >> /etc/dhcp/dhcpd.conf
echo "  range $IP1 $IP2;" >> /etc/dhcp/dhcpd.conf
echo "}" >> /etc/dhcp/dhcpd.conf
###REINICI DEL SERVIDOR
systemctl restart isc-dhcp-server
#FINALITZACIÓ AMB CODI DE RETORN 0
exit 0
