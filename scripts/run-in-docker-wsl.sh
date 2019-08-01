#!/bin/bash

WORK_DIR=/usr/src/wrk 
#For WSL installs, need to get equiv path relative to windows file system, as docker runs on the host
#If sharing folder via mnt, need to resolve any symlinks and then remove mnt portion of path
#Mount paths with WSL point to a path usually under c, /mnt/c -> C://
MNT_PATH=/mnt
ABS_PWD=$(readlink -f $PWD) #get abs path of PWD
echo "path = $ABS_PWD"
WINDOWS_REL_PATH=`echo ${ABS_PWD#$MNT_PATH}`
echo "path = $WINDOWS_REL_PATH"

if [[ $# -eq 0 ]] ; then
	echo "Use this script to run commands in the specified docker container - the PWD (parent working directory) will be passed as a mount dir @ $WORK_DIR"
	echo "After the commands have been issued, the container will terminate"
	echo "Arguments-"
	echo "0: 		Must provide docker image key (tag assigned when building, or auto generated tag) as first argument"
	echo "1..n:		Passed to the docker image as commands to run inside the docker container"
	echo "If no arguments are passed after the image key, the docker container will be accessed via a persistent tty shell, use 'exit' to break out of the container"
	exit 1
fi

isInDockerGroup() {
	getent group docker | grep &>/dev/null `whoami`
}

isSudo() {
	[ $(id -u) -eq 0 ]
}

if ! isSudo ; then
	if ! isInDockerGroup ; then
		echo "Not member of docker group!"
		echo "Use \"gpasswd -a <user> docker\" to assign user to docker group - or run as sudo" 
		exit 1
	fi
else
	echo "Running as sudo"
	echo "Consider adding user to docker group with \"gpasswd -a <user> docker\""
fi

IMAGE_TAG=$1
shift
DOCKER_ARGUMENTS=$@

echo_and_run() { 
	echo "\$ $@" ; 
	"$@" ; 
}

echo_and_run docker run -it --rm \
	-e WORKING_DIR=$WORK_DIR \
	-v $WINDOWS_REL_PATH:$WORK_DIR \
	-w $WORK_DIR \
	$IMAGE_TAG \
	$DOCKER_ARGUMENTS
