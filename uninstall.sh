#! /usr/bin/env bash

project_path=$(cd `dirname $0`; pwd)
cd ${project_path}

if [ -z "$1" ];then
    echored "unknow arguments, use './uninstall.sh appName' to uninstall a app"
    exit 0
fi

for appName in "$@"
do
    sudo rm -f /usr/share/applications/electron-${appName}*.desktop
    rm -rf ~/SoftWare/electron/electron-${appName}*
    rm -rf dist/electron-${appName}*
done
