*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | whisper | 旗舰-耳语 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Default Tags      whisper
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Channels/Webim_Common.robot
Resource          ../../../commons/CollectionData/Agent Mode/Conversation_Collection.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取耳语消息(/v1/tenants/{tenantId}/whisper-messages)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【旗舰-耳语】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、获取耳语消息，调用接口：/v1/tenants/{tenantId}/whisper-messages，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建待接入会话
    ${sessionInfo}    Create Processing Conversation    webim
    ${serviceSessionId}    set variable    ${sessionInfo.serviceSessionId}
    ${chatGroupId}    set variable    ${sessionInfo.chatGroupId}
    #获取该会话的所有消息
    &{filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    page=0    size=10
    ${j}    Get Servicesession Message    ${AdminUser}    ${serviceSessionId}    ${filter}
    #获取会话第一页第一条消息的时间戳
    ${beginTimestamp}    set variable    ${j['entities'][-1]['createDateTime']}
    &{whisperMessageEntity}    copy dictionary    ${WhisperMessageEntity}
    set to dictionary    ${whisperMessageEntity}    beginTimestamp=${beginTimestamp}    chatGroupId=${chatGroupId}
    #获取耳语消息
    &{apiResponse}    Get Whisper Message    ${AdminUser}    ${whisperMessageEntity}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤3时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    Should Be Equal     ${text['status']}    OK    步骤3时，status字段值不等于OK：${apiResponse.describetion}

发送耳语消息(/v1/tenants/{tenantId}/sessions/{serviceSessionId}/whisper-messages)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【旗舰-耳语】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、发送耳语消息，调用接口：/v1/tenants/{tenantId}/sessions/{serviceSessionId}/whisper-messages，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建待接入会话
    ${sessionInfo}    Create Processing Conversation    webim
    ${serviceSessionId}    set variable    ${sessionInfo.serviceSessionId}
    #初始化接口参数
    ${uuid}    Uuid 4
    ${curTime}    get time    epoch
    ${msg}    set variable    msg=耳语消息-${uuid}
    ${data}    set variable    {"msg":"${msg}","type":"txt","sendTime":${curTime}000}
    #发送耳语消息
    &{apiResponse}    Send Whisper Message    ${AdminUser}    ${serviceSessionId}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤3时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    Should Be Equal     ${text['status']}    OK    步骤3时，status字段值不等于OK：${apiResponse.describetion}

发送耳语消息并获取耳语消息数据(/v1/tenants/{tenantId}/sessions/{serviceSessionId}/whisper-messages)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【旗舰-耳语】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、发送耳语消息，调用接口：/v1/tenants/{tenantId}/sessions/{serviceSessionId}/whisper-messages，接口请求状态码为200。
    ...    - Step4、获取耳语消息，调用接口：/v1/tenants/{tenantId}/whisper-messages，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建待接入会话
    ${sessionInfo}    Create Processing Conversation    webim
    ${serviceSessionId}    set variable    ${sessionInfo.serviceSessionId}
    ${chatGroupId}    set variable    ${sessionInfo.chatGroupId}
    #初始化接口参数
    ${uuid}    Uuid 4
    ${curTime}    get time    epoch
    ${msg}    set variable    msg=耳语消息-${uuid}
    ${data}    set variable    {"msg":"${msg}","type":"txt","sendTime":${curTime}000}
    #发送耳语消息
    &{apiResponse}    Send Whisper Message    ${AdminUser}    ${serviceSessionId}    ${data}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤3时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    Should Be Equal     ${text['status']}    OK    步骤3时，status字段值不等于OK：${apiResponse.describetion}
    #获取该会话的所有消息
    &{filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    page=0    size=10
    ${j}    Get Servicesession Message    ${AdminUser}    ${serviceSessionId}    ${filter}
    #获取会话第一页第一条消息的时间戳
    ${beginTimestamp}    set variable    ${j['entities'][-1]['createDateTime']}
    &{whisperMessageEntity}    copy dictionary    ${WhisperMessageEntity}
    set to dictionary    ${whisperMessageEntity}    beginTimestamp=${beginTimestamp}    chatGroupId=${chatGroupId}
    #获取耳语消息
    &{apiResponse}    Get Whisper Message    ${AdminUser}    ${whisperMessageEntity}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤4时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    Should Be Equal     ${text['status']}    OK    步骤4时，status字段值不等于OK：${apiResponse.describetion}
    Should Be Equal     ${text['totalElements']}    ${1}    步骤4时，totalElements字段值不等于1，实际值：${text['totalElements']}，${apiResponse.describetion}
    Should Be Equal     ${text['entities'][0]['body']['bodies'][0]['msg']}    ${msg}    步骤4时，msg字段值不等于${msg}，实际值：${text['entities'][0]['body']['bodies'][0]['msg']}，${apiResponse.describetion}
    
