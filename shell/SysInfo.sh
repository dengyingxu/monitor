#!/bin/bash 
#--------------------------------------------
# 这是一个注释
# author：dengyingxu
#--------------------------------------------
##### 用户配置区 开始 #####
#
# CPU信息获取：
# 时间 主机名 OS版本 内核版本 运行时间 平均负载 磁盘总量 磁盘已用% 内存大小
# 内存已用% CPU温度 磁盘报警级别 内存报警级别 CPU报警级别
#
##### 用户配置区 结束  #####


NowTime=`date +"%Y-%m-%d__%H:%M:%S"`
HostName=`cat /etc/hostname`
OSVersion=`cat /etc/redhat-release`
KernelVersion=`uname -r`
RunTime=`cat /proc/uptime | awk -F"." '{runDay=$1 / 86400;runHour=($1 % 86400)/3600 ; 
    runMinute=($1 %3600)/60;runSecond=$1 % 60; 
    printf("up_%d_day,_%d_hours,_%d_minutes", runDay,runHour,runMinute)}'`
AverageLoad=` uptime | cut -d ' ' -f 12- |tr -d ','`
AllDisk=`df -m | awk -v sum=0 'NR==1 {next};{sum+=$2} END {printf sum}'`
UsedDisk=`df -m | awk -v sum=0 'NR==1 {next};{sum+=$3} END {printf sum}'`
UsedDiskPer=`echo "${UsedDisk}*100 / ${AllDisk}"|bc`
TotalMem=`free -m | head -n 2|tail -n 1 | awk '{printf $2}'`
UsedMem=`free -m | head -n 2|tail -n 1 | awk '{printf $3}'`
UsedMemPer=`echo "${UsedMem}*100 / ${TotalMem}"|bc`



LoadAvg=`cut -d " " -f 1-3 /proc/loadavg`
CpuTemp=`cat  /sys/class/thermal/thermal_zone0/temp`
CpuTemp=`echo "scale = 2; ${CpuTemp}/1000" | bc`


DiskWarn="normal"
if [[ `echo $UsedDiskPer '>=' 90 | bc` == 1 ]];then
    DiskWarn="waring"
elif [[ `echo $CpuTemp '>=' 80 | bc` == 1 ]];then
    DiskWarn="note"
fi

CpuWarn="normal"
if [[ `echo $CpuTemp '>=' 70 | bc` == 1 ]];then
    CpuWarn="waring"
elif [[ `echo $CpuTemp '>=' 50 | bc` == 1 ]];then
    CpuWarn="note"
fi


MemWarn="normal"
if [[ `echo $CpuTemp '>=' 80 | bc` == 1 ]];then
    MemWarn="waring"
elif [[ `echo $CpuTemp '>=' 70 | bc` == 1 ]];then
    MemWarn="note"
fi

echo "${NowTime} ${HostName} ${OSVersion} ${KernelVersion} ${RunTime} ${AverageLoad} ${AllDisk} ${UsedDiskPer}% ${TotalMem} ${UsedMemPer}% ${CpuTemp}°c ${DiskWarn} ${CpuWarn} ${MemWarn}"




