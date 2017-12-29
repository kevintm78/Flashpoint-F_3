#!/bin/bash

export ARCH=arm
export CROSS_COMPILE=$(pwd)/arm-eabi-5.3/bin/arm-eabi-
mkdir output

make -C $(pwd) O=output apq8084_sec_defconfig VARIANT_DEFCONFIG=apq8084_sec_trlte_eur_defconfig SELINUX_DEFCONFIG=selinux_defconfig
make -j64 -C $(pwd) O=output

cp output/arch/arm/boot/zImage $(pwd)/AIK/split_img/boot.img-zImage
./tools/dtbTool -o ./AIK/split_img/boot.img-dtb -s 4096 -p ./output/scripts/dtc/ ./output/arch/arm/boot/dts/
./AIK/repackimg.sh
mv ./AIK/image-new.img ./boot.img
rm ./AIK/split_img/boot.img-dtb
rm ./AIK/split_img/boot.img-zImage
rm -rf output/
make clean && make mrproper