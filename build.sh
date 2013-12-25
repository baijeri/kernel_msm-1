#!/bin/bash

# Stupid shell script to compile kernel, nothing fancy
# Original script from SlimBean Mako kernel

((!$#)) && echo -e "No arguments supplied!\nTry 'config', 'menuconfig' or value of '1-9'" && exit 1


VERSION=`cat .version`
NEWVERSION=$(expr $VERSION + 1)
DEFCONFIG=krnl_defconfig

# Exports all the needed things Arch, SubArch and Cross Compile
export ARCH=arm
echo 'exporting Arch...'
export SUBARCH=arm
echo 'exporting SubArch...'

##GCC 4.8
#export CROSS_COMPILE=/media/dev/android-ndk-r9/toolchains/arm-linux-androideabi-4.8/prebuilt/linux-x86_64/bin/arm-linux-androideabi-

##GCC 4.7
#export CROSS_COMPILE=/media/geek/dev-disk/kernel/toolchains/arm-linux-androideabi-4.7/bin/arm-linux-androideabi-

##Linaro 4.7 2013.04
#export CROSS_COMPILE=/home/geek/dev-disk/kernel/toolchains/gcc-linaro-4.7-2013.04/bin/arm-linux-gnueabihf-

##Linaro 4.8
export CROSS_COMPILE=/home/geek/dev-disk/kernel/toolchains/gcc-linaro-4.8-2013.08/bin/arm-linux-gnueabihf-

echo 'exporting Cross Compile'

# Generates a new .config and exists
if [ "$1" = "config" ] ; then
	echo 'Make defconfig...'
	make $DEFCONFIG
	exit
fi

# Generates a new .config and exists
if [ "$1" = "menuconfig" ] ; then
	echo 'Make defconfig and launch menuconfig...'
	make $DEFCONFIG
	make menuconfig
	cp .config arch/arm/configs/$DEFCONFIG
	exit
fi

#Let's check if $1 is a number
re='^[0-9]+$'
if [[ $1 =~ $re ]] ; then
	# Lets go!
	echo 'Lets go!'

	# Make sure build is clean!
	echo "Remove old zImage..."
	rm -f arch/arm/boot/zImage
	echo 'Cleaning...'
	make clean

	#make -j$1
	make -j$1 V=99 2>&1 |tee r${NEWVERSION}-build.log
else
	echo "Insert proper argument!"
fi
