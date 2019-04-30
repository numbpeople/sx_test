*** Keywords ***
/{org_name}/{app_name}/chatfiles
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${header}    ${file}    ${timeout}
    [Documentation]    上传图片、语音、视频等消息
    ${uri}=    set variable    /${org_name}/${app_name}/chatfiles
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    files=${file}    timeout=${timeout}
