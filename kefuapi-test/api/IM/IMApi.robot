*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib

*** Keywords ***
/{orgName}/{appName}/chatfiles
    [Arguments]    ${rest}    ${files}    ${timeout}
    [Documentation]    IM上传文件到服务器
    ${header}=    Create Dictionary    Authorization=Bearer ${rest.token}    restrict-access=true
    ${uri}=    set variable    /${rest.orgName}/${rest.appName}/chatfiles
    Run Keyword And Return    Post Request    ${rest.session}    ${uri}    files=${files}    headers=${header}    timeout=${timeout}

/{orgName}/{appName}/token
    [Arguments]    ${rest}    ${data}    ${timeout}
    [Documentation]    获取token
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /${rest.orgName}/${rest.appName}/token
    Run Keyword And Return    Post Request    ${rest.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
