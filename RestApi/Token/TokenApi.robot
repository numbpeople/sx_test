*** Settings ***
Resource    ../../Common/BaseCommon.robot

*** Keywords ***
/management/token/superToken
    [Arguments]    ${session}    ${header}    ${data}    ${timeout}
    [Documentation]    获取超级token
    ${uri}=    set variable    /management/token/superToken
    Run Keyword And Return    Post Request    ${session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/management/token
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}=   ${params}=    ${data}=    ${file}=
    [Documentation]    获取org token
    ${uri}=    set variable    /management/token
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}    ${data}    ${file}
    
/{org_name}/{app_name}/token
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}=    ${params}=    ${data}=    ${file}=
    [Documentation]    通过client_id和client_secret获取app token和获取普通用户token
    ${org_name}    set variable    ${pathParamter.org_name}
    ${app_name}    set variable    ${pathParamter.app_name}
    ${uri}=    set variable    /${org_name}/${app_name}/token
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}    ${data}    ${file}