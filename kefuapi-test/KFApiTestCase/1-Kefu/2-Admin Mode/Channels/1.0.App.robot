*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Library           ../../../../lib/KefuUtils.py
Resource          ../../../../AgentRes.robot
Resource          ../../../../AgentRes.robot
Resource          ../../../../JsonDiff/Channels/RestChannelsJsonDiff.robot
Resource          ../../../../commons/admin common/BaseKeyword.robot
Resource          ../../../../api/BaseApi/Channels/AppApi.robot

*** Test Cases ***
获取所有app关联(/channels)
    ${resp}=    /channels    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无app关联
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    获取app关联失败
    log    ${j}
    log    ${resp.content}
