#!/bin/sh
#working directory
touch directory
WORKING_DIRECTORY=$(cat directory)
if [[ $(wc -c directory) = "0 directory" ]]; then
	echo null > directory
	WORKING_DIRECTORY=$(cat directory)
else
	while [[ $WORKING_DIRECTORY == "null" ]]; do
	case $WORKING_DIRECTORY in
		null)
			echo "Please enter the whole working directory.. ${WORKING_DIRECTORY}"
			read WORKING_DIRECTORY
			echo ${WORKING_DIRECTORY} > directory
			echo "Working directory is now set at ${WORKING_DIRECTORY}"
			;;
		*)	break
			;;
	esac
	done
fi
if [ -d "$WORKING_DIRECTORY" ]; then
    # Control will enter here if $DIRECTORY exists.
	echo "========Entering working directory=========="
	echo "cd ${WORKING_DIRECTORY}"
	cd $WORKING_DIRECTORY
else echo "${WORKING_DIRECTORY} doesn't exist!!" 
fi

#syncing with remote
files=$(ls ${WORKING_DIRECTORY}/.repo 2> /dev/null | wc -l)
if [ "$files" != "0" ]
	then
	echo "========Syncing working directory=========="
	repo sync -j16
	#Android doesn't build using python3
	echo "=========Checking python version============"
	WHATPYTHON=$(ls -l /usr/bin/python | cut -d ">" -f2)

	if [ $WHATPYTHON == python3 ]; then
        echo "Changing python symlnk"
        cd /usr/bin/
        sudo rm python
        sudo ln -s python2 python
        echo "Python2 symlnk for python created"
        echo "Ready to build for android"
	elif [ $WHATPYTHON == python2 ]; then
        echo "Python is ready to build android"
	else
        echo "Python2 nor python3 is symlnk for python"
	fi
	cd $WORKING_DIRECTORY
	sleep 2

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
	rm ./out/target/product/endeavoru/system/build.prop
	./vendor/aokp/build.sh

	else
	echo "Not a repo folder."
	echo null > directory
fi