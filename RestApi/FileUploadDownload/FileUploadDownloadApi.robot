*** Settings ***
Resource          ../../Common/BaseCommon.robot

*** Keywords ***
/{orgName}/{appName}/chatfiles
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${files}=
    [Documentation]    上传图片、语音、视频等消息
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatfiles
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${files}

/{orgName}/{appName}/chatfiles/{fileStream}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    下载语音/图片文件
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatfiles/${pathParamter.fileStream}
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}

/{orgName}/{appName}/chatfiles/{fileUUID}
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    下载缩略图
    ${uri}=    set variable    /${pathParamter.orgName}/${pathParamter.appName}/chatfiles/{${pathParamter.fileUUID}
    Run Keyword And Return    request method    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}
