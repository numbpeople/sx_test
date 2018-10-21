*** Settings ***
Force Tags        basicReview
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Review/Review_Common.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/admin common/Daas/Daas_Common.robot

*** Test Cases ***
获取质量检查数据(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    #获取质检数据
    ${j}=    Get Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK

创建会话并检查质检数据(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、totalElements字段值等于1、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    groupId=${session.queueId}
    #根据queueId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    run keyword if    ${j} == {}    Fail    根据技能组id(queueId)筛选当天质检数据，没有找到数据
    should be equal    ${j['status']}    OK    接口返回值status不正确, ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不唯一, ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.sessionServiceId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '0'    质检接口返回值amsgCount不正确：${j}

创建会话并进行质检评分(/v1/tenants/{tenantId}/servicesessions/{sessionId}/steps/{stepId}/qualityreview)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、获取租户的质检评分项，调用接口：/v1/tenants/{tenantId}/qualityreviews/qualityitems，接口请求状态码为200。
    ...    - Step4、对该服务进行质检评分，调用接口：/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview，接口请求状态码为200。
    ...    - Step5、检查该服务的质检结果是否与预期一致，调用接口：/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    groupId=${session.queueId}
    #根据queueId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    run keyword if    ${j} == {}    Fail    根据技能组id(queueId)筛选当天质检数据，没有找到数据
    should be equal    ${j['status']}    OK    接口返回值status不正确, ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不唯一, ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.sessionServiceId}    质检接口返回值serviceSessionId不正确, ${j}
    #获取租户的质检评分项
    ${qualityResults}    Get Qualityitems
    #对该服务进行质检评分
    ${sessionInfo}    create dictionary    serviceSessionId=${session.sessionServiceId}    stepNum=1
    ${j}=    Quality Review    ${sessionInfo}    ${qualityResults}
    #检查该服务的质检结果是否与预期一致
    ${comment}    set variable    This is a comment of quality review!
    ${j}=    Get Quality Review    ${sessionInfo}
    should be equal    ${j["status"]}    OK    质检评分不正确:${j}
    Should Be Equal    ${j['entity']['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    '${j['entity']['appeals']}'    '[]'    质检接口返回值的appeals不正确：${j}
    Should Be Equal    '${j['entity']['attachments']}'    '[]'    质检接口返回值的attachments不正确：${j}
    Should Be Equal    ${j['entity']['comment']}    ${comment}    质检接口返回值的comment不正确：${j}
    Should Be Equal    ${j['entity']['reviewerId']}    ${AdminUser.userId}    质检接口返回值的reviewerId不正确：${j}
    Should Be Equal    ${j['entity']['serviceSessionId']}    ${session.sessionServiceId}    质检接口返回值的serviceSessionId不正确：${j}
    Should Be Equal    '${j['entity']['stepId']}'    '${sessionInfo.stepNum}'    质检接口返回值的stepId不正确：${j}
    Should Be Equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的tenantId不正确：${j}
    Should Be Equal    ${j['entity']['totalScore']}    ${score}    质检接口返回值的totalScore不正确：${j}

管理员模式基础质检按渠道筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据渠道和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    originType=${session.originType}    groupId=${session.queueId}
    #根据渠道和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' >= '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.sessionServiceId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '0'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按关联Id筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据关联Id和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    channelId=${session.techChannelId}    groupId=${session.queueId}
    #根据关联和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' >= '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.sessionServiceId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '0'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按首响时长筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据首响时长和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    firstResponseTime=2    groupId=${session.queueId}
    #根据首响时长和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '1'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按会话时长筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据会话时长和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    sessionTime=2    groupId=${session.queueId}
    #根据首响时长和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '1'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按平均响应时长筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据平均响应时长和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    avgResponseTime=2    groupId=${session.queueId}
    #根据平均响应时长和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '1'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按访客消息数筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据访客消息数和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    vmsgCount=1    groupId=${session.queueId}
    #根据访客消息数和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '1'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按坐席消息数筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据坐席消息数和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    amsgCount=1    groupId=${session.queueId}
    #根据坐席消息数和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '1'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按满意度已评价筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据满意度已评价和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    visitorMark=1    groupId=${session.queueId}
    #根据满意度评价和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '1'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按满意度未评价筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据满意度未评价和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Unvalid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    visitorMark=0    groupId=${session.queueId}
    #根据满意度评价和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '0'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按质检状未评价筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据质检状未评价和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Valid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    hasQM=V_NO    groupId=${session.queueId}
    #根据质检未评价和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '1'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按质检状已评价筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据质检状已评价和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Unvalid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    hasQM=V_YES    groupId=${session.queueId}
    #根据质检已评价和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '0'    质检接口返回值amsgCount不正确：${j}

管理员模式基础质检按质检员筛选(/v1/tenants/{tenantId}/servicesessions/qualityreviews)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表并手动结束（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、根据按质检员和技能组id、筛选当天的质量检查数据，调用接口：/v1/tenants/{tenantId}/servicesessions/qualityreviews，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、agentId字段值等于服务的坐席id、serviceSessionId字段值等于会话id、等等。
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建单服务有效会话
    ${session}    One Service Unvalid Conversation    ${AdminUser}    ${restentity}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    qmActorId=${session.qmActorId}    groupId=${session.queueId}
    #根据质检员和groupId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    should be equal    ${j['status']}    OK    接口返回值status不正确: ${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不正确: ${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.serviceSessionId}    质检接口返回值serviceSessionId不正确, ${j}
    Should Be Equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    质检接口返回值的租户id不正确：${j}
    Should Be Equal    ${j['entities'][0]['agentId']}    ${AdminUser.userId}    质检接口返回值的agentId不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['userId']}    ${session.userId}    质检接口返回值的访客userid不正确：${j}
    Should Be Equal    ${j['entities'][0]['visitorUser']['username']}    ${session.userName}    质检接口返回值的访客username不正确：${j}
    Should Be Equal    ${j['entities'][0]['chatGroupId']}    ${session.chatGroupId}    质检接口返回值的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['entities'][0]['state']}    Terminal    质检接口返回值state不是Terminal：${j}
    Should Be Equal    ${j['entities'][0]['queueId']}    ${session.queueId}    质检接口返回值queueId不正确：${j}
    Should Be Equal    ${j['entities'][0]['originType'][0]}    ${session.originType}    质检接口返回值originType不正确：${j}
    Should Be True    '${j['entities'][0]['vmsgCount']}' == '1'    质检接口返回值vmsgCount不正确：${j}
    Should Be True    '${j['entities'][0]['amsgCount']}' == '0'    质检接口返回值amsgCount不正确：${j}
