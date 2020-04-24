#!/bin/bash 
#--------------------------------------------
# 这是一个注释
# author：dengyingxu
#--------------------------------------------
##### 用户配置区 开始 #####
#
#
##### 用户配置区 结束  #####


NowTime=`date +"%Y-%m-%d__%H:%M:%S"`

PartDisk=(`df -m | grep ^/dev | awk -v time=${NowTime} '{printf("%s 1 %s %s %s %s\n", time,$6,$2,$4,$5)}'`)

DiskNum=`df -m | grep ^/dev | wc -l`
DiskUse=0
DiskFree=0

for ((i = 0; i < ${#PartDisk[@]}; i+=6)) do
    DiskFree=`echo "${DiskFree} + ${PartDisk[i+4]}"|bc`
    DiskUse=`echo "${DiskUse} + ${PartDisk[i+3]}"|bc`
    echo "${PartDisk[i]} ${PartDisk[i+1]} ${PartDisk[i+2]} ${PartDisk[i+3]} ${PartDisk[i+4]} ${PartDisk[i+5]}"
done
DiskPer=`echo "100-${DiskFree}*100/${DiskUse}"|bc`
echo "$NowTime "0" "disk" $DiskUse ${DiskFree} ${DiskPer}%"
