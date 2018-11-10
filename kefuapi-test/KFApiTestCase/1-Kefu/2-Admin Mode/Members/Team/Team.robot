*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../commons/admin common/Members/AgentQueue_Common.robot
Resource          ../../../../../commons/admin common/Members/Agents_Common.robot    #
Resource          ../../../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取技能组时间计划和问候语开关设置(/v1/tenants/{tenantId}/skillgroups/{queueId}/time-options)
    [Documentation]    【操作步骤】：
    ...    - Step1、新创建技能组，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、根据时间计划获取工作日设置，调用接口：/v1/Admin/Agents/file，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、tenantId字段值等于租户id、timeScheduleId字段值等于0。
    #使用第一个时间计划数据
    ${curTime}    Uuid 4
    ${queueName}    set variable    ${AdminUser.tenantId}${curTime}
    ${queue}    Create Agentqueue    ${queueName}
    #根据时间计划获取工作日设置
    ${j}=    Get Time-Options    ${AdminUser}    ${queue.queueId}
    should be equal    ${j['status']}    OK    接口返回值中status值不是OK , ${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    接口返回值中tenantId值不是${AdminUser.tenantId}, ${j}
    should be equal    '${j['entity']['timeScheduleId']}'    '0'    接口返回值中timeScheduleId值不是0 , ${j}

将坐席添加到技能组(/v1/AgentQueue/{queueId}/AgentUser)
    [Documentation]    【操作步骤】：
    ...    - Step1、新创建技能组，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、新创建坐席，调用接口：/v1/Admin/Agents，接口请求状态码为200。
    ...    - Step3、将新创建坐席添加到技能组中，调用接口：/v1/AgentQueue/{queueId}/AgentUser，接口请求状态码为204。
    ...    - Step4、查看技能组中的坐席，调用接口：/v2/tenants/{tenantId}/agents，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、username字段值等于登录账号、tenantId字段值等于租户id、totalElements字段值等于1。
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
    @{agentslist}    Create List    ${j['userId']}
    Add Agents To Queue    ${AdminUser}    ${queue.queueId}    ${agentslist}
    #查看技能组中的坐席
    ${j}    Get Queue Members    ${AdminUser}    ${queue.queueId}
    should be true    ${j['totalElements']} == 1    技能组内的坐席不是唯一，${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    根据账号查询结果tenantId不正确，${j}
    should be equal    ${j['entities'][0]['username']}    ${agent.username}    根据账号查询结果username不正确，${j}

查询坐席所在技能组(/v1/tenants/{tenantId}/agents/{agentId}/skillgroups)
    [Documentation]    【操作步骤】：
    ...    - Step1、查看坐席所在的技能组信息，调用接口：/v1/tenants/{tenantId}/agents/{agentId}/skillgroups，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、总数据大于0。
    ${j}    Get Agent QueueInfo    ${AdminUser}    ${AdminUser.userId}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    should be true    ${length} > 0    坐席不属于任何技能组: ${j}
