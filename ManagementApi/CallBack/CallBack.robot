*** Keywords ***
回调服务
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    management上开通、关闭回调服务
    ${uri}=    set variable    /os/service/definition?serviceName=callback
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}


设置回调规则上线
    [Arguments]    ${method}    ${session}    ${header}    ${pathParamter}    ${params}=    ${data}=
    ...    ${file}=
    [Documentation]    management上设置回调规则上线
    ${uri}=    set variable    /os/service/definition?serviceName=callback&appkey=${pathParamter.orgName}%23${pathParamter.appName}&cluster=${pathParamter.cluster}
    Run Keyword And Return    request    ${method}    ${session}    ${uri}    ${header}    ${params}
    ...    ${data}    ${file}