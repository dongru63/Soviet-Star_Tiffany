#!/bin/bash
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
read -p "Write the Kernel version: " KV
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " Cleaning old build directories ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " ";
echo " Setting up the compiler ";
echo " ";
git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 ~/Toolchain/64
git clone https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 ~/Toolchain/32
git clone https://github.com/PixelExperience/prebuilts_clang_host_linux-x86 ~/Toolchain/clang
echo " ";
echo " ";

##########################################

KERNEL_DIR="Soviet-Star"
KERNEL_NAME="Soviet-Star"
KERNEL_VER="4.9"
OUT_DIR="outputdTiffany-4.9-Treble_NonTreble"
DEVICE_CODENAME="Tiffany"
DEFCONFIG="soviet-star_tiffany_defconfig"
CLANG_DIR="clang-r353983e"
DTB_PATH="arch/arm64/boot/dts/qcom"
IMAGES_PATH="arch/arm64/boot"
STATUS="-Treble_NonTreble"

##########################################

##########################################
export CLANG_PATH=${HOME}/Toolchain/clang/$CLANG_DIR/bin/
export PATH=${CLANG_PATH}:${PATH}
export ARCH=arm64
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=${HOME}/Toolchain/64/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=${HOME}/Toolchain/32/bin/arm-linux-androideabi-
export LD_LIBRARY_PATH=${HOME}/Toolchain/clang/$CLANG_DIR/lib64:$LD_LIBRARY_PATH
##########################################

echo " ";
echo " ";
echo " ";
echo " Creating directories ";
echo " ";
echo " ";

if [ -d $OUT_DIR ]; then
    rm -rf $OUT_DIR
fi

mkdir $OUT_DIR

mkdir ~/$KERNEL_DIR

mkdir ~/$KERNEL_DIR/${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}
echo " ";
echo " ";
echo " Started Building the Kernels ! ";
echo " ";
echo " ";

##########################################

echo " Started Building Tiffany-4.9${STATUS} ! ";
echo " ";
echo " ";
echo " ";
make CC=clang -C $(pwd) O=$OUT_DIR $DEFCONFIG
make CC=clang -j$(nproc) -C $(pwd) O=$OUT_DIR
##########################################

echo " copying zImage and dtb and the template over to the output directory ";
echo " ";
echo " ";
echo " ";

if [ -d template/kernel ]; then
    echo " "
else
    mkdir template/kernel
    echo "mkdir template/kernel"
fi
if [ -d template/dtb-treble ]; then
    echo " "
else
    mkdir template/dtb-treble
    echo "mkdir template/dtb-treble"
fi
if [ -d template/dtb-nontreble ]; then
    echo " "
else
    mkdir template/dtb-nontreble
    echo "mkdir template/dtb-nontreble"
fi

cp -r template/. ~/$KERNEL_DIR/${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}

cp $OUT_DIR/$IMAGES_PATH/Image.gz ~/$KERNEL_DIR/${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}/kernel/Image.gz
cp $OUT_DIR/$DTB_PATH/msm8953-qrd-sku3-tiffany-nontreble.dtb ~/$KERNEL_DIR/${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}/dtb-nontreble
cp $OUT_DIR/$DTB_PATH/msm8953-qrd-sku3-tiffany-treble.dtb ~/$KERNEL_DIR/${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}/dtb-treble

echo " Zipping Kernel Files ";
echo " ";
echo " ";
echo " ";

##########################################
cd ~/$KERNEL_DIR/${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}
zip -r9 ${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}.zip * -x ${KERNEL_NAME}_V${KV}-${DEVICE_CODENAME}-${KERNEL_VER}${STATUS}.zip

echo " ";
echo " ";
echo " ";
echo " Compiling and uploading is done !! ";
