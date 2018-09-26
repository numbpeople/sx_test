*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | msgRecall | 旗舰-消息撤回 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Default Tags      msgRecall
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
消息撤回(/v1/tenants/{tenantId}/whisper-messages)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【旗舰-消息撤回】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、客服回复消息，调用接口：/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages，接口请求状态码为200。
    ...    - Step4、撤回消息，调用接口：/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/messages/{msgId}/recall，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #Step1、判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #Step2、创建进行中会话
    ${sessionInfo}    Create Processing Conversation    app
    ${serviceSessionId}    set variable    ${sessionInfo.serviceSessionId}
    ${userid}    set variable    ${sessionInfo.userId}
    #创建消息实体类型，消息文本，消息类型。
    ${msg}    set variable    Uuid 4
    &{msgEntity}    create dictionary    msg=${msg}    type=txt
    #Step3、调用接口/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages发送消息，接口请求状态码为200。
    ${j}    Agent Send Message    ${AdminUser}    ${userid}    ${serviceSessionId}    ${msgEntity}
    ${msgId}    set variable    ${j['msgId']}
    #Step4、撤回消息
    &{apiResponse}    Recall Message    ${AdminUser}    ${serviceSessionId}    ${msgId}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤4时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    #Step5、判断接口各字段的返回值
    Should Be Equal     ${text['status']}    OK    步骤5时，status字段值不等于OK：${apiResponse.describetion}

消息撤回并获取消息撤回历史消息(/v1/tenants/{tenantId}/whisper-messages)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【旗舰-消息撤回】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、客服回复消息，调用接口：/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages，接口请求状态码为200。
    ...    - Step4、撤回消息，调用接口：/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/messages/{msgId}/recall，接口请求状态码为200。
    ...    - Step5、获取该会话的所有消息，调用接口：/tenants/{tenantId}/servicesessions/{serviceSessionId}/messages，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #Step1、判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #Step2、创建进行中会话
    ${sessionInfo}    Create Processing Conversation    app
    ${serviceSessionId}    set variable    ${sessionInfo.serviceSessionId}
    ${userid}    set variable    ${sessionInfo.userId}
    #创建消息实体类型，消息文本，消息类型。
    ${msg}    set variable    Uuid 4
    &{msgEntity}    create dictionary    msg=${msg}    type=txt
    #Step3、调用接口/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Messages发送消息，接口请求状态码为200。
    ${j}    Agent Send Message    ${AdminUser}    ${userid}    ${serviceSessionId}    ${msgEntity}
    ${msgId}    set variable    ${j['msgId']}
    #Step4、撤回消息
    &{apiResponse}    Recall Message    ${AdminUser}    ${serviceSessionId}    ${msgId}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤4时，发生异常，状态不等于200：${apiResponse.describetion}
    ${text}    set variable    ${apiResponse.text}
    Should Be Equal     ${text['status']}    OK    步骤5时，status字段值不等于OK：${apiResponse.describetion}
    #Step5、获取该会话的所有消息
    &{filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    page=0    size=10
    ${j}    Get Servicesession Message    ${AdminUser}    ${serviceSessionId}    ${filter}
    #获取会话最近一条消息id
    ${recallMsgId}    set variable    ${j['entities'][0]['body']['ext']['weichat']['recall_msg_id']}
    #Step6、判断接口各字段的返回值
    Should Be Equal     ${recallMsgId}    ${msgId}    步骤6时，回撤的消息id不正确，${j}
    Should Be Equal     "${j['entities'][0]['body']['bodies'][0]['action']}"    "KEFU_MESSAGE_RECALL"    步骤6时，字段action不等于KEFU_MESSAGE_RECALL，${j}
