#!/bin/bash

if ! command -v figlet >/dev/null 2>&1; then
    sudo apt install -y figlet
fi

if [ ! -f config ]; then
    echo "\e[1;31m[-] config file not found\e[0m"
    exit 1
fi

source config

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
KDIR=$(pwd)
DEFCONFIG=$(eval echo $DEFCONFIG)
SAVEDCONFIG=$(eval echo $SAVEDCONFIG)
export KCFLAGS=' -w -pipe -O3'
export ANDROID_MAJOR_VERSION=r
export KCPPFLAGS=' -O3'
export CONFIG_SECTION_MISMATCH_WARN_ONLY=y

BOLDGREEN="\e[1;32m"
BOLDRED="\e[1;31m"
BOLDBLUE="\e[1;96m"
BOLDYELLOW="\e[1;33m"
ENDCOLOR="\e[0m"

if [ -f "$KDIR/$OUT_DIR/.config" ]; then
    CONFIG_STATUS="$BOLDGREEN}Config present$ENDCOLOR"
else
    CONFIG_STATUS="${BOLDRED}No .config found$ENDCOLOR"
fi

function show_gui() {
	clear
	echo -e "\e[1;93m"
	figlet Kernel Builder
	echo -e "\e[0m"
	echo -e "${BOLDGREEN}Creator: ${BOLDRED}karamdev1$ENDCOLOR"
	echo -e "${BOLDGREEN}Kernel Config: ${CONFIG_STATUS}$ENDCOLOR"
	echo
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}Kernel${BOLDGREEN}----------------------------|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}1${ENDCOLOR}] Compile Kernel                           $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}2${ENDCOLOR}] Compile Module $BOLDBLUE(Doesn't need prepare)    $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}3${ENDCOLOR}] Prepare Module                           $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}4${ENDCOLOR}] Clean Kernel $BOLDBLUE(Clean & Mrproper)          $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}5${ENDCOLOR}] Apply Defconfig $BOLDBLUE(Selection in Config)    $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}6${ENDCOLOR}] Edit Config $BOLDBLUE(MENUCONFIG) $BOLDYELLOW(GOOD)          $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}7${ENDCOLOR}] Edit Config $BOLDBLUE(NCONFIG) $BOLDGREEN(BEST)             $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}8${ENDCOLOR}] Save .config as new defconfig            $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}Script${BOLDGREEN}----------------------------|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDRED}E${ENDCOLOR}] Exit Builder                             $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|        ${ENDCOLOR}[${BOLDBLUE}G${ENDCOLOR}] Open the creator's github page           $BOLDGREEN|$ENDCOLOR"
	echo -e "${BOLDGREEN}|-------------------${ENDCOLOR}End${BOLDGREEN}-------------------------------|$ENDCOLOR"
	echo
}

function check_exit_code() {
	local ret=$?
	if [ $ret -eq 0 ]; then
		echo -e "$BOLDGREEN[+] Success$ENDCOLOR"
	else
		echo -e "$BOLDRED[-] Failed (exit code: $ret)$ENDCOLOR"
	fi
}

while true; do
	show_gui
	read -p "Enter the action: " action

	case $action in
		1)
			echo -e "$BOLDGREEN[+] Building$ENDCOLOR"
			if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
				echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
			else
				echo -e "$BOLDRED[+] .config found$ENDCOLOR"
				make -s -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y -j"$(nproc)"
				check_exit_code
				if [ ! -f "$KDIR/$OUT_DIR/arch/$ARCH/boot/Image" ]; then
					echo -e "$BOLDRED[-] Image binary isn't made$ENDCOLOR"
				else
					echo -e "$BOLDGREEN[+] Image binary copied to '$KDIR/arch/$ARCH/boot/Image'$ENDCOLOR"
					cp "$KDIR/$OUT_DIR/arch/$ARCH/boot/Image" "$KDIR/arch/$ARCH/boot/Image"
				fi
			fi
			;;
		2)
			echo -e "$BOLDGREEN[+] Building Modules$ENDCOLOR"
			if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
				echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
			else
				echo -e "$BOLDRED[+] .config found$ENDCOLOR"
				make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y module_prepare -j"$(nproc)" && make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y module -j"$(nproc)"
				check_exit_code
			fi
			;;
		2)
			echo -e "$BOLDGREEN[+] Preparing Modules$ENDCOLOR"
			if [ ! -f "$KDIR/$OUT_DIR/.config" ]; then
				echo -e "$BOLDRED[-] No .config found$ENDCOLOR"
			else
				echo -e "$BOLDRED[+] .config found$ENDCOLOR"
				make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y module_prepare -j"$(nproc)"
				check_exit_code
			fi
			;;
		4)
			echo -e "$BOLDGREEN[+] Cleaning$ENDCOLOR"
			make -s -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y clean -j"$(nproc)" && make -s -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y mrproper -j"$(nproc)"
			check_exit_code
			;;
		5)
			echo -e "$BOLDGREEN[+] Appling $DEFCONFIG$ENDCOLOR"
			if [ ! -f "arch/$ARCH/configs/$DEFCONFIG" ]; then
				echo -e "$BOLDRED[-] $DEFCONFIG is not found$ENDCOLOR"
				exit 1
			else
				echo -e "$BOLDGREEN[+] $DEFCONFIG is found$ENDCOLOR"
			fi
			make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y $DEFCONFIG -j"$(nproc)"
			check_exit_code
			;;
		6)
			echo -e "$BOLDGREEN[+] Editing Config (MENUCONFIG)$ENDCOLOR"
			make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y menuconfig -j"$(nproc)"
			;;
		7)
			echo -e "$BOLDGREEN[+] Editing Config (NCONFIG)$ENDCOLOR"
			make -C "$KDIR" O="$OUT_DIR" KCFLAGS="$KCFLAGS" CONFIG_SECTION_MISMATCH_WARN_ONLY=y nconfig -j"$(nproc)"
			;;
		8)
			echo -e "$BOLDGREEN[+] Saving current .config as new defconfig$ENDCOLOR"
			;;
		E)
			echo -e "$BOLDRED[!] Exiting!!$ENDCOLOR"
			break
			;;
		G)
			echo -e "$BOLDGREEN[+] Opening the creator's github page$ENDCOLOR"
			xdg-open https://github.com/karamdev1 > /dev/null 2>&1 &
			;;
		*)
			echo -e "$BOLDRED[!] Invalid Action!!$ENDCOLOR"
			;;
	esac
	read -p "Press Enter to continue..."
done