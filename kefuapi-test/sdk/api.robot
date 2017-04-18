*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../AgentRes.robot
Resource          ../api/SDKApi.robot
Resource          ../JsonDiff/KefuJsonDiff.robot

*** Test Cases ***
获取同事列表(/v1/Agents/me/Agents)
    [Tags]    sdk
    ${resp}=    /v1/Agents/me/Agents    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    Run Keyword If    ${j}==[]    log    没有同事列表
    ...    ELSE    Should Be Equal    '${j[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    获取同事列表失败
