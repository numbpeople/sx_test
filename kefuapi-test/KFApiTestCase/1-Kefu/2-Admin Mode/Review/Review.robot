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

对已质检评分的会话提起申诉(/v1/quality/tenants/{tenantId}/appeals)
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
    should be equal    ${j['status']}    OK    接口返回值status不正确:${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不唯一:${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.sessionServiceId}    质检接口返回值serviceSessionId不正确:${j}
    #获取租户的质检评分项
    ${qualityResults}    Get Qualityitems
    #对该服务进行质检评分,并记录质检id
    ${sessionInfo}    create dictionary    serviceSessionId=${session.sessionServiceId}    stepNum=1
    ${j}=    Quality Review    ${sessionInfo}    ${qualityResults}
    should be equal    ${j["status"]}    OK    质检评分不正确:${j}
    ${reviewId}    set variable    ${j["entity"]["id"]}
    #对质检记录提起申诉
    ${j}=    Submmit A Quality Appeal    ${AdminUser}    ${range}    ${reviewId}
    should be equal    ${j["status"]}    OK    质检提起申诉不正确:${j}
    should be equal    ${j["entity"]["status"]}    Wait    质检提起申诉不正确:${j["entity"]["status"]}
    ${appealNumber}    set variable    ${j["entity"]["appealNumber"]}
    ${id}    set variable    ${j["entity"]["id"]}
    #    set to dictionary    ${filter}    creatorId=${j["entity"]["creatorId"]}
    #根据申诉单号搜索申诉列表检查是否有记录
    set to dictionary    ${filter}    page=0    appealNumber=${appealNumber}
    #    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&timeBegin=${range.beginDate}&timeEnd=${range.endDate}&creatorId=${filter.creatorId}&appealNumber=${filter.appealNumber}
    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&appealNumber=${filter.appealNumber}
    ${j}=    Search Appeal    ${AdminUser}    ${range}    ${filter}    ${params}
    should be equal    ${j["status"]}    OK    质检评分不正确:${j}
    #验证申诉记录是否与预期一致
    ${subject}    set variable    This is a subject of appeal
    ${content}    set variable    This is a content of appeal
    should be true    ${j["totalElements"]}==1    接口返回数据不唯一:${j}
    should be equal    ${j['entities'][0]['appealNumber']}    ${appealNumber}    接口返回值appealNumber不正确:${j['entities'][0]['appealNumber']}
    should be equal    ${j['entities'][0]['content']}    ${content}    接口返回值content不正确:${j['entities'][0]['content']}
    should be equal    ${j['entities'][0]['subject']}    ${subject}    接口返回值subject不正确:${j['entities'][0]['subject']}
    should be equal    ${j['entities'][0]['creatorId']}    ${AdminUser.userId}    接口返回值creatorId不正确:${j['entities'][0]['creatorId']}
    should be equal    ${j['entities'][0]['id']}    ${id}    接口返回值id不正确:${j['entities'][0]['id']}
    should be equal    ${j['entities'][0]['reviewId']}    ${reviewId}    接口返回值reviewId不正确:${j['entities'][0]['reviewId']}
    should be equal    ${j['entities'][0]['status']}    Wait    接口返回值status不正确:${j['entities'][0]['status']}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    接口返回值tenantId不正确:${j['entities'][0]['tenantId']}
