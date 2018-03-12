*** Settings ***
Documentation     1.坐席清理会话，绑定到新技能组后，设置最大接待数为1
...               2.路由配置技能组优先，指定技能组后发送消息
...               3.能自动调度
Suite Setup       Create Channel
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
调度1：坐席登录（可接待状态），技能组优先调度，指定该坐席所在技能组发消息，能自动调度
    ${jbase}    to json    ${chatbasejson}
    go to    ${kefuurl}${jbase['navigator']['Agent']['uri']}
    #将坐席添加到新的技能组
    ${q}    Init Agent In New Queue    ${uiagent}    1
    #将入口指定设置优先顺序
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息，并指定到新技能组
    ${originTypeentity}=    create dictionary    name=APP    originType=app    key=APP    dutyType=Allday
    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}","queueName":"${q.queueName}"}}
    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originTypeentity.originType}
    Send Message    ${restentity}    ${guestentity}    ${msgentity}
