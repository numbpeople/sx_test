*** Settings ***
Resource          ../../Common/BaseCommon.robot

*** Keywords ***
/management/organizations/{orgName}/applications
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    创建/获取App
    ${uri}=    set variable    /management/organizations/${pathParamter.orgName}/applications
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{org_name}/{app_name}/credentials
    [Arguments]    ${session}    ${org_name}    ${app_name}    ${header}    ${timeout}
    [Documentation]    获取App密钥
    ${uri}=    set variable    /${org_name}/${app_name}/credentials
    Run Keyword And Return    Get Request    ${session}    ${uri}    headers=${header}    timeout=${timeout}

/management/organizations/{orgName}/applications/{appName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取指定App信息
    ${uri}=    set variable    /management/organizations/${pathParamter.orgName}/applications/${pathParamter.appName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/management/organizations/{orgName}/applications/list/console
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}    ${data}=
    ...    ${file}=
    [Documentation]    获取App
    ${uri}=    set variable    /management/organizations/${pathParamter.orgName}/applications/list/console
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    获取App
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}
