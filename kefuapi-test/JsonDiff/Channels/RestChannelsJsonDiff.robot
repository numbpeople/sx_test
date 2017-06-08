*** Variables ***
${PostRestChannelJson}    {"status":"OK","entity":{"tenantId":5833,"channelId":29,"name":"fs","description":null,"clientId":"e06021c9-edc3-423e-aa94-a22a33d7ed41","clientSecret":"dce9a4fa6c8a4fba6ede54a1b480c7a4","postMessageUrl":"/api/tenants/5833/rest/channels/29/messages","callbackUrl":"http://www.test.com","agentQueueId":null,"createDateTime":1496737508258}}
${PutRestChannelJson}    {"status":"OK","entity":{"tenantId":5833,"channelId":29,"name":"fs","description":null,"clientId":"e06021c9-edc3-423e-aa94-a22a33d7ed41","clientSecret":"dce9a4fa6c8a4fba6ede54a1b480c7a4","postMessageUrl":"/api/tenants/5833/rest/channels/29/messages","callbackUrl":"http://www.test.com","agentQueueId":null,"createDateTime":1496737508258}}

*** Keywords ***
PostRestChannelJsonDiff
    [Arguments]    ${base}    ${instance}
    log    '${base['entity']['name']}'
    log    '${instance['entity']['name']}'
    Dictionary Should Contain Key    ${instance}    status
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['entity']['callbackUrl']}'!='${instance['entity']['callbackUrl']}'    set to dictionary    ${r1}    entity.callbackUrl=invalid
    Run Keyword If    '${base['entity']['name']}'!='${instance['entity']['name']}'    set to dictionary    ${r1}    entity.name=invalid
    Run Keyword If    '${base['entity']['tenantId']}'!='${instance['entity']['tenantId']}'    set to dictionary    ${r1}    entity.tenantId=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

PutRestChannelJsonDiff
    [Arguments]    ${base}    ${instance}
    Dictionary Should Contain Key    ${instance}    status
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['entity']['callbackUrl']}'!='${instance['entity']['callbackUrl']}'    set to dictionary    ${r1}    entity.callbackUrl=invalid
    Run Keyword If    '${base['entity']['name']}'!='${instance['entity']['name']}'    set to dictionary    ${r1}    entity.name=invalid
    Run Keyword If    '${base['entity']['tenantId']}'!='${instance['entity']['tenantId']}'    set to dictionary    ${r1}    entity.tenantId=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}
