#!/bin/bash
#chkconfig:2345 80 90
#description:runAllShell service
while true
do
dir=/www/server/
# dir=./
# 进入指定目录
cd $dir
# 执行shell脚本--node检测更新脚本
sh nodeRun.sh s
sleep 1;

done