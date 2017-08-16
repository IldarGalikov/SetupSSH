## Set up passwordless ssh/scp

The purpose of this project is to provide easy way to set up password less connection to remote hosts

#### features
* copying RSA public key to authorized hosts on remote hosts.
* add alias in following format `alias="ssh username@hostname"` to `~/.bashrc`.

#### prerequisites
* Any environment with `bash` shell and `ssh` tool.

#### assumptions
* This script does not use any fancy tools like bash "expect" module. This means that it could be used even from windows OS with  `git bash` tool.
* Because of limitation of the shell. We will have to type/paste our password for each host.

