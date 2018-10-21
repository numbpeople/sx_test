*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | ssocfg | 单点登录 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Force Tags        ssocfg
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/HomePage_Common/SSO_Common.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取单点登录配置(/v1/access/config)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【单点登录】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取单点登录配置，调用接口：/v1/access/config，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    ${apiResponse}    Get Access Config    ${AdminUser}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤2时，发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${apiResponse.describetion}

获取单点登录跳转的地址信息(/v1/access)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【单点登录】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取单点登录跳转的地址信息，调用接口：/v1/access，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    ${apiResponse}    Get Access    ${AdminUser}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤2时，发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${apiResponse.describetion}
