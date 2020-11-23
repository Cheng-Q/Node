#!/bin/bash
#chkconfig:2345 80 90
#description:nodeRun service
#检测文件内容是否更改
# 检测的文件
# while true
# do
# package=/www/server/server.js

package=./server.js
# 记录 md5值的文件
md5=package_md5
# 创建新的md5信息

# cd /www/server/
package_md5_new=$(md5sum -b $package | awk '{print $1}'|sed 's/ //g')

# 创建md5的函数
function creatmd5()
{

    echo $package_md5_new > $md5
}

# 判断文件是否存在
if [ ! -f $md5 ] ; then
        echo "md5file is not exsit,create md5file......."
        creatmd5
        # exit
fi
# 读取旧的md5信息
package_md5_old=$(cat $md5|sed 's/ //g')

echo $package_md5_new
echo $package_md5_old
PIDS=`lsof -i:8088 | wc -l`
echo $PIDS
if [ "$PIDS" -gt "0" ]; then
echo '启动了'
else  
echo '没启动'
fi

# 对象对比判断
if [ "$package_md5_new" == "$package_md5_old" ];then
        echo 'md5 is not changed'
        echo '没有更改么，那我就运行了。。。'
        if [ "$PIDS" -gt "0" ]; then
          echo '已经启动了'
        else  
          echo '开始启动了'
          node $package
        fi
        docker restart saas
else
        echo "md5 is  changed"
        if [ "$PIDS" -gt "0" ]; then
          echo '已经启动了，让我关掉他'
          kill -9 $(ps aux | grep server | awk '{print $2}')
            echo "停止node服务"
            echo "开始下载依赖"
          # mkdir aa
          npm i
            echo "依赖下载完成重新开始服务"
        fi
        # cd /www/server/
        echo '更改了，我要启动了'
        creatmd5
        node $package
fi
# sleep 10;

# done

