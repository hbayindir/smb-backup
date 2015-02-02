#!/bin/bash

###############################################################
# SMB Backup - A small tool to backup remote SMB/CIFS shares. #
# Developed by Hakan Bayindir <hakan@bayindir.org>            #
# Licensed GNU/GPLv3                                          #
###############################################################

### Configuration Block ###
temporary_mount_point='/tmp/temp_mount'
mount_options='ro,guest'
remote_address='192.168.1.1'
remote_folder='trunk'
backup_folder='backups'

# You have to be root to run this script.
if [ `whoami` != 'root' ]
then
    echo 'You must be root to run this script'
    exit 1;
fi

# TODO: Check presence of $backup_folder. Create if not present.
# TODO: Check writability of $backup_folder.
# TODO: Try to create $temporary_mount_point.
# TODO: Try to mount the $remote_address/$remote_folder to $temporary_mount_point.
# TODO: Run backup with rsync -ahax --delete <source> <target>
# TODO: Unmount $temporary_mount_point.
# TODO: Delete $temporary_mount_point.
