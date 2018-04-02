*** Settings ***
Suite Setup       Run Keywords    Create Channel    ${uiadmin}
...               AND    Disable All Waiting Rules    ${uiadmin}
Suite Teardown    Delete Channels    ${uiadmin}
Force Tags        ui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Library           uuid
Library           urllib
Library           Selenium2Library
Resource          ../../api/HomePage/Login/Login_Api.robot
Resource          ../../UIcommons/Kefu/chatres.robot
Resource          ../../commons/Base Common/Base_Common.robot
Resource          ../../commons/admin common/Channels/App_Common.robot
Resource          ../../commons/admin common/Members/AgentQueue_Common.robot

*** Test Cases ***
调度1：管理员能自动调度
    [Documentation]    步骤：
    ...    1.坐席登录
    ...    2.设置该接待数为0
    ...    3.清空该坐席进行中会话
    ...    4.创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组
    ...    5.设置坐席接待数为1，状态为在线
    ...    6.指定路由规则为入口优先
    ...    7.发送消息（扩展中技能技能组queuea）
    ...
    ...
    ...    期望结果：
    ...    坐席自动接起该会话
    #步骤2-步骤4
    ${q}    Init Agent In New Queue    ${uiadmin}    ${uiadmin}
    #步骤5
    ${j}    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    ${j}    Set Agent MaxServiceUserNumber    ${uiadmin}    1
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #步骤6：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiadmin}
    #步骤7：发送消息，并指定到新技能组
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${q.queueName}"}}
    ${guestentity}=    create dictionary    userName=${uiadmin.tenantId}-${curTime}    originType=${originTypeentity.originType}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #检查结果：格式化会话列表json并检查ui
    ${j}    format chatlistlijson    1    ${guestentity.originType}    ${guestentity.userName}    @{chatlistliclassattributes}
    ${jbase}    to json    ${j}
    Check Base Elements    ${uiadmin.language}    ${jbase['elements']}
    [Teardown]    Delete Agentqueue    ${q.queueId}    ${uiadmin}

调度2：管理员能心跳调度（修改接待数）
    [Documentation]    步骤：
    ...    1.坐席登录
    ...    2.设置该接待数为0
    ...    3.清空该坐席进行中会话
    ...    4.创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组
    ...    5.设置坐席接待数为0，状态为在线
    ...    6.指定路由规则为入口优先
    ...    7.发送消息（扩展中技能技能组queuea），会话进入待接入
    ...    8.设置坐席接待数为1
    ...
    ...
    ...    期望结果：
    ...    坐席自动接起该会话
    #步骤2-步骤4
    ${q}    Init Agent In New Queue    ${uiadmin}    ${uiadmin}
    #步骤5
    ${j}    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #步骤6：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiadmin}
    #步骤7：发送消息，并指定到新技能组，待接入中能查询到该会话
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${q.queueName}"}}
    ${guestentity}=    create dictionary    userName=${uiadmin.tenantId}-${curTime}    originType=${originTypeentity.originType}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${uiadmin}    ${filter}    ${range}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    #步骤8：设置坐席接待数为1
    Set Agent MaxServiceUserNumber    ${uiadmin}    1
    #必须加上，不然预调度会导致接口调用传递ack=false,跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #检查结果：格式化会话列表json并检查ui
    ${j}    format chatlistlijson    1    ${guestentity.originType}    ${guestentity.userName}    @{chatlistliclassattributes}
    ${jbase}    to json    ${j}
    Check Base Elements    ${uiadmin.language}    ${jbase['elements']}
    [Teardown]    Delete Agentqueue    ${q.queueId}    ${uiadmin}

调度3：管理员能心跳调度（修改状态）
    [Documentation]    步骤：
    ...    1.坐席登录
    ...    2.设置该接待数为0
    ...    3.清空该坐席进行中会话
    ...    4.创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组
    ...    5.设置坐席接待数为1，状态为非在线
    ...    6.指定路由规则为入口优先
    ...    7.发送消息（扩展中技能技能组queuea），会话进入待接入
    ...    8.设置坐席状态为在线
    ...
    ...
    ...    期望结果：
    ...    坐席自动接起该会话
    #步骤2-步骤4
    ${q}    Init Agent In New Queue    ${uiadmin}    ${uiadmin}
    #步骤5
    ${j}    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    ${j}    Set Agent MaxServiceUserNumber    ${uiadmin}    1
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #步骤6：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiadmin}
    #步骤7：发送消息，并指定到新技能组，待接入中能查询到该会话
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${q.queueName}"}}
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    ${l}    get length    ${kefustatus}
    : FOR    ${i}    IN RANGE    1    ${l}
    \    #步骤5.2：设置坐席接待状态为非在线并刷新页面
    \    Set Agent Status    ${uiadmin}    ${kefustatus[${i}]}
    \    goto and checkchatebasejson    ${uiadmin}
    \    #发送消息
    \    ${guestentity}=    create dictionary    userName=${uiadmin.tenantId}-${curTime}-${i}    originType=${originTypeentity.originType}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    \    ${resp}    Search Waiting Conversation    ${uiadmin}    ${filter}    ${range}
    \    ${j}    to json    ${resp.content}
    \    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    \    #步骤8：设置坐席接待状态为Online
    \    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    \    #检查结果：格式化会话列表json并检查ui
    \    ${j}    format chatlistlijson    1    ${guestentity.originType}    ${guestentity.userName}    @{chatlistliclassattributes}
    \    ${jbase}    to json    ${j}
    \    Check Base Elements    ${uiadmin.language}    ${jbase['elements']}
    \    #关闭会话
    \    Stop All Processing Conversations    ${uiadmin}
    [Teardown]    Delete Agentqueue    ${q.queueId}    ${uiadmin}

调度4：管理员不能调度非本组的会话
    [Documentation]    步骤：
    ...    1.坐席登录
    ...    2.设置该接待数为0
    ...    3.清空该坐席进行中会话
    ...    4.创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组
    ...    5.创建一个新技能组（下面用queueb简称）不绑定任何技能组
    ...    6.设置坐席接待数为1，状态为在线
    ...    7.指定路由规则为入口优先
    ...    8.发送消息（扩展中技能技能组queueb）
    ...
    ...
    ...    期望结果：
    ...    1.坐席待接入中能查询到该会话
    ...    2.坐席不会自动接起该会话（3秒不从待接入中消失）
    #步骤2-步骤4
    ${q1}    Init Agent In New Queue    ${uiadmin}    ${uiadmin}
    #步骤5
    ${j}    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    ${j}    Set Agent MaxServiceUserNumber    ${uiadmin}    1
    #步骤6
    ${q2}    Create Random Agentqueue    ${uiadmin}
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #步骤7：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiadmin}
    #步骤8：发送消息，并指定到新技能组
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${q2.queueName}"}}
    ${guestentity}=    create dictionary    userName=${uiadmin.tenantId}-${curTime}    originType=${originTypeentity.originType}
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #检查结果
    ${resp}    Search Waiting Conversation    ${uiadmin}    ${filter}    ${range}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    sleep    3
    ${resp}    Search Waiting Conversation    ${uiadmin}    ${filter}    ${range}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    #将技能组id放入list
    @{qidlist}    create list    ${q1.queueId}    ${q2.queueId}
    [Teardown]    Delete Agentqueues    ${uiadmin}    @{qidlist}

调度5：指定坐席的会话能进入不可调度状态的管理员的进行中会话（指定当前坐席所在技能组，开启预调度）
    [Documentation]    步骤：
    ...    1.坐席登录
    ...    2.设置预调度开关为开
    ...    3.设置该接待数为0
    ...    4.清空该坐席进行中会话
    ...    5.创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组
    ...    6.指定路由规则为入口优先
    ...    7.发送消息（扩展中指定坐席，技能组指定queuea）(预调度开的情况下)
    ...
    ...
    ...    期望结果：
    ...    坐席进行中会话有该会话
    #步骤2，打开预调度开关
    ${data}    set variable    {"value":true}
    ${resp}=    /tenants/{tenantId}/options/{optionName}    ${uiadmin}    put    serviceSessionPreScheduleEnable    ${data}    ${timeout}
    #步骤2-步骤4
    ${q}    Init Agent In New Queue    ${uiadmin}    ${uiadmin}
    #步骤5
    ${j}    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    ${j}    Set Agent MaxServiceUserNumber    ${uiadmin}    1
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #步骤6：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiadmin}
    #步骤7：发送消息，并指定到新技能组
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","agentUsername":"${uiadmin.username}","queueName":"${q.queueName}"}}
    ${guestentity}=    create dictionary    userName=${uiadmin.tenantId}-${curTime}    originType=${originTypeentity.originType}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #检查结果：格式化会话列表json并检查ui
    ${j}    format chatlistlijson    1    ${guestentity.originType}    ${guestentity.userName}    @{chatlistliclassattributes}
    ${jbase}    to json    ${j}
    Check Base Elements    ${uiadmin.language}    ${jbase['elements']}
    [Teardown]    Delete Agentqueue    ${q.queueId}    ${uiadmin}

调度6：指定坐席的会话能进入不可调度状态的管理员的进行中会话（指定当前坐席所在技能组，关闭预调度）
    [Documentation]    步骤：
    ...    1.坐席登录
    ...    2.设置预调度开关为关
    ...    3.设置该接待数为0
    ...    4.清空该坐席进行中会话
    ...    5.创建一个新技能组（下面用queuea简称）并将该坐席绑定到该技能组
    ...    6.指定路由规则为入口优先
    ...    7.发送消息（扩展中指定坐席，技能组指定queuea）(预调度开的情况下)
    ...
    ...
    ...    期望结果：
    ...    坐席进行中会话有该会话
    #步骤2，打开预调度开关
    ${data}    set variable    {"value":false}
    ${resp}=    /tenants/{tenantId}/options/{optionName}    ${uiadmin}    put    serviceSessionPreScheduleEnable    ${data}    ${timeout}
    #步骤2-步骤4
    ${q}    Init Agent In New Queue    ${uiadmin}    ${uiadmin}
    #步骤5
    ${j}    Set Agent Status    ${uiadmin}    ${kefustatus[0]}
    ${j}    Set Agent MaxServiceUserNumber    ${uiadmin}    1
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${uiadmin}
    #步骤6：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiadmin}
    #步骤7：发送消息，并指定到新技能组
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","agentUsername":"${uiadmin.username}","queueName":"${q.queueName}"}}
    ${guestentity}=    create dictionary    userName=${uiadmin.tenantId}-${curTime}    originType=${originTypeentity.originType}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #检查结果：格式化会话列表json并检查ui
    ${j}    format chatlistlijson    1    ${guestentity.originType}    ${guestentity.userName}    @{chatlistliclassattributes}
    ${jbase}    to json    ${j}
    Check Base Elements    ${uiadmin.language}    ${jbase['elements']}
    [Teardown]    Delete Agentqueue    ${q.queueId}    ${uiadmin}
