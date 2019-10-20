# FuYun 集成分析计算环境

___FuYun___ 是面向大科学工程应用和物理研究的集成数据分析、建模环境。



![系统架构](./docs/figures/FuYunSystem.svg "FuYun")

主要包含三子系统：
 * 工作流管理 (___SpDM___)：负责工作流的执行、调度和监控等动态控制；

 * 科学数据库 (___SpDB___)：负责数据和工作流的交换、存储、检索等静态管理;

 * 交互环境UI/UX (___SpUI___)：为用户提供，编辑、调试工作流，以及可视化数据分析的交互环境。

___FuYun___ 采用 Docker + EasyBuild 搭建容器作为开发和运行的基础环境，代称为 ___FyBox___。


## 目录结构

    - ebfiles       # EasyBuild module 环境
    - dockerfiles   # Docker 容器
    - sources       # 源代码缓存 gitignore


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