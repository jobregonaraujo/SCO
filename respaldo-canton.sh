#! /usr/bin/bash
#vars
rootprofile="/var/opt/K/SCO/Unix/6.0.0Ni/.profile"
cajas=('/u/resta')
#Revisamos y agregamos las carpetas de caja* existentes en /u y las agregamos al array
for i in {2..10}
do

    if [ -d "/u/caja$i" ]
    then
        cajas+=("/u/caja$i")
    fi
done
#Aqui puedes colocar el identificador del dispositivo para automatizar el script por completo
discorespaldo=""

# Montar Disco Duro de Respaldo 
#Chequeamos si ya tenemos el identicador del disco de respaldo , si no lo tenemos procedemos a pedirlo al usuario 
if [[ -z "$discorespaldo" ]]
then
#unset $discorespaldo
getlclfsdev
read -p "Escribe el identificador del disco que deseas utilizar como espejo o respaldo eg(c1b0t0xxxp1s2) es el que pone vxfs al lado: " discorespaldo 
fi

if [ -n "$(ls -A /mnt)" ]
then
umount /mnt || { echo "Error desmontando /mnt"; exit 1; }
fi

mount "/dev/dsk/$discorespaldo" /mnt || { echo "Error al montar /dev/dsk/$discorespaldo"; exit 1; }

# copiar y remplazar cajas
for caja in "${cajas[@]}"
do
    echo -e "Estamos trabajando , no tques nada hasta que terminemos , por favor!!\n\n"
    cp -prf $caja "/mnt/u/" || { echo "Error copiando  $dir"; exit 1; }
    echo -e "Terminamos de copiar $caja de manera correcta...\n\n"
done
###
###Opcional todavia no se si va a ir aqui
read -p "Deseas transferir el profile del root y los archivos fiscal* (y/N): " rootfiscal
if [[ "$rootfiscal" == "y" ]]
then
    echo -e "Transfiriendo root profile ...\n"
    cp -pf  "$rootprofile" "/mnt$rootprofile"  || { echo "Error copiando  $rootprofile"; exit 1; }
    echo -e "Root Profile transferido correctamente.\n"
    echo -e "Transfiriendo bin/fiscal...\n"
    cp -pf "$fiscal" "/mnt/usr/bin/" || { echo "Error copiando  $fiscal"; exit 1; }
    for i in {2..8}
    do
        if [[ -e "/usr/bin/fiscal$i" ]]
        then
            cp -pf "/usr/bun/fiscal$i" "/mnt/usr/bin/"  || { echo "Error copiando  fiscal$i"; exit 1; }
        fi
    done
    echo -e "Transferido Correctamente Profile y fiscal\n"
fi
#####
# Desmontar Disco Duro de Respaldo
umount /mnt
echo "Listo!!"