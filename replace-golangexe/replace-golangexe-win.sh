#!/bin/bash

# 注：当前脚本支持windows下bash执行。
#(1) windows下需要安装putty工具
#(2) linux下需要安装sshpass工具，需要修改脚本部分代码。示例：
#   sshpass -p "$SSHPASSWD" ssh safm@192.168.78.2 "cd /home/ap/safm/tjxtest && touch hello.txt"
#   sshpass -p "$SSHPASSWD" scp test.txt safm@192.168.78.2:/home/ap/safm/tjxtest

export CGO_ENABLED=0
export GOOS=linux
export GOARCH=amd64

# 远程服务器ip、用户名、密码、端口。
SSH_PASSWORD="your pass"
REMOTE_SERVER="your server"
SSH_PORT="your server port"
REMOTE_USER="your remote server username"

# 远程服务器项目包目录以及包名等
REMOTE_SERVICE_DIR="/home/ap/safm/ccbc/web/service/application/"
REMOTE_DIR="/home/ap/safm/ccbc/web/service/application/application_intelligent/"
BUILD_FILE_NAME="application_intelligent"

BAK_FILE_SUFFIX=$(date +"%Y%m%d%H%M")
ECHO_PREFIX="${0} -- $(date) service: ${BUILD_FILE_NAME} + ================"

BUILD_FILE_PATH=${REMOTE_DIR}${BUILD_FILE_NAME} 

# 更新最新代码
git pull origin develop && \

if [ $? -ne 0 ]; then
    echo $ECHO_PREFIX + "ERROR: pull origin develop failed! please resolve conflict!"
    exit 1
fi

# 编译打包
go build -ldflags "-w -s" -o ${BUILD_FILE_NAME} main.go

if [ $? -ne 0 ]; then
    echo $ECHO_PREFIX + "ERROR: build failed!"
    exit 9
fi
echo $ECHO_PREFIX + "build success！"

# 退出清除包文件
cleanup() {
    rm -f ${BUILD_FILE_NAME}
    echo "Exiting... remove ${BUILD_FILE_NAME} file..."
}
trap cleanup EXIT

plink -batch -ssh -P "$SSH_PORT" -pw "$SSH_PASSWORD" "$REMOTE_USER@$REMOTE_SERVER" "\
if [ -e ${BUILD_FILE_PATH} ]; then
    echo $ECHO_PREFIX + 'file exists, prepare to backup ${BUILD_FILE_NAME}...' && \
    cd $REMOTE_DIR && \
    cp ${BUILD_FILE_NAME} ${BUILD_FILE_NAME}.${BAK_FILE_SUFFIX} && \
    echo $ECHO_PREFIX + '${BUILD_FILE_NAME}.${BAK_FILE_SUFFIX} backup success...' && \
    cd $REMOTE_SERVICE_DIR && \
    npx pm2 stop ${BUILD_FILE_NAME} > /dev/null && \
    if [ $? -ne 0 ]; then
        echo $ECHO_PREFIX + "ERROR: service stop failed!"
        exit 8
    fi
else
    echo $ECHO_PREFIX + 'file not exists, no need to backup, prepare to deploy...'
fi
"
pscp -batch -P "$SSH_PORT" -pw "$SSH_PASSWORD" ${BUILD_FILE_NAME} "$REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIR/" && \
plink -batch -ssh -P "$SSH_PORT" -pw "$SSH_PASSWORD" "$REMOTE_USER@$REMOTE_SERVER" "\
if [ -e ${BUILD_FILE_PATH} ]; then
    echo $ECHO_PREFIX + 'prepare to restart ${BUILD_FILE_NAME}...' && \
    cd $REMOTE_SERVICE_DIR && \
    npx pm2 restart ${BUILD_FILE_NAME} > /dev/null && \
    if [ $? -ne 0 ]; then
        echo $ECHO_PREFIX + "ERROR: service restart failed!"
        exit 7
    else 
        echo $ECHO_PREFIX + "service restart success!"
    fi
else
    echo $ECHO_PREFIX + 'ERROR: file not exists, start service failed...'
    exit 6
fi
"