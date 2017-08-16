#!/usr/bin/env bash

username=$(whoami)
#password=def
pathToHosts=def
pathToPKey=~/.ssh/id_rsa.pub
b_addAliases=1
read_from_pipe() { read "$@" <&0; }

function parseArguments () {
 
  b_hasPathToHosts=0

  
  #help menu
  usage() { 
	printf "Usage: ./setupSSHKeys.sh -u <username> -d <path_to_file_with_hosts> -k <path_to_public_rsa_key>" 
	printf "\n\t-a default value '1'. Set to 0 if you dont want to add alias"
	printf "\n\t-u default value is the result of whoami command"
	printf "\n\t-d (Required) path to file containing list of hosts to configure"
	printf "\n\t-k path to public key file. Default value is ~/.ssh/id_rsa.pub"
	printf "\n\n--------------------------"
	printf "\ngenerating SSH key pair: ssh-keygen -t rsa"
	
	
	1>&2; 
	
	exit 1; }

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
    usage;
    exit 1
  fi
}



#Quotes required to avoid removing characters in $IFS from arguments
parseArguments "$@"
echo "Username: ${username}"
echo "PathToHosts: ${pathToHosts}"
echo "pathToPKey: ${pathToPKey}"
echo "--------------------------"

#saving public key to variable (so that we could put public key with single ssh call) 
pubKey=`cat $pathToPKey`
#reads hostsFile
hosts=`cat $pathToHosts`

#splits hosts variable
for x in $(echo $hosts | tr ";" "\n")
do
	# process
	echo "processing $x"
	cmdCopyPublic="ssh -oStrictHostKeyChecking=no ${username}@${x} 'mkdir -p ~/.ssh && echo ${pubKey} >> ~/.ssh/authorized_keys'";
	#echo $cmdCopyPublic;
	eval $cmdCopyPublic;
	
	#set 
	if [ $b_addAliases -ne 0 ] ; then		
		sshAlias="alias ${x}=\"ssh ${username}@${x}\""
		echo $sshAlias >> ~/.bashrc
	fi
	

done






