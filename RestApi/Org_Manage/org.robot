*** Settings ***

*** Keywords ***
/management/organizations
    [Arguments]    ${session}    ${header}    ${data}    ${timeout}
    [Documentation]    创建org和org管理员
    ${uri}=    set variable    /management/organizations
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/management/users/{username}
    [Arguments]    ${session}    ${username}    ${header}    ${data}    ${timeout}
    [Documentation]    激活org管理员接口
    ${uri}=    set variable    /management/users/${username}
    Run Keyword And Return    Put Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/management/orgs/{orgname}
    [Arguments]    ${session}    ${orgname}    ${header}    ${timeout}
    [Documentation]    获取org信息
    ${uri}=    set variable    /management/orgs/${orgname}
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/management/users/{username}/password
    [Arguments]    ${session}    ${username}    ${header}    ${data}    ${timeout}
    [Documentation]    修改org管理员密码
    ${uri}=    set variable    /management/users/${username}/password
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}
