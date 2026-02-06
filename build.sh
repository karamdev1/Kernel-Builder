#!/bin/bash

# Check figlet for gui
if ! command -v figlet >/dev/null 2>&1; then
    sudo apt install -y figlet
fi

# Load config
if [ ! -f config ]; then
    echo "[-] config file not found"
    exit 1
fi

source config

# Compiling parameters and toolchain
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
OUT_DIR=$(eval echo "$OUT_DIR")
KDIR=$(pwd)
DEFCONFIG=$(eval echo "$DEFCONFIG")
SAVEDCONFIG=$(eval echo "$SAVEDCONFIG")

# Colors
BOLDGREEN="\e[1;32m"
BOLDRED="\e[1;31m"
BOLDBLUE="\e[1;96m"
ENDCOLOR="\e[0m"

# Check if theres config
if [ -f "$KDIR/$OUT_DIR/.config" ]; then
    CONFIG_STATUS="${BOLDGREEN}Config present${ENDCOLOR}"
else
    CONFIG_STATUS="${BOLDRED}No .config found${ENDCOLOR}"
fi

function show_gui() {
	clear
	echo -e "\e[1;93m"
	figlet Kernel Builder
	echo -e "\e[0m"
	echo -e "${BOLDGREEN}Creator: ${BOLDRED}karamdev1${ENDCOLOR}"
	echo -e "${BOLDGREEN}Kernel Config: ${CONFIG_STATUS}${ENDCOLOR}"
	echo
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}Compile${BOLDGREEN}---------------------------|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}1${ENDCOLOR}] Compile Kernel                           ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}2${ENDCOLOR}] Compile Module (Doesn't need prepare)    ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}3${ENDCOLOR}] Prepare Module                           ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}Clean${BOLDGREEN}-----------------------------|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}4${ENDCOLOR}] Clean Kernel                             ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}5${ENDCOLOR}] Apply Defconfig (Selection in Config)    ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}6${ENDCOLOR}] Apply Saved Config (Selection in Config) ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}Script${BOLDGREEN}----------------------------|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDRED}E${ENDCOLOR}] Exit Builder                             ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}End${BOLDGREEN}-------------------------------|${ENDCOLOR}"
	echo
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