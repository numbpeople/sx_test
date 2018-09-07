*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/SDK/SDKApi.robot
Resource          ../../JsonDiff/KefuJsonDiff.robot

*** Test Cases ***
获取同事列表(/v1/Agents/me/Agents)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取图片验证码，调用接口：/v1/Agents/me/Agents，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    ${resp}=    /v1/Agents/me/Agents    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==[]    log    没有同事列表
    ...    ELSE    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取同事列表失败
