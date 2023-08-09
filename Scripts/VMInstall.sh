#!/bin/bash

#Program
#    KVM Tools - VM Install Scripts
#History
#2023   Ueincn  Release
UNIT="G"

function VMInstallTitles(){
    clear
    cat ProductTips
    echo -e "\n"
    echo "|======== KVM管理工具 - KVM实例系统安装 ========|"
    echo ""
}

function VMInstallMenu(){

    if [[ "$UID" != "0" ]]; then
        echo "[ !! 请使用sudo权限或切换root运行脚本!! ]"
        exit 1
    fi

    VMInstallTitles
    VMInstallInfo
    echo "KVM实例磁盘创建 ..."
    read -p "    请输入磁盘名称：" DISKNAME
    read -p "    请输入磁盘大小(单位/G): " DSIKSIZE
    VMInstallFormat
    qemu-img create -f $DISKFORMAT $DISKNAME.$DISKFORMAT $DSIKSIZE$UNIT >/dev/null 2>&1
    DISK="$(pwd)/$DISKNAME.$DISKFORMAT"
    echo "    KVM实例磁盘创建中 ... PASS"
    echo ""
    echo "KVM实例系统安装 ..."
    read -p "    请输入镜像文件地址(ISO): " IMAGEPATH
    read -p "    请输入启动内存大小(单位/MB): " INSTALLMEN
    read -p "    请输入启动CPU数量(单位/个): " INSTALLCPU
    echo "    KVM实例创建中 ... "
    sleep 0.5
    qemu-system-$(arch) -m "$INSTALLMEM" -smp "$INSTALLCPU" $DISK -cdrom $IMAGEPATH >/dev/null 2>&1 &
    echo ""
    echo "获取KVM实例信息 ..."
    echo "    实例名称：$DISKNAME"
    echo "    实例格式：$DISKFORMAT"
    echo "    实例大小：$DSIKSIZE$UNIT"
    echo "    实例位置：$DISK"
    echo ""
    read -p "请按任意按键返回主界面 ... " VMINSTALLMAIN
        if [ -n $VMINSTALLMAIN ]; then
            Main
        fi
}

function VMInstallInfo(){
    if [ ! -d ~/KVMTools/VMInstance/VM ]; then
        mkdir -p ~/KVMTools/VMInstance/VM
    fi
    cd ~/KVMTools/VMInstance/VM
}

function VMInstallFormat(){
    echo "      1) qcow2"
    echo "      2) raw"
    read -p "    请选择磁盘格式：" DISKFORMATSELECT
    case $DISKFORMATSELECT in
        '1')
            DISKFORMAT="qcow2"
            ;;
        '2')
            DISKFORMAT="raw"
            ;;
        *)
            echo "    输入格式错误！请重新输入！"
            VMInstallFormat
            ;;
    esac
}