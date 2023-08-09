#!/bin/bash

#Program
#    KVM Tools - Run Scripts
#History
#2023   Ueincn  Release

#set -x

. Main.sh

function OSCheck(){
    OS_NAME=$(cat /etc/os-release | grep -w "NAME" | awk -F '"' '{print $2}') 
    OS_VERSION=$(cat /etc/os-release | grep -w "VERSION" | awk -F '"' '{print $2}' | awk -F '(' '{print $1}') 
    OS_KERNAL=$(uname -r | awk -F '-' '{print $1}')
    OS_ARCH=$(uname -m || arch)
    OS_HOSTNAME=$(uname -n || hostname)
}

if [[ "$UID" != "0" ]]; then
    echo ""
    echo "[ !! 请使用sudo权限或切换root运行脚本!! ]"
    echo ""
    OSCheck
    echo "系统：$OS_NAME"
    echo "系统版本：$OS_VERSION"
    echo "内核版本：$OS_KERNAL"
    echo "系统架构：$OS_ARCH"
    echo "主机名称：$OS_HOSTNAME"
    echo "当前工作目录：$PWD"
    echo ""
    exit 1
else
    Main
fi
