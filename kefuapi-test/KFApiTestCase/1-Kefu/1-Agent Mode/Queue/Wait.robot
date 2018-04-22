*** Settings ***
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
Resource          ../../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../../api/BaseApi/Queue/WaitApi.robot

*** Test Cases ***
关闭待接入列表search出的指定访客
    [Documentation]    关闭待接入中search出来的访客，历史会话中查询（坐席模式无该会话，管理员模式应该有该会话），访客中心中查询（坐席模式无该访客，管理员模式应该有该访客），质检中查询
    [Tags]
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
    [Tags]    sdk
    #获取待接入会话列表数据
    ${json}    Get UserWaitQueues    ${AdminUser}    ${FilterEntity}
    ${baseCount}    evaluate    ${json['total_entries']} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get UserWaitQueues    ${AdminUser}    ${FilterEntity}
    Should Be True    '${j['total_entries']}' == '${baseCount}'    待接入数不正确： ${j['total_entries']} 不等于 ${baseCount}

获取待接入总数(/v1/Tenant/me/Agents/me/UserWaitQueues/count)
    #获取执行用例前的待接入数
    ${baseCount}    Get UserWaitQueues Count    ${AdminUser}
    ${baseCount}    evaluate    ${baseCount} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get UserWaitQueues Count    ${AdminUser}
    Should Be equal    ${j}    ${baseCount}    待接入总数不正确：${j}

获取待接入总数new(/v1/tenants/{tenantId}/queues/count)
    [Tags]    sdk
    #获取执行用例前的待接入数
    ${baseCount}    Get Queue Count    ${AdminUser}
    ${baseCount}    evaluate    ${baseCount} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get Queue Count    ${AdminUser}
    Should Be equal    ${j}    ${baseCount}    待接入总数不正确：${j}

获取待接入列表new(/v1/tenants/{tenantId}/queues)
    #获取待接入会话列表数据
    ${json}    Get Queue    ${AdminUser}
    ${baseCount}    evaluate    ${json['total_entries']} + 1
    #创建待接入会话
    Create Wait Conversation    app
    #获取待接入会话列表数据
    ${j}    Get Queue    ${AdminUser}
    Should Be True    '${j['total_entries']}' == '${baseCount}'    待接入数不正确： ${j['total_entries']} 不等于 ${baseCount}

获取待接入分组信息new(/v1/tenants/{tenantId}/agents/{agentId}/queues)
    #获取坐席所处技能组信息
    ${j}    Get Agent In Queue    ${AdminUser}
    Should Be Equal    '${j['entities'][0]['tenantId']}'    '${AdminUser.tenantId}'    待接入列表不正确：${j}
    Should Be Equal    '${j['status']}'    'OK'    待接入列表不正确：${j}结束待接入会话(/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort)

关闭待接入会话(/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort)
    #创建待接入会话
    ${session}    Create Wait Conversation    app
    #清理待接入会话
    ${j}=    Close Waiting Conversation    ${session.serviceSessionId}
    Should Be Equal    '${j['status']}'    'OK'    待接入会话关闭发生异常：${j}

获取待接入列表(/waitings)
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

获取待接入的返回字段信息(/v1/tenants/{tenantId}/queues/waitqueue/waitings/{waitingId}/abort)
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
    [Documentation]    1.创建待接入会话    2.手动结束待接入会话    3.历史会话根据访客昵称搜索该会话
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
    Should Be True    '${r['items'][0]['serviceSessionId']}' == '${session.serviceSessionId}'   管理员模式查到该访客的历史会话会话id不正确：${r}

手动接入待接入会话(/v6/Tenant/me/Agents/me/UserWaitQueues/{serviceSesssionId})
    [Documentation]    1.创建待接入会话    2.手动接入会话    3.查询进行中会话该接入的会话
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
    [Documentation]    1.创建待接入会话    2.待接入转接会话到技能组
    #使用局部变量来使用
    ${filter}    Copy Dictionary    ${FilterEntity}
    #创建待接入会话
    ${session}    Create Wait Conversation    weibo
    #待接入转接会话到技能组
    ${j}=    Assign Queue For Waiting Session    ${AdminUser}    ${session.serviceSessionId}    ${session.queueId}
    Should Be Equal    '${j['status']}'    'OK'    转接待接入会话结果status不为OK：${j}
    Should Be True    ${j['entity']}    转接待接入会话结果entity不为true：${j}

待接入转接会话给其他坐席(/v6/tenants/{tenantId}/queues/unused/waitings/{serviceSesssionId}/assign/agents/{agentUserId})
    [Documentation]    1.创建待接入会话    2.创建坐席    3.待接入转接会话到坐席
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
