
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

### Ride工具: 
- ##### 界面点击运行按钮即可, 如下图:

![image](https://kefu.easemob.com/v1/Tenant/634/MediaFiles/1684bef9-ef61-45ca-92fb-89aa9ea46a89aW1hZ2UucG5n)

- ##### 用例执行前，可以填写参数Arguments，例如：
```
--variable url:http://sandbox.kefu.easemob.com --variable username:lijipeng_1@qq.com --variable password:lijipeng123 --variable status:Online  --variable messageGateway: --variable orgName: --variable appName: --variable serviceEaseMobIMNumber: --variable restDomain:

```


### 命令行:
- ##### 使用pybot.bat 或 pybot 命令执行测试用例，例如：
```
$ pybot.bat --variable url:http://sandbox.kefu.easemob.com --variable username:lijipeng_1@qq.com --variable password:lijipeng123 --variable status:Online --variable messageGateway: --variable orgName: --variable appName: --variable serviceEaseMobIMNumber: --variable restDomain: --listener C:\Users\leo\git\kefu-auto-test\kefuapi-test\lib\MyListener.py;leoli@easemob.com;reportLog\emailreport.html;http://sandbox.kefu.easemob.com;lijipeng_1@qq.com;lijipeng123;Online -d C:\Users\leo\git\kefu-auto-test\kefuapi-test\reportLog --include debugChat --exclude tool --exclude ui --exclude appui --exclude org C:\Users\leo\git\kefu-auto-test\kefuapi-test

```
- ##### 命令行执行参数定义：

|参数名称|参数值举例|参数描述|建议|
| ---- | --- | --- | --- |
|--variable|url:http://sandbox.kefu.easemob.com|参数传递，设置客服系统登录地址变量|无|
|--listener|C:\Users\leo\git\kefu-auto-test\kefuapi-test\lib\MyListener.py|监听用例执行时的信息和结果|监听脚本支持参数。Windows系统参数之间使用分号分隔，Mac或Linux系统参数之间使用冒号分割|
|-d|C:\Users\leo\git\kefu-auto-test\kefuapi-test\reportLog|执行用例完成后生成的日志路径|无|
|--include|debugChat|仅执行标记为debugChat标签的用例集或用例|无|
|--exclude|tool|不执行标记为tool标签的用例集或用例|无|



- ##### 支持用例完毕后发送邮件和报告到邮箱，MyListener.py监听脚本参数定义：

|参数名称|参数值举例|参数描述|建议|
| ---- | --- | --- | --- |
|receive|leoli@easemob.com|接收邮件的邮箱地址，多个邮箱使用逗号隔开|无|
|outpath|reportLog\emailreport.html|测试报告邮件报告地址与名称|使用文件夹和邮件名称形式|
|url|http://sandbox.kefu.easemob.com|客服系统登录地址|Linux或Mac系统不加协议，即：//sandbox.kefu.easemob.com|
|username|lijipeng_1@qq.com|客服登录账号|无|
|password|lijipeng123|客服登录密码|无|
|status|Online|客服登录状态|取值范围：Online、Busy、Leave、Hidden|

- ##### Windows环境运行
```
$ cd kefu-auto-test/kefuapi-test/(进入到用例执行目录下)
$ pybot.bat --variable url:http://sandbox.kefu.easemob.com --variable username:lijipeng_1@qq.com --variable password:lijipeng123 --variable status:Online --variable messageGateway: --variable orgName: --variable appName: --variable serviceEaseMobIMNumber: --variable restDomain: --listener C:\Users\leo\git\kefu-auto-test\kefuapi-test\lib\MyListener.py;leoli@easemob.com;reportLog\emailreport.html;http://sandbox.kefu.easemob.com;lijipeng_1@qq.com;lijipeng123;Online -d C:\Users\leo\git\kefu-auto-test\kefuapi-test\reportLog --include debugChat --exclude tool --exclude ui --exclude appui --exclude org C:\Users\leo\git\kefu-auto-test\kefuapi-test

或执行运行脚本
$ ./start.bat

```
- ##### Mac或Linux环境运行
```
$ cd kefu-auto-test/kefuapi-test/ (进入到用例执行目录下)
$ pybot --variable url:http://sandbox.kefu.easemob.com --variable username:lijipeng_1@qq.com --variable password:lijipeng123 --variable status:Online --variable messageGateway: --variable orgName: --variable appName: --variable serviceEaseMobIMNumber: --variable restDomain: --listener /kefuapi-test/lib/MyListener.py:leoli@easemob.com:/kefuapi-test/reportLog/emailreport.html://sandbox.kefu.easemob.com:lijipeng_1@qq.com:lijipeng123:Online -d kefuapi-test/reportLog --include debugChat --exclude org --exclude tool --exclude ui --exclude appui kefuapi-test

或执行运行脚本
$ sh ./start.sh

```


###### 更多pybot参数介绍 : [pybot参数介绍](https://blog.csdn.net/huashao0602/article/details/72846217)



# Docker 搭建客服自动化环境

## 目的

使用Docker容器技术，以便于客服项目自动化可以在不同系统环境、不同团队、不同项目快速实施搭建、构建以及运行，执行完毕后将测试用报告发送给执行人员。以达到一键构建、秒级运行、快速定位问题终极目标

## 构建

```
$ cd kefu-auto-test (进入kefu-auto-test目录下)
$ docker build -t kf-docker .

或执行项目下的脚本
$ sh ./docker_build.sh

```

## 运行 

- #### Docker构建镜像后，执行测试用例
```
$ cd kefu-auto-test (进入kefu-auto-test目录下)
$ sudo docker run -v $CURDIR/$VOLUME_REPORT:/$REPORTFOLDERPATH -it --rm $DOCKER_IMAGE_NAME --variable url:${KEFUURL} --variable username:${USERNAME} --variable password:${PASSWORD} --variable status:${STATUS} --variable messageGateway:${MESSAGEGATEWAY} --variable orgName:${ORGNAME} --variable appName:${APPNAME} --variable serviceEaseMobIMNumber:${SERVICEEASEMOBIMNUMBER} --variable restDomain:${RESTDOMAIN} --listener $LISTENERPATH:$EMAIL_RECEIVE:$EMAILREPORTPATH:${DOCKER_KEFUURL}:${USERNAME}:${PASSWORD}:${STATUS} -d $REPORTFOLDERPATH $includetag $excludetag $ROBOT_TESTS

或执行项目下的脚本
$ sh ./docker_start.sh
```

- #### 使用已上传的镜像文件，执行测试用例
```
$ cd kefu-auto-test (进入kefu-auto-test目录下)
$ sudo docker run -v $CURDIR/$VOLUME_REPORT:/$REPORTFOLDERPATH -it --rm $DOCKER_IMAGE_NAME --variable url:${KEFUURL} --variable username:${USERNAME} --variable password:${PASSWORD} --variable status:${STATUS} --variable messageGateway:${MESSAGEGATEWAY} --variable orgName:${ORGNAME} --variable appName:${APPNAME} --variable serviceEaseMobIMNumber:${SERVICEEASEMOBIMNUMBER} --variable restDomain:${RESTDOMAIN} --listener $LISTENERPATH:$EMAIL_RECEIVE:$EMAILREPORTPATH:${DOCKER_KEFUURL}:${USERNAME}:${PASSWORD}:${STATUS} -d $REPORTFOLDERPATH $includetag $excludetag $ROBOT_TESTS

或执行项目下的脚本
$ sh ./docker_start_easemob_registry.sh.sh

```
```
Docker镜像已经上传到公司镜像仓库中
使用该镜像执行Docker客服自动化，可参照README_DOCKER.md文档说明
```



- #### 执行docker_start.sh 或 docker_start_easemob_registry.sh脚本中，参数定义：


|参数名称|参数值|参数描述|建议|必填|
| ---- | --- | --- | --- | --- |
|EMAIL_RECEIVE|leoli@easemob.com,zhukai@easemob.com|接收测试报告的邮箱账号，多个邮箱账号使用逗号隔开|无|是|
|KEFUURL|http://sandbox.kefu.easemob.com|客服登录地址|Linux或Mac系统不加协议，即：//sandbox.kefu.easemob.com|是|
|USERNAME|lijipeng_1@qq.com|客服可登录的坐席邮箱账号|无|是|
|PASSWORD|llijipeng123|客服登录账号的密码|无|是|
|STATUS|Online|客服登录状态|无|是|
|INCLUED_TAG|debugChat|执行用例的Tag标签名称，多个标签使用逗号隔开|若需要全部执行用例，可以不填写值|否|
|EXCLUED_TAG|org,tool,ui,appui|不执行用例的Tag标签名称|若需要全部执行用例，该四个值需要填写不要修改|是|
|VOLUME_REPORT|autotest_report|在docker执行的宿主机上挂载挂在的文件夹，存放执行测试用例的报告|无|是|
|EMAIL_FILENAME|emailreport.html|接收测试报告HTML文件名称，建议使用英文，暂时仅支持html格式|并且不建议使用report.html、log.html，例如：emailreport.html|是|
|MESSAGEGATEWAY|im|访客进行发消息时，选取的消息渠道来源，im：使用IM的rest接口发送消息，secondGateway：使用客服的第二通道接口发送消息|无|否|
|ORGNAME|sipsoft|使用租户下已有的关联发消息，orgName为关联下的组织名称|无|否|
|APPNAME|sandbox|使用租户下已有的关联发消息，appName为关联下的应用名称|无|否|
|SERVICEEASEMOBIMNUMBER|117497|使用租户下已有的关联发消息，serviceEaseMobIMNumber为关联的IM服务号|无|否|
|RESTDOMAIN|a1.esemob.com|使用租户下已有的关联发消息，restDomain为appkey所属集群rest地址|无|否|
