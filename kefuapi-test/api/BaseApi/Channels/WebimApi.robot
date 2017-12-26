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

/v1/webimplugin/welcome
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取系统欢迎语
    ...
    ...    Request URL:/v1/webimplugin/welcome
    ...
    ...    Request Method: GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/welcome
    ${params}=    set variable    tenantId=${agent.tenantId}&_v=1508139785894
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/tenants/robots/welcome
    [Arguments]    ${agent}    ${timeout}    ${paramData}
    [Documentation]    Description:
    ...
    ...    获取网页插件机器人欢迎语
    ...
    ...    Request URL:/v1/webimplugin/tenants/robots/welcome
    ...
    ...    Request Method: GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/tenants/robots/welcome
    ${params}=    set variable    channelType=${paramData.channelType}&originType=${paramData.originType}&channelId=${paramData.channelId}&tenantId=${paramData.tenantId}&queueName=${paramData.queueName}&agentUsername=${paramData.agentUsername}&_v=1508145602025
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/tenants/{tenantId}/skillgroup-menu
    [Arguments]    ${agent}    ${timeout}
    [Documentation]    Description:
    ...
    ...    获取网页插件技能组绑定欢迎语
    ...
    ...    Request URL:/v1/webimplugin/tenants/{tenantId}/skillgroup-menu
    ...
    ...    Request Method: GET
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/tenants/${agent.tenantId}/skillgroup-menu
    ${params}=    set variable    _=1505908063604
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/emoj/tenants/{tenantId}/packages
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/emoj/tenants/${agent.tenantId}/packages
    ${params}=    set variable    _=1508830444702
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/emoj/tenants/{tenantId}/files
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/emoj/tenants/${agent.tenantId}/files
    ${params}=    set variable    _=1508830444702
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/showMessage
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/showMessage
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/visitors/password
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/visitors/password
    ${params}=    set variable    tenantId=${agent.tenantId}&userId=${agent.userId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/agentnicename/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/agentnicename/options
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/theme/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/theme/options
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/webimplugin/notice/options
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/webimplugin/notice/options
    ${params}=    set variable    tenantId=${agent.tenantId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}
