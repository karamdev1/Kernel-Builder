# Kernel-Builder

## Requirements
```
figlet (for the logo)
```

## Setup (inside your kernel tree) (running it as user is recommended)
```
git clone https://github.com/karamdev1/Kernel-Builder.git
mv Kernel-Builder/build.sh ./
mv Kernel-Builder/building_config ./
rm -r Kernel-Builder
```
Hook your toolchain, defconfig and arch type in **building_config** file and execute the build.sh