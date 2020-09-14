#! /bin/bash
read -p "请输入.exe包的打包版本号:" versions
read -p "请输入.exe包的包名:" app_name
root_path=$(dirname $0)
cd ${root_path}

rm -rf out
electron-packager . $app_name --platform=win32 --arch=x64 --icon=icon.ico --out=./out --asar --app-version=$versions --download.mirrorOptions.mirror=https://npm.taobao.org/mirrors/electron/

echo "completed!"
exit 0;
