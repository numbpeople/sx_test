*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Customers/Customers_Api.robot
Resource          ../../agent common/Customers/Customers_Common.robot
Resource          ../../Base Common/Base_Common.robot

*** Keywords ***
Search Crm Customers
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}
    [Documentation]    根据查询条件查询客户中心
    ...
    ...    describtion：
    ...    ${agent}:坐席信息
    ...    ${filter}:筛选条件
    ...    ${date}:日期条件
    ...    ${retryTimes}:请求重试次数
    ...
    ...    返回值：
    ...    ${true}|${false}：有|无查询结果
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/crm/tenants/{tenantId}/customers    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['numberOfElements']} ==1
    \    sleep    ${delay}
    Return From Keyword if    ${j['numberOfElements']} ==1    ${true}    ${false}

Search My Crm Customers
    [Arguments]    ${agent}    ${filter}    ${date}    ${retryTimes}
    [Documentation]    根据查询条件查询客户中心
    ...
    ...    describtion：
    ...    ${agent}:坐席信息
    ...    ${filter}:筛选条件
    ...    ${date}:日期条件
    ...    ${retryTimes}:请求重试次数
    ...
    ...    返回值：
    ...    ${true}|${false}：有|无查询结果
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/crm/tenants/{tenantId}/agents/{agentId}/customers    ${agent}    ${filter}    ${date}    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    \    ${j}    to json    ${resp.content}
    \    Exit For Loop If    ${j['numberOfElements']} ==1
    \    sleep    ${delay}
    Return From Keyword if    ${j['numberOfElements']} ==1    ${true}    ${false}

Search Customers
    [Arguments]    ${agent}    ${customerFieldName}    ${filter}
    [Documentation]    获取客户中心数据
    ...    参数:${customerFieldName},该参数是字典,故key为:
    ...    createDateTime,代表创建时间
    ...    lastSessionCreateDateTime,代表最后一次会话创建时间
    ...    nickname,代表昵称
    ...    username,代表ID
    ...    customerTags,代表客户标签
    ...    truename,代表名字
    ...    email,代表邮箱
    ...    phone,代表手机
    #处理请求体
    ${customerFieldNameData}    Customers Request Data    ${customerFieldName}    ${filter}
    #获取客户中心数据
    ${resp}=    /customers/_search    ${agent}    ${customerFieldNameData}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Customers Request Data
    [Arguments]    ${customerFieldName}    ${filter}
    [Documentation]    获取客户中心数据
    log dictionary    ${customerFieldName}
    log dictionary    ${customerOperation}
    @{keyList}    Get Dictionary Keys    ${customerFieldName}
    ${keyLength}    get length    ${keyList}
    ${entityLength}    evaluate    ${keyLength}-1    #因为createDateTime和lastSessionCreateDateTime只能存在一个值,故做减一操作
    @{conditionsList}    create list
    &{conditionsDic}    create dictionary
    #如果字段值为空，则去除该key
    :FOR    ${i}    IN RANGE    ${keyLength}
    \    ${field_name}    set variable    ${keyList[${i}]}
    \    run keyword if    "${customerFieldName.${field_name}}" == ""    Remove From Dictionary    ${customerFieldName}    ${field_name}
    log dictionary    ${customerFieldName}
    @{keyList}    Get Dictionary Keys    ${customerFieldName}
    ${entityLength}    get length    ${keyList}
    #构造请求体
    :FOR    ${i}    IN RANGE    ${entityLength}
    \    ${field_name}    set variable    ${keyList[${i}]}
    \    ${field_value}    Get From Dictionary    ${customerFieldName}    ${field_name}
    \    ${operation}    Get From Dictionary    ${customerOperation}    ${field_name}
    \    set to dictionary    ${conditionsDic}    field_name=${field_name}    value=${field_value}    operation=${operation}
    \    ${conditionsJson}    dumps    ${conditionsDic}
    \    Append To List    ${conditionsList}    ${conditionsJson}
    \    log    ${conditionsList}
    ${conditionsList}    replace string    '${conditionsList}'    '    ${EMPTY}
    ${data}    set variable    {"page":${filter.page},"size":${filter.size},"agent_query":${filter.agent_query},"conditions":${conditionsList}}
    Return From Keyword    ${data}

Export Customers
    [Arguments]    ${agent}    ${customerFieldName}    ${filter}    ${language}=zh-CN
    [Documentation]    获取客户中心数据
    ...    参数:${customerFieldName},该参数是字典,故key为:
    ...    createDateTime,代表创建时间
    ...    lastSessionCreateDateTime,代表最后一次会话创建时间
    ...    nickname,代表昵称
    ...    username,代表ID
    ...    customerTags,代表客户标签
    ...    truename,代表名字
    ...    email,代表邮箱
    ...    phone,代表手机
    #处理请求体
    ${customerFieldNameData}    Export Customers Request Data    ${customerFieldName}    ${filter}
    #获取客户中心数据
    ${resp}=    /v1/crm/tenants/{tenantId}/customers/newfile    ${agent}    ${customerFieldNameData}    ${language}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}:${resp.text}
    Return From Keyword    ${resp}

Export Customers Request Data
    [Arguments]    ${customerFieldName}    ${filter}
    [Documentation]    导出客户中心数据
    log dictionary    ${customerFieldName}
    log dictionary    ${customerOperation}
    @{keyList}    Get Dictionary Keys    ${customerFieldName}
    ${keyLength}    get length    ${keyList}
    ${entityLength}    evaluate    ${keyLength}-1    #因为createDateTime和lastSessionCreateDateTime只能存在一个值,故做减一操作
    @{conditionsList}    create list
    &{conditionsDic}    create dictionary
    #如果字段值为空，则去除该key
    :FOR    ${i}    IN RANGE    ${keyLength}
    \    ${field_name}    set variable    ${keyList[${i}]}
    \    run keyword if    "${customerFieldName.${field_name}}" == ""    Remove From Dictionary    ${customerFieldName}    ${field_name}
    log dictionary    ${customerFieldName}
    @{keyList}    Get Dictionary Keys    ${customerFieldName}
    ${entityLength}    get length    ${keyList}
    #构造请求体
    :FOR    ${i}    IN RANGE    ${entityLength}
    \    ${field_name}    set variable    ${keyList[${i}]}
    \    ${field_value}    Get From Dictionary    ${customerFieldName}    ${field_name}
    \    ${operation}    Get From Dictionary    ${customerOperation}    ${field_name}
    \    set to dictionary    ${conditionsDic}    field_name=${field_name}    value=${field_value}    operation=${operation}
    \    ${conditionsJson}    dumps    ${conditionsDic}
    \    Append To List    ${conditionsList}    ${conditionsJson}
    \    log    ${conditionsList}
    ${conditionsList}    replace string    '${conditionsList}'    '    ${EMPTY}
    ${data}    set variable    {"skill_group_export":${filter.skill_group_export},"agent_query":${filter.agent_query},"conditions":${conditionsList}}
    Return From Keyword    ${data}

Create Customer And Export Data
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    1、创建新访客和新会话    2、导出该客户数据
    #创建待接入会话
    ${session}    Create Wait Conversation    app
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${timeValue}    Create Time Value    ${param}
    #创造查询请求体
    ${crmFieldName}    copy dictionary    ${customerFieldName}
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${crmFieldName}    createDateTime=${timeValue}    username=${session.userName}
    set to dictionary    ${filter}    page=0    size=10
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${agent}    ${crmFieldName}    ${filter}
    ${expectConstruction}    set variable    ['totalElements']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    1    #该参数为获取接口某字段的预期值
    #查询单个客户中心数据
    ${j}    Repeat Keyword Times    Search Customers    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    客户中心查询了10秒中,未找到刚创建的客户数据
    Should Be True    ${j['totalElements']} == 1    访客中心人数不唯一：${j}
    Should Be True    ${j['entities'][0]['username'][0]} == ${session.userName}    访客中心返回值中username字段值:${j['entities'][0]['username'][0]},不是${session.userName}：${j}
    Should Be True    ${j['entities'][0]['nickname']} == ${session.userName}    访客中心返回值中nickname字段值:${j['entities'][0]['nickname']},不是${session.userName}：${j}
    #获取客户中心数据
    ${resp}    Export Customers    ${agent}    ${crmFieldName}    ${filter}    ${language}
    set to dictionary    ${session}    visitorId=${j['entities'][0]['bind_visitors'][0]}    customerId=${j['entities'][0]['customer_id']}    createDateTime=${j['entities'][0]['created_at']}    updateDateTime=${j['entities'][0]['updated_at']}    lastUpdateDateTime=${j['entities'][0]['last_session_create_at']}  
    Return From Keyword    ${session}

Download Customer Template
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    下载客户中心模板
    #下载客户中心模板
    ${resp}=    /download/tplfiles/%E5%AE%A2%E6%88%B7%E4%B8%AD%E5%BF%83%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xlsx    ${agent}    ${language}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.text}
    Return From Keyword    ${resp}
    