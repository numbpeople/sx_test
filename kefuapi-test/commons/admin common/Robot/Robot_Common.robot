*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/KefuApi.robot

*** Keywords ***
Get Robotlist
    [Documentation]    获取所有机器人的tenantId和userId的字典集合
    #获取多机器人的id
    ${resp}=    /v1/Tenants/{tenantId}/robot/profile/personalInfos    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    log    ${resp.content}
    ${j}    to json    ${resp.content}
    log    ${resp.content}
    &{robotList}    create dictionary
    : FOR    ${i}    IN RANGE    ${j['numberOfElements']}
    \    ${tenantId}=    convert to string    ${j['content'][${i}]['tenantId']}
    \    ${userId}=    convert to string    ${j['content'][${i}]['robotId']}
    \    log    ${tenantId}
    \    log    ${userId}
    \    set to dictionary    ${robotList}    ${tenantId}=${userId}
    Return From Keyword    ${robotList}
