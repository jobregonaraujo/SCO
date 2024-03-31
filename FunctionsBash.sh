collectcajas () {
    cajas=('resta')
    #Revisamos y agregamos las carpetas de caja* existentes en /u y las agregamos al array
    for i in {2..10}
    do

        if [ -d "/u/caja$i" ]
        then
            cajas+=("caja$i")
        fi
    done
}

rootfiscal () {
    read -t 10 -p "Deseas transferir el profile del root y los archivos fiscal* (y/N): " rootfiscal
    if [[ "$rootfiscal" == "y" ]]
    then
        echo -e "Transfiriendo root profile ...\n"
        cp -pf  "$rootprofile" "/mnt$rootprofile"  || { echo "Error copiando  $rootprofile"; exit 1; }
        echo -e "Root Profile transferido correctamente.\n"
        echo -e "Transfiriendo bin/fiscal...\n"
        cp -pf "$fiscal" "/mnt/usr/bin/" || { echo "Error copiando  $fiscal"; exit 1; }
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
}
