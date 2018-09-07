*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/HomePage_Common/SSO_Common.robot

*** Test Cases ***
获取单点登录配置(/v1/access/config)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【单点登录】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取单点登录配置，调用接口：/v1/access/config，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    ${j}    Get Access Config    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${j}

获取单点登录跳转的地址信息(/v1/access)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【单点登录】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取单点登录跳转的地址信息，调用接口：/v1/access，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    ${j}    Get Access    ${AdminUser}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${j}
