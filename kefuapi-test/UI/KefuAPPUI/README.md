
# 客服APP工作台自动化
客服APP工作台自动化是为客服项目打造的一套UI自动化项目，其中包括工作台启动、登录、登出、消息收发、会话调度等一系列测试场景。

## 基础环境:

1. 客服端app ui自动化使用robotframework测试自动化框架进行验收测试： [官网地址](http://robotframework.org/)
2. 使用GIT下载项目： https://github.com/easemob/kefu-auto-test
3. 项目依赖

```
* python
* setuptools
* pip
* Robot Framework
* wxPython
* robotframework-ride
* robotframework-requests
* robotframework-selenium2library
* robotframework-excellibrary
* robotframework-appiumlibrary
* pandas
  ...
```
4.在线安装依赖包

```
$ cd kefu-auto-test/kefuapi-test/
$ pip install -r requirements.txt
```


## 环境配置搭建

此教程适用于Windows系统，Mac系统：[Mac OS Xcode 上运行 Appium](https://github.com/appium/appium/blob/master/docs/cn/appium-setup/running-on-osx.md)

### 依赖环境安装：

1. 下载最新版本的 [node 与 npm 工具](https://nodejs.org/download/release/v6.3.0/node-v6.3.0-x64.msi) 的 MSI (版本 >= 6.0) **npm** 和 **nodejs** 两个命令应该在你的 PATH 系统变量里。
2. 打开你的 cmd 终端
3. 运行 **npm --registry http://registry.cnpmjs.org install -g appium@1.4.16**  这条命令后，就会通过 NPM 去安装 Appium。


### Android 应用测试的一些额外配置
1. 下载最新版的 Java JDK[这里](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)（记得先接受协议的许可）。设置 '**JAVA_HOME**' 为你的 JDK 路径。目录下的 bin 文件夹应该添加到你的 PATH 变量中。
2. 安装 Android SDK。将环境变量**ANDROID_HOME**设置为你的 Android SDK 路径
3. 将 **tools** 和 **platform-tools** 这两个文件夹添加到你的 PATH 变量中去。


### 下载模拟器(推荐使用：夜神模拟器)
1. [夜神模拟器下载](https://www.yeshen.com/)
2. 启动模拟器

```
程序启动模拟器，或在文件夹 kefu-auto-test\kefuapi-test\UI\KefuAPPUI ，执行批处理脚本启动：simulator_start.bat
$ start cmd /k "D:\Program Files\Nox\bin\Nox.exe"
```

3. adb 连接模拟器
```
$ adb connect 127.0.0.1:62001
```

### 启动Appium
1. 查看已连接设备

```
$ adb devices
```

2. 打开命令行，启动appium

```
$ appium -a 127.0.0.1 -p 4723 -bp 4724 -U 127.0.0.1:62001 --session-override --command-timeout 1200
```


---