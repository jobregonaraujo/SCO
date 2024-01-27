#! /usr/bin/bash
#vars
now=$(date +"%d-%m-%Y")
day=$(date +"%d")
crespaldo="/backups"
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

#Chequeamos si existe la carpeta de respaldo 
if [[ ! -d "$crespaldo" ]]
then
    echo -e "Creando la carpeta para respaldos en $crespaldo...\n"
    mkdir /backups || { echo "Error creando la carpeta de respaldo $crespaldo "; exit 1; }
fi
#Creamos los respaldos de las carpetas de usuarios en la carpeta de respaldo
for caja in "${cajas[@]}"
do
zip -rq "$crespaldo/$caja-$now.zip" /u/$caja || { echo "Error comprimiendo  $caja"; exit 1; }
done
## Opcional respaldar fiscal y rootprofile
read -p "Deseas respaldar el profile del root y los archivos fiscal* (y/N): " rootfiscal
if [[ "$rootfiscal" == "y" ]]
then
    echo -e "comprimiendo root profile ...\n"
    zip -rq "$crespaldo/root-profile-$now.zip" "$rootprofile"  || { echo "Error comprimiendo  $rootprofile"; exit 1; }
    echo -e "Root Profile respaldado correctamente.\ncomprimiendo bin/fiscal...\n"
    zip -q "$crespaldo/fiscalbin-$now.zip" /usr/bin/fiscal*
fi
echo -e "Listo!\n"