*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Channels/AppApi.robot
Resource          ../../../api/BaseApi/Channels/WebimApi.robot
Resource          ../BaseKeyword.robot

*** Keywords ***
Get Channels
    [Arguments]    ${agent}=${AdminUser}
    [Documentation]    获取所有关联信息，返回appkey和channelId的字典集
    #获取关联信息
    &{channelList}    create dictionary
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${agent}    ${timeout}
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

Get Channels List
    [Arguments]    ${agent}
    [Documentation]    获取所有关联信息，所有的关联信息
    #获取所有关联信息
    &{channelList}    create dictionary
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Add Channel
    [Arguments]    ${agent}=${AdminUser}
    [Documentation]    快速创建一个关联，并返回该关联的所有信息
    ...
    ...    describtion：包含字段
    ...
    ...    appKey、appName、orgName、clientId、clientSecret、serviceEaseMobIMNumber、channelName、dutyType、agentQueueId、robotId、channelId
    #快速创建关联
    ${data}=    create dictionary    companyName=对接移动客服 请勿移除管理员    email=${agent.userId}@easemob.com    password=47iw5ytIN8Ab8f2KopaAaq    telephone=13800138000    tenantId=${agent.tenantId}
    ${resp}=    /v1/autoCreateImAssosciation    ${agent}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Comment    ${restentity}=    create dictionary    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}
    ...    clientSecret=${j['entity']['clientSecret']}    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}    agentQueueId=${j['entity']['agentQueueId']}    robotId=${j['entity']['robotId']}
    ${restentity}=    create dictionary    appKey=${j['entity']['appKey']}    appName=${j['entity']['appName']}    orgName=${j['entity']['orgName']}    clientId=${j['entity']['clientId']}    clientSecret=${j['entity']['clientSecret']}
    ...    serviceEaseMobIMNumber=${j['entity']['serviceEaseMobIMNumber']}    channelName=${j['entity']['name']}    dutyType=${j['entity']['dutyType']}
    #查询关联id
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel    ${agent}    ${timeout}
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
    ${resp}=    /v1/webimplugin/targetChannels    ${agent}    ${timeout}
    ${j}    to json    ${resp.content}
    ${diffs1}    set variable    ${restentity.appName}${restentity.orgName}${restentity.serviceEaseMobIMNumber}
    : FOR    ${d}    IN    @{j}
    \    ${diffs2}    set variable    ${d['appName']}${d['orgName']}${d['imServiceNumber']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    set to dictionary    ${restentity}    restDomain=${d['restDomain']}
    log dictionary    ${restentity}
    Return From Keyword    ${restentity}

Delete Channel
    [Arguments]    ${channelId}    ${agent}=${AdminUser}
    [Documentation]    删除关联，参数为关联Id
    #删除新增关联
    ${resp}=    /v1/Admin/TechChannel/EaseMobTechChannel/{channelId}    ${agent}    ${channelId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    204    不正确的状态码:${resp.status_code},${resp.text} 

Delete Channels
    [Arguments]    ${agent}=${AdminUser}
    #设置关联对比模板
    ${preChannelname}=    convert to string    ${agent.tenantId}
    #获取所有关联列表
    ${channellist}=    Get Channels    ${agent}    #返回字典
    ${channelNameList}=    Get Dictionary Keys    ${channellist}
    ${listlength}=    Get Length    ${channelNameList}
    log    ${channellist}
    #循环判断返回值中是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${channelname}=    convert to string    ${channelNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${channelname}    ${preChannelname}
    \    ${channelIdValue}=    Get From Dictionary    ${channellist}    ${channelNameList[${i}]}
    \    Run Keyword If    ${status}    Close Conversations By ChannelId    ${channelIdValue}    ${agent}
    \    Run Keyword If    ${status}    Delete Channel    ${channelIdValue}    ${agent}

Create Channel
    [Arguments]    ${agent}=${AdminUser}
    [Documentation]    使用已有关联或快速创建关键并返回关联的所有信息
    ...
    ...    Return：
    ...
    ...    全局变量：${restentity}
    ...
    ...    describtion：包含字段
    ...
    ...    appKey、appName、orgName、clientId、clientSecret、serviceEaseMobIMNumber、channelName、dutyType、agentQueueId、robotId、channelId、token、restDomain、restsession
    &{restentity}    create dictionary
    #判断是否配置了已有的关联
    log dictionary    ${ExistChannelEntity}
    ${status}    Run Keyword And Return Status    Should Not Be Empty    ${ExistChannelEntity.appName}${ExistChannelEntity.orgName}
    Run Keyword And Return If    ${status}    Use Exist Channel    ${agent}    ${ExistChannelEntity}    ${restentity}
    #快速创建新的关联
    ${restentity}    Create New Channel    ${agent}
    set global variable    ${restentity}    ${restentity}
    log dictionary    ${restentity}
    Return From Keyword    ${restentity}

Get Channel With Appkey
    [Arguments]    ${agent}    ${ExistChannelEntity}
    [Documentation]    根据appkey获取租户下的关联信息
    #获取所有关联
    ${channelList}    Get Channels List    ${agent}
    ${diffs}    set variable    ${ExistChannelEntity.appName}${ExistChannelEntity.orgName}${ExistChannelEntity.serviceEaseMobIMNumber}
    #根据appkey+im号匹配结果
    : FOR    ${d}    IN    @{channelList}
    \    ${diffs2}    set variable    ${d['appName']}${d['orgName']}${d['serviceEaseMobIMNumber']}
    \    Return From Keyword If    '${diffs}' == '${diffs2}'    ${d}
    return from keyword    {}

Create New Channel
    [Arguments]    ${agent}
    [Documentation]    快速创建新的关联
    #快速创建一个关联
    ${restentity}    Add Channel    ${agent}
    #获取关联appkey的token
    Create Session    restsession    http://${restentity.restDomain}
    ${j}    Get Appkey Token    restsession    ${restentity}
    set to dictionary    ${restentity}    token=${j['access_token']}    session=restsession
    Return From Keyword    ${restentity}

Use Exist Channel
    [Arguments]    ${agent}    ${ExistChannelEntity}    ${restentity}
    [Documentation]    使用已有的关联信息发消息，并设置到${restentity}中，以为后续其他接口使用
    ...
    ...    参数：
    ...    - ${agent}：账号/密码信息
    ...    - ${ExistChannelEntity}：资源文件中设置的已有关联信息
    ...    - ${restentity}：全局的
    #&{ExistChannelEntity}字典的字段值是否为空，为空则标记失败
    Check Valid Channel Params    ${ExistChannelEntity}
    #根据appkey获取关联
    ${j}    Get Channel With Appkey    ${agent}    ${ExistChannelEntity}
    run keyword if    ${j} == {}    Fail    租户下没有所匹配的关联，检查下配置的orgName、appName、im号是否正确，${ExistChannelEntity}
    #将资源文件中配置已有关联信息设置到${restentity}中
    set to dictionary    ${restentity}    appName=${j['appName']}    orgName=${j['orgName']}    appKey=${j['appKey']}    serviceEaseMobIMNumber=${j['serviceEaseMobIMNumber']}    clientId=${j['clientId']}
    ...    clientSecret=${j['clientSecret']}    channelId=${j['id']}    channelName=${j['name']}    restDomain=${ExistChannelEntity.restDomain}
    #获取关联appkey的token
    Create Session    restsession    http://${restentity.restDomain}
    ${j}    Get Appkey Token    restsession    ${restentity}
    set to dictionary    ${restentity}    token=${j['access_token']}    session=restsession
    set global variable    ${restentity}    ${restentity}
    log dictionary    ${restentity}
    Return From Keyword    ${restentity}

Check Valid Channel Params
    [Arguments]    ${ExistChannelEntity}
    [Documentation]    判断在AgentRes资源文件，&{ExistChannelEntity}字典的字段值是否为空，为空则标记失败
    #判断字段为空情况，为空则标记失败
    @{keyList}    Get Dictionary Keys    ${ExistChannelEntity}
    ${length}    get length    ${keyList}
    : FOR    ${i}    IN RANGE    ${length}
    \    ${keyName}    set variable    ${keyList[${i}]}
    \    ${status}    Run Keyword And Return Status    should be empty    ${ExistChannelEntity.${keyName}}
    \    run keyword if    ${status}    Fail    AgentRes资源文件设置的ExistChannelEntity字典，字段${keyName}值为空

Get Tenant Channels
    [Arguments]    ${agent}
    [Documentation]    获取租户下所有的渠道关联信息
    #获取租户下所有的渠道的关联信息
    ${resp}=    /channels    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Channel With ChannelId
    [Arguments]    ${agent}    ${channelId}
    [Documentation]    根据关联id获取该关联
    #获取租户下所有的渠道的关联信息
    ${j}    Get Tenant Channels    ${agent}
    :FOR    ${i}    IN    @{j}
    \    Return From Keyword if    "${i['id']}" == "${channelId}"    ${i}
    Return From Keyword    {}