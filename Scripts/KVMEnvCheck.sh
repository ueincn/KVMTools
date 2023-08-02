#!/bin/bash

#Program
#    KVM Tools - OS Check Scripts
#History
#2023   Ueincn  Release

function KVMEnvCheckTitles(){
    clear
    cat ProductTips
    echo -e "\n"
    echo "|========= KVM管理工具 - 系统环境检测 =========|"
}

function KVMEnvCheckMenu(){
    KVMEnvCheckTitles
    echo "    1.KVM系统环境[ 检测 ]"
    echo "    2.返回主界面"
    echo "    3.退出系统"
    echo ""
    read -p "请选择: " SELECT
    case $SELECT in 
        "1")
            KVMEnvCheck
            ;;
        "2")
            Main
            ;;
        "3")
            clear
            exit 0
            ;;
        *)
            echo "输入无效，请重新输入！"
            KVMEnvCheckMenu
            ;;
    esac
}

function KVMEnvCheck(){
    echo ""
    echo "系统环境检测开始："
    egrep "(svm|vmx)" /proc/cpuinfo >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "   系统虚拟化支持检测 ... PASS"
    else
        echo "   系统虚拟化支持检测 ... FAIL"
        echo "   请开启系统虚拟化支持！"
    fi

    lsmod | grep kvm >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "   KVM 模块检测 ... PASS"
    else
        echo "   KVM 模块检测 ... FAIL"
        echo "   请安装KVM模块! "
    fi
    echo ""
    read -p "请按任意按键返回主界面 ... " KVMENVCHECHMAIN
    if [ -n $KVMENVCHECHMAIN ]; then
        Main
    fi
}

