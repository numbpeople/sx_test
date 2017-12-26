*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Customers/Customers_Api.robot
Resource          ../../../../api/MicroService/Webapp/InitApi.robot

*** Test Cases ***
获取访客中心列表(/v1/crm/tenants/{tenantId}/agents/{agentId}/customers)
    ${resp}=    /v1/crm/tenants/{tenantId}/agents/{agentId}/customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} >= 0    访客中心人数不正确：${resp.content}

获取访客中心数据(/tenants/{tenantId}/visitorusers)
    ${resp}=    /tenants/{tenantId}/visitorusers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取的访客数不正确：${resp.content}

获取客户中心列表(/v1/crm/tenants/{tenantId}/customers)
    ${resp}=    /v1/crm/tenants/{tenantId}/customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} >= 0    访客中心人数不正确：${resp.content}
