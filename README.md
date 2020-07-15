
# IM自动化
IM自动化是一个企业级自动化项目，包含接口&UI自动化。致力于高效、低成本、可持续集成的理念，以达到一键构建、秒级运行、快速定位问题终极目标。

## 环境搭建:

1. IM自动化使用robotframework测试自动化框架进行验收测试： [官网地址](http://robotframework.org/)
2. 使用GIT下载项目： https://github.com/easemob/kefu-auto-test/tree/im-auto-test
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
* robotframework-pabot
  ...
```
4.在线安装依赖包

```
$ cd C:\Users\leo\git\IM-auto-test
$ pip install -r requirements.txt
```

---

## 项目结构

自动化项目示意图：

![image](https://kefu.easemob.com/v1/Tenant/634/MediaFiles/29a8874e-b60f-429e-a1dd-5e943f14b974aW1hZ2UucG5n)


```
RestTestCase: 接口测试用例层，包含多个suite层级，每个suite层级区分不同模块，例如：App管理、用户管理等

Common：接口封装层、逻辑层

RestApi：API定义层，包含URI、接口参数、请求体等

Result：测试用例对比的预期返回结构

Variable_Env.robot: 定义了用例执行的Rest地址、登录账号密码、指定超管Token和Appkey信息等参数定义的资源文件
```

---


## 项目配置方式

当前IM自动化项目支持以下两个配置方式运行用例：

- 环信Console管理后台账号和密码执行用例

```
使用环信Console管理后台已存在的【管理员登录邮箱和密码】，执行用例会创建新的应用来执行所有测试用例

执行用例范围：用例将执行每条测试用例中除去最后一条数据的所有测试数据
```

![image](https://kefu.easemob.com/v1/Tenant/634/MediaFiles/c95647b2-4eea-44d6-abb2-757e22c10761Y29uc29sZeaJp-ihjOaWueW8jy5wbmc=)


- 环信Console管理后台账号/密码和指定Appkey执行用例

```
使用环信Console管理后台账号/密码 + 指定Appkey 执行所有测试用例

执行用例范围：用例将执行每条测试用例中除去最后一条数据的所有测试数据
```
![image](https://kefu.easemob.com/v1/Tenant/634/MediaFiles/c95647b2-4eea-44d6-abb2-757e22c10761Y29uc29sZeaJp-ihjOaWueW8jy5wbmc=)

![image](https://kefu.easemob.com/v1/Tenant/634/MediaFiles/bcae4ee6-a6db-470c-a888-7d89dfe9b896aW1hZ2UucG5n)


- 指定Appkey和超管Token执行用例

```
设置范围：需要设置&{RunModelCaseConditionDic}变量中specificBestToken、orgName、appName

执行用例范围：用例将仅执行每条测试用例中最后一条测试数据，其他测试数据将忽略
```
![image](https://kefu.easemob.com/v1/Tenant/634/MediaFiles/77e94d89-a5fe-4670-be14-8ba30efd712a5oyH5a6aYXBwa2V55omn6KGMLnBuZw==)


---

## 项目运行
支持ride页面启动与命令行执行用例，命令行模式下：

- 单线程模式
```
pybot -d C:\Users\leo\git\IM-auto-test\log C:\Users\leo\git\IM-auto-test
```
- 多线程模式
```
pabot --pabotlib --processes 16 -d C:\Users\leo\git\IM-auto-test\log C:\Users\leo\git\IM-auto-test
```


#### 其中 ==*--processes*== 参数后需要填写用例suite集并发数


---

## Variable_Env变量参数的定义


|参数名称|参数值举例|参数描述|
| ---- | --- | --- |
|&{RestRes}|RestUrl=${URLDeclare.rest1_sdb}、username=leoli@easemob.com、password=lijipeng123|测试环境、console登录账号密码配置|
|&{URLDeclare}|bj=https://a1.easemob.com|定义了常用的Rest集群地址|
|&{RunModelCaseConditionDic}|orgName=sipsoft、appName=sandbox、specificBestToken=YWMtzyUm6ItOEemUEgcakCE-pgAAAAAAAAAAAAAAAAAAAAFe2JYa1n8R45heowo6U5LUAQMAAAFrQDk7fQBPGgDzCSzjnyAlJr1bFVAh7729xKey1_D2gZ7JMRqZZ6Pk8g|指定Appkey场景下配置的Appkey信息和超管token，该配置优先于console后台账号密码配置|
|${timeout}|${30.0}|接口超时时间设置|

---

## 特需场景配置：


1. 仅需要使用OrgToken执行所有正常测试用例，不想其他异常case，例如：token为空，或contentType为空下场景的case

```
需要设置&{ModelCaseRunStatus}变量中变量各个参数的值

例如：
1、OrgToken_ContentType：代表OrgToken和ContentType不为空，值${RunStatus.RUN}或${RunStatus.NORUN}，分别代表执行或不执行

2、EmptyOrgToken_EmptyContentType：代表OrgToken和ContentType均为空，值${RunStatus.RUN}或${RunStatus.NORUN}，分别代表执行或不执行

```
