*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          api/KefuApi.robot
Resource          api/RoutingApi.robot

*** Test Cases ***
客服删除新增加关联、账号和技能组并登出
    #删除新增的关联指定
    ${cData}=    create dictionary    dutyType=None    id=0    id2=0    type=    type2=
    set to dictionary    ${AgentQueue1}    channelData=${cData}
    ${data}=    evaluate    {"tenantId":"${AdminUser.tenantId}","type":"easemob","id":"${RestEntity.channelId}","dutyType":"${AgentQueue1.channelData.dutyType}","name":"${RestEntity.channelName}","info":"${RestEntity.orgName}#${RestEntity.appName}#${RestEntity.serviceEaseMobIMNumber}","id1":"${AgentQueue1.channelData.id}","type1":"${AgentQueue1.channelData.type}","id2":"${AgentQueue1.channelData.id2}","type2":"${AgentQueue1.channelData.type2}"}
    ${resp}=    /v1/tenants/{tenantId}/channel-data-binding    ${AdminUser}    ${cData}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #删除新增技能组
    ${resp}=    /v1/AgentQueue/{queueId}    ${AdminUser}    ${AgentQueue1.queueId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}
    #删除新增账号
    ${resp}=    /v1/Admin/Agents/{userId}    ${AdminUser}    ${AgentUser1.userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}
    #删除新增关联
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel/{channelId}    ${AdminUser}    ${RestEntity.channelId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}
    #退出
    ${resp}=    /logout    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
