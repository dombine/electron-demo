#!/usr/bin/env bash

project_path=$(cd `dirname $0`; pwd)

cd ${project_path}

declare -A map=()
#map['electron-leetcode']='https://leetcode-cn.com/problemset/all/'
#map['electron-qqmusic']='https://y.qq.com/'
#map['electron-qqsport']='https://kbs.sports.qq.com/#hot'
#map['electron-iqiyi']='https://www.iqiyi.com/'
#map['electron-youku']='https://www.youku.com/'
#map['electron-video']='https://v.qq.com/'
#map['electron-youdaonote']='https://note.youdao.com/web/'
#map['electron-bilibili']='https://www.bilibili.com/'
#map['electron-baidu-pan']='https://pan.baidu.com/disk/home?#/all?vmode=list&path=%2Fapps%2Fbypy'
#map['electron-baidu-translate']='https://fanyi.baidu.com/?aldtype=16047#auto/zh'

for key in ${!map[@]}
do
	echo "=======================" ${key}: ${map[$key]}

	line1=`cat index.js | grep -n 'const staticUrl' | awk -F ':' '{print $1}'`
	sed -i "${line1}c const staticUrl='${map[$key]}';" index.js

	line2=`cat index.js | grep -n 'const staticTitle' | awk -F ':' '{print $1}'`
	sed -i "${line2}c const staticTitle='${key}';" index.js

	line3=`cat scripts/build.sh | grep -n 'APP_NAME=' | awk -F ':' '{print $1}'`
	sed -i "${line3}c APP_NAME='${key}'" scripts/build.sh

	npm run build:linux
done
