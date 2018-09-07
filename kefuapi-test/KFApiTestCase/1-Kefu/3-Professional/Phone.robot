*** Settings ***
Default Tags      phone
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
    ${j}    Get Agent Phone Data    ${AdminUser}
    Should Be Equal    '${j['status']}'    'OK'    callcenter属性数据不正确：${j}

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
    ${j}    Get PhoneTechChannel    ${AdminUser}
    # Run Keyword If    ${j}==[]    log    无呼叫中心信息
    # ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    呼叫中心信息不正确：${j}
