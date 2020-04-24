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
FreeMem=`free -m | head -n 2|tail -n 1 | awk '{printf $4}'`
UsedMemPer=`echo "scale=1;${UsedMem}*100 / ${TotalMem}"|bc`



LoadAvg=`cut -d " " -f 1-3 /proc/loadavg`
CpuTemp=`cat  /sys/class/thermal/thermal_zone0/temp`
CpuTemp=`echo "scale = 2; ${CpuTemp}/1000" | bc`



tmp=$(cat ./tmp)
MovingPer=`echo "scale=1;${tmp}*0.3+${UsedMemPer}*0.7"|bc` 
echo "${MovingPer}" > tmp
echo "${NowTime} ${TotalMem}M ${FreeMem}M ${UsedMemPer}% ${MovingPer}%" 




