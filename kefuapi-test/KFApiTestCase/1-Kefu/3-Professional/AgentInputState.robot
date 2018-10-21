*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | agentInputStateEnable | 客服输入状态 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Force Tags        agentInputStateEnable
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../commons/Base Common/Base_Common.robot
Resource          ../../../commons/admin common/Channels/Webim_Common.robot
Resource          ../../../commons/agent common/Conversations/Conversations_Common.robot

*** Test Cases ***
获取客服输入状态数据(/v1/webimplugin/sessions/{serviceSessionId}/agent-input-state)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【客服输入状态】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、获取客服输入状态数据，调用接口：/v1/webimplugin/sessions/{serviceSessionId}/agent-input-state，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    ${serviceSessionId}    set variable    ${sessionInfo.sessionServiceId}
    ${visitorUserId}    set variable    ${sessionInfo.userId}
    ${userName}    set variable    ${sessionInfo.userName}
    #创建请求参数
    ${rest}    copy dictionary    ${restentity}
    log    ${rest}
    set to dictionary    ${rest}    userName=${userName}
    #获取会话的客服输入状态数据
    ${apiResponse}    Set AgentInputState    get    ${AdminUser}    ${serviceSessionId}    ${EMPTY}    ${rest}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤3时，发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    '${j['status']}'    'OK'    步骤4时，客服输入状态接口返回status数据不是OK：${apiResponse.describetion}
    Should Be Equal    '${j['entity']['input_state_tips']}'    'None'    步骤4时，客服输入状态接口返回input_state_tips数据不是None：${apiResponse.describetion}
    Should Be Equal    '${j['entity']['service_session_id']}'    '${serviceSessionId}'    步骤4时，客服输入状态接口返回service_session_id数据不是${serviceSessionId}：${apiResponse.describetion}

创建客服输入状态数据(/v1/webimplugin/sessions/{serviceSessionId}/agent-input-state)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【客服输入状态】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、上报客服输入状态数据，调用接口：/v1/webimplugin/sessions/{serviceSessionId}/agent-input-state，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    ${serviceSessionId}    set variable    ${sessionInfo.sessionServiceId}
    ${visitorUserId}    set variable    ${sessionInfo.userId}
    ${userName}    set variable    ${sessionInfo.userName}
    #创建请求参数
    ${rest}    copy dictionary    ${restentity}
    log    ${rest}
    set to dictionary    ${rest}    userName=${userName}
    #创建请求体
    ${curTime}    get time    epoch
    ${data}    set variable    {"service_session_id":"${serviceSessionId}","input_state_tips":"${curTime}","timestamp":${curTime}}
    ${apiResponse}    Set AgentInputState    post    ${AdminUser}    ${serviceSessionId}    ${data}    ${rest}
    Should Be Equal As Integers    ${apiResponse.statusCode}    200    步骤3时，发生异常，状态不等于200：${apiResponse.describetion}
    ${j}    set variable    ${apiResponse.text}
    Should Be Equal    '${j['status']}'    'OK'    步骤4时，客服输入状态接口返回status数据不是OK：${apiResponse.describetion}
    Should Be True    ${j['entity']}    步骤4时，客服输入状态接口返回entity字段数据不是True：${apiResponse.describetion}

创建并获客服输入状态数据(/v1/webimplugin/sessions/{serviceSessionId}/agent-input-state)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【客服输入状态】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、上报客服输入状态数据，调用接口：/v1/webimplugin/sessions/{serviceSessionId}/agent-input-state，接口请求状态码为200。
    ...    - Step4、获取上报的客服输入状态数据，调用接口：/v1/webimplugin/sessions/{serviceSessionId}/agent-input-state，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、获取到输入状态数据等于预期。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建消息预知数据
    ${agentInputStateResult}    Create AgentInputState Data    ${AdminUser}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${agentInputStateResult.serviceSessionId}    ${EMPTY}    ${agentInputStateResult}
    ${expectConstruction}    set variable    ['entity']['service_session_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${agentInputStateResult.serviceSessionId}    #该参数为获取接口某字段的预期值
    #Step4、获取会话的消息预知数据，如果获取到数据不是预期，尝试重试取多次，再对比结果。
    ${j}    Repeat Keyword Times    Set AgentInputState    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回值未包含指定的visitorUserId值，预期值：${msgPredictResult.visitorUserId}
    should be equal    "${j['entity']['input_state_tips']}"    "${agentInputStateResult.content}"    获取到的会话的content不正确，预期值：${agentInputStateResult.content}, ${j}
