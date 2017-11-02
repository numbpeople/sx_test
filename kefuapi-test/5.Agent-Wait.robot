*** Settings ***
Suite Setup       Run Keywords    Create Channel
...               AND    log    routing case 执行开始
Suite Teardown    Run Keywords    Delete Agentusers
...               AND    Delete Queues
...               AND    Delete Channels
...               AND    log    routing case 执行结束
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/RoutingApi.robot
Resource          api/KefuApi.robot
Resource          JsonDiff/KefuJsonDiff.robot
Library           uuid
Resource          commons/admin common/admin_common.robot
Resource          commons/agent common/agent_common.robot
Resource          commons/admin common/Customers_common.robot
Resource          commons/admin common/History_common.robot
Resource          api/SystemSwitch.robot
Resource          kefutool/Tools-Resource.robot

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
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
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
    set to dictionary    ${FilterEntity}    page=0
    ${j}    Get Admin Customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${retryTimes}
    Should Be True    ${j['numberOfElements']} ==1    待接入结束的会话，管理员模式未查到该访客：${j}
    #获取坐席模式下客户中心
    set test variable    ${retryTimes}    1
    ${j}    Get Agent Customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${retryTimes}
    Should Be True    ${j['numberOfElements']} ==0    待接入结束的会话，坐席模式能查到该访客：${j}
    set test variable    ${retryTimes}    10
    #获取管理员模式下历史会话
    set to dictionary    ${FilterEntity}    isAgent=False    page=1
    ${r}    Search History    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${retryTimes}
    Should Be True    ${r}    管理员模式下未查到该访客的历史会话：${guestentity.userName}
    #获取坐席模式下历史会话
    set to dictionary    ${FilterEntity}    isAgent=True
    set test variable    ${retryTimes}    1
    ${r}    Search History    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${retryTimes}
    Should Not Be True    ${r}    坐席模式下查到该访客历史会话：${guestentity.userName}
    set test variable    ${retryTimes}    10
