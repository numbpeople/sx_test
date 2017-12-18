*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           DateTime
Library           ../../../lib/KefuUtils.py
Resource          ../../../api/BaseApi/Customers/Customers_Api.robot
Resource          ../../../api/MicroService/Webapp/WebappApi.robot

*** Keywords ***
Get Admin Customers
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}=10
    [Documentation]    获取管理模式下访客的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${filter} | ${date}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #获取管理员模式下客户中心
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/crm/tenants/{tenantId}/customers    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['numberOfElements']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}

Get Agent Customers
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}=10
    [Documentation]    获取坐席模式下访客的信息
    ...
    ...    Arguments：
    ...
    ...    ${agent} | ${filter} | ${date}
    ...
    ...    Return：
    ...
    ...    请求结果：${j}
    #获取客服模式下客户中心
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/crm/tenants/{tenantId}/agents/{agentId}/customers    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['numberOfElements']} > 0
    \    sleep    ${delay}
    Return From Keyword    ${j}

Get Visitor Tags
    [Arguments]    ${agent}    ${userId}
    [Documentation]    查询访客的客户标签信息
    #查询访客的客户标签信息
    ${resp}=    /v1/crm/tenants/{tenantId}/visitors/{visitorId}/tags    ${agent}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Set Filters
    [Arguments]    ${method}    ${agent}    ${data}=    ${filterId}=
    [Documentation]    获取/新增/修改/删除租户的客户的filters
    #操作租户的客户的filters
    ${resp}=    /v1/crm/tenants/{tenantId}/filters    ${method}    ${agent}    ${timeout}    ${data}    ${filterId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Visitor Filters
    [Arguments]    ${agent}    ${userId}
    [Documentation]    获取客户的filters
    #获取客户的filters
    ${resp}=    /v1/crm/tenants/{tenantId}/visitor/{visitorId}/filters    ${agent}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Visitor Blacklists
    [Arguments]    ${agent}    ${userId}
    [Documentation]    获取访客的黑名单列表
    #获取访客的黑名单列表
    ${resp}=    /v1/tenants/{tenantId}/visitors/{visitorUserId}/blacklists    ${agent}    ${userId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Create Time Value
    [Arguments]    ${param}
    [Documentation]    获取接口的参数时间戳，类似：1512921600000,1513007940000
    ...
    ...    param：
    ...
    ...    参数值为1、2、3、4、5，分别对应：今天、昨天、本周、本月、上月
    ...
    ...    return:
    ...
    ...    返回结果格式为：1512921600000,1513007940000
    #获取时间范围
    ${begintimeDate}    ${endtimeDate}    Get Time Range    ${param}
    #获取时间范围
    ${beginDate}    convert date    ${begintimeDate.yyyy}${begintimeDate.mm}${begintimeDate.day} 0:0:0    epoch
    ${endDate}    convert date    ${endtimeDate.yyyy}${endtimeDate.mm}${endtimeDate.day} 23:59:0    epoch
    @{list}    create list    ${beginDate}    ${endDate}
    #将时间做处理，返回类似：1512921600000,1513007940000
    ${num}    set variable    ${EMPTY}
    : FOR    ${i}    IN    @{list}
    \    ${dateString}    convert to string    ${i}
    \    ${date}    Split String From Right    ${dateString}    .    1
    \    ${num}    set variable    ${num},${date[0]}000
    ${num}    Strip String    ${num}    mode=left    characters=,
    return from keyword    ${num}

Get Time Range
    [Arguments]    ${param}
    [Documentation]    获取接口的参数时间戳，类似：1512921600000,1513007940000
    ...
    ...    param：
    ...
    ...    参数值为1、2、3、4、5，分别对应：今天、昨天、本周、本月、上月
    ...
    ...    return:
    ...
    ...    返回结果为：&{begintimeDate}和&{endtimeDate}两个字典集
    #设置今天为默认时间筛选
    ${yyyy}    ${mm}    ${day}    Get Time    year,month,day
    &{begintimeDate}    create dictionary    yyyy=${yyyy}    mm=${mm}    day=${day}
    &{endtimeDate}    create dictionary    yyyy=${yyyy}    mm=${mm}    day=${day}
    #获取昨天日期
    ${yesterday}    Subtract Time From Date    ${yyyy}-${mm}-${day}    1 days
    ${yesyyyy}    ${yesmm}    ${yesday}    get time    year,month,day    ${yesterday}
    #获取本周日期
    @{weekList}    Get Week    ${yyyy}-${mm}-${day}
    ${weekbeginyyyy}    ${weekbeginmm}    ${weekbeginday}    get time    year,month,day    ${weekList[0]}
    ${weekendyyyy}    ${weekendmm}    ${weekendday}    get time    year,month,day    ${weekList[1]}
    #获取本月日期
    ${yn}=    Convert To Integer    ${yyyy}
    ${mn}=    Convert To Integer    ${mm}
    ${mr}=    Monthrange    ${yn}    ${mn}
    #获取上个月日期
    @{monthList}    Get_Last_Month
    ${monthbeginyyyy}    ${monthbeginmm}    ${monthbeginday}    get time    year,month,day    ${monthList[0]}
    ${monthendyyyy}    ${monthendmm}    ${monthendday}    get time    year,month,day    ${monthList[1]}
    run keyword if    ${param} == 2    set to dictionary    ${begintimeDate}    yyyy=${yesyyyy}    mm=${yesmm}    day=${yesday}
    run keyword if    ${param} == 2    set to dictionary    ${endtimeDate}    yyyy=${yesyyyy}    mm=${yesmm}    day=${yesday}
    run keyword if    ${param} == 3    set to dictionary    ${begintimeDate}    yyyy=${weekbeginyyyy}    mm=${weekbeginmm}    day=${weekbeginday}
    run keyword if    ${param} == 3    set to dictionary    ${endtimeDate}    yyyy=${weekendyyyy}    mm=${weekendmm}    day=${weekendday}
    run keyword if    ${param} == 4    set to dictionary    ${begintimeDate}    yyyy=${yyyy}    mm=${mm}    day=01
    run keyword if    ${param} == 4    set to dictionary    ${endtimeDate}    yyyy=${yyyy}    mm=${mm}    day=${mr[1]}
    run keyword if    ${param} == 5    set to dictionary    ${begintimeDate}    yyyy=${monthbeginyyyy}    mm=${monthbeginmm}    day=${monthbeginday}
    run keyword if    ${param} == 5    set to dictionary    ${endtimeDate}    yyyy=${monthendyyyy}    mm=${monthendmm}    day=${monthendday}
    log dictionary    ${begintimeDate}
    log dictionary    ${endtimeDate}
    return from keyword    ${begintimeDate}    ${endtimeDate}

Clear Filters
    [Documentation]    循环删除包含${preDisplayName}的客户中心filter数据
    #设置filter名称模板
    ${preDisplayName}=    convert to string    ${AdminUser.tenantId}
    #获取客户中心filter数据
    ${j}    Set Filters    get    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #循环删除包含${preDisplayName}的客户中心filter数据
    : FOR    ${i}    IN    @{j['entities']}
    \    ${displayName}=    convert to string    ${i['displayName']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${displayName}    ${preDisplayName}
    \    Run Keyword If    '${status}' == 'True'    Set Filters    delete    ${AdminUser}    ${EMPTY}
    \    ...    ${i['filterId']}
