#!/bin/bash
#setting default values
username=$(whoami)
pathToPubicKey=~/.ssh/id_rsa.pub
b_putScript=0
b_addAliases=0
#creates variable
pathToHosts=def

function parseArguments () { 
	b_hasPathToHosts=0  
	#help menu
	usage() { 
		printf "Usage: ./setupSSHKeys.sh -d <path_to_file_with_hosts>"
		printf "\nRequired:"
		printf "\n\t-d path to file containing list of hosts to configure"
		printf "\nOptional:"	
		printf "\n\t-a enable to add alias to .bashrc"
		printf "\n\t-u default value is the result of whoami command"		
		printf "\n\t-k path to public key file. Default value is ~/.ssh/id_rsa.pub"
		printf "\n\t-p put this script to '~/' and set permissions to execute on remote hosts"
		printf "\n\n--------------------------"
		printf "\ngenerating SSH key pair: ssh-keygen -t rsa\n"
		1>&2;
		exit 1; 
	}

	while getopts 'u:d:k:ap' opt "$@"; do
		case $opt in
		a)
			b_addAliases=1
		  ;;
		u)
			username="${OPTARG}"
		  ;;
		d)
			pathToHosts="${OPTARG}"
			b_hasPathToHosts=1
		  ;;
		k)
			pathToPubicKey="${OPTARG}"
		  ;;
		p)
			b_putScript=1			
		  ;;
		\?)
			usage;
			exit 1;
		esac
	done

	if [ $b_hasPathToHosts -ne 0 ] ; then
		echo "--------------------------"
	else
		#fail if option d was not passed
		usage;		
		exit 1
	fi
}

#gets script dir. Allows to call this script both using absolute and relative paths
function get_script_dir () {
     SOURCE="${BASH_SOURCE[0]}"
     # While $SOURCE is a symlink, resolve it
     while [ -h "$SOURCE" ]; do
          DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
          SOURCE="$( readlink "$SOURCE" )"
          # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
          [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
     done
     DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     echo "$DIR"
}


#Reads arguments
parseArguments "$@"
#printing info fields
echo "Username: ${username}"
echo "Path to file with a list hosts: ${pathToHosts}"
echo "path to pubic key: ${pathToPubicKey}"
echo "--------------------------"

scriptFileAbsolutePath="$(get_script_dir)/setupSSHKeys.sh"

#allows to cancel script if printed detaisl are not correct
read -p "Press enter to continue or Ctrl+C to cancel"


#saving public key to variable (so that we could put public key with single ssh call)
pubKey=`cat $pathToPubicKey`
#reads hostsFile
hosts=`cat $pathToHosts`

#splits hosts variable
for host in $(echo $hosts | tr "\r" "\n" )
do
	# copy public key to this host
	echo "processing '$host'"
	cmdCopyPublic="ssh -oStrictHostKeyChecking=no ${username}@${host} 'mkdir -p ~/.ssh && chmod -R 700 ~/.ssh/ &&echo ${pubKey} >> ~/.ssh/authorized_keys'";
	eval $cmdCopyPublic;
	
	#add Alias if option -a was used
	if [ $b_addAliases -ne 0 ] ; then
		sshAlias="alias ${host}=\"ssh ${username}@${host}\""
		echo $sshAlias >> ~/.bashrc
	fi
	
	#copy script if option -p was used
	if [ $b_putScript -ne 0 ] ; then		
		cmdPutScript="scp $scriptFileAbsolutePath ${username}@${host}:~/ && ssh ${username}@${host} 'chmod 774 ~/setupSSHKeys.sh'"
		eval $cmdPutScript		
	fi	
done
