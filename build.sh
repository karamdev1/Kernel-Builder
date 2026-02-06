#!/bin/bash

# Check figlet for gui
FIGLET_STATUS=$(which figlet)
if [ ! $FIGLET_STATUS]; then
	sudo apt install figlet
fi

# Load config
if [ ! -f config ]; then
    echo "[-] config file not found"
    exit 1
fi

source config

export ANDROID_MAJOR_VERSION=r
ARCH=$(eval echo $ARCH)
CC=$(eval echo $CC)
LD=$(eval echo $LD)
OBJCOPY=$(eval echo $OBJCOPY)
AS=$(eval echo $AS)
NM=$(eval echo $NM)
STRIP=$(eval echo $STRIP)
OBJDUMP=$(eval echo $OBJDUMP)
READELF=$(eval echo $READELF)
CROSS_COMPILE=$(eval echo $CROSS_COMPILE)
CROSS_COMPILE_ARM32=$(eval echo $CROSS_COMPILE_ARM32)
KCFLAGS=' -w -pipe -O3'

# Colors
BOLDGREEN="\e[1;32m"
BOLDRED="\e[1;31m"
BOLDCYAN="\e[1;36m"
ENDCOLOR="\e[0m"

function show_gui() {
	clear
	echo -e "\e[1;93m"
	figlet Kernel Builder
	echo -e "\e[0m"
	echo -e "${BOLDGREEN}Creator: ${BOLDRED}karamdev1${ENDCOLOR}"
	echo
	echo -e "${BOLDGREEN}|---------------${ENDCOLOR}Compile${BOLDGREEN}---------------|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDCYAN}1${ENDCOLOR}] Compile Kernel           ${BOLDGREEN}|${ENDCOLOR}"
}

while true; do
	show_gui
	read action

	case $action in
		1)
			echo building
			;;
		2)
			echo editing_config
			;;
		3)
			echo cleaning
			;;
		E)
			echo -e "${BOLDRED}[!] Exiting!!${ENDCOLOR}"
			break
			;;
		*)
			echo -e "${BOLDRED}[!] Invalid Action!!${ENDCOLOR}"
			read -p temp "Press Enter to Continue"
			;;
	esac
done