## Set up passwordless ssh/scp

The purpose of this project is to provide easy way to set up password less connection to remote hosts

#### features
* copying RSA public key to authorized hosts on remote hosts.
* add alias in following format `alias="ssh username@hostname"` to `~/.bashrc`.

#### prerequisites
* `bash`
* `ssh`
* `ssh-keygen`
* generated RSA keys by `ssh-keygen -t rsa`

#### assumptions
* This script does not use any fancy tools like bash "expect" module. This means that it could be used even from windows OS with  `git bash` tool.
* Because of limitation of the shell. We will have to type/paste our password for each host.

### Usage:

   Usage: `./setupSSHKeys.sh -d <path_to_file_with_hosts>`

        
        Required:
                -d path to file containing list of hosts to configure
        Optional:
                -a enable to add alias to .bashrc
                -u default value is the result of whoami command
                -k path to public key file. Default value is ~/.ssh/id_rsa.pub
                -p put this script to '~/' and set permissions to execute on remote hosts

### Hints
* Instead of typing password each time, I'd recommend to copy it once and paste it for each host.
