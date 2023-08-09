#!/bin/bash

#Program
#    KVM Tools - VM Manager Scripts
#History
#2023   Ueincn  Release

function VMMTitles(){
    clear
    cat ProductTips
    echo -e "\n"
    echo "|=========== KVM管理工具 - VM实例管理 ===========|"
}

function VMMMenu(){

    if [[ "$UID" != "0" ]]; then
        echo "[ !! 请使用sudo权限或切换root运行脚本!! ]"
        exit 1
    fi

    VMMTitles
    echo "    1.VM实例 [ 查询 ]"
    echo "    2.VM实例 [ 启动 ]"
    echo "    3.VM实例 [ 停止 ]"
    echo "    4.VM实例 [ 复制 ]"
    echo "    5.返回主页面"
    echo "    6.退出系统"
    echo " "
    read -p  "请选择：" VMMSELECT
    case $VMMSELECT in
        "1")
            VMMQuery
            ;;
        "2")
            VMMStart
            ;;
        "3")
            VMMStop
            ;;
        "4")
            VMMCopy
            ;;
        "5")
            Main
            ;;
        "6")
            clear
            exit 0
            ;;
        *)
            echo "输入无效，请重新输入！"
            VMMMenu
            ;;
    esac
}

function VMMQuery(){
    echo ""
    sudo virsh list --all
    echo ""
    read -p "请按任意按键返回上一级 ... " VMMMENU
    if [ -n $VMMMENU ]; then
         VMMMenu
    fi
}

function VMMStart(){
    echo ""
    sudo virsh list --all
    read -p "请输入要启动的VM实例名称: " VMMNAME
    sudo virsh start $VMMNAME >/dev/null
    if [ $? == 0 ]; then
        echo "VM实例 $VMMNAME 启动 ... 成功！"
    else
        echo "VM实例 $VMMNAME 启动 ... 失败！"
    fi
    echo ""
    read -p "请按任意按键返回上一级 ... " VMMMENU
    if [ -n $VMMMENU ]; then
         VMMMenu
    fi
}

function VMMStop(){
    echo ""
    sudo virsh list --all
    read -p "请输入要停止的VM实例名称: " VMMNAME
    sudo virsh destroy $VMMNAME >/dev/null
    if [ $? == 0 ]; then
        echo "VM实例 $VMMNAME 停止 ... 成功！"
    else
        echo "VM实例 $VMMNAME 停止 ... 失败！"
    fi
    echo ""
    read -p "请按任意按键返回上一级 ... " VMMMENU
    if [ -n $VMMMENU ]; then
         VMMMenu
    fi
}

function VMMCopy(){
    echo ""
    sudo virsh list --all
    read -p "请输入要复制的VM实例名称: " VMMNAME
    read -p "请输入新VM实例名称: " VMMNEWNAME
    sudo virt-clone -o $VMMNAME -n $VMMNEWNAME --auto-clone
    if [ $? == 0 ]; then
        echo "VM实例 $VMMNAME 复制 ... 成功！"
        echo "VM实例新名称: $VMMNEWNAME"
    else
        echo "VM实例 $VMMNAME 复制 ... 失败！"
    fi
    echo ""
    read -p "请按任意按键返回上一级 ... " VMMMENU
    if [ -n $VMMMENU ]; then
         VMMMenu
    fi
}