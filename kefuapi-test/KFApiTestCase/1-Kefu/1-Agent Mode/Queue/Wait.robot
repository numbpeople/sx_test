*** Settings ***
Force Tags
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Members/AgentQueue_Common.robot
Resource          ../../../../commons/admin common/Customers/Customers_common.robot
Resource          ../../../../commons/admin common/History/History_common.robot
Resource          ../../../../commons/admin common/Setting/Routing_Common.robot
Resource          ../../../../commons/agent common/Customers/Customers_Common.robot
Resource          ../../../../commons/admin common/BaseKeyword.robot
Resource          ../../../../commons/Base Common/Base_Common.robot
Resource          ../../../../commons/admin common/Channels/App_Common.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../../api/BaseApi/Queue/WaitApi.robot

*** Test Cases ***
关闭待接入列表search出的指定访客
    [Documentation]    【操作步骤】：
    ...    - Step1、创建新的技能组。
    ...    - Step2、调整路由规则顺序，使入口指定优先，调用接口：/tenants/{tenantId}/options/RoutingPriorityList，接口请求状态码为200。
    ...    - Step3、新访客发起消息，发起新会话。
    ...    - Step4、待接入根据访客昵称搜索待接入会话，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/search，接口请求状态码为200。
    ...    - Step5、手动结束待接入的会话，调用接口：/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort，接口请求状态码为200。
    ...    - Step6、坐席模式下，根据昵称搜索客户中心数据，调用接口：/v1/crm/tenants/{tenantId}/agents/{agentId}/customers，接口请求状态码为200。
    ...    - Step7、管理员模式下，根据昵称搜索客户中心数据，调用接口：/v1/crm/tenants/{tenantId}/customers，接口请求状态码为200。
    ...    - Step8、坐席模式&管理员模式下，根据昵称查询历史会话，调用接口：/v1/Tenant/me/ServiceSessionHistorys ，接口请求状态码为200。
    ...    - Step9、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    客户中心/历史会话可以搜索到该访客的数据。
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
    ${filter}    Copy Dictionary    ${FilterEntity}
    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #根据查询结果关闭待接入会话
    ${resp}=    /v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    #获取管理员模式下客户中心
    set to dictionary    ${filter}    page=0
    ${j}    Get Admin Customers    ${AdminUser}    ${filter}    ${DateRange}    ${retryTimes}
    Should Be True    ${j['numberOfElements']} ==1    待接入结束的会话，管理员模式未查到该访客：${j}
    #获取坐席模式下客户中心
    set test variable    ${retryTimes}    1
    ${j}    Get Agent Customers    ${AdminUser}    ${filter}    ${DateRange}    ${retryTimes}
    Should Be True    ${j['numberOfElements']} ==0    待接入结束的会话，坐席模式能查到该访客：${j}
    set test variable    ${retryTimes}    10
    #获取管理员模式下历史会话
    set to dictionary    ${filter}    isAgent=False    page=1
    ${r}    Search History    ${AdminUser}    ${filter}    ${DateRange}    ${retryTimes}
    Should Be True    ${r}    管理员模式下未查到该访客的历史会话：${guestentity.userName}
    #获取坐席模式下历史会话
    set to dictionary    ${filter}    isAgent=True
    set test variable    ${retryTimes}    1
    ${r}    Search History    ${AdminUser}    ${filter}    ${DateRange}    ${retryTimes}
    Should Not Be True    ${r}    坐席模式下查到该访客历史会话：${guestentity.userName}
    set test variable    ${retryTimes}    10

获取待接入列表(/v1/Tenant/me/Agents/me/UserWaitQueues)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取待接入会话数据，并记录总数，作为对比待接入总数变化的基数，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues，接口请求状态码为200。
    ...    - Step2、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step3、获取待接入会话数据，并记录新的会话总数，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues，接口请求状态码为200。
    ...    - Step4、判断待接入数总数情况。
    ...
    ...    【预期结果】：
    ...    发起待接入会话之后，获取到最新待接入会话总数应该增加1。
    #获取待接入会话列表数据
    ${json}    Get UserWaitQueues    ${AdminUser}    ${FilterEntity}
    ${baseCount}    evaluate    ${json['total_entries']} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get UserWaitQueues    ${AdminUser}    ${FilterEntity}
    Should Be True    '${j['total_entries']}' == '${baseCount}'    待接入数不正确： ${j['total_entries']} 不等于 ${baseCount}

获取待接入总数(/v1/Tenant/me/Agents/me/UserWaitQueues/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取待接入会话总数，作为对比待接入总数变化的基数，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/count，接口请求状态码为200。
    ...    - Step2、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step3、获取待接入会话总数，调用接口：/v1/Tenant/me/Agents/me/UserWaitQueues/count，接口请求状态码为200。
    ...    - Step4、判断待接入数总数情况。
    ...
    ...    【预期结果】：
    ...    发起待接入会话之后，获取到最新待接入会话总数应该增加1。
    #获取执行用例前的待接入数
    ${baseCount}    Get UserWaitQueues Count    ${AdminUser}
    ${baseCount}    evaluate    ${baseCount} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get UserWaitQueues Count    ${AdminUser}
    Should Be equal    ${j}    ${baseCount}    待接入总数不正确：${j}

获取待接入总数new(/v1/tenants/{tenantId}/queues/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取待接入会话总数，作为对比待接入总数变化的基数，调用接口：/v1/tenants/{tenantId}/queues/count，接口请求状态码为200。
    ...    - Step2、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step3、获取待接入会话总数，调用接口：/v1/tenants/{tenantId}/queues/count，接口请求状态码为200。
    ...    - Step4、判断待接入数总数情况。
    ...
    ...    【预期结果】：
    ...    发起待接入会话之后，获取到最新待接入会话总数应该增加1。
    #获取执行用例前的待接入数
    ${baseCount}    Get Queue Count    ${AdminUser}
    ${baseCount}    evaluate    ${baseCount} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get Queue Count    ${AdminUser}
    Should Be equal    ${j}    ${baseCount}    待接入总数不正确：${j}

获取待接入列表new(/v1/tenants/{tenantId}/queues)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取待接入会话总数，作为对比待接入总数变化的基数，调用接口：/v1/tenants/{tenantId}/queues，接口请求状态码为200。
    ...    - Step2、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step3、获取待接入会话总数，调用接口：/v1/tenants/{tenantId}/queues，接口请求状态码为200。
    ...    - Step4、判断待接入数总数情况。
    ...
    ...    【预期结果】：
    ...    发起待接入会话之后，获取到最新待接入会话总数应该增加1。
    #获取待接入会话列表数据
    ${json}    Get Queue    ${AdminUser}
    ${baseCount}    evaluate    ${json['total_entries']} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get Queue    ${AdminUser}
    Should Be True    '${j['total_entries']}' == '${baseCount}'    待接入数不正确： ${j['total_entries']} 不等于 ${baseCount}

获取待接入分组信息new(/v1/tenants/{tenantId}/agents/{agentId}/queues)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取坐席所带技能组数据，调用接口：/v1/tenants/{tenantId}/agents/{agentId}/queues，接口请求状态码为200。
    ...    - Step2、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，tenantId等于租户id、status等于OK。
    #获取坐席所处技能组信息
    ${j}    Get Agent In Queue    ${AdminUser}
    Should Be Equal    '${j['entities'][0]['tenantId']}'    '${AdminUser.tenantId}'    待接入列表不正确：${j}
    Should Be Equal    '${j['status']}'    'OK'    待接入列表不正确：${j}

关闭待接入会话(/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、手动关闭待接入会话，调用接口：/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status等于OK。
    #创建待接入会话
    ${session}    Create Wait Conversation    app
    #清理待接入会话
    ${j}=    Close Waiting Conversation    ${session.serviceSessionId}
    Should Be Equal    '${j['status']}'    'OK'    待接入会话关闭发生异常：${j}

获取待接入列表(/waitings)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取待接入会话总数，作为对比待接入总数变化的基数，，调用接口：/waitings，接口请求状态码为200。
    ...    - Step2、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step3、获取待接入会话总数，调用接口：/waitings，接口请求状态码为200。
    ...    - Step4、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    发起待接入会话之后，获取到最新待接入会话总数应该增加1。
    Log Dictionary    ${FilterEntity}
    #获取待接入会话列表数据
    ${json}    Get Waiting    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${baseCount}    evaluate    ${json['totalElements']} + 1
    #创建待接入会话
    Create Wait Conversation    app
    Log Dictionary    ${FilterEntity}
    #获取待接入会话列表数据
    ${j}    Get Waiting    ${AdminUser}    ${FilterEntity}    ${DateRange}
    Should Be True    '${j['totalElements']}' == '${baseCount}'    待接入数不正确： ${j['totalElements']} 不等于 ${baseCount}

根据渠道作为筛选条件，获取待接入会话数据(/waitings)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、根据渠道作为筛选条件，获取待接入会话数据，调用接口：/waitings，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status等于OK、session_id字段值等于发起会话的会话id、origin_type字段值等于会话的渠道类型。
    #使用局部变量来使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建待接入会话
    ${originType}    set variable    app    #渠道参数值：app、webim、weixin、weibo等值
    ${session}    Create Wait Conversation    ${originType}
    #设置查询待接入会话的参数,将筛选条件的渠道originType设置为app,从第0页获取数据
    set to dictionary    ${filter}    originType=${originType}    page=0    visitorName=${session.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get Waiting接口的参数值
    ${expectConstruction}    set variable    ['entities'][-1]['session_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.serviceSessionId}    #该参数为获取接口某字段的预期值
    #获取待接入会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    会话在待接入中没有被找到
    Should Be Equal    ${j['status']}    OK    获取接口status不是OK: ${j}
    Should Be Equal    ${j['entities'][-1]['session_id']}    ${session.serviceSessionId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['entities'][-1]['origin_type']}    ${originType}    获取接口渠道值不正确: ${j}

根据关联作为筛选条件，获取待接入会话数据(/waitings)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、根据关联作为筛选条件，获取待接入会话数据，调用接口：/waitings，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status等于OK、session_id字段值等于发起会话的会话id、origin_type字段值等于会话的渠道类型。
    #使用局部变量来使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建待接入会话
    ${originType}    set variable    weixin    #渠道参数值：app、webim、weixin、weibo等值
    ${session}    Create Wait Conversation    ${originType}
    #根据关联id获取关联信息
    ${channelInfo}    Get Channel With ChannelId    ${AdminUser}    ${session.channelId}
    run keyword if    "${channelInfo}" == "{}"    该关联id获取关联信息，关联id：${session.channelId}
    ${channelType}    set variable    ${channelInfo['type']}    #获取关联类型
    #设置查询待接入会话的参数,将筛选条件关联id,从第0页获取数据
    set to dictionary    ${filter}    techChannelId=${session.channelId}    techChannelType=${channelType}    page=0    visitorName=${session.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get Waiting接口的参数值
    ${expectConstruction}    set variable    ['entities'][-1]['session_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.serviceSessionId}    #该参数为获取接口某字段的预期值
    #获取待接入会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    会话在待接入中没有被找到
    Should Be Equal    ${j['status']}    OK    获取接口status不是OK: ${j}
    Should Be Equal    ${j['entities'][-1]['session_id']}    ${session.serviceSessionId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['entities'][-1]['origin_type']}    ${originType}    获取接口渠道值不正确: ${j}

根据技能组id作为筛选条件，获取待接入会话数据(/waitings)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、根据技能组id作为筛选条件，获取待接入会话数据，调用接口：/waitings，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status等于OK、session_id字段值等于发起会话的会话id、origin_type字段值等于会话的渠道类型。
    #使用局部变量来使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建待接入会话
    ${originType}    set variable    weibo    #渠道参数值：app、webim、weixin、weibo等值
    ${session}    Create Wait Conversation    ${originType}
    #设置查询待接入会话的参数,将筛选条件技能组id,从第0页获取数据
    set to dictionary    ${filter}    queueId=${session.queueId}    page=0
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get Waiting接口的参数值
    ${expectConstruction}    set variable    ['entities'][0]['session_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.serviceSessionId}    #该参数为获取接口某字段的预期值
    #获取待接入会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    会话在待接入中没有被找到
    Should Be Equal    ${j['status']}    OK    获取接口status不是OK: ${j}
    Should Be Equal    ${j['entities'][0]['session_id']}    ${session.serviceSessionId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['entities'][0]['origin_type']}    ${originType}    获取接口渠道值不正确: ${j}
    Should Be True    '${j['totalElements']}' == '1'    待接入数不正确，不唯一： ${j['totalElements']}

根据访客昵称作为筛选条件，获取待接入会话数据(/waitings)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、根据访客昵称作为筛选条件，获取待接入会话数据，调用接口：/waitings，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status等于OK、session_id字段值等于发起会话的会话id、origin_type字段值等于会话的渠道类型。
    #使用局部变量来使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建待接入会话
    ${originType}    set variable    weibo    #渠道参数值：app、webim、weixin、weibo等值
    ${session}    Create Wait Conversation    ${originType}
    #设置查询待接入会话的参数,将筛选条件访客昵称,从第0页获取数据
    set to dictionary    ${filter}    visitorName=${session.userName}    page=0
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get Waiting接口的参数值
    ${expectConstruction}    set variable    ['entities'][0]['session_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.serviceSessionId}    #该参数为获取接口某字段的预期值
    #获取待接入会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    会话在待接入中没有被找到
    Should Be Equal    ${j['status']}    OK    获取接口status不是OK: ${j}
    Should Be Equal    ${j['entities'][0]['session_id']}    ${session.serviceSessionId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['entities'][0]['origin_type']}    ${originType}    获取接口渠道值不正确: ${j}
    Should Be True    '${j['totalElements']}' == '1'    待接入数不正确，不唯一： ${j['totalElements']}

根据VIP标签作为筛选条件，获取待接入会话数据(/waitings)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话携带VIP标签信息，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、根据VIP标签：是，作为筛选条件，获取待接入会话数据，调用接口：/waitings，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status等于OK、session_id字段值等于发起会话的会话id、origin_type字段值等于会话的渠道类型。
    #使用局部变量来使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #设置扩展visitor字段,创建待接入会话
    ${originType}    set variable    weibo    #渠道参数值：app、webim、weixin、weibo等值
    ${visitor}    set variable    {"tags":["vip1","vip2"]}
    ${session}    Create Wait Conversation    ${originType}    ${visitor}
    #设置查询待接入会话的参数,将筛选条件VIP标签的True值,从第0页获取数据
    set to dictionary    ${filter}    vip=true    page=0    visitorName=${session.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get Waiting接口的参数值
    ${expectConstruction}    set variable    ['entities'][-1]['session_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.serviceSessionId}    #该参数为获取接口某字段的预期值
    #获取待接入会话
    ${j}    Repeat Keyword Times    Get Waiting    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    会话在待接入中没有被找到
    Should Be Equal    ${j['status']}    OK    获取接口status不是OK: ${j}
    Should Be Equal    ${j['entities'][-1]['session_id']}    ${session.serviceSessionId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['entities'][-1]['origin_type']}    ${originType}    获取接口渠道值不正确: ${j}
    Should Be True    '${j['totalElements']}' == '1'    待接入数不正确，不唯一： ${j['totalElements']}
    Should Be True    ${j['entities'][-1]['vip']}    待接入该会话vip值不是true，不唯一：${j}
    Should Be True    '${j['entities'][-1]['priority']}' == 'vip1'    待接入该会话priority值不是vip1，不唯一：${j}

获取待接入的返回字段信息(/waitings)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话携带VIP标签信息，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、根据访客昵称筛选，获取待接入会话数据，调用接口：/waitings，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，筛选数据总数为1、status等于OK、skill_group_id值是会话技能组id、session_id字段值等于发起会话的会话id、origin_type字段值等于会话的渠道类型，等等。
    #设置扩展visitor字段
    ${visitor}    set variable    {"tags":["vip1","vip2"]}
    #创建待接入会话
    ${j}    Create Wait Conversation    app    ${visitor}
    #查询指定访客的待接入数据
    ${filter}    copy dictionary    ${FilterEntity}
    #使用临时变量${filter}作为参数传递
    set to dictionary    ${filter}    visitorName=${j.userName}    page=0
    ${json}    Get Waiting    ${AdminUser}    ${filter}    ${DateRange}
    ${countNumber}    get length    ${json['entities']}
    run keyword if    ${countNumber} == 0    Fail    获取接口返回结果为1，但是获取不到待接入数据。${json}
    #断言接口返回字段：访客名称、技能组id、会话id、渠道信息、vip客户等级标识
    Should Be Equal    ${json['entities'][0]['visitor_name']}    ${j.userName}    访客名称不正确：${json}
    Should Be Equal    ${json['entities'][0]['skill_group_id']}    ${j.queueId}    技能组id不正确：${json}
    Should Be Equal    ${json['entities'][0]['session_id']}    ${j.serviceSessionId}    会话id不正确：${json}
    Should Be Equal    ${json['entities'][0]['origin_type']}    ${j.originType}    渠道信息：${json}
    Should Be Equal    ${json['entities'][0]['priority']}    vip1    vip客户等级返回不正确：${json}

关闭待接入会话(/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/abort)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话携带VIP标签信息，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、手动结束待接入会话，调用接口：/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/abort，接口请求状态码为200。
    ...    - Step2、查询历史会话数据，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，结果不应该为空，并且字段serviceSessionId为会话id。
    #使用局部变量来使用
    ${filter}    Copy Dictionary    ${FilterEntity}
    #创建待接入会话
    ${session}    Create Wait Conversation    weibo
    #清理待接入会话
    ${j}=    Close Waiting Session    ${session.serviceSessionId}    ${AdminUser}
    Should Be Equal    '${j['status']}'    'OK'    待接入会话关闭发生异常：${j}
    #获取管理员模式下历史会话
    set to dictionary    ${filter}    isAgent=False    page=1    visitorName=${session.userName}
    ${r}    Search History    ${AdminUser}    ${filter}    ${DateRange}
    run keyword if    ${r} == {}    管理员模式下未查到该访客的历史会话
    Should Be True    '${r['items'][0]['serviceSessionId']}' == '${session.serviceSessionId}'    管理员模式查到该访客的历史会话会话id不正确：${r}

手动接入待接入会话(/v6/Tenant/me/Agents/me/UserWaitQueues/{serviceSesssionId})
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、手动接入待接入会话，调用接口：/v6/Tenant/me/Agents/me/UserWaitQueues/{serviceSessionId}，接口请求状态码为200。
    ...    - Step3、查询进行中会话的数据，调用接口：/v1/Agents/me/Visitors，接口请求状态码为200。
    ...    - Step4、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，结果不应该为空，并且字段nicename为访客的昵称。
    #使用局部变量来使用
    ${filter}    Copy Dictionary    ${FilterEntity}
    #创建待接入会话
    ${session}    Create Wait Conversation    weibo
    #手动接入待接入会话
    ${j}=    Access Waiting Session    ${AdminUser}    ${session.serviceSessionId}
    Should Be Equal    '${j['status']}'    'OK'    待接入会话关闭发生异常：${j}
    #获取进行中会话列表
    &{searchDic}    create dictionary    fieldName=serviceSessionId    fieldValue=${session.serviceSessionId}    fieldConstruction=['serviceSessionId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['serviceSessionId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.serviceSessionId}    #该参数为获取接口某字段的预期值
    #获取会话对应的会话
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中会话根据会话id搜索不到相应的会话
    should be true    '${j[0]['user']['nicename']}'=='${session.userName}'    获取到的nicename不是${session.userName}, ${j}

待接入转接会话给其他技能组(/v6/Tenant/me/Agents/me/UserWaitQueues/{serviceSesssionId})
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、待接入转接会话到技能组，调用接口：/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSessionId}/assign/queues/{queueId}，接口请求状态码为200。
    ...    - Step3、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，结果不应该为空，并且字段status等于OK、entity等于True。
    #使用局部变量来使用
    ${filter}    Copy Dictionary    ${FilterEntity}
    #创建待接入会话
    ${session}    Create Wait Conversation    weibo
    ${queueIdB}    set variable    ${session.queueentityB.queueId}
    #待接入转接会话到技能组
    ${j}=    Assign Queue For Waiting Session    ${AdminUser}    ${session.serviceSessionId}    ${queueIdB}
    Should Be Equal    '${j['status']}'    'OK'    转接待接入会话结果status不为OK：${j}
    Should Be True    ${j['entity']}    转接待接入会话结果entity不为true：${j}

待接入转接会话给其他坐席(/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/assign/agents/{agentUserId})
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、创建新坐席，调用接口：/v1/Admin/Agents，接口请求状态码为200。
    ...    - Step3、获取坐席所在技能组，调用接口：/v1/tenants/{tenantId}/agents/{agentId}/skillgroups，接口请求状态码为200。
    ...    - Step4、待接入转接会话到坐席，调用接口：/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/assign/agents/{agentUserId}，接口请求状态码为200。
    ...    - Step5、管理员当前会话查询该转接坐席的会话，调用接口：/v1/tenants/{tenantId}/servicesessioncurrents，接口请求状态码为200。
    ...    - Step6、判断接口返回各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，结果不应该为空，并且字段serviceSessionId等于发起会话的会话id、agentUserNiceName等于转接后坐席id。
    #使用局部变量来使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建待接入会话
    ${session}    Create Wait Conversation    weibo
    #设置创建坐席请求参数
    ${uuid}    Uuid 4
    ${name}    set variable    ${AdminUser.tenantId}${uuid}
    &{agent}=    create dictionary    username=${name}@qq.com    password=lijipeng123    maxServiceSessionCount=10    nicename=${name}    permission=1
    ...    roles=admin,agent
    ${data}=    set variable    {"nicename":"${agent.nicename}","username":"${agent.username}","password":"${agent.password}","confirmPassword":"${agent.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${agent.maxServiceSessionCount}","permission":${agent.permission},"roles":"${agent.roles}"}
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #创建坐席并获取坐席id
    ${agentInfo}    Create Agent    ${AdminUser}    ${agentFilter}    ${data}
    ${userId}    set variable    ${agentInfo['userId']}
    #获取坐席所在技能组
    ${agentInQueueIds}    Get Agent QueueInfo    ${AdminUser}    ${userId}
    ${agentInQueueId}    set variable    ${agentInQueueIds['entities'][0]['queueId']}
    #创建转接请求体
    ${assignData}    set variable    {"agentUserId":"${userId}","queueId":${agentInQueueId}}
    #待接入转接会话到坐席
    ${j}=    Assign Agent For Waiting Session    ${AdminUser}    ${session.serviceSessionId}    ${userId}    ${assignData}
    Should Be Equal    '${j['status']}'    'OK'    转接待接入会话结果status不为OK：${j}
    #设置查询当前会话的参数
    set to dictionary    ${filter}    state=Processing    isAgent=${False}    visitorName=${session.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get EnquiryStatus接口的参数值
    ${expectConstruction}    set variable    ['items'][0]['agentUserId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${userId}    #该参数为获取接口某字段的预期值
    #获取会话满意度评价结果
    ${j}    Repeat Keyword Times    Get Current Conversation    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中会话不属于转接后的坐席
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.serviceSessionId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['items'][0]['agentUserNiceName']}    ${name}    获取接口返回agentUserNiceName不正确: ${j}
