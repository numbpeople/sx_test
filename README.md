
# 客服自动化
客服自动化是一个企业级自动化项目，包含接口&UI自动化。致力于高效、低成本、可持续集成的理念，以达到一键构建、秒级运行、快速定位问题终极目标。

## 环境搭建:

1. 客服自动化使用robotframework测试自动化框架进行验收测试： [官网地址](http://robotframework.org/)
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
* pandas
  ...
```
4.在线安装依赖包

```
$ cd kefu-auto-test/kefuapi-test/
$ pip install -r requirements.txt
```



## 项目结构

自动化项目示意图：

![image](https://sandbox.kefu.easemob.com/v1/Tenant/11699/MediaFiles/8d06ec46-b4ff-489e-89b9-b42edfe96baeaW1hZ2UucG5n)

```
KFApiTestCase: 接口测试用例层，包含多个suite层级，每个suite层级包含多个测试用例

UI: UI测试用例suite以及测试用例

Commons：接口封装层、逻辑层

UICommons：UI各模块的逻辑层、客服路径、元素定位值等

API：API定义层，包含URI、接口参数、请求体等

Resource：用例中使用的文件，包括压缩包、图片文件等

Lib：使用python封装的其他方法，包括读文件、获取指定日期等函数

JsonDiff：json标准模板结构的定义

Testdata：生成/下载表格文件的暂存路径

AgentRes.robot: 定义客服登录地址、账号/密码、筛选字典、接口超时、重试次数等参数定义的资源文件
```


## 项目运行

* Ride工具: 界面点击运行按钮即可, 如下图:

![image](https://sandbox.kefu.easemob.com/v1/Tenant/11699/MediaFiles/cc4161e7-d48c-4e9a-b20d-d20c3dce0ab3aW1hZ2UucG5n)


* 命令行:

按照tag标记名称执行
```
$ cd kefu-auto-test/kefuapi-test/
$ pybot.bat --include baselogin --exclude tool --exclude org --exclude ui C:\Users\leo\git\kefu-auto-test\kefuapi-test

```


支持用例完毕后发送邮件和报告到邮箱

```
MyListener.py 脚本支持两个参数
    1、receive：接收邮件的邮箱地址，多个邮箱使用逗号隔开
    2、outpath：报告名称或目录地址
```
```
$ pybot.bat --listener C:\Users\leo\git\kefu-auto-test\kefuapi-test\lib\MyListener.py;leoli@easemob.com,zhukai@easemob.com;emailreport.html --include baselogin --exclude tool --exclude ui --exclude org  C:\Users\leo\git\kefu-auto-test\kefuapi-test

```



更多pybot参数介绍:
[pybot参数介绍](https://blog.csdn.net/huashao0602/article/details/72846217)

