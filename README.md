
# IM自动化
IM自动化是一个企业级自动化项目，包含接口&UI自动化。致力于高效、低成本、可持续集成的理念，以达到一键构建、秒级运行、快速定位问题终极目标。

## 环境搭建:

1. IM服自动化使用robotframework测试自动化框架进行验收测试： [官网地址](http://robotframework.org/)
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
  ...
```
4.在线安装依赖包

```
$ cd C:\Users\leo\git\IM-auto-test
$ pip install -r requirements.txt
```

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




