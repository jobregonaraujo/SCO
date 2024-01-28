#! /usr/bin/bash
#optener IP publica
publicip=$(curl icanhazip.com)
echo -e "La direccion IP publica a travez de la cuel se comunica este equipo con internet es $publicip"
