*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Library           ../../../../lib/KefuUtils.py
Resource          ../../../../AgentRes.robot
Resource          ../../../../AgentRes.robot
Resource          ../../../../JsonDiff/Channels/RestChannelsJsonDiff.robot
Resource          ../../../../commons/admin common/BaseKeyword.robot
Resource          ../../../../api/BaseApi/Channels/AppApi.robot
Resource          ../../../../tool/Tools-Resource.robot

*** Test Cases ***
添加、查询、编辑并删除rest channel
    #添加rest channel
    ${data}    create dictionary    name=测试rest    callbackUrl=http://www.test.com
    ${resp}=    /v1/tenants/{tenantId}/channels    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    添加rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${PostRestChannelJson}
    set to dictionary    ${temp['entity']}    name=${data.name}    callbackUrl=${data.callbackUrl}    tenantId=${AdminUser.tenantId}
    log    ${j}
    log    ${temp}
    ${r}=    PostRestChannelJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    添加rest channel返回数据不正确：${r}
    set global variable    ${PostRestChannelJson}    ${j}
    #查询rest channel中是否有新添加的channel
    ${resp}=    /v1/tenants/{tenantId}/channels    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['status']}'=='OK'
    set test variable    ${diffs1}    ${PostRestChannelJson['entity']['name']}${PostRestChannelJson['entity']['callbackUrl']}${PostRestChannelJson['entity']['channelId']}${PostRestChannelJson['entity']['postMessageUrl']}
    : FOR    ${i}    IN    @{j['entities']}
    \    set test variable    ${diffs2}    ${i['name']}${i['callbackUrl']}${i['channelId']}${i['postMessageUrl']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Be True    '${diffs1}' == '${diffs2}'    未查询到添加的rest channel信息:${j}
    #编辑rest channel
    ${data}    create dictionary    name=测试rest1    callbackUrl=http://www.test1.com
    ${resp}=    /v1/tenants/{tenantId}/channels/{channelId}    put    ${AdminUser}    ${PostRestChannelJson['entity']['channelId']}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    添加rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    ${temp}    to json    ${PutRestChannelJson}
    set to dictionary    ${temp['entity']}    name=${data.name}    callbackUrl=${data.callbackUrl}    tenantId=${AdminUser.tenantId}
    log    ${temp}
    ${r}=    PutRestChannelJsonDiff    ${temp}    ${j}
    Should Be True    ${r['ValidJson']}    编辑rest channel返回数据不正确：${r}
    set global variable    ${PutRestChannelJson}    ${j}
    #查询编辑后的channel信息是否正确
    ${resp}=    /v1/tenants/{tenantId}/channels    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['status']}'=='OK'
    set test variable    ${diffs1}    ${PutRestChannelJson['entity']['name']}${PutRestChannelJson['entity']['callbackUrl']}${PutRestChannelJson['entity']['channelId']}${PutRestChannelJson['entity']['postMessageUrl']}
    : FOR    ${i}    IN    @{j['entities']}
    \    set test variable    ${diffs2}    ${i['name']}${i['callbackUrl']}${i['channelId']}${i['postMessageUrl']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Be True    '${diffs1}' == '${diffs2}'    未查询到编辑后的rest channel信息:${j}
    #删除rest channel
    ${resp}=    /v1/tenants/{tenantId}/channels/{channelId}    delete    ${AdminUser}    ${PostRestChannelJson['entity']['channelId']}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    删除rest channel返回不正确的状态码:${resp.status_code}
    #查询编辑后的channel信息是否正确
    ${resp}=    /v1/tenants/{tenantId}/channels    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rest channel返回不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['status']}'=='OK'
    set test variable    ${diffs1}    ${PutRestChannelJson['entity']['name']}${PutRestChannelJson['entity']['callbackUrl']}${PutRestChannelJson['entity']['channelId']}${PutRestChannelJson['entity']['postMessageUrl']}
    ${diffs2}    set variable    ${EMPTY}
    : FOR    ${i}    IN    @{j['entities']}
    \    set test variable    ${diffs2}    ${i['name']}${i['callbackUrl']}${i['channelId']}${i['postMessageUrl']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Not Be True    '${diffs1}' == '${diffs2}'    查询到已删除的rest channel信息:${j}

获取所有app关联(/channels)
    ${resp}=    /channels    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Run Keyword If    ${j}==[]    log    无app关联
    ...    ELSE    Should Be Equal    '${j[0]['tenantId']}'    '${AdminUser.tenantId}'    获取app关联失败
    log    ${j}
    log    ${resp.content}
