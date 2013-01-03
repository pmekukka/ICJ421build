#!/bin/sh
#edit working directory
echo "========Entering working directory=========="
echo "cd /home/pmekukka/das_kovalevy/ICJ421/"
cd /home/pmekukka/das_kovalevy/ICJ421/
sleep 1

#syncing with remote
#echo "========Syncing working directory=========="
#repo sync -j16

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
cd /home/pmekukka/das_kovalevy/ICJ421/
sleep 2

#To check if 'make clean' is to be used or not
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

#echo Starting to build
#./vendor/aokp/build.sh
echo $MAKE