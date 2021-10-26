*** Settings ***
Resource    ../../Common/BaseCommon.robot
*** Keywords ***
/{orgName}/{appName}/callbacks
    [Documentation]    增加/查看所有回调详情
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    ${uri}=    Set Variable    /${pathParamter.orgName}/${pathParamter.appName}/callbacks
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}
/{orgName}/{appName}/callbacks/{callbackname}
    [Documentation]    查询/删除/修改单个回调
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    ${uri}=    Set Variable    /${pathParamter.orgName}/${pathParamter.appName}/callbacks/${pathParamter.callbackname}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}