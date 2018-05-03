*** Keywords ***
/v1/Tenants/me/robot/rule/group/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rule/group/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/robot/menu/items
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/menu/items
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&q=${filter.q}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/menu/items
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/menu/items
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&q=${filter.q}
    ${rs}=    Run Keyword If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    params=${params}    timeout=${timeout}
    Return From Keyword    ${rs}

/v1/Tenants/{tenantId}/robots/intent/list
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/intent/list
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/robot/rules
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rules
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&q=${filter.q}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/rules
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/rules
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&q=${filter.q}&_=1524888233192
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/rule/item
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/rule/item
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/rule/group/count
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/rule/group/count
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/me/robot/rule/items/template
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/rule/items/template
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/rule/items/template
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/rule/items/template
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/media/items
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/media/items
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/me/robot/profile/setting
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/profile/setting
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/setting
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/setting
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/settings
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/settings
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&_=1524882756868
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/predefinedReplys
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}    ${replyId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/predefinedReply
    run keyword if    '${method}'=='get'    set suite variable    ${uri}    /v1/Tenants/${agent.tenantId}/robot/profile/predefinedReplys
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&type=${filter.type}
    run keyword if    '${method}'=='delete'    set suite variable    ${params}    replyId=${replyId}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    
/v1/Tenants/{tenantId}/robots/greetings
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/greetings
    ${params}    set variable    _=1524882756868
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/robotUserTransferKf
    [Arguments]    ${method}    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/robotUserTransferKf
    ${params}    set variable    _=1524882756894
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    
/v1/Tenants/me/robot/profile/personalInfo
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/me/robot/profile/personalInfo
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/personalInfo
    [Arguments]    ${agent}    ${language}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/personalInfo
    ${params}    set variable    language=${language}&_=1524820513174
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/profile/personalInfos
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/profile/personalInfos
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/userChannelSwitches
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/userChannelSwitches
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robot/userChannelSwitches/{channel}
    [Arguments]    ${agent}    ${channel}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robot/userChannelSwitches/${channel}
    Run Keyword And Return    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/freechat
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/freechat
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/recommendationSwitch
    [Arguments]    ${agent}    ${switchType}    ${switchId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/recommendationSwitch
    ${params}=    set variable    switchType=${switchType}&switchId=${switchId}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/recommendation/status
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/recommendation/status
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v3/Tenants/{tenantId}/robot/profile/personalInfos
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robot/profile/personalInfos
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&_=1524882756866
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/rules/search
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/rules/search
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&q=${filter.q}&_=1524891109721
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/menus/search
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/menus/search
    ${params}    set variable    page=${filter.page}&per_page=${filter.per_page}&q=${filter.q}&_=1524891109721
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v1/Tenants/{tenantId}/robots/kb/ask
    [Arguments]    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenants/${agent.tenantId}/robots/kb/ask
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/categorys/trees
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/categorys/trees
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/rules/records
    [Arguments]    ${agent}    ${filter}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/rules/records
    ${params}    set variable    pageIndex=${filter.pageIndex}&pageSize=${filter.pageSize}&page=${filter.page}&per_page=${filter.per_page}&start=${filter.start}&end=${filter.end}&_=1524882756904
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/rules/item
    [Arguments]    ${method}    ${agent}    ${data}    ${ruleId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/rules/item
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/rules/item/${ruleId}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/categorys/item
    [Arguments]    ${method}    ${agent}    ${data}    ${categoryId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/categorys/item
    run keyword if    '${method}'=='put' or '${method}'=='delete'    set suite variable    ${uri}    /v3/Tenants/${agent.tenantId}/robots/categorys/item/${categoryId}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/rule/template
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/rule/template?locale=zh_CN
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/rule/export
    [Arguments]    ${agent}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/rule/export
    ${params}    set variable    locale=zh_CN&userId=${agent.userId}&name=${agent.nicename}
    Run Keyword And Return    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/menus/item
    [Arguments]    ${method}    ${agent}    ${data}    ${itemId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/menus/item
    run keyword if    '${method}'=='delete'    set suite variable    ${uri}    /v3/Tenants/${agent.tenantId}/robots/menus/item/${itemId}
    Run Keyword And Return If    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}    params=${params}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}
    Run Keyword And Return If    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}    data=${data}
    ...    timeout=${timeout}

/v3/Tenants/{tenantId}/robots/menus/item/{itemId}/menu-answer
    [Arguments]    ${agent}    ${data}    ${itemId}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v3/Tenants/${agent.tenantId}/robots/menus/item/${itemId}/menu-answer
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}