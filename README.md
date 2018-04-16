
# 客服自动化
客服自动化是一个针对客服系统内所有模块以及接口，编写包括接口&&UI自动化项目

## 环境搭建:

1. 客服自动化使用robotframework工具进行编写：http://robotframework.org/
2. 使用GIT下载项目： https://github.com/easemob/kefu-auto-test
3. 安装依赖:

	* python
	* steuptools
	* pip
	* Robot Framework
	* wxPython
	* robotframework-ride
	* robotframework-requests
	* robotframework-selenium2library


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

* Ride工具:
  界面点击运行按钮即可

* 命令行:
  pybot.bat --include baselogin --exclude tool --exclude org --exclude ui C:\Users\leo\git\kefu-auto-test\kefuapi-test

更多pybot参数介绍 
[pybot参数介绍](https://blog.csdn.net/huashao0602/article/details/72846217)



