*** Settings ***
Resource          ../Common/BaseCommon.robot

*** Keywords ***
开通增值回调服务/{org_anme}/{app_name}/subscriptions/IMEnterprise-monthly
    [Documentation]    开通回调增值服务
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}    ${data}    ${file}
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/subscriptions/IMEnterprise-monthly
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}    ${data}    ${file}
 