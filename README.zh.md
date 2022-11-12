####  FyDevops——集成建模软件基础环境初始化工具集
### 目的
    - 搭建针对磁约束聚变研究的集成建模软件栈的基础环境。
    - 特点：支持多个站点上的软件环境同步，从可重现性的角度， 首先要保持基础软件环境的一致性
    本仓库的目的，是提供一系列脚本工具集，脚本化基础环境的建立过程，并包含不同站点上的虚拟化的模拟。
### 功能
    - 囊括多种应用方式：
        - 本地HPC高性能集群环境下基础环境初始化
        - 支持对远程高性能计算站点的基础环境的同步
### 用法:
    - 启动容器:

    - 构建eb环境
        不同 
    EasyBuild安装本地
    /mnt/d/02_for_sicdata/0202_for_code/FyDevOps/scripts/fy_bootstrap.sh

- devops：相关的部署脚本
    - 版本管理：git@gitee.com:fusion_yun/FyDevOps.git
    - 管理整个fydev或者浮云平台的工具脚本集
        - 持续集成过程（待开发中）
        - Jupyterhub平台建立（待完善中）
        - 各种应用模块在jupyter界面中的插件开发（待开发中）
        - 更完善的UI界面(待开发中)
___FuYun___ 是面向大科学工程应用和物理研究的集成数据分析、建模环境。

![系统架构](./docs/figures/FuYunSystem.svg "FuYun")

主要包含三子系统：

* 工作流管理 (___SpDM___)：负责工作流的执行、调度和监控等动态控制；

* 科学数据库 (___SpDB___)：负责数据和工作流的交换、存储、检索等静态管理;

* 交互环境UI/UX (___SpUI___)：为用户提供，编辑、调试工作流，以及可视化数据分析的交互环境。

___FuYun___ 采用 Docker + EasyBuild 搭建容器作为开发和运行的基础环境，代称为 ___FyDev___。

## 目录结构

    - ebfiles       # ebfiles 编译安装描述文件
        - fydev-2019b.eb # FyDev 环境build文件
    - dockerfiles   # Docker 容器    
    - scripts       # 执行脚本
    - build_src     # 源代码打包缓存 .gitignore

## 生成 build

    $cd scripts
    $./main.sh

## 使用 Usage
    
- 拉回镜像 pull image

        $docker pull registry.cn-hangzhou.aliyuncs.com/fusionyun/fydev:latest

- 启动 JupyterLab

       $docker run --rm -p 8888:8888/tcp fylab:0.0.1 'jupyter lab --ip=\$(hostname -i) --no-browser'



## ___FyBox___ 架构

### EasyBuild module 环境

用于管理功能模块，负责

* 工具链和库依赖
* 自动编译
* 版本管理
* 部署
 
### Docker 容器

Docker 容器技术，管理、封装运行环境，打包应用。

## Requirement

## Description
