*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/SatisfactionSurveyApi.robot

*** Test Cases ***
获取满意度评价级别（/v1/tenants/{tenantId}/evaluationdegrees）
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
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
    \    ${level}=    Convert To String    ${j['entities'][${i}]['level']}
    set global variable    ${degreeId}    ${r1}
    set global variable    ${evaluationdegreeId}    ${degreeId[0]}

获取租户满意度评价标签(/v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags)
    set global variable    ${evaluationdegreeId}    ${degreeId}
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags    ${AdminUser}    ${timeout}    ${evaluationdegreeId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    ${name}=    Convert To String    ${j['entities'][${i}]['name']}
