#!/bin/bash

#Program
#    KVM Tools - VM Run Scripts
#History
#2023   Ueincn  Release

function VMRunTitles(){
    clear
    cat ProductTips
    echo -e "\n"
    echo "|======== KVM管理工具 - KVM实例启动 ========|"
}

function VMRunMenu(){

    if [[ "$UID" != "0" ]]; then
        echo "[ !! 请使用sudo权限或切换root运行脚本!! ]"
        exit 1
    fi

    VMRunTitles
    VMRunInfo
    echo "    1.实例启动（单开）"
    echo "    2.实例启动（多开）"
    echo "    3.返回主界面"
    read -p  "请选择数字：" VMRUNSELECT
    case $VMRUNSELECT in 
        "1")
            VMRunSingle
            ;;
        "2")
            VMRunMultiple
            ;;
        "3")
            Main
            ;;
        *)
            echo "输入无效，请重新输入！"
            VMRunMenu
            ;;
    esac
}

function VMRunSingle(){
    VMRunTitles

    if [ ! -d ~/KVMTools/VMInstance/VMSingle ]; then
        mkdir ~/KVMTools/VMInstance/VMSingle
    fi

    echo ""
    echo "实例启动(单开) ... "
    read -p "    请输入虚拟机实例名称：" VMRUNSINGLENAME
    read -p "    请输入虚拟机实例启动内存(单位/MiB): " VMRUNSINGLEMEN
    read -p "    请输入虚拟机实例启动CPU数量(单位/个): " VMRUNSINGLECPU
    read -p "    请输入虚拟机实例磁盘地址(仅支持qcow2): " VMRUNSINGLEDISKPATH
    echo "读取本机网络信息 ... "
    sudo virsh net-list --all
    read -p "    请选择虚拟机实例启动网络名称：" VMRUNSINGLENETWORK
    read -p "    请输入MAC地址(最后两位[可随意]): " VMRUNSINGLEMACADDRESS
    read -p "    请输入VNC服务端口号: " VMRUNSINGLEPORT

    mkdir ~/KVMTools/VMInstance/VMSingle/$VMRUNSINGLENAME
    touch ~/KVMTools/VMInstance/VMSingle/$VMRUNSINGLENAME/$VMRUNSINGLENAME.xml
    cp $VMRUNSINGLEDISKPATH ~/KVMTools/VMInstance/VMSingle/$VMRUNSINGLENAME/$VMRUNSINGLENAME.qcow2
    cd ~/KVMTools/VMInstance/VMSingle/$VMRUNSINGLENAME/
    DISKPATH="$(pwd)/$VMRUNSINGLENAME.qcow2"

    cat > ~/KVMTools/VMInstance/VMSingle/$VMRUNSINGLENAME/$VMRUNSINGLENAME.xml <<EOF
<domain type='kvm'>
    <name>$VMRUNSINGLENAME</name>
    <uuid>$(uuidgen)</uuid>
    <memory unit='MiB'>$VMRUNSINGLEMEN</memory>
    <currentMemory unit='MiB'>$VMRUNSINGLEMEN</currentMemory>
     <vcpu placement='static'>$VMRUNSINGLECPU</vcpu>
    <os>
        <type arch='$(arch)' machine='pc-i440fx-1.5'>hvm</type>
        <boot dev='cdrom'/> 
    </os>
    <features>
        <acpi/>
        <apic/>
        <pae/>
   </features>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>restart</on_crash>
    <clock offset="localtime" />
    <devices> 
        <emulator>/usr/bin/qemu-system-x86_64</emulator> 
        <disk type='file' device='disk'> 
            <driver name='qemu' type='qcow2'/>
            <source file='$DISKPATH'/>
            <target dev='hda' bus='ide'/> 
        </disk>
        <interface type='network'>   
            <mac address='fa:92:01:33:d6:$VMRUNSINGLEMACADDRESS'/> 
            <source network='$VMRUNSINGLENETWORK'/>
        </interface>
        <input type='tablet' bus='usb'/>
        <input type='mouse' bus='ps2'/>
        <input type='keyboard' bus='ps2'/>
        <graphics type='vnc' port='$VMRUNSINGLEPORT' autoport='yes' listen = '0.0.0.0' keymap='en-us'/>
   </devices> 
</domain>
EOF

    echo "虚拟机实例创建完成，启动中 ... "
    sudo virsh define ~/KVMTools/VMInstance/VMSingle/$VMRUNSINGLENAME/$VMRUNSINGLENAME.xml
    sudo virsh start $VMRUNSINGLENAME

    echo "虚拟机实例启动完成！"
    echo ""
    echo "获取虚拟机实例 $VMRUNSINGLENAME 信息："
    echo "    虚拟机实例名称：$VMRUNSINGLENAME "
    echo "    虚拟机实例内存：$VMRUNSINGLEMEN " 
    echo "    虚拟机实例 CPU: $VMRUNSINGLECPU "
    echo "    虚拟机实例磁盘：$DISKPATH "
    echo "    虚拟机实例网络：$VMRUNSINGLENETWORK "
    echo "    虚拟机实例 VNC: 0.0.0.0:$VMRUNSINGLEPORT "
    
    read -p "请按任意按键返回上一级 ... " VMRUNSINGLEMENU
    if [ -n $VMRUNSINGLEMENU ]; then
         VMRunMenu
    fi
}

function VMRunMultiple(){
    VMRunTitles

    if [ ! -d ~/KVMTools/VMInstance/VMMultiple ]; then
        mkdir ~/KVMTools/VMInstance/VMMultiple
    fi

    echo ""
    echo "实例启动(多开) ... "
    read -p "    请输入虚拟机实例名称：" VMRUNMULTIPLENAME
    read -p "    请输入虚拟机实例个数：" VMRUNMULTIPLENUM
    read -p "    请输入虚拟机实例启动内存(单位/MiB): " VMRUNMULTIPLEMEN
    read -p "    请输入虚拟机实例启动CPU数量(单位/个): " VMRUNMULTIPLECPU
    read -p "    请输入虚拟机实例磁盘地址(仅支持qcow2): " VMRUNMULTIPLEPATH
    echo "读取本机网络信息 ... "
    sudo virsh net-list --all
    read -p "    请选择虚拟机实例启动网络名称：" VMRUNMULTIPLENETWORK
    read -p "    请输入MAC地址(最后两位[可随意]): " VMRUNMULTIPLEMACADDRESS
    read -p "    请输入VNC服务端口号: " VMRUNMULTIPLEPORT

    for ((VMNUM=0; VMNUM<$VMRUNMULTIPLENUM; VMNUM++)); do

        mkdir ~/KVMTools/VMInstance/VMMultiple/$VMRUNMULTIPLENAME$VMNUM
        touch ~/KVMTools/VMInstance/VMMultiple/$VMRUNMULTIPLENAME$VMNUM/$VMRUNMULTIPLENAME$VMNUM.xml
        cp $VMRUNMULTIPLEPATH ~/KVMTools/VMInstance/VMMultiple/$VMRUNMULTIPLENAME$VMNUM/$VMRUNMULTIPLENAME$VMNUM.qcow2
        cd ~/KVMTools/VMInstance/VMMultiple/$VMRUNMULTIPLENAME$VMNUM/
        DISKPATH="$(pwd)/$VMRUNMULTIPLENAME$VMNUM.qcow2"

            cat > ~/KVMTools/VMInstance/VMMultiple/$VMRUNMULTIPLENAME$VMNUM/$VMRUNMULTIPLENAME$VMNUM.xml <<EOF
<domain type='kvm'>
    <name>$VMRUNMULTIPLENAME$VMNUM</name>
    <uuid>$(uuidgen)</uuid>
    <memory unit='MiB'>$VMRUNMULTIPLEMEN</memory>
    <currentMemory unit='MiB'>$VMRUNMULTIPLEMEN</currentMemory>
     <vcpu placement='static'>$VMRUNMULTIPLECPU</vcpu>
    <os>
        <type arch='$(arch)' machine='pc-i440fx-1.5'>hvm</type>
        <boot dev='cdrom'/> 
    </os>
    <features>
        <acpi/>
        <apic/>
        <pae/>
   </features>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>restart</on_crash>
    <clock offset="localtime" />
    <devices> 
        <emulator>/usr/bin/qemu-system-x86_64</emulator> 
        <disk type='file' device='disk'> 
            <driver name='qemu' type='qcow2'/>
            <source file='$DISKPATH'/>
            <target dev='hda' bus='ide'/> 
        </disk>
        <interface type='network'>   
            <mac address='fa:92:01:33:d6:$VMRUNMULTIPLEMACADDRESS'/> 
            <source network='$VMRUNMULTIPLENETWORK'/>
        </interface>
        <input type='tablet' bus='usb'/>
        <input type='mouse' bus='ps2'/>
        <input type='keyboard' bus='ps2'/>
        <graphics type='vnc' port='$VMRUNMULTIPLEPORT' autoport='yes' listen = '0.0.0.0' keymap='en-us'/>
   </devices> 
</domain>
EOF

        echo "虚拟机实例 $VMRUNMULTIPLENAME$VMNUM 创建完成，启动中 ... "
        sudo virsh define ~/KVMTools/VMInstance/VMMultiple/$VMRUNMULTIPLENAME$VMNUM/$VMRUNMULTIPLENAME$VMNUM.xml
        sudo virsh start $VMRUNMULTIPLENAME$VMNUM

        echo "获取虚拟机实例 $VMRUNMULTIPLENAME$VMNUM 信息："
        echo "    虚拟机实例名称：$VMRUNMULTIPLENAME$VMNUM "
        echo "    虚拟机实例内存：$VMRUNMULTIPLEMEN " 
        echo "    虚拟机实例 CPU: $VMRUNMULTIPLECPU "
        echo "    虚拟机实例磁盘：$DISKPATH "
        echo "    虚拟机实例网络：$VMRUNMULTIPLENETWORK "
        echo "    虚拟机实例 VNC: 0.0.0.0:$VMRUNMULTIPLEPORT "

        #MAC Add
        ((VMRUNMULTIPLEMACADDRESS = $VMRUNMULTIPLEMACADDRESS + 1))
        
        #VNC Port Add
        ((VMRUNMULTIPLEPORT = $VMRUNMULTIPLEPORT + 1))
        
    done

    echo "虚拟机 [$VMRUNMULTIPLENUM] 实例全部启动完成！"
    echo ""
    
    read -p "请按任意按键返回上一级 ... " VMRUNSINGLEMENU
    if [ -n $VMRUNSINGLEMENU ]; then
         VMRunMenu
    fi

}

function VMRunInfo(){
    if [ ! -d ~/KVMTools/VMInstance ]; then
        mkdir -p ~/KVMTools/VMInstance/
    fi
}