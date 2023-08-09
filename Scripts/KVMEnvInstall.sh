#!/bin/bash

#Program
#    KVM Tools - KVM Environment Install Scripts
#History
#2023   Ueincn  Releasel

function KVMEnvInstallTitles(){
    clear
    cat ProductTips
    echo -e "\n"
    echo "|========== KVM管理工具 - KVM环境管理 ==========|"
}
function KVMEnvInstallMenu(){

    if [[ "$UID" != "0" ]]; then
        echo "[ !! 请使用sudo权限或切换root运行脚本!! ]"
        exit 1
    fi

    KVMEnvInstallTitles
    echo "    1.KVM环境 [ 安装 ]"
    echo "    2.KVM环境 [ 卸载 ]"
    echo "    3.返回主界面"
    echo "    4.退出系统"
    echo ""
    read -p  "请选择：" KVMENVINSTALLSELECT
    case $KVMENVINSTALLSELECT in 
        "1")
            KVMOSCheck
            KVMEnvPkgCheck
            KVMEnvInstall
            read -p "请按任意按键返回主界面 ... " KVMENVINSTALLMAIN
            if [ -n $KVMENVINSTALLMAIN ]; then
                Main
            fi
            ;;
        "2")
            KVMEnvUninstall
            read -p "请按任意按键返回主界面 ... " KVMENVUNINSTALLMAIN
            if [ -n $KVMENVUNINSTALLMAIN ]; then
                Main
            fi
            ;;
        "3")
            Main
            ;;
        "4")
            clear
            exit 0
            ;;
        *)
            echo "输入无效，请重新输入！"
            KVMEnvInstallMenu
            ;;
    esac
}

function KVMSpinLine(){
    PID=$!
    echo -ne " ... "
    while kill -0 $PID 2>/dev/null
    do
        spin[0]="-"
        spin[1]="\\"
        spin[2]="|"
        spin[3]="/"
        for i in "${spin[@]}"
        do
            echo -ne "$i"
            sleep 0.1
            echo -ne "\b"
        done
    done
    if [ $? -eq "0" ]; then
        echo "PASS"
    else
        echo "FAIL"
    fi
}

function KVMEnvPkgCheck(){
    KVMEnvInstallTitles

    #KVM环境命令检测
    echo " KVM环境命令检测..."
    COMMANDLIST="qemu-system-$(arch) qemu-img libvirtd virsh virt-install brctl"

    for COMMAND in $COMMANDLIST
    do
        if command -v $COMMAND >/dev/null 2>&1; then
            echo "    $COMMAND ... Exist"
        else
            echo "    $COMMAND ... Not Exist"
        fi
    done

    #软件包安装工具检测
    echo "软件包安装工具检测..."
    if command -v apt >/dev/null 2>&1; then
        IS_PKG="APT"
        echo "    $IS_PKG ... Exist"
    elif command -v yum >/dev/null 2>&1; then
        IS_PKG="YUM"
        echo "    $IS_PKG ... Exist"
    else
        echo "系统存在未知包安装工具！"
    fi
}

function KVMOSCheck(){
    OSCHECKCOMMAND=$(sudo dmesg | grep "Linux version")
    if echo $OSCHECKCOMMAND | egrep "Debian|debian|DEBIAN" >/dev/null 2>&1; then
        OS="debain"
        KERNELVERSION=$(uname -r | awk -F '-' '{print $1}')
        ARCH=$(uname -m || arch)
        HOSTNAME=$(uname -n || hostname)
    fi


    if [ $OS = "debain" ]; then
        PKGLIST="libvirt-daemon-system libvirt-clients virtinst qemu-system qemu-system-gui bridge-utils virt-manager uuid-runtime"
    fi

}

function KVMEnvInstall(){

    echo "KVM环境安装开始..."
    echo -n "    KVM Installing"
    if [ $IS_PKG == "APT" ]; then
        for PKGINSTALL in $PKGLIST
        do
            sudo apt install $PKGLIST >/dev/null 2>&1 &
            KVMSpinLine
        done
    fi
}

function KVMEnvUninstall(){
    KVMEnvInstallTitles
    echo "KVM环境卸载开始..."
    echo -n "    KVM Remove"
    if [ $IS_PKG == "APT" ]; then
        for PKGINSTALL in $PKGLIST
        do
            sudo apt remove $PKGLIST >/dev/null 2>&1 &
            KVMSpinLine
        done
    fi
}

function EnvConfigure(){
    echo 'user = "root"' >> /etc/libvirt/qemu.conf
    echo 'group = "root"' >> /etc/libvirt/qemu.conf
}