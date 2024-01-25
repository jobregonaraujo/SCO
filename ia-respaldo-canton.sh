#!/usr/bin/bash

# Variables
root_profile="/var/opt/K/SCO/Unix/6.0.0Ni/.profile"
fiscal=$(which fiscal)
backup_directories=('/u/resta')

# Check for existing directories and add them to the array
for i in {2..10}
do
    dir="/u/caja$i"
    if [ -d "$dir" ]
    then
        backup_directories+=("$dir")
    fi
done

# Disk identifier for backup
backup_disk_id=""

# Mount backup disk
if [[ -z "$backup_disk_id" ]]
then
    read -p "Enter the identifier of the disk to use for backup (e.g., c1b0t0xxxp1s2): " backup_disk_id 
fi

if [ -n "$(ls -A /mnt)" ]
then
    umount /mnt || { echo "Failed to unmount /mnt"; exit 1; }
fi

mount "/dev/dsk/$backup_disk_id" /mnt || { echo "Failed to mount /dev/dsk/$backup_disk_id"; exit 1; }

# Copy and replace directories
for dir in "${backup_directories[@]}"
do
    echo -e "Copying $dir...\n"
    cp -prf "$dir" "/mnt/$dir" || { echo "Failed to copy $dir"; exit 1; }
    echo -e "Successfully copied $dir.\n"
done

# Optional: Transfer root profile and fiscal files
read -p "Do you want to transfer the root profile and fiscal files? (y/N): " transfer_root_fiscal
if [[ "$transfer_root_fiscal" == "y" ]]
then
    echo -e "Transferring root profile...\n"
    cp -pf  "$root_profile" "/mnt$root_profile" || { echo "Failed to copy $root_profile"; exit 1; }
    echo -e "Successfully transferred root profile.\n"

    echo -e "Transferring bin/fiscal...\n"
    cp -pf "$fiscal" "/mnt/usr/bin/" || { echo "Failed to copy $fiscal"; exit 1; }
    for i in {2..8}
    do
        if [[ -e "$fiscal$i" ]]
        then
            cp -pf "$fiscal$i" "/mnt/usr/bin/" || { echo "Failed to copy $fiscal$i"; exit 1; }
        fi
    done
    echo -e "Successfully transferred fiscal files.\n"
fi

# Unmount backup disk
umount /mnt || { echo "Failed to unmount /mnt"; exit 1; }
echo "Backup completed successfully!"
