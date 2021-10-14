*** Settings ***
Resource          ../../Common/BaseCommon.robot

*** Keywords ***
/management/token/superToken
    [Arguments]    ${session}    ${header}    ${data}    ${timeout}
    [Documentation]    获取超级token
    ${uri}=    set variable    /management/token/superToken
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/management/token
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}=    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取org token
    ${uri}=    set variable    /management/token
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/token
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    通过client_id和client_secret获取app token和获取普通用户token
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/token
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}