#!/usr/bin/env bash

project_path=$(cd `dirname $0`; pwd)

cd ${project_path}

appName=$1;
appUrl=$2;

if [ -n "${appName}" ] && [ -n "${appUrl}" ];then

	echo "=======================" ${appName}: ${appUrl}

	line1=`cat index.js | grep -n 'const staticUrl' | awk -F ':' '{print $1}'`
	sed -i "${line1}c const staticUrl='${appUrl}';" index.js

	line2=`cat index.js | grep -n 'const staticTitle' | awk -F ':' '{print $1}'`
	sed -i "${line2}c const staticTitle='electron-${appName}';" index.js

	line3=`cat scripts/build.sh | grep -n 'APP_NAME=' | awk -F ':' '{print $1}'`
	sed -i "${line3}c APP_NAME='electron-${appName}'" scripts/build.sh

	npm run build:linux
elif [ "${appName}" == "demo" ];then
	declare -A map=()
    #map['leetcode']='https://leetcode-cn.com/problemset/all/'
    #map['qqmusic']='https://y.qq.com/'
    #map['qqsport']='https://kbs.sports.qq.com/#hot'
    #map['iqiyi']='https://www.iqiyi.com/'
    #map['youku']='https://www.youku.com/'
    #map['qqvideo']='https://v.qq.com/'
    #map['youdaonote']='https://note.youdao.com/web/'
    #map['bilibili']='https://www.bilibili.com/'
    #map['baidu-pan']='https://pan.baidu.com/disk/home?#/all?vmode=list&path=%2Fapps'
    #map['baidu-translate']='https://fanyi.baidu.com/?aldtype=16047#auto/zh'
    #map['music163']='https://music.163.com/'
    #map['calendar']='http://qq.ip138.com/day/'
    #map['datapps-email']='https://exmail.qq.com/cgi-bin/frame_html?sid=O9Yo7hQOGQfJUXsm,7&r=f82d2ce07519491e5cf7fa54a909de3d'
    #map['qq-email']='https://mail.qq.com/cgi-bin/frame_html?sid=rvGoNIjdQK2teUYY&r=6718e03bba9dd65a17135bc77affa4cb'
    #map['163-email']='https://mail.163.com/js6/main.jsp?sid=MCCBpDdumjriNtwDYkuuFuGpFULPluDN&df=mail163_letter#module=welcome.WelcomeModule%7C%7B%7D'

    for key in ${!map[@]}
    do
        echo "=======================" ${key}: ${map[$key]}

        line1=`cat index.js | grep -n 'const staticUrl' | awk -F ':' '{print $1}'`
        sed -i "${line1}c const staticUrl='${map[$key]}';" index.js

        line2=`cat index.js | grep -n 'const staticTitle' | awk -F ':' '{print $1}'`
        sed -i "${line2}c const staticTitle='electron-${key}';" index.js

        line3=`cat scripts/build.sh | grep -n 'APP_NAME=' | awk -F ':' '{print $1}'`
        sed -i "${line3}c APP_NAME='electron-${key}'" scripts/build.sh

        npm run build:linux
    done
else
    echored "unknow arguments, use like './build.sh appName appUrl' to build a app OR './build.sh demo' to build the given apps"
fi
