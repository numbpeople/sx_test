*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/MicroService/Webapp/OutDateApi.robot

*** Test Cases ***
获取租户系统配置信息(/v1/Tenant/me/Configuration)
    [Tags]    unused
    ${resp}=    /v1/Tenant/me/Configuration    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无app关联
    ...    ELSE    Should Be Equal    '${j['tenantId']}'    '${AdminUser.tenantId}'    获取app关联失败:${resp.content}
