*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../../api/BaseApi/Members/Queue_Api.robot
Resource          Agents_Common.robot

*** Variables ***

*** Keywords ***
Add Agentqueue
    [Arguments]    ${agentqueue}    ${queueName}
    [Documentation]    创建一个技能组，返回该技能组的id和名字
    ...
    ...    describtion：参数技能组名字
    ...
    ...    返回值：
    ...
    ...    queueId、queueName
    #添加技能组
    ${data}=    set variable    {"queueName":"${queueName}"}
    ${resp}=    /v1/AgentQueue    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    技能组列表数据不正确：${resp.content}
    set to dictionary    ${agentqueue}    queueId=${j['queueId']}
    Return From Keyword    ${agentqueue}

Create Agentqueue
    [Arguments]    ${queueName}    ${agent}=${Adminuser}
    [Documentation]    创建一个技能组，返回该技能组的id和名字
    ...
    ...    describtion：参数技能组名字
    ...
    ...    返回值：
    ...
    ...    queueId、queueName
    #添加技能组
    ${data}=    set variable    {"queueName":"${queueName}"}
    ${agentqueue}    create dictionary    queueName=${queueName}
    ${resp}=    /v1/AgentQueue    post    ${agent}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    '${j['tenantId']}'    '${agent.tenantId}'    技能组列表数据不正确：${resp.content}
    set to dictionary    ${agentqueue}    queueId=${j['queueId']}
    Return From Keyword    ${agentqueue}

Set Queue Agents
    [Arguments]    ${agent}    ${userIds}    ${queueId}
    [Documentation]    设置技能组坐席列表
    ...
    ...    describtion：包含字段
    ...
    ...    agent:指定调用接口的agent变量
    ...    userIds:需要设置的用户id列表，格式为list，如：["ccd08c6b-ef15-4380-89cd-c362e8ee11f4","b02ccf78-d5cc-4a81-9890-753a56d1f4ce"] 或 ["ccd08c6b-ef15-4380-89cd-c362e8ee11f4"]
    ...    queueId：需要添加的到的技能组id
    #添加坐席到技能组
    ${resp}=    /v1/AgentQueue/{queueId}/AgentUser    ${agent}    ${queueId}    ${userIds}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Delete Agentqueue
    [Arguments]    ${queueId}    ${agent}=${AdminUser}
    [Documentation]    删除技能组，参数为技能组Id
    #删除新增技能组
    ${resp}=    /v1/AgentQueue/{queueId}    ${agent}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Delete Queues
    #设置技能组名称模板
    ${preQueuename}=    convert to string    ${AdminUser.tenantId}
    #获取所有技能组列表
    ${queuelist}=    Get Agentqueue    #返回字典
    ${queueNameList}=    Get Dictionary Keys    ${queuelist}
    ${listlength}=    Get Length    ${queueNameList}
    log    ${queuelist}
    #循环判断技能组名称是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${queueName}=    convert to string    ${queueNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${queueName}    ${preQueuename}
    \    ${queueIdValue}=    Get From Dictionary    ${queuelist}    ${queueNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Agentqueue    ${queueIdValue}

Get Agentqueue
    [Documentation]    获取所有技能组信息，返回queueName和queueId的字典集
    ###获取技能组
    &{queueList}    create dictionary
    ${resp}=    /v1/AgentQueue    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${queueName}=    convert to string    ${j[${i}]['agentQueue']['queueName']}
    \    log    ${queueName}
    \    set to dictionary    ${queueList}    ${queueName}=${j[${i}]['agentQueue']['queueId']}
    Return From Keyword    ${queueList}

Get Time-Options
    [Arguments]    ${agent}    ${queueId}
    [Documentation]    获取技能组时间和开关设置
    #获取技能组时间和开关设置
    ${resp}=    /v1/tenants/{tenantId}/skillgroups/{queueId}/time-options    ${agent}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Add Agents To Queue
    [Arguments]    ${agent}    ${queueId}    ${agentslist}
    [Documentation]    添加坐席到技能组
    #添加坐席到技能组
    ${resp}=    /v1/AgentQueue/{queueId}/AgentUser    ${agent}    ${queueId}    ${agentslist}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Get Queue Members
    [Arguments]    ${agent}    ${queueId}
    [Documentation]    获取技能组内的客服成员
    #获取技能组内的客服成员
    ${resp}=    /v2/tenants/{tenantId}/agents    ${agent}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Set Agents To Queue
    [Documentation]    创建技能组和坐席，并将坐席设置到技能组里
    ...
    ...    return：
    ...
    ...    queueId、queueName、${agent}字典（包含如下信息）
    ...
    ...    username、password、maxServiceSessionCount、nicename、permission、roles、agentId
    #创建技能组
    ${curTime}    Uuid 4
    ${queueName}    set variable    ${AdminUser.tenantId}${curTime}
    ${queue}    Create Agentqueue    ${queueName}
    #设置局部变量
    ${name}    set variable    ${AdminUser.tenantId}${curTime}
    &{agent}=    create dictionary    username=${name}@qq.com    password=lijipeng123    maxServiceSessionCount=10    nicename=${name}    permission=1
    ...    roles=admin,agent
    ${data}=    set variable    {"nicename":"${agent.nicename}","username":"${agent.username}","password":"${agent.password}","confirmPassword":"${agent.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${agent.maxServiceSessionCount}","permission":${agent.permission},"roles":"${agent.roles}"}
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #新增坐席
    ${j}    Set Agents    post    ${AdminUser}    ${agentFilter}    ${data}
    should be equal    ${j['username']}    ${agent.username}    接口客服列表返回值中的username字段不正确，${j}
    should be equal    ${j['nicename']}    ${agent.nicename}    接口客服列表返回值中的nicename字段不正确，${j}
    should be equal    ${j['tenantId']}    ${AdminUser.tenantId}    接口客服列表返回值中的tenantId字段不正确，${j}
    should be equal    ${j['state']}    Offline    接口客服列表返回值中的state字段不正确，${j}
    should be equal    ${j['status']}    Enable    接口客服列表返回值中的Enable字段不正确，${j}
    should be equal    ${j['maxServiceSessionCount']}    ${${agent.maxServiceSessionCount}}    接口客服列表返回值中的maxServiceSessionCount字段不正确，${j}
    should be equal    ${j['roles']}    ${agent.roles}    接口客服列表返回值中的roles字段不正确，${j}
    #添加坐席到技能组
    ${agentId}    set variable    ${j['userId']}
    @{agentslist}    Create List    ${agentId}
    Add Agents To Queue    ${AdminUser}    ${queue.queueId}    ${agentslist}
    #查看技能组中的坐席
    ${j1}    Get Queue Members    ${AdminUser}    ${queue.queueId}
    should be true    ${j1['totalElements']} == 1    技能组内的坐席不是唯一，${j1}
    should be equal    ${j1['entities'][0]['tenantId']}    ${AdminUser.tenantId}    根据账号查询结果tenantId不正确，${j1}
    should be equal    ${j1['entities'][0]['username']}    ${agent.username}    根据账号查询结果username不正确，${j1}
    set to dictionary    ${agent}    agentId=${agentId}
    set to dictionary    ${queue}    agent=${agent}
    return from keyword    ${queue}

Remove Agents From Queue
    [Arguments]    ${agent}    ${queueId}    ${timeout}    @{userIdlist}
    ${jqueue}    Get Queue Members    ${agent}    ${queueId}
    #获取当前技能组用户list
    @{AgentList}    Create List
    : FOR    ${i}    IN    @{jqueue['entities']}
    \    Append To List    ${AgentList}    ${i['userId']}
    log    ${AgentList}
    #从当前用户list中删除需要删除的用户list
    Remove Values From List    ${AgentList}    @{userIdlist}
    log    ${AgentList}
    #更新技能组用户列表
    Add Agents To Queue    ${agent}    ${queueId}    ${AgentList}

Get Agent QueueInfo
    [Arguments]    ${agent}    ${agentId}
    [Documentation]    获取坐席所在的技能组信息
    #获取坐席所属技能组信息
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/skillgroups    ${agent}    ${timeout}    ${agentId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Remove Agent From All Queues
    [Arguments]    ${admin}    ${agent}    ${timeout}
    #获取要删除坐席的信息
    ${jagent}    Get Agent QueueInfo    ${agent}    ${agent.userId}
    @{l}    create list    ${agent.userId}
    : FOR    ${i}    IN    @{jagent['entities']}
    \    #用管理员账号去移除
    \    Run Keyword If    '${i['queueGroupType']}'=='UserDefined'    Remove Agents From Queue    ${admin}    ${i['queueId']}    ${timeout}
    \    ...    @{l}

Create Random Agentqueue
    [Arguments]    ${agent}
    [Documentation]    创建一个修机名字的技能组，返回该技能组的id和名字
    ...
    ...
    ...
    ...    返回值：
    ...
    ...    queueId、queueName
    ${queueName}    UUID 4
    ${q}    Create Agentqueue    ${queueName}    ${agent}
    Return From Keyword    ${q}

Delete Agentqueues
    [Arguments]    ${agent}    @{queueIds}
    [Documentation]    删除一组技能组，参数为技能组Id列表
    #循环删除新增技能组
    : FOR    ${i}    IN    @{queueIds}
    \    Delete Agentqueue    ${i}    ${agent}
