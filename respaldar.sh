#! /usr/bin/bash
now=$(date +"%d-%m-%Y")
zip -r "/backups/resta-$now.zip" /u/resta
zip -r "/backups/caja2-$now.zip" /u/caja2
zip -r "/backups/caja3-$now.zip" /u/caja3
zip "/backups/fiscalbin-$now.zip" /usr/bin/fiscal*
zip "/backups/rootprofile-$now.zip" /var/opt/K/SCO/Unix/6.0.0Ni/.profile
echo "Listo"
