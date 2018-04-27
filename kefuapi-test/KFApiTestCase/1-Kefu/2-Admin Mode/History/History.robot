*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/History/HistoryApi.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot
Resource          ../../../../commons/Base Common/Base_Common.robot
Resource          ../../../../commons/admin common/Channels/App_Common.robot
Resource          ../../../../commons/agent common/Queue/Queue_Common.robot

*** Test Cases ***
获取默认历史会话数据(/v1/Tenant/me/ServiceSessionHistorys)
    log    ${DateRange}
    ${resp}=    /v1/Tenant/me/ServiceSessionHistorys    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} >= 0    历史会话数不正确

获取管理员模式的历史会话数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建已结束的会话    2.查询历史会话，并检查返回的所有字段值
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取管理员模式历史会话数据
    set to dictionary    ${filter}    isAgent=false    visitorName=${session.userName}    #isAgent为true，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    管理员模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    管理员模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

管理员模式下回呼历史会话(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建已结束的会话    2.历史会话中回呼刚结束的会话，并检查进行中是否存在
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

管理员模式历史会话根据会话ID筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建已结束的会话    2.历史会话中根据会话ID筛选会话
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取管理员模式历史会话数据
    set to dictionary    ${filter}    isAgent=false    serviceSessionId=${session.sessionServiceId}    #isAgent为true，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    管理员模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    管理员模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

管理员模式历史会话根据渠道类型筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建已结束的会话    2.历史会话中根据渠道类型筛选会话
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取管理员模式历史会话数据
    set to dictionary    ${filter}    isAgent=false    originType=${session.originType}    customerName=${session.userName}    #isAgent为true，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    管理员模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    管理员模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

管理员模式历史会话根据关联ID筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建已结束的会话    2.历史会话中根据关联ID筛选会话
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #根据关联id获取关联信息
    ${channelInfo}    Get Channel With ChannelId    ${AdminUser}    ${session.techChannelId}
    run keyword if    "${channelInfo}" == "{}"    该关联id获取关联信息，关联id：${session.techChannelId}
    ${channelType}    set variable    ${channelInfo['type']}    #获取关联类型
    #获取管理员模式历史会话数据
    set to dictionary    ${filter}    isAgent=false    techChannelId=${session.techChannelId}    techChannelType=${channelType}    customerName=${session.userName}    #isAgent为true，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    管理员模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    管理员模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

管理员模式历史会话根据客户昵称筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建已结束的会话    2.历史会话中根据客户昵称筛选会话
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取管理员模式历史会话数据
    set to dictionary    ${filter}    isAgent=false    customerName=${session.userName}    #isAgent为true，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    管理员模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    管理员模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

管理员模式历史会话根据是否转接参数筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建进行中的会话    2.将会话转接到其他技能组    3.从待接入中接入待接入会话并手动结束掉    4.历史会话中根据是否转接参数筛选会话
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
    #获取管理员模式历史会话数据
    set to dictionary    ${filter}    page=1    isAgent=false    transfered=true    customerName=${session.userName}    #isAgent为true，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    管理员模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    管理员模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}

管理员模式历史会话根据会话类型筛选数据(/v1/Tenant/me/ServiceSessionHistorys)
    [Documentation]    1.创建进行中的会话    2.将会话转接到其他技能组    3.从待接入中接入待接入会话并手动结束掉    4.历史会话中根据会话类型筛选会话
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
    #结束进行中的会话
    Stop Processing Conversation    ${AdminUser}    ${j[0]['user']['userId']}    ${j[0]['serviceSessionId']}
    #获取管理员模式历史会话数据
    set to dictionary    ${filter}    page=1    isAgent=false    fromAgentCallback=true    customerName=${session.userName}    #isAgent为true，表示管理员模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话查询到该会话不是唯一：${j}
    Should Be True    ${j['items'][0]['fromAgentCallback']}    管理员模式历史会话fromAgentCallback值不正确：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    管理员模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    管理员模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    管理员模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    管理员模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    管理员模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    管理员模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    管理员模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    管理员模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    管理员模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    管理员模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    管理员模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    管理员模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    管理员模式历史会话enquirySummary值不正确：${j}