#!/bin/bash

#Program
#    KVM Tools - Main Scripts
#History
#2023   Ueincn  Release

. KVMEnvCheck.sh
. KVMEnvInstall.sh
. VMInstall.sh
. KVMNetwork.sh
. VMRun.sh
. VMM.sh

function Main(){
    clear
    cat ProductTips
    echo -e "\n"
    echo "|=========== 欢迎访问KVM管理工具系统 ===========|"
    echo "    1.KVM环境 [ 检测 ]"
    echo "    2.KVM环境 [ 安装与卸载 ]"
    echo "    3.VM实例 [ 网络管理 ]"
    echo "    4.VM实例 [ 系统安装 ]"
    echo "    5.VM实例 [ 启动 ]"
    echo "    6.VM实例 [ 管理 ]"
    echo "    7.退出系统"
    echo ""
    read -p  "请选择: " SELECT
    case $SELECT in 
        "1")
            KVMEnvCheckMenu
            ;;
        "2")
            KVMEnvInstallMenu
            ;;
        "3")
            KVMNetworkMenu
            ;;
        "4")
            VMInstallMenu
            ;;
        "5")
            VMRunMenu
            ;;
        "6")
            VMMMenu
            ;;
        "7")
            echo "系统已退出 Bye."
            clear
            exit 0
            ;;
        *)
            echo "输入无效，请重新输入！"
            Main
            ;;
    esac
}