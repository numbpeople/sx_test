*** Settings ***
Library    requests
Library    RequestsLibrary
Library    ollections
Library    json
Resource    ../../RestApi/CallBack/CallBackApi.robot
*** Keywords ***
增加一个回调
    [Documentation]    创建一个回调
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    ${resp}=    /{orgName}/{appName}/callbacks    POST    ${session}    ${header}    pathParamter=${pathParamter}
    ...    data=${data}    
删除一个回调
    [Documentation]    删除一个回调
    [Arguments]    ${session}    ${header}    ${pathParamter}    ${data}
    ${resp}=    /{orgName}/{appName}/callbacks/{callbackname}    DELETE    ${session}    ${header}    ${pathParamter}
    ...    data=${data}  
查看所有回调
修改一个回调
查看单个回调