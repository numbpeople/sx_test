*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Members/Agent_Api.robot
Library           uuid
Resource          ../../../api/BaseApi/Settings/PermissionApi.robot

*** Keywords ***
Get Agents
    [Documentation]    获取所有客服信息，返回username和userId的字典集
    ###查询坐席信息
    &{agentList}    create dictionary
    set to dictionary    ${AgentFilterEntity}    size=100
    ${resp}=    /v1/Admin/Agents    get    ${AdminUser}    ${AgentFilterEntity}    ${EMPTY}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    run keyword if    ${resp.status_code}!=200    log    测试用例集名称:${SUITE NAME}、调用方法:Get Agents、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
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
    run keyword if    ${resp.status_code}!=204    log    测试用例集名称:${SUITE NAME}、调用方法:Delete Agent、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR

Delete AgentUser
    [Arguments]    ${userId}    ${agent}=${AdminUser}
    [Documentation]    删除客服，参数为客服userId
    ${resp}=    /v6/Admin/Agents/{userId}    ${agent}    ${userId}    ${timeout}
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
    \    Run Keyword If    '${status}' == 'True'    Delete Agent    ${userIdValue}

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
    &{AgentUser}=    create dictionary    username=${t}@t.cn    password=test2015    maxServiceSessionCount=10    tenantId=${agent.tenantId}
    ${roles}    set variable if    ${permissionid} == 1    admin,agent    agent
    ${data}=    set variable    {"nicename":"${AgentUser.username}","username":"${AgentUser.username}","password":"${AgentUser.password}","confirmPassword":"${AgentUser.password}","trueName":"trueName","mobilePhone":"13800138000","agentNumber":"","maxServiceSessionCount":"${AgentUser.maxServiceSessionCount}","permission":"${permissionid}","roles":"${roles}"}
    ${resp}=    /v1/Admin/Agents    post    ${agent}    ${empty}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.text}
    ${data}    set variable    {"role_ids":[${permissionid}]}
    ${resp}=    /v1/permission/tenants/{tenantId}/users/{userId}/roles    ${agent}    ${data}    ${j['userId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    [Return]    ${AgentUser}

Create Specify Agent
    [Arguments]    ${agent}
    [Documentation]    创建管理员账号包含租户id的客服
    #设置局部变量
    ${uuid}    Uuid 4
    ${name}    set variable    ${agent.tenantId}${uuid}
    &{agentAccount}=    create dictionary    username=${name}@qq.com    password=lijipeng123    maxServiceSessionCount=10    nicename=${name}    permission=1
    ...    roles=admin,agent
    ${data}=    set variable    {"nicename":"${agentAccount.nicename}","username":"${agentAccount.username}","password":"${agentAccount.password}","confirmPassword":"${agentAccount.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${agentAccount.maxServiceSessionCount}","permission":${agentAccount.permission},"roles":"${agentAccount.roles}"}
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #新增坐席
    ${j}    Set Agents    post    ${agent}    ${agentFilter}    ${data}
    should be equal    ${j['username']}    ${agentAccount.username}    接口客服列表返回值中的username字段不正确，${j}
    should be equal    ${j['nicename']}    ${agentAccount.nicename}    接口客服列表返回值中的nicename字段不正确，${j}
    should be equal    ${j['tenantId']}    ${agent.tenantId}    接口客服列表返回值中的tenantId字段不正确，${j}
    should be equal    ${j['state']}    Offline    接口客服列表返回值中的state字段不正确，${j}
    should be equal    ${j['status']}    Enable    接口客服列表返回值中的Enable字段不正确，${j}
    should be equal    ${j['maxServiceSessionCount']}    ${${agentAccount.maxServiceSessionCount}}    接口客服列表返回值中的maxServiceSessionCount字段不正确，${j}
    should be equal    ${j['roles']}    ${agent.roles}    接口客服列表返回值中的roles字段不正确，${j}
    set to dictionary    ${agentAccount}    agentUserId=${j['userId']}    state=${j['state']}    status=${j['status']}
    return from keyword    ${agentAccount}

Download Agent Data
    [Arguments]    ${agent}    ${filter}    ${language}=zh-CN
    [Documentation]    导出客服信息
    ...    ${language}:值为en-US或zh-CN
    ${resp}=    /v1/Admin/Agents/file    ${agent}    ${filter}    ${language}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    【实际结果】：导出客服信息，返回实际状态码：${resp.status_code}，调用接口：${resp.url}，接口返回值：${resp.text}
    return from keyword    ${resp}

Create Agent And Download Data
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    1、创建坐席 2、导出客服信息
    #设置局部变量
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    ${agentInfo}    Create Specify Agent    ${agent}
    #设置导出该创建的客服数据
    set to dictionary    ${agentFilter}    keyValue=${agentInfo.username}
    Download Agent Data    ${agent}    ${agentFilter}    ${language}
    return from keyword    ${agentInfo}
