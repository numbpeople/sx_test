*** Settings ***
Library           RequestsLibrary

*** Variables ***

*** Keywords ***
/v1/webimplugin/settings/template
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取网页插件默认模板信息
    ...
    ...    Request URL:/v1/webimplugin/settings/template
    ...
    ...    Request Method: GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/settings/template
    ${params}=    set variable    _=1505908063605
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/settings/tenants/{tenantId}/configs
    [Arguments]    ${agent}    ${method}    ${timeout}    ${data}    ${configId}
    [Documentation]    Description:
    ...
    ...    获取/修改租户的网页插件配置
    ...
    ...    Request URL: /v1/webimplugin/settings/tenants/{tenantId}/configs
    ...
    ...    Request Method: GET / PUT / POST / DELETE
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/settings/tenants/${agent.tenantId}/configs
    ${uriDelete}=    set variable    /v1/webimplugin/settings/tenants/${agent.tenantId}/configs/${configId}
    ${params}=    set variable    page=1&per_page=100&_=1505908063604
    ${dataJson}    Run Keyword If    '${data}' != '${EMPTY}'    to json    ${data}
    ${dataParams}    Run Keyword If    '${data}' != '${EMPTY}'    set variable    configName=${dataJson['configName']}&isDefault=${dataJson['isDefault']}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    params=${dataParams}
    ...    data=${data}    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uriDelete}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v1/webimplugin/settings/tenants/{tenantId}/configs/{configId}/global
    [Arguments]    ${agent}    ${timeout}    ${configId}    ${data}
    [Documentation]    Description:
    ...
    ...    修改网页插件配置信息
    ...
    ...    Request URL:/v1/webimplugin/settings/tenants/{tenantId}/configs/{configId}/global
    ...
    ...    Request Method: PUT
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/settings/tenants/${agent.tenantId}/configs/${configId}/global
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/webimplugin/settings/visitors/configs/{configId}
    [Arguments]    ${agent}    ${timeout}    ${configId}
    [Documentation]    Description:
    ...
    ...    获取网页插件配置
    ...
    ...    Request URL:/v1/webimplugin/settings/visitors/configs/{configId}
    ...
    ...    Request Method: GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/settings/visitors/configs/${configId}
    ${params}=    set variable    _=1505908063604
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/targetChannels
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取网页插件关联信息
    ...
    ...    Request URL:/v1/webimplugin/targetChannels
    ...
    ...    Request Method: GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/targetChannels
    ${params}=    set variable    tenantId=${agent.tenantId}&_v=1508139785894
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/tenants/show-message
    [Arguments]    ${agent}    ${timeout}    ${paramData}
    [Documentation]    Description:
    ...
    ...    获取网页插件是否上下班
    ...
    ...    Request URL:/v1/webimplugin/tenants/show-message
    ...
    ...    Request Method: GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/tenants/show-message
    ${params}=    set variable    channelType=${paramData.channelType}&originType=${paramData.originType}&channelId=${paramData.channelId}&tenantId=${paramData.tenantId}&queueName=${paramData.queueName}&agentUsername=${paramData.agentUsername}&timeScheduleId=${paramData.timeScheduleId}&_v=1508145602025
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
