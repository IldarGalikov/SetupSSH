#!/usr/bin/env bash
#setting default values
username=$(whoami)
pathToPKey=~/.ssh/id_rsa.pub
b_addAliases=1
#creates variable
pathToHosts=def

function parseArguments () { 
	b_hasPathToHosts=0  
	#help menu
	usage() { 
		printf "Usage: ./setupSSHKeys.sh -u <username> -d <path_to_file_with_hosts> -k <path_to_public_rsa_key>" 
		printf "\n\t-a default value '1'. Set to 0 if you don not want to add alias"
		printf "\n\t-u default value is the result of whoami command"
		printf "\n\t-d (Required) path to file containing list of hosts to configure"
		printf "\n\t-k path to public key file. Default value is ~/.ssh/id_rsa.pub"
		printf "\n\n--------------------------"
		printf "\ngenerating SSH key pair: ssh-keygen -t rsa"
		1>&2;
		exit 1; 
	}

	while getopts 'u:d:k:a:' opt "$@"; do
		case $opt in
		a)
			b_addAliases="${OPTARG}"
		  ;;
		u)
			username="${OPTARG}"
		  ;;
		d)
			pathToHosts="${OPTARG}"
			b_hasPathToHosts=1
		  ;;
		k)
			pathToPKey="${OPTARG}"
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

#Reads arguments
parseArguments "$@"

#printing info fields
echo "Username: ${username}"
echo "PathToHosts: ${pathToHosts}"
echo "pathToPKey: ${pathToPKey}"
echo "--------------------------"

#allows to cancel script if printed detaisl are not correct
read -p "Press enter to continue or Ctrl+C to cancel"

#saving public key to variable (so that we could put public key with single ssh call)
pubKey=`cat $pathToPKey`
#reads hostsFile
hosts=`cat $pathToHosts`

#splits hosts variable
for host in $(echo $hosts | tr ";" "\n")
do
	# copy public key to this host
	echo "processing $host"
	cmdCopyPublic="ssh -oStrictHostKeyChecking=no ${username}@${host} 'mkdir -p ~/.ssh && echo ${pubKey} >> ~/.ssh/authorized_keys'";
	eval $cmdCopyPublic;

	
	#set Alias for this host if option is not disabled
	if [ $b_addAliases -ne 0 ] ; then
		sshAlias="alias ${host}=\"ssh ${username}@${host}\""
		echo $sshAlias >> ~/.bashrc
	fi
done
