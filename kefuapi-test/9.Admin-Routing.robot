*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Force Tags        routing
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          MsgCenterApi.robot
Library           uuid

*** Test Cases ***
获取消息中心未读消息数据(/users/{agentUserId}/activities)
    [Documentation]    设置路由规则：
    ...
    ...    规则为：渠道指定技能组规则
    ...
    ...    前提：
    ...    1.将所发消息关联设置为空
    ...    2.渠道指定技能组A
    [Tags]
    #获取未读消息，并标记
    ${resp}=    /users/{agentUserId}/activities    ${AdminUser}    ${timeout}    unread
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j['count_total']}
    log    ${j['count_unread']}
    Should Be True    ${j['count_total']} >= 1    count_total返回值不正确:${j}
    Should Be True    ${j['count_unread']} >= 1    count_unread返回值不正确:${j}
    #发送未读消息
    ${secs} =    Get Time    epoch
    ${uuid} =    Uuid 4
    ${uuid1} =    Uuid 4
    ${msgCenterEntity}=    create dictionary    actorId=${uuid}    actorName=leoli_01_${secs}    objectId=${uuid1}
    log    ${msgCenterEntity}=
    ${data}=    set variable    {"receiverIds":["${AdminUser.userId}"],"activity":{"actor":{"id":"${msgCenterEntity.actorId}","objectType":"visitor","name":"${msgCenterEntity.actorName}","avatar":"/avatars/223.jpg"},"verb":"POST","object":{"id":"${msgCenterEntity.objectId}","uri":"http://www.baidu.com","content":{"summary":"status has changed.","detail":"status has changed：customer has sent."}}}}
    ${resp}=    /v1/tenants/{tenantId}/activities    ${AdminUser}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
