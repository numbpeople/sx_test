*** Settings ***
Suite Setup
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Conversations/AgentsApi.robot

*** Test Cases ***
获取坐席信息(/agents/{agentId})
    set test variable    ${tadmin}    ${AdminUser}
    set test variable    ${data}    ${empty}
    ${resp}=    /agents/{agentId}    get    ${tadmin}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

获取坐席会话信息(/agents/{agentId}/sessions)
    set test variable    ${tadmin}    ${AdminUser}
    ${resp}=    /agents/{agentId}/sessions    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

获取坐席接待过的访客列表(/agents/{agentId}/visitors)
    set test variable    ${tadmin}    ${AdminUser}
    ${resp}=    /agents/{agentId}/visitors    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

获取坐席所在的技能组列表(/agents/{agentId}/skillgroups)
    set test variable    ${tadmin}    ${AdminUser}
    ${resp}=    /agents/{agentId}/skillgroups    ${tadmin}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

获取会话详情(/agents/{sessionId})
    [Tags]    unused
    set test variable    ${tadmin}    ${AdminUser}
    ${resp}=    /agents/{sessionId}    ${tadmin}    ${sessionId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

获取会话消息(/agents/{sessionId}/messages)
    [Tags]    unused
    set test variable    ${tadmin}    ${AdminUser}
    ${resp}=    /agents/{sessionId}/messages    ${tadmin}    ${sessionId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
