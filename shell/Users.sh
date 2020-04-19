#!/bin/bash 
#--------------------------------------------
# 这是一个注释
# author：dengyingxu
#--------------------------------------------


NowTime=`date +"%Y-%m-%d__%H:%M:%S"`

UserNum=`cat /etc/passwd | grep home | grep bash | wc -l`
Users=(`cat /etc/passwd | w | tail -n 3  | cut -d ' ' -f 1`)


echo "${NowTime} ${LoadAvg} ${CpuUsedPerc} ${CpuTemp}℃  ${Warn}"




