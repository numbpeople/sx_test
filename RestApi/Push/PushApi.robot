*** Settings ***
Resource          ../../Common/BaseCommon.robot

*** Keywords ***
/{org_name}/{app_name}/notifiers
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]   
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/notifiers/${params}
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}
