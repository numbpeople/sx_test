*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/MicroService/WebGray/WebGrayApi.robot

*** Test Cases ***
获取灰度列表(/v1/grayscale/tenants/{tenantId})
    ${resp}=    /v1/grayscale/tenants/{tenantId}    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['status']}'    'OK'    不正确的返回值：${j}
