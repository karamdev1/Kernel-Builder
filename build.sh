#!/bin/bash

# Check figlet for gui
if ! command -v figlet >/dev/null 2>&1; then
    sudo apt install -y figlet
fi

# Load config
if [ ! -f config ]; then
    echo "\e[1;31m[-] config file not found\e[0m"
    exit 1
fi

source config

# Compiling parameters and toolchain
export ARCH=$(eval echo $ARCH)
export CC=$(eval echo $CC)
export LD=$(eval echo $LD)
export OBJCOPY=$(eval echo $OBJCOPY)
export AS=$(eval echo $AS)
export NM=$(eval echo $NM)
export STRIP=$(eval echo $STRIP)
export OBJDUMP=$(eval echo $OBJDUMP)
export READELF=$(eval echo $READELF)
export CROSS_COMPILE=$(eval echo $CROSS_COMPILE)
export CROSS_COMPILE_ARM32=$(eval echo $CROSS_COMPILE_ARM32)
OUT_DIR=$(eval echo $OUT_DIR)
DEFCONFIG=$(eval echo $DEFCONFIG)
SAVEDCONFIG=$(eval echo $SAVEDCONFIG)
export KCFLAGS=' -w -pipe -O3'
export ANDROID_MAJOR_VERSION=r
export KCPPFLAGS=' -O3'
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

# Colors
BOLDGREEN="\e[1;32m"
BOLDRED="\e[1;31m"
BOLDBLUE="\e[1;96m"
ENDCOLOR="\e[0m"

# Check if theres config
if [ -f "$(pwd)/$OUT_DIR/.config" ]; then
    CONFIG_STATUS="${BOLDGREEN}Config present${ENDCOLOR}"
else
    CONFIG_STATUS="${BOLDRED}No .config found${ENDCOLOR}"
fi

# Show gui
function show_gui() {
	clear
	echo -e "\e[1;93m"
	figlet Kernel Builder
	echo -e "\e[0m"
	echo -e "${BOLDGREEN}Creator: ${BOLDRED}karamdev1${ENDCOLOR}"
	echo -e "${BOLDGREEN}Kernel Config: ${CONFIG_STATUS}${ENDCOLOR}"
	echo
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}Kernel${BOLDGREEN}----------------------------|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}1${ENDCOLOR}] Compile Kernel                           ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}2${ENDCOLOR}] Compile Module (Doesn't need prepare)    ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}3${ENDCOLOR}] Prepare Module                           ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}4${ENDCOLOR}] Clean Kernel (Clean & Mrproper)          ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}5${ENDCOLOR}] Apply Defconfig (Selection in Config)    ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}6${ENDCOLOR}] Apply Saved Config (Selection in Config) ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}7${ENDCOLOR}] Edit Config (MENUCONFIG)                 ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}8${ENDCOLOR}] Edit Config (NCONFIG)                    ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}Script${BOLDGREEN}----------------------------|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDRED}E${ENDCOLOR}] Exit Builder                             ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}G${ENDCOLOR}] Open the creator's github page           ${BOLDGREEN}|${ENDCOLOR}"
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}End${BOLDGREEN}-------------------------------|${ENDCOLOR}"
	echo
}

# Show message success or failed based on exit code
function check_exit_code() {
	local ret=$?
	if [ $ret -eq 0 ]; then
		echo -e "${BOLDGREEN}[+] Success${ENDCOLOR}"
	else
		echo -e "${BOLDRED}[-] Failed (exit code: $ret)${ENDCOLOR}"
	fi
}

while true; do
	show_gui
	read -p "Enter the action: " action

	case $action in
		1)
			echo building
			;;
		2)
			echo editing_config
			;;
		4)
			echo -e "${BOLDGREEN}[+] Cleaning${ENDCOLOR}"
			make -s -C "$(pwd)" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y clean -j"$(nproc)" && make -s -C "$(pwd)" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y mrproper -j"$(nproc)"
			check_exit_code
			;;
		E)
			echo -e "${BOLDRED}[!] Exiting!!${ENDCOLOR}"
			break
			;;
		G)
			echo -e "${BOLDGREEN}[+] Opening the creator's github page${ENDCOLOR}"
			xdg-open https://github.com/karamdev1 > /dev/null 2>&1 &
			;;
		*)
			echo -e "${BOLDRED}[!] Invalid Action!!${ENDCOLOR}"
			;;
	esac
	read -p "Press Enter to continue..."
done