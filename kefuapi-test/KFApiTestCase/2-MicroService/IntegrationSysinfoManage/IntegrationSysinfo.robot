*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../api/MicroService/IntegrationSysinfoManage/CheckisnewuserApi.robot
Resource          ../../../api/MicroService/IntegrationSysinfoManage/GrowingIOApi.robot
Resource          ../../../AgentRes.robot

*** Test Cases ***
获取版本更新信息(/v1/tenants/{tenantId}/agents/{agentId}/news/latest)
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/news/latest    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    ${status}    Run Keyword And Return Status    Should Not Be Empty    ${j['entity']['content']}    获取版本更新信息不正确：${resp.content}
    #断言结果是None或者不为空
    Should Be True    ('${j['entity']['content']}' == 'None') or ${status}

获取新手任务信息(/v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser)
    ${resp}=    /v1/tenants/{tenantId}/agents/{agentId}/checkisnewuser    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be Equal    ${j['status']}    OK    获取新手任务信息不正确：${resp.content}
