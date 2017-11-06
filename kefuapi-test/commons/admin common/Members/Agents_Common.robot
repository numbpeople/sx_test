*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/KefuApi.robot
Resource          ../../../api/RoutingApi.robot
Resource          ../../../api/SystemSwitch.robot
Resource          ../../../api/SessionCurrentApi.robot

*** Keywords ***
Get Agents
    [Documentation]    获取所有客服信息，返回username和userId的字典集
    ###查询坐席信息
    &{agentList}    create dictionary
    set to dictionary    ${AgentFilterEntity}    size=100
    ${resp}=    /v1/Admin/Agents    get    ${AdminUser}    ${AgentFilterEntity}    ${EMPTY}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j['content']}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${username}=    convert to string    ${j['content'][${i}]['username']}
    \    log    ${username}
    \    set to dictionary    ${agentList}    ${username}=${j['content'][${i}]['userId']}
    Return From Keyword    ${agentList}

Delete Agent
    [Arguments]    ${userId}
    [Documentation]    删除客服，参数为客服userId
    ${resp}=    /v1/Admin/Agents/{userId}    ${AdminUser}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}
