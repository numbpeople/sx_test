*** Settings ***
Resource    ../../Common/BaseCommon.robot
Resource    ../../Variable_Env.robot


*** Keywords ***
/{orgName}/{appName}/msghooks
    [Documentation]    增加/查看所有发送前回调详情
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    ${uri}=    Set Variable    /${pathParamter.orgName}/${pathParamter.appName}/msghooks
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}


/{orgName}/{appName}/msghooks/{msghooksname}
    [Documentation]    查询/删除/修改单个发送前回调
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    ${uri}=    Set Variable    /${pathParamter.orgName}/${pathParamter.appName}/msghooks/${pathParamter.msgHooksName}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}