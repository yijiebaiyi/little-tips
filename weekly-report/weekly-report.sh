#!/bin/bash

# 你的git用户名
gitname="tuojinxin"

# 你需要输出周报的git项目
gitpath=(
    "/d/project/standard_server"
    "/d/project/demo/golang-demos"
)

# 输出周报保存路径
reportdir="/d/project/little_tips/weekly-report/report"

# 计算每周的开始天和结束天
start_date=$(date -d "last monday" +"%Y-%m-%d")
last_date=$(date -d "$start_date + 6 days" +"%Y-%m-%d")

# 周报名称
logfilename="log_$start_date-$last_date.txt"

# 当前脚本目录
script_directory="$(cd "$(dirname "$0")" && pwd)"

# 清空日志文件，写入日志信息
echo -e "\n===================================================" > "$reportdir/$logfilename"
echo "|         周报:${start_date} ~ ${last_date}        |" >> "$reportdir/$logfilename"
echo -e "===================================================\n" >> "$reportdir/$logfilename"

for ((i=0; i<7; i++)); do
    current_date=$(date -d "$start_date + $i days" +"%Y-%m-%d")
    end_date=$(date -d "$current_date + 1 days" +"%Y-%m-%d")

    echo "日期：$current_date" >> "$reportdir/$logfilename"
    
    for path in "${gitpath[@]}"; do
        cd "$path" && \
        git log --author="$gitname" --since="$current_date" --until="$end_date" --no-merges --pretty=format:'%Cgreen(%ad) %C(bold blue)%s' --date=default \
        >> "$reportdir/$logfilename" 
    done

    echo " " >> "$reportdir/$logfilename"
done

# 回到当前脚本，做些别的事...
cd ${script_directory}
