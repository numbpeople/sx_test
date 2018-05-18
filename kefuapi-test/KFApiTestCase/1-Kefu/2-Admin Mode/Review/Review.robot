*** Settings ***
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
    [Setup]
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
    [Setup]
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
    [Tags]
    [Setup]
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
    [Setup]
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
    set to dictionary    ${filter}    originType=${session.originType}
    #根据渠道筛选当天质检数据，验证筛选结果的第一条数据是期望值
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
    [Setup]
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
    set to dictionary    ${filter}    channelId=${session.techChannelId}
    #根据关联筛选当天质检数据，验证筛选结果的第一条数据是期望值
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
    [Setup]
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
    [Setup]
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
    [Setup]
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
    [Setup]
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
    [Setup]
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
    [Setup]
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
    [Setup]
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
    [Setup]
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
    [Setup]
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
    [Setup]
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

