*** Settings ***
Library           ../../../lib/KefuUtils.py

*** Variables ***
&{RestChannelEntity}    channelId=    callbackUrl=    clientId=    clientSecret=    postMessageUrl=    expires=-1    verb=POST
${PostRestChannelJson}    {"status":"OK","entity":{"tenantId":5833,"channelId":260,"name":"发多少","description":null,"clientId":"e00361ff-03e8-430e-bde4-67982248510e","clientSecret":"bd7387222830f5717a66923db84f2f03","postMessageUrl":"/api/tenants/5833/rest/channels/260/messages","callbackUrl":"http://test.com","agentQueueId":null,"createDateTime":1512139957385}}
&{RestMsgEntity}    msg=    type=txt    queue_id=    queue_name=    agent_username=    tags=["vip1","vip2"]    callback_user=
...               user_nickname=restguesttest    true_name=resttruename    sex=0    qq=11111111    email=test@test.com    phone=13800138000    company_name=restcom
...               description=restdesc    msg_id=    origin_type=rest    From=testversitor    timestamp=

*** Keywords ***
/v1/tenants/{tenantId}/channels
    [Arguments]    ${method}    ${agent}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/channels
    ${rs}=    Run Keyword If    '${method}'=='post'    Post Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='get'    Get Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/v1/tenants/{tenantId}/channels/{channelId}
    [Arguments]    ${method}    ${agent}    ${channelId}    ${data}    ${timeout}
    ${header}=    Create Dictionary    Content-Type=application/json
    ${uri}=    set variable    /v1/tenants/${agent.tenantId}/channels/${channelId}
    ${rs}=    Run Keyword If    '${method}'=='put'    Put Request    ${agent.session}    ${uri}    headers=${header}
    ...    data=${data}    timeout=${timeout}
    ...    ELSE IF    '${method}'=='delete'    Delete Request    ${agent.session}    ${uri}    headers=${header}
    ...    timeout=${timeout}
    Return From Keyword    ${rs}

/api/tenants/{tenantId}/rest/channels/{channelId}/messages
    [Arguments]    ${agent}    ${restchannelentity}    ${data}    ${timeout}
    ${h}    GenerateRestSignature    ${restchannelentity.clientSecret}    ${restchannelentity.postMessageUrl}    ${data}    ${restchannelentity.expires}    ${restchannelentity.verb}
    log    ${h}
    ${header}=    Create Dictionary    Content-Type=application/json    Authorization=hmac ${restchannelentity.clientId}:${h}    X-Auth-Expires=${restchannelentity.expires}
    ${uri}=    set variable    ${restchannelentity.postMessageUrl}
    Run Keyword And Return    Post Request    ${agent.session}    ${uri}    headers=${header}    data=${data}    timeout=${timeout}