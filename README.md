# smb-backup
A small tool to backup remote windows shares over cifs using rsync.

## Why?
My router's shared storage has crashed, causing data loss. To prevent further damage, I've developed this small script, and thought that sharing it would be fun.

## How to use
In the beginning of the script, there is a configuration block. Set the remote IP and the share name, also set the local backup folder, mount options and rsync parameters to your taste. Run the script as root and have fun!

All pull requests and forks are very welcome. Thanks for taking a look!

## Changelog
### Version 1.1
- Detect writability of the backups folder in a better way using stat and by checking owner and permissions of the folder. 
