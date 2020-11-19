#!/bin/bash
#chkconfig:2345 80 90
#检测文件内容是否更改
# 检测的文件
package=/www/server/server.js
# 记录 md5值的文件
md5=package_md5
# 创建新的md5信息
# while true
# do

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
        exit
fi

# 读取旧的md5信息
package_md5_old=$(cat $md5|sed 's/ //g')

echo $package_md5_new
echo $package_md5_old

# 对象对比判断
if [ "$package_md5_new" == "$package_md5_old" ];then
        echo 'md5 is not changed'
        # docker restart saas
else
        echo "md5 is  changed"
        echo "停止node服务"
        kill -9 $(ps aux | grep server | awk '{print $2}')
        npm i
        echo "重新开始服务"
        node $package
        creatmd5
        
fi
#sleep 10;

#done

