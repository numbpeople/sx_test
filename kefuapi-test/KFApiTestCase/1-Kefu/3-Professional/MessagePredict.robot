*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | msgPredictEnable | 消息预知 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Default Tags      msgPredictEnable
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
获取消息预知数据(/v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【消息预知】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、获取会话的消息预知数据，调用接口：/v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict，接口请求状态码为200。
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
    #获取会话的消息预知数据
    ${j}    Set MessagePredict    get    ${AdminUser}    ${serviceSessionId}
    Should Be Equal    '${j['status']}'    'OK'    消息预知接口返回status数据不是OK：${j}
    Should Be Equal    '${j['entity']['content']}'    'None'    消息预知接口返回content数据不是None：${j}
    Should Be Equal    '${j['entity']['visitor_user_id']}'    'None'    消息预知接口返回visitor_user_id数据不是None：${j}
    Should Be Equal    '${j['entity']['timestamp']}'    '0'    消息预知接口返回visitor_user_id数据不是None：${j}

创建消息预知数据(/v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【消息预知】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、发送上报消息预知数据请求，调用接口：/v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict，接口请求状态码为200。
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
    set to dictionary    ${rest}    userName=${userName}    techChannelInfo=${rest.orgName}#${rest.appName}#${rest.serviceEaseMobIMNumber}
    #创建请求体
    ${curTime}    get time    epoch
    ${data}    set variable    {"visitor_user_id":"${visitorUserId}","content":"${curTime}","timestamp":${curTime}000}
    #发送创建消息预知数据请求
    ${j}    Set MessagePredict    post    ${AdminUser}    ${serviceSessionId}    ${data}    ${rest}
    Should Be Equal    '${j['status']}'    'OK'    消息预知接口返回status数据不是OK：${j}
    Should Be True    ${j['entity']}    消息预知接口返回entity字段数据不是True：${j}

创建并获取消息预知数据(/v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【消息预知】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step3、发送上报消息预知数据请求，调用接口：/v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict，接口请求状态码为200。
    ...    - Step4、获取已上报消息预知数据请求，调用接口：/v1/webimplugin/servicesessions/{serviceSessionId}/messagePredict，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、接口中取回的消息文本值等于预期。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #创建消息预知数据
    ${msgPredictResult}    Create MessagePredict Data    ${AdminUser}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    get    ${AdminUser}    ${msgPredictResult.serviceSessionId}
    ${expectConstruction}    set variable    ['entity']['visitor_user_id']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${msgPredictResult.visitorUserId}    #该参数为获取接口某字段的预期值
    #Step4、获取会话的消息预知数据，如果获取到数据不是预期，尝试重试取多次，再对比结果。
    ${j}    Repeat Keyword Times    Set MessagePredict    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回值未包含指定的visitorUserId值，预期值：${msgPredictResult.visitorUserId}
    should be equal    "${j['entity']['content']}"    "${msgPredictResult.content}"    获取到的会话的content不正确，预期值：${msgPredictResult.content}, ${j}
