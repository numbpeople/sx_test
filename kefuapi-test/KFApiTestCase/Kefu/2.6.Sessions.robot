*** Settings ***
Suite Setup
Force Tags        base    unused
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Library           urllib
Resource          ../../AgentRes.robot
Resource          ../../api/BaseApi/Conversations/AgentsApi.robot
Resource          ../../api/BaseApi/Conversations/SessionsApi.robot

*** Test Cases ***
获取所有的当前会话(/sessions)
    set test variable    ${tadmin}    ${AdminUser}
    ${resp}=    /sessions    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
