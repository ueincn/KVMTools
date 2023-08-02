#!/bin/bash

#Program
#    KVM Tools - KVM Network Manager Scripts
#History
#2023   Ueincn  Release

function KVMNetworkTitles(){
    clear
    cat ProductTips
    echo -e "\n"
    echo "|========== KVM管理工具 - KVM网络管理 ==========|"
}

function KVMNetworkMenu(){
    KVMNetworkTitles
    KVMRunInfo
    echo "    1.查询网络信息"
    echo "    2.启动网络"
    echo "    3.创建网络"
    echo "    4.删除网络"
    echo "    5.返回主界面"
    echo ""
    read -p  "请选择数字：" KVMNETWORKSELECT
    case $KVMNETWORKSELECT in 
        "1")
            KVMNetworkInfo
            ;;
        "2")
            KVMNetworkStart
            ;;
        "3")
            KVMNetworkCreate
            ;;
        "4")
            KVMNetworkRemove
            ;;
        "5")
            Main
            ;;
        *)
            echo "输入无效，请重新输入！"
            KVMNetworkMenu
            ;;
    esac
}

function KVMNetworkInfo(){
    sudo virsh net-list --all
    echo ""
    read -p "请按任意按键返回上一级 ... " KVMNETWORKMENU
    if [ -n $KVMNETWORKMENU ]; then
         KVMNetworkMenu
    fi
}

function KVMNetworkStart(){
    read -p "请输入要开启网络的XML文件路径: " RUNNETWORKPATH
    if [ -z $RUNNETWORKPATH ]; then
        KVMNetworkMenu  
    fi
    sudo virsh net-define $RUNNETWORKPATH
    RUNNETWORK=$(cat $RUNNETWORKPATH | grep "<name>" | grep -v "</name>" | awk -F '>' '{print $NF}')
    sudo virsh net-start $RUNNETWORK
    echo ""
    read -p "请按任意按键返回上一级 ... " KVMNETWORKMENU
    if [ -n $KVMNETWORKMENU ]; then
         KVMNetworkMenu
    fi
}

function KVMNetworkCreate(){
    echo "创建KVM网络 ..."
    read -p "    请输入网络名称：" NETWORKNAME
    read -p "    请输入网卡名称：" NICNAME
    read -p "    请输入MAC地址(最后两位): " MACADDRESS
    read -p "    请输入网卡IP地址: " NICIP
    read -p "    请输入网卡掩码地址：" NICMASK
    read -p "    请输入DHCP服务起始IP: " DHCPSTART
    read -p "    请输入DHCP服务结束IP: " DHCPEND

    touch ~/KVMTools/KVMNetwork/$NETWORKNAME.xml
    cat > ~/KVMTools/KVMNetwork/$NETWORKNAME.xml <<EOF
<network>
    <name>$NETWORKNAME</name>
    <uuid>$(uuidgen)</uuid>
    <forward mode='nat'/>
    <bridge name='$NICNAME' stp='on' delay='0'/>
    <mac address='52:54:00:25:bf:$MACADDRESS'/>
    <ip address='$NICIP' netmask='$NICMASK'>
        <dhcp>
            <range start='$DHCPSTART' end='$DHCPEND'/>
        </dhcp>
    </ip>
</network>
EOF

    sudo virsh net-define ~/KVMTools/KVMNetwork/$NETWORKNAME.xml
    echo -n "加载网络 $NETWORKNAME ... "

    sudo virsh net-start $NETWORKNAME
    echo -n "启动网络 $NETWORKNAME ... "

    sudo virsh net-autostart $NETWORKNAME
    echo -n "设置网络 $NETWORKNAME 开机自启 ... "

    echo "$NETWORKNAME 网络创建并启动成功！"
    
    echo ""
    read -p "请按任意按键返回上一级 ... " KVMNETWORKMENU
    if [ -n $KVMNETWORKMENU ]; then
         KVMNetworkMenu
    fi

}

function KVMNetworkRemove(){
    sudo virsh net-list --all
    echo ""
    read -p "请选择要删除的网络名称：" REMOVENETWORK
    sudo virsh net-undefine $REMOVENETWORK
    sudo virsh net-destroy $REMOVENETWORK
    
    echo ""
    read -p "请按任意按键返回上一级 ... " KVMNETWORKMENU
    if [ -n $KVMNETWORKMENU ]; then
         KVMNetworkMenu
    fi

}

function KVMRunInfo(){
    if [ ! -d ~/KVMTools/KVMNetwork ]; then
        mkdir -p ~/KVMTools/KVMNetwork
    fi
}