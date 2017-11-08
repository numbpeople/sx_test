*** Keywords ***
/{orgName}/{appName}/chatfiles
    [Arguments]    ${rest}    ${files}    ${timeout}
    [Documentation]    IM上传文件到服务器
    ${header}=    Create Dictionary    Authorization=Bearer ${rest.token}    restrict-access=true
    ${uri}=    set variable    /${rest.orgName}/${rest.appName}/chatfiles
    Run Keyword And Return    Post Request    ${rest.session}    ${uri}    files=${files}    headers=${header}    timeout=${timeout}
