# KVM Tools
```bash
 _  __ __     __  __  __   _____           _     
| |/ / \ \   / / |  \/  | |_   _|__   ___ | |___ 
| ' /   \ \ / /  | |\/| |   | |/ _ \ / _ \| / __|
| . \    \ V /   | |  | |   | | (_) | (_) | \__ \
|_|\_\    \_/    |_|  |_|   |_|\___/ \___/|_|___/
language:[Shell] By:[Ueincn]
```
> KVM Tools（KVM管理工具）是一个云计算的计算节点常使用技术栈（KVM）相关管理工具。
## 功能
- KVM环境检测
- KVM环境安装与卸载
- KVM网络管理
- VM实例生命周期管理
- ......

## 使用
1.Git Clone
```bash
$ git clone https://github.com/ueincn/KVMTools.git
```
2.赋权
```bash
$ chmod -R u+x KVMTools/
```
3.使用
```bash
$ cd KVMTools/Scripts/

$ bash run.sh
#或
$ ./run.sh
```
## 目录结构
```bash
├── README.md              //README自述文件
└── Scripts                //程序脚本存放
    ├── KVMEnvCheck.sh     //KVM系统环境检测
    ├── KVMEnvInstall.sh   //KVM系统环境安装与卸载
    ├── KVMNetwork.sh      //KVM网络管理
    ├── Main.sh            //Menu
    ├── ProductTips        //发行名称
    ├── run.sh             //程序运行入口文件
    ├── VMInstall.sh       //VM实例系统安装
    ├── VMM.sh             //VM实例生命周期管理
    └── VMRun.sh           //VM单启动以及多开启动
```
## 程序主界面
```bash
 _  __ __     __  __  __   _____           _     
| |/ / \ \   / / |  \/  | |_   _|__   ___ | |___ 
| ' /   \ \ / /  | |\/| |   | |/ _ \ / _ \| / __|
| . \    \ V /   | |  | |   | | (_) | (_) | \__ \
|_|\_\    \_/    |_|  |_|   |_|\___/ \___/|_|___/

|=========== 欢迎访问KVM管理工具系统 ===========|
    1.KVM环境 [ 检测 ]
    2.KVM环境 [ 安装与卸载 ]
    3.VM实例 [ 网络管理 ]
    4.VM实例 [ 系统安装 ]
    5.VM实例 [ 启动 ]
    6.VM实例 [ 管理 ]
    7.退出系统

请选择: 
```