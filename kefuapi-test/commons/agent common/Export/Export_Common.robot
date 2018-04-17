*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/History/HistoryApi.robot
Resource          ../../../api/BaseApi/Export/Export_Api.robot

*** Variables ***
${diffCreatetimeValue}    10

*** Keywords ***
Get My Export
    [Arguments]    ${method}    ${agent}    ${filter}    ${range}
    [Documentation]    查询我的导出管理数据
    #查询我的管理导出数据
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles    ${method}    ${agent}    ${timeout}    ${filter}    ${range}
    ...    ${agent.userId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Diff CreateTime Value
    [Arguments]    ${j}    ${localTime}
    [Documentation]    判断导出文件的时间，比较当前本地时间和接口返回的createTime相差秒数不小于10，即返回true，否则返回false
    #判断导出文件的时间，比较当前本地时间和接口返回的createTime相差秒数不小于10，即返回true，否则返回false
    : FOR    ${i}    IN    @{j['content']}
    \    @{fileCreateTime}    get time    year month day hour min sec    ${i['createTime']}
    \    ${diffValue}    Evaluate    ${${fileCreateTime[5]}} - ${${localTime[5]}}    #获取差值
    \    ${diffValue}    set variable    ${diffValue.__abs__()}    #取差值的绝对值
    \    #判断创建时间差值是否在规定范围内
    \    Run Keyword If    '${localTime[0]}'=='${fileCreateTime[0]}' and '${localTime[1]}'=='${fileCreateTime[1]}' and '${localTime[2]}'=='${fileCreateTime[2]}' and '${localTime[3]}'=='${fileCreateTime[3]}' and '${localTime[4]}'=='${fileCreateTime[4]}'    Return From Keyword If    ${diffValue} < ${diffCreatetimeValue}    ${i}
    Return From Keyword    {}

Get My Export And Check Status
    [Arguments]    ${agent}    ${filter}    ${range}    ${localTime}
    [Documentation]    判断接口返回值中status的值，如果不是Finish，则重试
    #判断接口返回值中status的值，如果不是Finish，则重试
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    #获取当前的导出管理数据
    \    ${j}    Get My Export    get    ${agent}    ${filter}    ${range}
    \    ${length}    get length    ${j['content']}
    \    #判断导出管理中是否有历史会话导出数据
    \    run keyword if    ${length} == 0    Fail    导出历史会话数据后，导出管理没有产生数据，${j}
    \    ${value}    Diff CreateTime Value    ${j}    ${localTime}
    \    run keyword if    "${value}" == "{}"    Fail    导出历史会话数据后，未在导出管理中找到数据，${j}
    \    Exit For Loop If    '${value['status']}' == 'Finished'
    \    sleep    ${delay}
    Return From Keyword    ${value}

Set Download Records
    [Arguments]    ${method}    ${agent}    ${serviceSessionHistoryFileId}
    [Documentation]    查询下载记录情况
    #查询下载记录情况
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/downloadDetails    ${method}    ${agent}    ${serviceSessionHistoryFileId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get My Export And Diff Counts
    [Arguments]    ${agent}    ${filter}    ${range}    ${preCount}
    [Documentation]    获取导出数据并对比总数是否增加。并且判断接口返回值中status的值，如果不是Finish，则重试
    #判断接口返回值中status的值，如果不是Finish，则重试
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    #获取导出数据并对比总数
    \    ${j}    Diff Export Count    ${agent}    ${filter}    ${range}    ${preCount}
    \    run keyword if    "${j}" == "{}"    Fail    导出历史会话数据后，对比没有增加
    \    #获取结果第一数据
    \    ${value}    set variable    ${j['content'][0]}
    \    #判断如果status不为Finished则循环
    \    Return From Keyword If    '${value['status']}' == 'Finished'    ${value}
    \    sleep    ${delay}
    Return From Keyword    {}

Diff Export Count
    [Arguments]    ${agent}    ${filter}    ${range}    ${preCount}
    [Documentation]    获取导出管理数据并对比总数
    #获取当前的导出管理数据
    :FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    Get My Export    get    ${agent}    ${filter}    ${range}
    \    ${exportCount}    set variable    ${j['totalElements']}
    \    #判断导出管理总数是否有增加
    \    run keyword if    ${exportCount} == 0    Fail    导出历史会话数据后，导出管理没有产生数据，${j}
    \    #比较导出后的数据是否有增加
    \    ${status}    Diff Count    ${exportCount}    ${preCount}
    \    Return From Keyword If    '${status}' == 'true'    ${j}
    \    sleep    ${delay}
    Return From Keyword    {}

Diff Count
    [Arguments]    ${exportCount}    ${preCount}
    [Documentation]    比较导出后的数据是否有增加，如果对比后增加1，则返回true，反之返回false
    #比较导出后的数据是否有增加
    ${preExportCount}    evaluate    ${preCount} + 1
    Return From Keyword If    ${exportCount} == ${preExportCount}    true
    Return From Keyword    false
