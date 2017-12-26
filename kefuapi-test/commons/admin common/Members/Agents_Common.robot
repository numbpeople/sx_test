*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Members/Agent_Api.robot

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

Delete AgentUser
    [Arguments]    ${userId}
    [Documentation]    删除客服，参数为客服userId
    ${resp}=    /v6/Admin/Agents/{userId}    ${AdminUser}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Set Agents
    [Arguments]    ${method}    ${agent}    ${agentFilter}    ${data}
    [Documentation]    对客服模块的增和查操作
    #对客服模块的增和查操作
    ${resp}=    /v1/Admin/Agents    ${method}    ${agent}    ${agentFilter}    ${data}    ${timeout}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='get'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}
