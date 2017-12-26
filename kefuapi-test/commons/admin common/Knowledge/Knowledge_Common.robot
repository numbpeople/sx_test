*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Knowledge/Knowledge_Api.robot

*** Keywords ***
Get Knowledge Categories
    [Arguments]    ${agent}
    [Documentation]    获取知识库的菜单分类
    #获取知识库的菜单分类
    ${resp}=    /v1/tenants/{tenantId}/knowledge/categories/tree    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
