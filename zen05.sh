#!/bin/bash
MM_DIR=$(zenity --file-selection --filename=$HOME --directory --title="Selecciona la carpeta a on has desat les teves cançons" --width 500)
#
# Canvio al directori dels fitxers multimèdia, i el resultat de ls ho envia a zenity perquè ho mostri gràficament
opc=$(cd "$MM_DIR";ls *.flv | zenity --width 500 --height 500 --list --column="Llista de cançons")
#
# Si no trobes fitxers .flv ho pots provar amb mp4. Comenta la línia 5 i descomenta la 8
#opc=$(cd "$MM_DIR";ls *.mp4 | zenity --width 500 --height 500 --list --column="Llista de cançons")
#
vol=$(zenity --scale --min-value=0 --max-value=500 --title "Escull volum")
vlc "$MM_DIR/$opc" --volume $vol
exit 0
