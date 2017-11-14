*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/CustomerTagApi.robot

*** Test Cases ***
获取访客标签数据(/v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/)
    : FOR    ${visitorid}    IN    @{visitorUserId}
    \    ${resp}=    /v1/Tenant/VisitorUsers/{visitorUserId}/VisitorUserTags/    ${AdminUser}    ${visitorid}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    Should Not Be Empty    ${resp.content}    返回值为空
    \    ${j}    to json    ${resp.content}
    \    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    返回的访客数据中tenantId不正确
    \    Should Be Equal    ${j[0]['visitorUserId']}    ${visitorid}    返回的访客数据中userId不正确

获取访客标签(/v1/Admin/UserTags)
    ${resp}=    /v1/Admin/UserTags    ${AdminUser}    ${FilterEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']}>=0    获取的访客标签数不正确：${resp.content}
