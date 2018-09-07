*** Settings ***
Documentation     该新的路由规则是在47.17版本上新增，并且配合了时间计划。
...
...               修改点：
...
...               1、指定渠道/关联，添加timeScheduleId参数
...
...
...               ***
...
...               在执行或跳过用例时，tag名请确认为newrouting
Force Tags        newrouting
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/RoutingApi.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../../commons/admin common/Setting/Routing_Common.robot
Resource          ../../../../commons/admin common/Robot/Robot_Common.robot
Resource          ../../../../commons/admin common/BaseKeyword.robot
Resource          ../../../../commons/admin common/Channels/App_Common.robot
Resource          ../../../../commons/admin common/Setting/Business-Hours_Common.robot
Resource          ../../../../api/IM/IMApi.robot

*** Test Cases ***
渠道指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step4、路由规则设置将网页渠道全天指定技能组，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、发送消息并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联指定规则(全天指定)(/v1/tenants/{tenantId}/channel-data-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、路由规则设置关联指定全天指定技能组，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step4、发送消息并创建访客。
    ...    - Step5、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentityA.queueId}    id2=0    type=agentQueue    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为入口-渠道-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、发送消息指定技能组并创建访客。
    ...    - Step4、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和关联指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step4、路由规则设置APP渠道全天指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置关联指定全天指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step6、发送消息并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    渠道    关联    入口
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentityB.queueId}    id2=0    type=agentQueue    type2=
    set to dictionary    ${queueentityB}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentityB.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentityB.channelData.id}","type1":"${queueentityB.channelData.type}","id2":"${queueentityB.channelData.id2}","type2":"${queueentityB.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和渠道指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定全天指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道全天指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentityA.queueId}    id2=0    type=agentQueue    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityB.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和入口指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为渠道-入口-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step4、路由规则设置APP渠道全天指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、发送消息入口指定指定技能组B并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityB.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #将规则排序设置为渠道->入口指定优先
    Set RoutingPriorityList    渠道    入口    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和渠道指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为入口-渠道-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step4、路由规则设置APP渠道全天指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、发送消息入口指定指定技能组A并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到入口指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    渠道    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityB.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和入口指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为关联-入口-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、路由规则设置关联指定全天指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step4、发送消息入口指定指定技能组B并创建访客。
    ...    - Step5、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityB.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #将规则排序设置为关联->入口指定优先
    Set RoutingPriorityList    关联    入口    渠道
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentityA.queueId}    id2=0    type=agentQueue    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和关联指定规则(全天指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、将规则排序设置为入口-关联-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、路由规则设置关联指定全天指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step4、发送消息入口指定指定技能组A并创建访客。
    ...    - Step5、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到入口指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    关联    渠道
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentityB.queueId}    id2=0    type=agentQueue    type2=
    set to dictionary    ${queueentityB}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentityB.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentityB.channelData.id}","type1":"${queueentityB.channelData.type}","id2":"${queueentityB.channelData.id2}","type2":"${queueentityB.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-binding
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置网页渠道上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道上班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-data-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联上班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityA.queueId}    id2=${queueentityB.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和关联指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置关联指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step7、发送消息并创建访客。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道上班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    渠道    关联    入口
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityB.queueId}    id2=${queueentityA.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    log    ${restentity}
    ${resp}=    send msg    ${restentity}    ${guestentity}    ${msgentity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['data']['${RestEntity.serviceEaseMobIMNumber}']}    success    发送消息失败
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    #根据访客昵称查询待接入列表
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和渠道指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置APP渠道指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、发送消息并创建访客。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联上班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityA.queueId}    id2=${queueentityB.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和入口指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-入口-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组B并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道上班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityB.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道->入口指定优先
    Set RoutingPriorityList    渠道    入口    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和渠道指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为入口-渠道-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到入口指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    渠道    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和入口指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-入口-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息入口指定技能组B并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联上班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityB.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为关联->入口指定优先
    Set RoutingPriorityList    关联    入口    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityA.queueId}    id2=${queueentityB.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和关联指定规则(上班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、将规则排序设置为入口-关联-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息入口指定技能组A并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到入口指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    关联    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityB.queueId}    id2=${queueentityA.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-binding
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置网页渠道指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道下班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-data-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联下班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityB.queueId}    id2=${queueentityA.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和关联指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置关联指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step7、发送消息并创建访客。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道下班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    渠道    关联    入口
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityA.queueId}    id2=${queueentityB.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和渠道指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置APP渠道指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、发送消息并创建访客。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联下班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityB.queueId}    id2=${queueentityA.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和入口指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-入口-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到渠道下班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityB.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为渠道->入口指定优先
    Set RoutingPriorityList    渠道    入口    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和渠道指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为入口-渠道-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到入口指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    渠道    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班技能组    #下班技能组
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和入口指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-入口-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息入口指定技能组A并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到关联下班指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityB.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为关联->入口指定优先
    Set RoutingPriorityList    关联    入口    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityB.queueId}    id2=${queueentityA.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和关联指定规则(下班时间指定)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、将规则排序设置为入口-关联-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联指定上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息入口指定技能组A并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且会话分配到入口指定的技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    关联    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityA.queueId}    id2=${queueentityB.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置渠道全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息并创建访客。
    ...    - Step7、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    0    0    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询的筛选条件
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}

关联指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-data-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息并创建访客。
    ...    - Step6、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到机器人
    ${cData}=    create dictionary    dutyType=Allday    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}

渠道和关联指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置渠道全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置关联全天指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step7、发送消息并创建访客。
    ...    - Step8、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step9、发送转人工消息。
    ...    - Step10、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step11、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后会话所属技能组等于关联指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    渠道    关联    入口
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    0    0    ${robotId}
    #关联指定到技能组
    ${cData}=    create dictionary    dutyType=Allday    id=${queueentityA.queueId}    id2=0    type=agentQueue    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和渠道指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置关联全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置渠道全天指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、发送消息并创建访客。
    ...    - Step8、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step9、发送转人工消息。
    ...    - Step10、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step11、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后会话所属技能组等于渠道指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定机器人
    ${cData}=    create dictionary    dutyType=Allday    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和入口指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置渠道全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step8、发送转人工消息。
    ...    - Step9、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step10、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->入口指定优先
    Set RoutingPriorityList    渠道    入口    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    0    0    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和渠道指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为入口-渠道-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置APP渠道全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    渠道    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    0    0    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和入口指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-入口-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息指定技能组A并创建访客。
    ...    - Step6、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step7、发送转人工消息。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后会话所属技能组等于关联指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为关联->入口指定优先
    Set RoutingPriorityList    关联    入口    渠道
    #关联指定到机器人
    ${cData}=    create dictionary    dutyType=Allday    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和关联指定规则(全天-指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为入口-关联-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联全天指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息指定技能组A并创建访客。
    ...    - Step6、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且待接列表话所属技能组等于关联指定技能组A。
 
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    关联    渠道
    #关联指定到机器人
    ${cData}=    create dictionary    dutyType=Allday    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}"}
    log    ${data}
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${AdminUser}    ${cData}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding
    [Documentation]    【操作步骤】：
    ...    - Step1、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置网页渠道上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息并创建访客。
    ...    - Step7、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求    #上班指定机器人
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}

关联指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-data-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息并创建访客。
    ...    - Step6、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}

渠道和关联指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置APP渠道上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、路由规则设置关联上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step8、发送消息并创建访客。
    ...    - Step9、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step10、发送转人工消息。
    ...    - Step11、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step12、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于关联上班指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    渠道    关联    入口
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班指定机器人    #下班不指定
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    ${robotId}
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityA.queueId}    id2=${queueentityB.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和渠道指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、路由规则设置关联上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step6、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、路由规则设置APP渠道上班时间指定技能组A、下班时间指定技能组B，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step8、发送消息并创建访客。
    ...    - Step9、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step10、发送转人工消息。
    ...    - Step11、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step12、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于APP渠道上班指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityA.queueId}    ${queueentityB.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和入口指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为渠道-入口-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置渠道上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、发送消息入口指定技能组A并创建访客。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->入口指定优先
    Set RoutingPriorityList    渠道    入口    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班机器人    #下班不指定
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和渠道指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为入口-渠道-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置渠道上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、发送消息入口指定技能组A并创建访客。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    渠道    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班机器人    #下班不指定
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和入口指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为关联-入口-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、路由规则设置关联上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为关联->入口指定优先
    Set RoutingPriorityList    关联    入口    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和关联指定规则(上班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为上班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/worktimes，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为入口-关联-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、路由规则设置关联上班时间指定机器人、下班时间不指定，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    on    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    关联    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${robotId}    id2=0    type=robot    type2=
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding
    [Documentation]    【操作步骤】：
    ...    - Step1、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step5、路由规则设置网页渠道上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、发送消息并创建访客。
    ...    - Step7、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    Set Worktime Ext    off    ${AdminUser}    ${originTypeentity.scheduleId}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求    #上班指定机器人
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    null
    ...    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    null
    ...    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}

关联指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-data-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step2、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step3、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step4、路由规则设置关联上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step5、发送消息并创建访客。
    ...    - Step6、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    ${weekend}=    Get Current Weekend
    log    ${weekend}
    Set Worktime    off    ${weekend}    ${AdminUser}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=0    id2=${robotId}    type=    type2=robot
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    log    ${data}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}

渠道和关联指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为渠道-关联-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置APP渠道上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、路由规则设置关联上班时间指定技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step8、发送消息并创建访客。
    ...    - Step9、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step10、发送转人工消息。
    ...    - Step11、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step12、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于关联下班指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    ${weekend}=    Get Current Weekend
    log    ${weekend}
    Set Worktime    off    ${weekend}    ${AdminUser}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    渠道    关联    入口
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班指定机器人    #下班不指定
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    null
    ...    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    null
    ...    ${robotId}
    #关联指定到技能组    #设置全天或者上下班    #上班技能组    #下班技能组    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=${queueentityB.queueId}    id2=${queueentityA.queueId}    type=agentQueue    type2=agentQueue
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和渠道指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A和B，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为关联-渠道-入口顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、路由规则设置关联上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step6、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、路由规则设置APP渠道上班时间技能组B、下班时间指定技能组A，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step8、发送消息并创建访客。
    ...    - Step9、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step10、发送转人工消息。
    ...    - Step11、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step12、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于APP渠道下班指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    ${agentqueue1}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}B
    ${queueentityB}=    Add Agentqueue    ${agentqueue1}    ${agentqueue1.queueName}    #创建一个技能组B
    #设置当日设置为上班时间
    ${weekend}=    Get Current Weekend
    log    ${weekend}
    Set Worktime    off    ${weekend}    ${AdminUser}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->关联指定优先
    Set RoutingPriorityList    关联    渠道    入口
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=0    id2=${robotId}    type=    type2=robot
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    ${queueentityB.queueId}    ${queueentityA.queueId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

渠道和入口指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为渠道-入口-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置APP渠道上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、发送消息入口指定技能组A并创建访客。
    ...    - Step8、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step9、发送转人工消息。
    ...    - Step10、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step11、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组A
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    ${weekend}=    Get Current Weekend
    log    ${weekend}
    Set Worktime    off    ${weekend}    ${AdminUser}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为渠道->入口指定优先
    Set RoutingPriorityList    渠道    入口    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班机器人    #下班不指定
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    null
    ...    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    null
    ...    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和渠道指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为入口-渠道-关联顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、获取渠道绑定关系，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step6、路由规则设置APP渠道上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-binding，接口请求状态码为200。
    ...    - Step7、发送消息入口指定技能组A并创建访客。
    ...    - Step8、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    ${weekend}=    Get Current Weekend
    log    ${weekend}
    Set Worktime    off    ${weekend}    ${AdminUser}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    渠道    关联
    #获取渠道绑定关系
    ${j}    Get Routing
    ${listlength}=    Get Length    ${j['content']}
    #判断渠道是否有绑定关系，如果没有渠道数据，使用post请求，反之使用put请求    #上班机器人    #下班不指定
    Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    0    0    null
    ...    ${robotId}
    Run Keyword If    ${listlength} > 0    Update Routing Ext    ${originTypeentity}    0    0    null
    ...    ${robotId}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

关联和入口指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为关联-入口-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、路由规则设置关联上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询当前会话列表，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step8、发送转人工消息。
    ...    - Step9、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step10、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、并且当前会话中，该会话分配给机器人，转人工后待接入会话所属技能组等于关联指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    ${weekend}=    Get Current Weekend
    log    ${weekend}
    Set Worktime    off    ${weekend}    ${AdminUser}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为关联->入口指定优先
    Set RoutingPriorityList    关联    入口    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=0    id2=${robotId}    type=    type2=robot
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #设置查询当前会话的参数
    set to dictionary    ${FilterEntity}    state=Processing    isAgent=${False}    visitorName=${guestentity.userName}
    #查询当前会话是否属于机器人
    ${j}    Get Current Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['items'][0]['agentUserId']}' == '${robotUserId}'    获取当前会话数所属的机器人不正确：${j}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    set to dictionary    ${msgentity}    msg=转人工    #发送转人工消息，将会话转至待接入
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}

入口和关联指定规则(下班时间指定机器人)(/v1/tenants/{tenantId}/channel-binding)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建技能组A，调用接口：/v1/AgentQueue，接口请求状态码为200。
    ...    - Step2、设置当日设置为下班时间，调用接口：/v1/tenants/{tenantId}/timeplans/schedules/{scheduleId}/holidays，接口请求状态码为200。
    ...    - Step3、获取机器人账号信息的列表，调用接口：/v1/Tenants/{tenantId}/robot/profile/personalInfos，接口请求状态码为200。
    ...    - Step4、将规则排序设置为入口-关联-渠道顺序，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step5、路由规则设置关联上班时间不指定、下班时间指定机器人，调用接口：/v1/tenants/{tenantId}/channel-data-binding，接口请求状态码为200。
    ...    - Step6、发送消息入口指定技能组A并创建访客。
    ...    - Step7、根据访客昵称查询待接入列表，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step8、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、根据访客昵称查询待接入会话数等于1、待接入会话所属技能组等于入口指定技能组A。
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Onoff    scheduleId=${timeScheduleId}
    #快速创建两个技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组A
    #创建扩展消息体：包括扩展字段技能组B
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${queueentityA.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    #设置当日设置为上班时间
    ${weekend}=    Get Current Weekend
    log    ${weekend}
    Set Worktime    off    ${weekend}    ${AdminUser}
    #获取机器人的tenantId、userId列表
    &{robotlist}    Get Robotlist
    log    ${robotlist}
    ${robotTenantIds}=    Get Dictionary Keys    ${robotlist}
    ${robotId}=    set variable    ${robotTenantIds[0]}    #第一个机器人的tenantId
    ${robotUserId}=    Get From Dictionary    ${robotlist}    ${robotId}    #第一个机器人的userId
    #将规则排序设置为入口-> 渠道指定优先
    Set RoutingPriorityList    入口    关联    渠道
    #关联指定到技能组    #设置全天或者上下班    #上班指定机器人    #下班不指定    #上班的绑定类型    #下班的绑定类型
    ${cData}=    create dictionary    dutyType=Onoff    id=0    id2=${robotId}    type=    type2=robot
    &{queueentity}    create dictionary    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${restentity.channelId}","dutyType":"${queueentity.channelData.dutyType}","name":"${restentity.channelName}","info":"${restentity.orgName}#${restentity.appName}#${restentity.serviceEaseMobIMNumber}","id1":"${queueentity.channelData.id}","type1":"${queueentity.channelData.type}","id2":"${queueentity.channelData.id2}","type2":"${queueentity.channelData.type2}","timeScheduleId":${originTypeentity.scheduleId}}
    Set ChannelData Routing    ${AdminUser}    ${cData}    ${data}
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
