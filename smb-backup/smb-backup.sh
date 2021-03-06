#!/bin/bash

# SMB Backup - A small tool to backup remote SMB/CIFS shares.
# Copyright (C) 2015  Hakan Bayindir <hakan@bayindir.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


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

# Check whether we own the backups folder or not.
if [ `whoami` != `stat -c %U $backup_folder` ]
then
    echo "Error: Owner of folder $backup_folder is" `stat -c %U $backup_folder` "and different from" `whoami`", exiting."
    umount $temporary_mount_point
    rmdir $temporary_mount_point
    exit 1
fi

# Check writability of $backup_folder.
folder_permissions=$(stat -c %a $backup_folder)
if [ ${folder_permissions:0:1} != 7 ]
then
    # If the permissions is not the way we want, construct a human readable error message.
    # recycle the variables in the process.
    folder_permissions=$(stat -c %A $backup_folder)
    folder_permissions=${folder_permissions:1:3}

    echo "Folder $backup_folder permissions for owner ("`stat -c %U $backup_folder`") is '$folder_permissions', not 'rwx', exiting."
    umount $temporary_mount_point
    rmdir $temporary_mount_point
    exit 1
fi

# Run backup with rsync -aHAX --delete <source> <target>
rsync $rsync_parameters $temporary_mount_point/ $backup_folder

# Unmount $temporary_mount_point.
umount $temporary_mount_point

# Delete $temporary_mount_point.
rmdir $temporary_mount_point
