#! /usr/bin/bash
#script to get local ip
ip=$(ifconfig net0 | grep inet | head -1 | cut -c7-20)
echo -e "La direccion IP configurada actualmente en el equipo servidor es $ip\n"

