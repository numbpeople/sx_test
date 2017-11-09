*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/KefuApi.robot

*** Keywords ***
Get Channels
    [Documentation]    获取所有关联信息，返回appkey和channelId的字典集
    #获取关联信息
    &{channelList}    create dictionary
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    log    ${j}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${listlength}=    Get Length    ${j}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${appName}=    convert to string    ${j[${i}]['appName']}
    \    ${id}=    convert to string    ${j[${i}]['id']}
    \    log    ${appName}
    \    set to dictionary    ${channelList}    ${appName}#${id}=${j[${i}]['id']}
    Return From Keyword    ${channelList}

Add Channel
    [Documentation]    快速创建一个关联，并返回该关联的所有信息
    ...
    ...    describtion：包含字段
    ...
    ...    appKey、appName、orgName、clientId、clientSecret、serviceEaseMobIMNumber、channelName、dutyType、agentQueueId、robotId、channelId
    #快速创建关联
    ${data}=    create dictionary    companyName=对接移动客服 请勿移除管理员    email=${AdminUser.userId}@easemob.com    password=47iw5ytIN8Ab8f2KopaAaq    telephone=13800138000    tenantId=${AdminUser.tenantId}
    ${resp}=    /v1/autoCreateImAssosciation    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Comment    ${restentity}=    create dictionary    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}
    ...    clientSecret=${j['entity']['clientSecret']}    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}    agentQueueId=${j['entity']['agentQueueId']}    robotId=${j['entity']['robotId']}
    ${restentity}=    create dictionary    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}    clientSecret=${j['entity']['clientSecret']}
    ...    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}
    #查询关联id
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    Should Not Be Empty    ${j[0]['appKey']}    appkey为空
    ${diffs1}    set variable    ${restentity.appName}${restentity.orgName}${restentity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    ${diffs2}    set variable    ${d['appName']}${d['orgName']}${d['serviceEaseMobIMNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    set to dictionary    ${restentity}    channelId=${d['id']}
    set global variable    ${easemobtechchannelJson}    ${d}
    #查询关联domain
    ${resp}=    /v1/webimplugin/targetChannels    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    ${diffs1}    set variable    ${restentity.appName}${restentity.orgName}${restentity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    ${diffs2}    set variable    ${d['appName']}${d['orgName']}${d['imServiceNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    set to dictionary    ${restentity}    restDomain=${d['restDomain']}
    log    ${restentity}
    Return From Keyword    ${restentity}

Delete Channel
    [Arguments]    ${channelId}
    [Documentation]    删除关联，参数为关联Id
    #删除新增关联
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel/{channelId}    ${AdminUser}    ${channelId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code}

Create Channel
    [Documentation]    快速创建关键并返回关联的所有信息
    ...
    ...    Return：
    ...
    ...    全局变量：${restentity}
    ...
    ...    describtion：包含字段
    ...
    ...    appKey、appName、orgName、clientId、clientSecret、serviceEaseMobIMNumber、channelName、dutyType、agentQueueId、robotId、channelId、token、restDomain、restsession
    #快速创建一个关联
    ${restentity}=    Add Channel
    #获取关联appkey的token
    Create Session    restsession    http://${restentity.restDomain}
    ${j}    Get Appkey Token    restsession    ${easemobtechchannelJson}
    set to dictionary    ${restentity}    token=${j['access_token']}    session=restsession
    set global variable    ${restentity}    ${restentity}
