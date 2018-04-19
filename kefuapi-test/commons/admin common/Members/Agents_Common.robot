*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Members/Agent_Api.robot
Library           uuid

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
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code},${resp.text}

Delete AgentUser
    [Arguments]    ${userId}
    [Documentation]    删除客服，参数为客服userId
    ${resp}=    /v6/Admin/Agents/{userId}    ${AdminUser}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Delete Agentusers
    #设置客服账号名称模板
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #获取所有客服列表
    ${agentlist}=    Get Agents    #返回字典
    ${userNameList}=    Get Dictionary Keys    ${agentlist}
    ${listlength}=    Get Length    ${userNameList}
    log    ${agentlist}
    #循环判断技能组名称是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${username}=    convert to string    ${userNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}=    Get From Dictionary    ${agentlist}    ${userNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Agent   ${userIdValue}

Set Agents
    [Arguments]    ${method}    ${agent}    ${agentFilter}    ${data}
    [Documentation]    对客服模块的增和查操作
    #对客服模块的增和查操作
    ${resp}=    /v1/Admin/Agents    ${method}    ${agent}    ${agentFilter}    ${data}    ${timeout}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='get'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}
    
Create Agent
    [Arguments]    ${agent}    ${agentFilter}    ${data}
    [Documentation]    创建一个坐席
    #新增坐席
    ${j}    Set Agents    post    ${agent}    ${agentFilter}    ${data}
    return from keyword    ${j}

Create Temp Agent
    [Arguments]    ${agent}    ${permissionid}    #permissionid : 1为管理员；2为坐席；以后为自定义角色
    ${t}    UUID 4
    &{AgentUser}=    create dictionary    username=${t}    password=test2015    maxServiceSessionCount=10    tenantId=${agent.tenantId}
    ${data}=    set variable    {"nicename":"${AgentUser.username}","username":"${AgentUser.username}@qq.com","password":"${AgentUser.password}","confirmPassword":"${AgentUser.password}","trueName":"trueName","mobilePhone":"13800138000","agentNumber":"","maxServiceSessionCount":"${AgentUser.maxServiceSessionCount}","permission":"${permissionid}","roles":"agent"}
    ${resp}=    /v1/Admin/Agents    post    ${agent}    ${empty}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${agent}
    return from keyword    {"tenantId":5833,"userId":"092b9776-438e-4d54-ae21-c536a1affdcd","userType":"Agent","userScope":"Tenant","nicename":"fs","password":"","username":"0216l9@test.com","roles":"admin,agent","createDateTime":"2018-03-23 17:49:47","lastUpdateDateTime":"2018-03-23 17:49:47","status":"Enable","state":"Offline","maxServiceSessionCount":10,"trueName":"","mobilePhone":"","agentType":"Message","language":"zh_CN","timeZone":"UTC+8","bizId":"5833","scope":"Tenant","onLineState":"Offline","currentOnLineState":"Offline"}
