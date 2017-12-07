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
获取质量检查数据(/v1/tenants/{tenantId}/timeplans/schedules)
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

创建会话并检查质检数据(/v1/tenants/{tenantId}/timeplans/schedules)
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
