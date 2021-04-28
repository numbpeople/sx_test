*** Keywords ***
/{orgName}/{appName}/chatmessages/{time}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${files}=
    [Documentation]    发送文本、图片、语音、视频、扩展等消息
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatmessages/{time}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${files}
/{orgName}/{appName}/chatmessages/roaming_settings?settingType={msg_type}
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${msg_type}
    [Documentation]    查询漫游消息设置
    ${uri}=    Set Variable    ${pathParamter.orgName}/${pathParamter.appName}/chatmessages/roaming_settings?settingType=${msg_type}
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}
/{orgName}/{appName}/chatmessages/roaming_settings?settingType
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${msg_type}
    [Documentation]    漫游消息设置
    ${uri}=    Set Variable    ${pathParamter.orgName}/${pathParamter.appName}/chatmessages/roaming_settings?settingType=${msg_type}
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}