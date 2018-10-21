*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | 无 | 呼叫中心 | 数据库插入数据 | 无 |
Force Tags        phone
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Channels/Phone_Common.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取单个坐席呼叫中心配置属性(/v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【呼叫中心】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取单个坐席呼叫中心配置属性，调用接口：/v1/tenants/{tenantId}/agents/{agentId}/callcenter-attrs，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #获取坐席绑定呼叫中心的数据
    ${apiResponse}    Get Agent Phone Data    ${AdminUser}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤2时，发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    '${j['status']}'    'OK'    步骤3时，callcenter属性数据不正确：${apiResponse.describetion}

获取呼叫中心信息(/v1/tenants/{tenantId}/phone-tech-channel)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【呼叫中心】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取呼叫中心信息，调用接口：/v1/tenants/{tenantId}/phone-tech-channel，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    ${apiResponse}    Get PhoneTechChannel    ${AdminUser}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤2时，发生异常，状态不等于200：${apiResponse.describetion}
