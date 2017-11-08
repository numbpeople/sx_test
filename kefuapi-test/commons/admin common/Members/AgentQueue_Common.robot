*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/KefuApi.robot
Resource          ../../../api/RoutingApi.robot
Resource          ../../../api/SessionCurrentApi.robot

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
    [Arguments]    ${queueId}
    [Documentation]    删除技能组，参数为技能组Id
    #删除新增技能组
    ${resp}=    /v1/AgentQueue/{queueId}    ${AdminUser}    ${queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

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
