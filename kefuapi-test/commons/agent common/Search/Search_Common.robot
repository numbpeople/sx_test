*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Search/Search_Api.robot

*** Keywords ***
Set Searchrecords
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}
    [Documentation]    获取或设置搜索中的记录
    #获取或设置搜索中的记录
    ${resp}=    /v1/tenants/{tenantId}/searchrecords    ${method}    ${agent}    ${filter}    ${timeout}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Search Searchrecords
    [Arguments]    ${method}    ${agent}    ${filter}    ${searchId}
    [Documentation]    获取指定searchId的搜索记录
    #获取指定searchId的搜索记录
    ${j}    Set Searchrecords    ${method}    ${agent}    ${filter}    ${EMPTY}
    : FOR    ${i}    IN    @{j['entities']}
    \    Exit For Loop If    '${i['searchId']}' == '${searchId}'
    Return From Keyword    ${i}

Get Chatmessage History
    [Arguments]    ${agent}    ${filter}    ${range}
    [Documentation]    查询搜索记录的消息信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${filter} | ${range}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #查询搜索记录的消息信息
    ${resp}=    /v1/tenants/{tenantId}/chatmessagehistorys    ${agent}    ${filter}    ${range}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}
