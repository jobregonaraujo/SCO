#! /usr/bin/bash
#vars
day=$(date +"%d")
now=$(date +"%d-%m-%Y")
dob="26"
rootprofile="/var/opt/K/SCO/Unix/6.0.0Ni/.profile"
cajas=('resta')
#Revisamos y agregamos las carpetas de caja* existentes en /u y las agregamos al array
for i in {2..10}
do

    if [ -d "/u/caja$i" ]
    then
        cajas+=("caja$i")
    fi
done
#Aqui puedes colocar el identificador del dispositivo para automatizar el script por completo
discorespaldo=""

# Montar Disco Duro de Respaldo 
#Chequeamos si ya tenemos el identicador del disco de respaldo , si no lo tenemos procedemos a pedirlo al usuario 
if [[ -z "$discorespaldo" ]]
then
#unset $discorespaldo
getlclfsdev #Listado de dispositivos de alamacenamiento
echo -e "Arriba se ven los dispositivos conectados\n"
read -p "Escribe el identificador del disco que deseas utilizar como espejo o respaldo eg(c1b0t0xxxp1s2) es el que pone vxfs al lado: " discorespaldo 
fi
#Chequeamos si exiten archivos o carpetas en /mnt si hay algo se procede a desmontar
if [ -n "$(ls -A /mnt)" ]
then
umount /mnt || { echo "Error desmontando /mnt prueba borrando el contenido de /mnt/* y prueba de nuevo"; exit 1; }
fi
#Montando disco de respaldo con el identificador indicado anteriormente
mount "/dev/dsk/$discorespaldo" /mnt || { echo "Error al montar /dev/dsk/$discorespaldo"; exit 1; }
if [[ ! -d "/mnt/u" ]] ; then echo -e "Es probable que $discorespaldo no sea el identificador correcto"; exit 1; fi 
# copiar y remplazar cajas
for caja in "${cajas[@]}"
do
    echo -e "Estamos tranfiriendo $caja al disco de respaldo , no tques nada hasta que terminemos , por favor!!...\n\n"
    cp -prf "/u/$caja" "/mnt/u/" || { echo "Error copiando  $caja"; exit 1; }
    echo -e "Terminamos de copiar $caja de manera correcta...\n\n"
done
## Verificar el dia y realizar un backup en ZIP 
if [ "$(ls -1 "/u/" | grep '\.zip$' | wc -l)" -gt 0 ] && [ "$day" == $dob ]
then
find /u/ -level 0 -name "*.zip" -exec rm -f {} \; 
fi
for caja in "${cajas[@]}"
do
    if [[ "$day" == $dob ]] # Chequeando el dia para hacer respaldo en zip comprimido si corresponde
        then
            if [[ -f "/u/$caja-$now.zip" ]]
                then
                echo "Ya se realizo un respaldo del dia $now "
                else
                echo -e "Hoy es $dob asi que procedemos a realizar un respaldo del mes en zip de $caja \n"
                zip -rq "/u/$caja-$now.zip" "/u/$caja" || { echo "Error comprimiendo  $caja"; exit 1; }
            fi
    fi
done
###
###Opcional todavia no esta listo! Debug en progreso
read -t 200 -p "Deseas transferir el profile del root y los archivos fiscal* (y/N): " rootfiscal
if [[ "$rootfiscal" == "y" ]]
then
    echo -e "Transfiriendo root profile ...\n"
    cp -pf  "$rootprofile" "/mnt$rootprofile"  || { echo "Error copiando  $rootprofile"; exit 1; }
    echo -e "Root Profile transferido correctamente.\n"
    echo -e "Transfiriendo bin/fiscal...\n"
#    cp -pf "$fiscal" "/mnt/usr/bin/" || { echo "Error copiando  $fiscal"; exit 1; }
    if [[ -f "/usr/bin/fiscal" ]]
    then
        cp -pf "/usr/bin/fiscal" "/mnt/usr/bin/" || { echo "Error Copiando el archivo fiscal"; exit 1; }
    fi
    for i in {2..8}
    do
        if [[ -f "/usr/bin/fiscal$i" ]]
        then
            cp -pf "/usr/bin/fiscal$i" "/mnt/usr/bin/"  || { echo "Error copiando  fiscal$i"; exit 1; }
        fi
    done
    echo -e "Transferido Correctamente Profile y fiscal\n"
else
    echo -e "No se realizo el backup del profile o de los archivos bin/fiscal*\n"
fi
#####
# Desmontar Disco Duro de Respaldo
echo -e "Desmontando unidad de Respaldo\n"
umount /mnt
echo "Listo!!"