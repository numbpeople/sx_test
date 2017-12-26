*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Review/QualityReviews_Api.robot

*** Keywords ***
Get Reviews
    [Arguments]    ${agent}    ${filter}    ${range}
    [Documentation]    获取质检数据
    #获取质检数据
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/qualityreviews    ${agent}    ${filter}    ${range}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Search Reviews
    [Arguments]    ${agent}    ${filter}    ${range}
    [Documentation]    获取质检数据
    #获取质检数据
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    Get Reviews    ${agent}    ${filter}    ${range}
    \    Return From Keyword If    ${j['totalElements']} > 0    ${j}
    \    sleep    ${delay}
    Return From Keyword    {}
