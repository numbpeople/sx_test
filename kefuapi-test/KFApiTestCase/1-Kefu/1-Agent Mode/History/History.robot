*** Settings ***
Force Tags        agentHistory
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot
Resource          ../../../../commons/Base Common/Base_Common.robot
Resource          ../../../../commons/admin common/Channels/App_Common.robot
Resource          ../../../../commons/agent common/Queue/Queue_Common.robot

*** Test Cases ***
获取坐席模式的历史会话数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、坐席在历史会话中，查询刚刚结束的会话数据，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，total_entries字段的值等于1，tenantId字段等于租户id，agentUserId字段等于接待的坐席Id，等等。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    isAgent=true    visitorName=${session.userName}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Check Agent History Detail    ${AdminUser}    ${j}    ${session}

坐席模式下回呼历史会话(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、坐席在历史会话中，回呼刚刚结束的会话，调用接口：/v6/Tenants/me/Agents/me/ServiceSessions/VisitorUsers/{visitorUserId}/CreateServiceSession，接口请求状态码为200。
    ...    - Step3、在进行中列表中，查询该进行中会话，调用接口：/v1/Agents/me/Visitors，接口请求状态码为200。
    ...    - Step4、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，会话结果中的nicename应该等于访客昵称。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #坐席回呼刚刚创建并结束的会话
    ${callBackSession}    Agent CallingBack Conversation    ${AdminUser}    ${session.userId}
    Should Be True    "${callBackSession['status']}" == "OK"    回呼会话返回后的status值不对，正常的结果OK：${callBackSession}
    Should Be True    "${callBackSession['entity']['state']}" == "Processing"    回呼会话返回后的接口state值不对，正常的结果为Processing：${callBackSession}
    Should Be True    "${callBackSession['entity']['visitorUser']['userId']}" == "${session.userId}"    回呼会话返回后的接口userId值不对，正常的结果为${session.userId}：${callBackSession}
    #获取进行中会话列表
    &{searchDic}    create dictionary    fieldName=${session.userId}    fieldValue=${session.userId}    fieldConstruction=['user']['userId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['user']['userId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.userId}    #该参数为获取接口某字段的预期值
    #获取会话对应的会话
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    回呼会话后，进行中会话不是预期值
    should be equal    ${j[0]['user']['nicename']}    ${session.userName}    获取到的会话昵称不正确, ${j}

坐席模式历史会话根据会话ID筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、坐席在历史会话中，根据会话id查询历史会话数据，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，total_entries字段的值等于1，tenantId字段等于租户id，agentUserId字段等于接待的坐席Id，等等。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    isAgent=true    serviceSessionId=${session.sessionServiceId}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Check Agent History Detail    ${AdminUser}    ${j}    ${session}

坐席模式历史会话根据渠道类型筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、坐席在历史会话中，根据渠道类型查询历史会话数据，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，total_entries字段的值等于1，tenantId字段等于租户id，agentUserId字段等于接待的坐席Id，等等。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    isAgent=true    originType=${session.originType}    customerName=${session.userName}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Check Agent History Detail    ${AdminUser}    ${j}    ${session}

坐席模式历史会话根据关联ID筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、坐席在历史会话中，根据关联id查询历史会话数据，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，total_entries字段的值等于1，tenantId字段等于租户id，agentUserId字段等于接待的坐席Id，等等。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #根据关联id获取关联信息
    ${channelInfo}    Get Channel With ChannelId    ${AdminUser}    ${session.techChannelId}
    run keyword if    "${channelInfo}" == "{}"    该关联id获取关联信息，关联id：${session.techChannelId}
    ${channelType}    set variable    ${channelInfo['type']}    #获取关联类型
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    isAgent=true    techChannelId=${session.techChannelId}    techChannelType=${channelType}    customerName=${session.userName}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Check Agent History Detail    ${AdminUser}    ${j}    ${session}

坐席模式历史会话根据客户昵称筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、坐席在历史会话中，根据客户昵称查询历史会话数据，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，total_entries字段的值等于1，tenantId字段等于租户id，agentUserId字段等于接待的坐席Id，等等。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    isAgent=true    customerName=${session.userName}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Check Agent History Detail    ${AdminUser}    ${j}    ${session}

坐席模式历史会话根据是否转接参数筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、坐席在进行中会话列表，将会话转接到其他技能组，调用接口：/v1/ServiceSession/{serviceSessionId}/AgentQueue/{queueId}，接口请求状态码为200。
    ...    - Step3、从待接入中手动接入会话到进行中，调用接口：/waitings，接口请求状态码为200。
    ...    - Step4、手动结束进行中的会话，调用接口：/v1/Agents/me/Visitors/{visitorId}/ServiceSessions/{serviceSessionId}/Stop，接口请求状态码为200。
    ...    - Step5、坐席在历史会话中，根据是否转接参数类型查询历史会话数据，调用接口：/v1/Tenant/me/ServiceSessionHistorys，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，total_entries字段的值等于1，tenantId字段等于租户id，agentUserId字段等于接待的坐席Id，等等。
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建会话并手动接入到进行中会话
    ${session}    Create Processiong Conversation
    #客服转接会话到其他技能组
    ${j}    Tansfer Conversation To Queue    ${AdminUser}    ${session.sessionServiceId}    ${session.queueId}
    should be true    ${j}    获取接口返回结果不是True: ${j}
    #接入待接入会话并手动结束掉
    Access Waiting And Stop Session    ${AdminUser}    ${session}    ${filter}    ${range}
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    page=1    isAgent=true    transfered=true    customerName=${session.userName}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Check Agent History Transfered Detail    ${AdminUser}    ${j}    ${session}
