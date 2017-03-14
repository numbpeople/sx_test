*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/KefuApi.robot
Resource          api/ThirdPartApi.robot

*** Test Cases ***
学而思统计接口关联发送消息数(/v1/Tenant/me/ServiceSession/Statistics/MessageCountByTechChannelList)
    set to dictionary    ${DateRange}    beginDate=2016-01-01T00%3A00%3A00.000Z    endDate=2099-01-01T23%3A59%3A59.000Z
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/MessageCountByTechChannelList    ${AdminUser}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j[0]['messageCount']}>=0    不正确的消息数:${resp.content}

学而思统计接口关联创建会话数(/v1/Tenant/me/ServiceSession/Statistics/EveryTechChannelNewServiceSessionCount)
    set to dictionary    ${DateRange}    beginDate=2016-01-01T00%3A00%3A00.000Z    endDate=2099-01-01T23%3A59%3A59.000Z
    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/EveryTechChannelNewServiceSessionCount    ${AdminUser}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    ${j[0]['messageCount']}>=0    不正确的消息数:${resp.content}
