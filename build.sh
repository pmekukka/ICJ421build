#!/bin/sh
#working directory
RUN=$(pwd)
WORKING_DIRECTORY=$(cat directory)

if [ -d "$WORKING_DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
	echo "========Entering working directory=========="
	echo "cd ${WORKING_DIRECTORY}"
	cd $WORKING_DIRECTORY
else echo "${WORKING_DIRECTORY} doesn't exist!!" 
fi


files=$(ls ${WORKING_DIRECTORY}/.repo 2> /dev/null | wc -l)
if [ "$files" != "0" ]
	#syncing with remote
	then
	echo "========Syncing working directory=========="
	#repo sync -j16
	

	#To check if 'make clean' is to be used or not
	echo
	echo "=========== make clean? ===================="
	MAKE=nothing
	echo "Please type 'yes' or 'no'."
	while read MAKE
	do
	case $MAKE in
		yes)		echo "==========Removing build directory=========="
					make clean 
					break 
					;;
		no)			echo "=============Continuing building============"
					echo
					echo
					break
					;;
		*)			echo "==============Type 'yes' or 'no'============" 
					;;
	esac
	done

	#Using Sun java 6 to build
	echo "=======Sourcing Sun Java6==================="
	source /opt/sun-java6/envsetup.sh
	java -version
	sleep 2

	echo "=============Starting to build=============="
	echo ./vendor/aokp/build.sh

	else
	echo "Not a repo folder. Typo?"
	cd $RUN
	echo /enter/working/directory/path/here > directory
fi