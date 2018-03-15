*** Settings ***
Documentation     1.坐席清理会话，绑定到新技能组后，设置最大接待数为1
...               2.路由配置技能组优先，指定技能组后发送消息
...               3.能自动调度
Suite Setup       Create Channel    ${uiagent}
Suite Teardown    Delete Channels    ${uiagent}
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

*** Test Cases ***
调度1：坐席能自动调度
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
    #步骤2-步骤5
    ${q}    Init Agent In New Queue    ${uiagent}    1
    #跳转到进行中会话页面
    ${jbase}    to json    ${chatbasejson}
    go to    ${kefuurl}${jbase['navigator']['Agent']['uri']}
    #步骤6：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiagent}
    #步骤7：发送消息，并指定到新技能组
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${q.queueName}"}}
    ${guestentity}=    create dictionary    userName=${uiagent.tenantId}-${curTime}    originType=${originTypeentity.originType}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    #检查结果：格式化会话列表json并检查ui
    ${j}    format chatlistlijson    1    ${guestentity.originType}    ${guestentity.userName}    @{chatlistliclassattributes}
    ${jbase}    to json    ${j}
    Check Base Elements    ${uiagent.language}    ${jbase['elements']}

调度2：坐席能心跳调度
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
    #步骤2-步骤5
    ${q}    Init Agent In New Queue    ${uiagent}    0
    #跳转到进行中会话页面
    ${jbase}    to json    ${chatbasejson}
    go to    ${kefuurl}${jbase['navigator']['Agent']['uri']}
    #步骤6：将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联    ${uiagent}
    #步骤7：发送消息，并指定到新技能组，待接入中能查询到该会话
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${q.queueName}"}}
    ${guestentity}=    create dictionary    userName=${uiagent.tenantId}-${curTime}    originType=${originTypeentity.originType}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${uiagent}    ${filter}    ${range}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    #步骤8：设置坐席接待数为1
    Set Agent MaxServiceUserNumber    ${uiagent}    1
    #检查结果：格式化会话列表json并检查ui
    ${j}    format chatlistlijson    1    ${guestentity.originType}    ${guestentity.userName}    @{chatlistliclassattributes}
    ${jbase}    to json    ${j}
    Check Base Elements    ${uiagent.language}    ${jbase['elements']}
