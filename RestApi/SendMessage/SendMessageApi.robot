*** Keywords ***
/{org_name}/{app_name}/messages
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${header}    ${data}    ${timeout}
    [Documentation]    发送文本、图片、语音、视频、扩展等消息
    ${uri}=    set variable    /${org_name}/${app_name}/messages
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
