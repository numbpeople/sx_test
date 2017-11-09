*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Settings/SatisfactionSurveyApi.robot

*** Keywords ***
Get evaluationdegreeId
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #获取评价级别id
    log    ${j['entities'][0]['id']}
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    Append To List    ${r1}    ${r2}
    set global variable    ${degreeId}    ${r1}
    set global variable    ${evaluationdegreeId}    ${degreeId[0]}
