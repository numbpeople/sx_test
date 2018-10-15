
# Docker 搭建客服自动化环境

## 目的

- 使用Docker容器技术，以便于客服项目自动化可以在不同系统环境、不同团队、不同项目快速实施搭建、构建以及运行，执行完毕后将测试用报告发送给执行人员。以达到一键构建、秒级运行、快速定位问题终极目标


## Docker运行

#### 1. 下载执行docker运行的脚本，上传到部署了docker机器上
#### 2. 根据被测客服系统环境信息，vi 或 vim 修改docker_start_easemob_registry.sh脚本中的参数，例如：

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/53a70200-0b62-43d2-9d9e-c9dd07746f97aW1hZ2UucG5n)
#### 3. 保存脚本后，执行sh ./docker_start_easemob_registry.sh，如第一次执行脚本，会看到如下截图：

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/0da9a2e4-6fce-4384-8a8d-d145f291d9d5aW1hZ2UucG5n)
#### 4.下载完成后，会自动执行测试用例，看到如下截图：

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/85fb8f47-08e4-47d6-abe1-32be736ce0d6aW1hZ2UucG5n)

#### 5.测试用例执行完毕后，会给脚本中配置的EMAIL_RECEIVE邮箱地址发一封测试报告邮件信息，看到如下截图：
![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/c6e981e6-77e4-45a4-9eba-c4e3ab5538a7aW1hZ2UucG5n)

#### 6.至此docker执行客服自动化已完毕
![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/c6e981e6-77e4-45a4-9eba-c4e3ab5538a7aW1hZ2UucG5n)



### 特别注意：

- ##### 如若私有环境不支持外网，只允许内网测试，则可能出现邮件发送不出情况，为了避免该情况，则可以在脚本配置VOLUME_REPORT参数。
- ##### 该参数定义：docker宿主机上，与docker_start_easemob_registry.sh 脚本相同目录下，会自动创建文件夹，测试报告会同步到该文件夹下，可以自己导出测试报告。

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/530fe08a-a389-40b5-808b-887bde88858baW1hZ2UucG5n)



## 脚本参数定义 

- #### 执行docker_start_easemob_registry.sh脚本中，参数定义：


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

