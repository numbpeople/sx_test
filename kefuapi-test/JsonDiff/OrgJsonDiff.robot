*** Settings ***
Library           jsonschema
Library           Collections

*** Variables ***
${OrgtokenJson}    {"status":"OK","entity":{"user":{"orgId":2056,"userId":"dc9af6f9-3962-4330-b8be-43bde9d947ec","username":"zk16@organ.com","nicename":"zhukai1","password":"","phone":"18600000000","status":"Enable","createDateTime":"2017-01-03 10:33:11","lastUpdateDateTime":"2017-01-03 10:33:11"},"token":{"name":"SESSION","value":"800497ad-e4fc-4d36-a5fb-ac81f33ee579","expires":604800}}}
${OrginitdataJson}    {"status":"OK","entity":{"orguser":{"orgId":2057,"userId":"dc9af6f9-3962-4330-b8be-43bde9d947ec","username":"zk1@organ.com","nicename":"zhukai1","password":"","phone":"18600000000","status":"Enable","createDateTime":"2017-01-03 10:33:11","lastUpdateDateTime":"2017-01-03 10:33:11"}}}
${OrgcounttotalJson}    {"status":"OK","entity":{"totalOnlineAgents":-1,"totalMessagesToday":0,"totalAgents":1,"totalTenants":1,"totalSessionsToday":0}}
${OrgUsersJson}    {"status":"OK","entities":[{"orgId":2057,"userId":"dc9af6f9-3962-4330-b8be-43bde9d947ec","username":"zk1@organ.com","nicename":"zhukai1","password":"","phone":"18600000000","status":"Enable","createDateTime":"2017-01-03 10:33:11","lastUpdateDateTime":"2017-01-03 10:33:11"}],"first":true,"last":true,"size":20,"number":0,"numberOfElements":1,"totalPages":1,"totalElements":1}
${OrgmetricsJson}    {"status":"OK","entities":[{"name":"zk11","tenantId":27918,"workLoad":{"cnt_ssc":0,"cnt_sc":0,"max_st":0,"cnt_mc":0,"avg_st":0},"workQuality":{"avg_vm":0.0,"max_ar":0,"max_fr":0,"avg_ar":0,"avg_fr":0},"visitor":{"count":0}}],"first":true,"last":true,"size":20,"number":0,"numberOfElements":1,"totalPages":1,"totalElements":1}
${OrgdownloadmetricsJson}    {"status":"OK","entities":[],"first":true,"last":true,"size":20,"number":0,"numberOfElements":0,"totalPages":0,"totalElements":0}
${OrgtenantsJson}    {"status":"OK","entities":[{"tenantId":27918,"orgId":2057,"name":"zk11","createDateTime":1483410850000,"lastUpdateDateTime":1483410850000,"status":"Enable","phone":"123445","totalAgentNumber":1,"onlineAgentNumber":0,"agentMaxNum":2}],"first":true,"last":true,"size":20,"number":0,"numberOfElements":1,"totalPages":1,"totalElements":1}
${OrgJson}        {"status":"OK","entity":{"orgId":2057,"name":"zk1","descr":"zk1-organ","agentNumQuota":10000,"agentNumUsedQuota":2,"tenantRegistOpen":true,"status":"Enable","creator":"zk1@organ.com","createDateTime":"2017-01-03 10:33:11","lastUpdateDateTime":"2017-01-03 10:33:11"}}
${OrgtemplateJson}    {"status":"OK","entity":{"template":[{"optionId":"94bd4e2b-3128-48ac-831d-c67de8342655","orgId":2057,"optionName":"agentMaxNum","optionValue":"2","createDateTime":"2017-01-03 02:33:11","lastUpdateDateTime":"2017-01-03 02:33:11"},{"optionId":"65b50f01-d630-11e6-bd1e-6c92bf21bbe1","orgId":2057,"optionName":"inactiveServiceSessionTimeoutEnable","optionValue":"false","createDateTime":"2017-01-09 05:56:43","lastUpdateDateTime":"2017-01-09 05:56:43"},{"optionId":"66781769-d630-11e6-bd1e-6c92bf21bbe1","orgId":2057,"optionName":"isStopSessionNeedSummary","optionValue":"0","createDateTime":"2017-01-09 05:56:44","lastUpdateDateTime":"2017-01-09 05:56:44"},{"optionId":"64d8e0ad-d630-11e6-bd1e-6c92bf21bbe1","orgId":2057,"optionName":"serviceSessionTimeoutEnable","optionValue":"false","createDateTime":"2017-01-09 05:56:42","lastUpdateDateTime":"2017-01-09 05:56:42"}]}}

*** Keywords ***
OrgtokenJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['entity']['user']['orgId']}'!='${instance['entity']['user']['orgId']}'    set to dictionary    ${r1}    entity.user.orgId=invalid
    Run Keyword If    '${base['entity']['user']['username']}'!='${instance['entity']['user']['username']}'    set to dictionary    ${r1}    entity.user.username=invalid
    Run Keyword If    '${base['entity']['user']['status']}'!='${instance['entity']['user']['status']}'    set to dictionary    ${r1}    entity.user.status=invalid
    Run Keyword If    '${base['entity']['token']['name']}'!='${instance['entity']['token']['name']}'    set to dictionary    ${r1}    entity.token.name=invalid
    Run Keyword If    '${base['entity']['token']['expires']}'!='${instance['entity']['token']['expires']}'    set to dictionary    ${r1}    entity.token.expires=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrginitdataJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['entity']['orguser']['orgId']}'!='${instance['entity']['orguser']['orgId']}'    set to dictionary    ${r1}    entity.orguser.orgId=invalid
    Run Keyword If    '${base['entity']['orguser']['username']}'!='${instance['entity']['orguser']['username']}'    set to dictionary    ${r1}    entity.orguser.username=invalid
    Run Keyword If    '${base['entity']['orguser']['nicename']}'!='${instance['entity']['orguser']['nicename']}'    set to dictionary    ${r1}    entity.orguser.nicename=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrgcounttotalJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrgusersJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['first']}'!='${instance['first']}'    set to dictionary    ${r1}    first=invalid
    Run Keyword If    '${base['last']}'!='${instance['last']}'    set to dictionary    ${r1}    last=invalid
    Run Keyword If    '${base['size']}'!='${instance['size']}'    set to dictionary    ${r1}    size=invalid
    Run Keyword If    '${base['number']}'!='${instance['number']}'    set to dictionary    ${r1}    number=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrgmetricsJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['first']}'!='${instance['first']}'    set to dictionary    ${r1}    first=invalid
    Run Keyword If    '${base['last']}'!='${instance['last']}'    set to dictionary    ${r1}    last=invalid
    Run Keyword If    '${base['size']}'!='${instance['size']}'    set to dictionary    ${r1}    size=invalid
    Run Keyword If    '${base['number']}'!='${instance['number']}'    set to dictionary    ${r1}    number=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrgdownloadmetricsJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['first']}'!='${instance['first']}'    set to dictionary    ${r1}    first=invalid
    Run Keyword If    '${base['last']}'!='${instance['last']}'    set to dictionary    ${r1}    last=invalid
    Run Keyword If    '${base['size']}'!='${instance['size']}'    set to dictionary    ${r1}    size=invalid
    Run Keyword If    '${base['number']}'!='${instance['number']}'    set to dictionary    ${r1}    number=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrgtenantsJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['first']}'!='${instance['first']}'    set to dictionary    ${r1}    first=invalid
    Run Keyword If    '${base['last']}'!='${instance['last']}'    set to dictionary    ${r1}    last=invalid
    Run Keyword If    '${base['size']}'!='${instance['size']}'    set to dictionary    ${r1}    size=invalid
    Run Keyword If    '${base['number']}'!='${instance['number']}'    set to dictionary    ${r1}    number=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrgJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    Run Keyword If    '${base['entity']['orgId']}'!='${instance['entity']['orgId']}'    set to dictionary    ${r1}    entity.orgId=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

OrgtemplateJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}
