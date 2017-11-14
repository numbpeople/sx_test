*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/SingleSignOnApi.robot

*** Test Cases ***
获取单点登录(/v1/access/config)
    ${resp}=    /v1/access/config    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取单点登录失败：${resp.content}
