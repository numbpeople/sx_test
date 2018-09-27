*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/MicroService/EventCollector/EventCollectorApi.robot
Resource          ../../admin common/BaseKeyword.robot

*** Keywords ***
Report EventCollector
    [Arguments]    ${agent}    ${data}
    [Documentation]    上报正在访问事件
    #上报正在访问事件
    ${resp}=    /v1/event_collector/events    ${agent}    ${data}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：上报正在访问事件，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Get Report EventCollector
    [Arguments]    ${agent}    ${agentAccountName}
    [Documentation]    获取上报正在访问事件
    #获取上报正在访问事件
    ${resp}=    /v1/event_collector/{tenantId}/events    ${agent}    ${agentAccountName}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取上报正在访问事件，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Send EventCollector Invite 
    [Arguments]    ${agent}    ${eventId}    ${data}
    [Documentation]    发送正在访问邀请
    #发送正在访问邀请
    ${resp}=    /v1/event_collector/event/{eventId}    ${agent}    ${eventId}    ${data}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：发送正在访问邀请，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

Create EventCollector Data
    [Arguments]    ${agent}
    [Documentation]    创建一条新的上报数据
    ...    
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
    #返回数据
    Return From Keyword    ${visitorDic}
    