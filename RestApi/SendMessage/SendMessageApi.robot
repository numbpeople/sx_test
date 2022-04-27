*** Settings ***
Resource          ../../Common/BaseCommon.robot
*** Keywords ***
/{orgName}/{appName}/messages
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${files}=
    [Documentation]    发送文本、图片、语音、视频、扩展等消息
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/messages
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${files}

/{orgName}/{appName}/messages?useMsgId=true
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${files}=
    [Documentation]    发送文本、图片、语音、视频、扩展等消息
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/messages?useMsgId=true
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${files}