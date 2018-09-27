*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | agentCallVisitor | 主动发起弹窗会话 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Default Tags      agentCallVisitor
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/Base Common/Base_Common.robot
Resource          ../../../commons/agent common/Queue/Visiting_Common.robot


*** Test Cases ***
上报正在访问请求数据(/v1/event_collector/events)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【主动发起弹窗会话】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、上报正在访问请求数据，调用接口：/v1/event_collector/events，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #Step1、判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #构建请求上报数据
    ${uuid}    Uuid 4
    ${eventDataDic}    create dictionary    type=VISIT_URL    tenantId=${AdminUser.tenantId}    url=测试请求地址    designatedAgent=
    ${visitorDic}    create dictionary    type=GUEST    id=${uuid}
    ${data}    set variable    {"type":"${eventDataDic.type}","tenantId":"${eventDataDic.tenantId}","url":"${eventDataDic.url}","designatedAgent":"${eventDataDic.designatedAgent}","userId":{"type":"${visitorDic.type}","id":"${visitorDic.id}"}}
    #Step2、上报正在访问请求数据
    &{apiResponse}    Report EventCollector    ${AdminUser}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤2时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    #Step3、判断返回值各字段情况。
    Should Be Equal     ${text['type']}    OK    步骤3时，type字段值不等于OK：${apiResponse.describetion}

获取上报正在访问请求数据(/v1/event_collector/{tenantId}/events)
    [Documentation]
    ...    - Step1、判断租户的增值功能【主动发起弹窗会话】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、上报正在访问请求数据，调用接口：/v1/event_collector/events，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...    - Step4、获取已上报正在访问请求数据，调用接口：/v1/event_collector/{tenantId}/events，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    #Step1、构建请求上报数据
    ${uuid}    Uuid 4
    ${eventDataDic}    create dictionary    type=VISIT_URL    tenantId=${AdminUser.tenantId}    url=测试请求地址    designatedAgent=
    ${visitorDic}    create dictionary    type=GUEST    id=${uuid}
    ${data}    set variable    {"type":"${eventDataDic.type}","tenantId":"${eventDataDic.tenantId}","url":"${eventDataDic.url}","designatedAgent":"${eventDataDic.designatedAgent}","userId":{"type":"${visitorDic.type}","id":"${visitorDic.id}"}}
    #Step2、上报正在访问请求数据
    &{apiResponse}    Report EventCollector    ${AdminUser}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤2时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    #Step3、判断返回值各字段情况。
    Should Be Equal     ${text['type']}    OK    步骤3时，type字段值不等于OK：${apiResponse.describetion}
    #Step4、获取已上报正在访问请求数据
    &{apiResponse1}    Get Report EventCollector    ${AdminUser}    ${AdminUser.username}
    Should Be Equal As Integers    ${apiResponse1.statusCode}    200    步骤4时，发生异常，状态不等于200：${apiResponse1.describetion}
    ${text}    set variable    ${apiResponse1.text}
    ${length}    get length    ${text['value']}
    #Step5、判断返回值各字段情况。
    Should Be True     ${length} > 0    步骤5时，获取到的数据为空：${apiResponse1.describetion}
    Should Be Equal     "${text['value'][-1]['id']}"    "${visitorDic.id}"    步骤5时，id字段值不等于：${visitorDic.id}：${apiResponse1.describetion}
    Should Be Equal     ${text['value'][-1]['url']}    ${eventDataDic.url}    步骤5时，url字段值不等于：${eventDataDic.url}：${apiResponse1.describetion}

发送正在访问邀请(/v1/event_collector/event/{eventId})
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【主动发起弹窗会话】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、创建一条新的上报数据，调用接口：/v1/event_collector/events，接口请求状态码为200。
    ...    - Step3、发送正在访问邀请，调用接口：/v1/event_collector/event/{eventId}，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #Step1、判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #Step2、创建一条新的上报数据
    ${eventResult}    Create EventCollector Data    ${AdminUser}
    ${id}    set variable    ${eventResult.id}
    ${curTime}    get time    epoch
    ${timestamp}    set variable    ${curTime}000
    ${inviteDic}    create dictionary    type=INIT_CALL    tenantId=${AdminUser.tenantId}    targetVisitorId=${id}    orgName=${restentity.orgName}    appName=${restentity.appName}    agentImName=${restentity.serviceEaseMobIMNumber}    channelId=${restentity.channelId}    agentUserName=${AdminUser.username}    message=can I help u    timestamp=${timestamp}    visitor=false
    ${agentDic}    create dictionary    type=AGENT    id=${AdminUser.userId}
    ${data}    set variable    {"type":"${inviteDic.type}","userId":{"type":"${agentDic.type}","id":"${agentDic.id}"},"targetVisitorId":"${inviteDic.targetVisitorId}","visitor":${inviteDic.visitor},"timestamp":${inviteDic.timestamp},"tenantId":${inviteDic.tenantId},"orgName":"${inviteDic.orgName}","appName":"${inviteDic.appName}","channelId":${inviteDic.channelId},"agentImName":"${inviteDic.agentImName}","agentUserName":"${inviteDic.agentUserName}","message":"${inviteDic.message}"}
    #Step3、发送正在访问邀请
    &{apiResponse}    Send EventCollector Invite    ${AdminUser}    ${id}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤3时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    #Step4、判断返回值各字段情况。
    Should Be Equal     "${text}"    "ok"    步骤4时，请求返回结果不等于ok：${apiResponse.describetion}
