# 环境部署安装（iOS模拟器）

## 一、安装appium
1. 安装node-js  
https://nodejs.org/en/download/ 下载 macOS Installer (.pkg) 安装
2. 安装appium的app和命令行(两个都需要)   
    2.1：https://github.com/appium/appium-desktop/releases 下载dmg格式文件安装 Appium.app
    2.2：命令行安装 npm install -g appium

## 二、iOS模拟器安装
1. 安装Xcode 9
从App Store下载安装或升级
2. 安装iOS模拟器  
安装完Xcode会默认安装最新版本系统的iOS模拟器，如需其它版本的可通过Xcode-Preferences-Components-Simulators下载  
    1)、点击模拟器的下载按钮  
    2)、打开系统帮助工具Console  
    3)、在Xcode里取消下载，然后会在Console里面看到对应的下载地址(对应的 Console Message是 DVTDownloadable: Download Cancelled. Downloadable: ...之类的)
    4)、复制对应的链接地址到某雷或者任何比Xcode下载快的工具里进行下载  ($ wget https://devimages-cdn.apple.com/downloads/xcode/simulators/com.apple.pkg.iPhoneSimulatorSDK10_2-10.2.1.1484185528.dmg)
    5)、下载完成进入 打开Finder 前往文件夹(cmd+Shift+g)  $HOME/Library/Caches
    6)、找到com.apple.dt.Xcode文件,右击选择Show Packages Contents  
    7)、进入Downloads目录(如果没有,则手动创建一个Downloads目录)  
    8)、将下载好的文件移到Downloads目录  
    9)、重启Xcode，回到Xcode下载模拟器界面，点击对应下载好的Simulator，大功告成

## 三、安装appium相关依赖
1. 安装homebrew  
终端运行如下命令安装 ruby -e"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
2. 安装Carthage  
brew install carthage
3. 安装webpack  
npm install -g webpack
4. Python（Mac系统已自带，无需再另外安装  ）
5. 安装pip 运行运行脚本机  
sudo easy_install pip
6. 安装Appium-Python-Client  
pip install Appium-Python-Client

7. 安装 WebDriverAgent相关依赖
  
```
cd /usr/local/lib/node_modules/appium/node_modules/appium-xcuitest-driver/WebDriverAgent/
mkdir -p Resources/WebDriverAgent.bundle  
./Scripts/bootstrap.sh -d  
```

8. 安装 Xcode Command Line Tools : `xcode-select --install`

9. 终端运行appium-doctor查看需要的依赖是否安装  

```
$ npm install -g appium-doctor
$ appium-doctor
info AppiumDoctor Appium Doctor v.1.4.2
info AppiumDoctor ### Diagnostic starting ###
info AppiumDoctor  ✔ The Node.js binary was found at: /usr/local/bin/node
info AppiumDoctor  ✔ Node version is 4.5.0
info AppiumDoctor  ✔ Xcode is installed at: /Applications/Xcode.app/Contents/Developer
info AppiumDoctor  ✔ Xcode Command Line Tools are installed.
info AppiumDoctor  ✔ DevToolsSecurity is enabled.
info AppiumDoctor  ✔ The Authorization DB is set up properly.
info AppiumDoctor  ✔ Carthage was found at: /usr/local/bin/carthage
info AppiumDoctor  ✔ HOME is set to: /Users/wenke
WARN AppiumDoctor  ✖ ANDROID_HOME is NOT set!
info AppiumDoctor  ✔ JAVA_HOME is set to: /Library/Java/JavaVirtualMachines/jdk1.8.0_40.jdk/Contents/Home
WARN AppiumDoctor  ✖ adb could not be found because ANDROID_HOME is NOT set!
WARN AppiumDoctor  ✖ android could not be found because ANDROID_HOME is NOT set!
WARN AppiumDoctor  ✖ emulator could not be found because ANDROID_HOME is NOT set!
WARN AppiumDoctor  ✖ Bin directory for $JAVA_HOME is not set
info AppiumDoctor ### Diagnostic completed, 5 fixes needed. ###
info AppiumDoctor
info AppiumDoctor ### Manual Fixes Needed ###
info AppiumDoctor The configuration cannot be automatically fixed, please do the following first:
WARN AppiumDoctor - Manually configure ANDROID_HOME.
WARN AppiumDoctor - Manually configure ANDROID_HOME and run appium-doctor again.
WARN AppiumDoctor - Add '$JAVA_HOME/bin' to your PATH environment
info AppiumDoctor ###
info AppiumDoctor
info AppiumDoctor Bye! Run appium-doctor again when all manual fixes have been applied!
info AppiumDoctor
```

## 四、 查找元素工具安装及使用（App Inspector）
1. 安装macaca-cli  
npm install macaca-cli -g
2. 安装 app-inspector  
npm install app-inspector -g
3. 获取设备ID  
方法一：终端运行命令 xcrun simctl list，从== Devices ==列表里选择对应系统和型号设备ID  
方法二：打开模拟器，从菜单中打开 Hardware - devices - manage devices
4. 启动app-inspector  
终端运行命令 app-inspector -u YOUR-DEVICE-ID
出现inspector start at: http://172.17.1.154:5678
然后在浏览器（推荐使用Chrome浏览器）里面打开输出的链接：http://172.17.1.154:5678 

# 执行测试
1. 启动终端，执行以下命令开启appium  
appium 
2. 修改auto_ui_ios_multi_devices.py脚本 start_demo() 用例里的uuid和deviceName，然后运行脚本auto_ui_ios_multi_devices.py


```
如果有报错:
selenium.common.exceptions.WebDriverException: Message: Parameters were incorrect. We wanted {"required":["value"]} and you sent ["text","sessionId","id","value"]

原因是selenium版本3.4.3不兼容
解决办法:
pip uninstall selenium  
pip install selenium==3.3.1
```
