#!/usr/bin/env bash

if ! hash electron-packager 2>/dev/null; then
	RED='\033[0;31m'
	NC='\033[0m'
	echo "${RED}Error${NC}: you need to npm install electron-packager. Aborting."
	exit 1
fi

if [[ "$#" -ne 2 ]]; then
	echo -e "Usage: ./script/build.sh <platform> <arch>"
	echo -e "	platform:	darwin, linux, win32"
	echo -e "	arch:	ia32, x64"
	exit 1
fi

PLATFORM=$1
ARCH=$2

# FIXEDME
APP_NAME='electron-baidu-pan'

echo "Start packaging for $PLATFORM $ARCH."

if [[ ${PLATFORM} = "darwin" ]]; then
	ICON=icon.svg
else
	ICON=icon.png
fi

ignore_list="dist|scripts|\.idea|.*\.md|.*\.yml|node_modules/nodejieba"
cp assets/${ICON} node_modules/electron/dist/resources/${ICON}
electron-packager . "${APP_NAME}" --platform=${PLATFORM} --arch=${ARCH} --electronVersion=4.1.1 --app-version=1.1.0 --asar --icon=assets/${ICON} --overwrite --out=./dist --ignore=${ignore_list}

APP_DIR=${APP_NAME}-${PLATFORM}-${ARCH}

if [[ ${PLATFORM} = "darwin" ]]; then
	cp assets/${ICON} dist/${APP_DIR}/${APP_NAME}.app/Contents/Resources/
else
	cp assets/${ICON} dist/${APP_DIR}/resources/
fi

# create desktop
touch dist/${APP_DIR}/${APP_NAME}.desktop

echo "[Desktop Entry]" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Version=1.0" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Type=Application" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Name=${APP_NAME}" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Comment=${APP_NAME}" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Exec=/home/ice/SoftWare/electron/${APP_DIR}/${APP_NAME}" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Icon=/home/ice/SoftWare/electron/${APP_DIR}/resources/icon.png" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Categories=Network;Application;" >> dist/${APP_DIR}/${APP_NAME}.desktop
echo "Terminal=false" >> dist/${APP_DIR}/${APP_NAME}.desktop

chmod +x dist/${APP_DIR}/${APP_NAME}.desktop

mkdir -p /home/ice/SoftWare/electron
cp -r dist/${APP_DIR} /home/ice/SoftWare/electron/

sudo ln -sf /home/ice/SoftWare/electron/${APP_DIR}/${APP_NAME}.desktop /usr/share/applications/${APP_NAME}.desktop

if [[ $? -eq 0 ]]; then
	echo -e "$(tput setaf 2)Packaging for $PLATFORM $ARCH succeeded.$(tput sgr0)\n"
fi
