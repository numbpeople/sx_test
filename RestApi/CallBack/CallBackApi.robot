*** Settings ***
Resource    ../../Common/BaseCommon.robot
Resource    ../../Variable_Env.robot


*** Keywords ***
/{orgName}/{appName}/callbacks
    [Documentation]    增加/查看所有发送后回调详情
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    ${uri}=    Set Variable    /${pathParamter.orgName}/${pathParamter.appName}/callbacks
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}


/{orgName}/{appName}/callbacks/{callbackname}
    [Documentation]    查询/删除/修改单个发送后回调
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    ${uri}=    Set Variable    /${pathParamter.orgName}/${pathParamter.appName}/callbacks/${pathParamter.callbackname}
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}