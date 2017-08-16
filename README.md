## Set up passwordless ssh/scp

The purpose of this project is to provide easy way to set up password less connection to remote hosts

#### features
* copying RSA public key to authorized hosts on remote hosts.
* add alias in following format `alias="ssh username@hostname"` to `~/.bashrc`.

#### prerequisites
* `bash`
* `ssh`
* `ssh-keygen`
* generated RSA keys (ssh-keygen -t rsa)

#### assumptions
* This script does not use any fancy tools like bash "expect" module. This means that it could be used even from windows OS with  `git bash` tool.
* Because of limitation of the shell. We will have to type/paste our password for each host.

### Usage:

   `./setupSSHKeys.sh -u <username> -d <path_to_file_with_hosts> -k <path_to_public_rsa_key>`

        -a default value '1'. Set to 0 if you dont want to add alias
        -u username. Default = result of whoami command
        -d path to file containing list of hosts to configure (Required)
        -k path to public key file. Default value is ~/.ssh/id_rsa.pub
