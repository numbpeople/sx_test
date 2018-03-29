*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          ../../../api/BaseApi/Notification/MsgCenterApi.robot

*** Variables ***

*** Keywords ***
Mark Read Activity
    [Arguments]    ${agent}    ${activityId}    ${timeout}
    [Documentation]    标记消息从未读到已读
    #标记消息从未读到已读
    ${resp}=    /v2/users/{agentUserId}/activities/{activitiesId}    ${agent}    ${activityId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    202    不正确的状态码:${resp.status_code}
