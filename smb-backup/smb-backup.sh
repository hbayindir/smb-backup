#!/bin/bash

###############################################################
# SMB Backup - A small tool to backup remote SMB/CIFS shares. #
# Developed by Hakan Bayindir <hakan@bayindir.org>            #
# Licensed GNU/GPLv3                                          #
###############################################################

# Exit on any error, don't make me write my own error handling
set -e

### Configuration Block ###
temporary_mount_point_base='/tmp/temp_mount'
mount_options='ro,guest'
remote_address='your.ip.address.here'
remote_folder='your-remote-folder-name-here'
backup_folder='backups'
rsync_parameters='-aHAX --delete'

# You have to be root to run this script.
if [ `whoami` != 'root' ]
then
    echo 'You must be root to run this script'
    exit 1;
fi

# Append a reandom string to the mount point to prevent collisions.
temporary_mount_point="$temporary_mount_point_base.$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)"

# Try to create $temporary_mount_point.
mkdir -p $temporary_mount_point

# Try to mount the $remote_address/$remote_folder to $temporary_mount_point.
mount.cifs //$remote_address/$remote_folder $temporary_mount_point -o $mount_options

# Check presence of $backup_folder. Create if not present.
mkdir -p $backup_folder

# Check writability of $backup_folder.
touch $backup_folder/test_file
rm -f $backup_folder/test_file

# Run backup with rsync -aHAX --delete <source> <target>
rsync $rsync_parameters $temporary_mount_point/ $backup_folder

# Unmount $temporary_mount_point.
umount $temporary_mount_point

# Delete $temporary_mount_point.
rmdir $temporary_mount_point
