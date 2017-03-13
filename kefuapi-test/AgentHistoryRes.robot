*** Keywords ***
/v1/Tenant/me/ServiceSessionHistorys
    [Arguments]    ${session}    ${timeout}    ${FilterEntity}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/Tenant/me/ServiceSessionHistorys?page=${FilterEntity.page}&per_page=${FilterEntity.per_page}&state=${FilterEntity.state}&isAgent=${FilterEntity.isAgent}&originType=${FilterEntity.originType}&techChannelId=${FilterEntity.techChannelId}&techChannelType=${FilterEntity.techChannelType}&visitorName=${FilterEntity.visitorName}&summaryIds=${FilterEntity.summaryIds}&sortOrder=${FilterEntity.sortOrder}&beginDate=${FilterEntity.beginDate}&endDate=${FilterEntity.endDate}
    Run Keyword And Return    Create Kefu Requests    ${session}    ${uri}    'get'    headers=${header}    timeout=${timeout}
