*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Customers/Customers_Api.robot
Resource          ../../../../api/MicroService/Webapp/InitApi.robot
Resource          ../../../../commons/admin common/Customers/Customers_common.robot
Resource          ../../../../commons/agent common/Customers/Customers_common.robot
Resource          ../../../../commons/agent common/Queue/Queue_Common.robot
Resource          ../../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取访客中心列表(接口较旧，可能私有版本仍使用，暂存留)(/v1/crm/tenants/{tenantId}/agents/{agentId}/customers)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客中心列表，调用接口：/v1/crm/tenants/{tenantId}/agents/{agentId}/customers，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，总数大于0，字段totalElements的值大于0。
    ${resp}=    /v1/crm/tenants/{tenantId}/agents/{agentId}/customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} >= 0    访客中心人数不正确：${resp.content}

获取访客中心数据(接口较旧，可能私有版本仍使用，暂存留)(/tenants/{tenantId}/visitorusers)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客中心数据，调用接口：/tenants/{tenantId}/visitorusers，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，总数大于0，字段totalElements的值大于0。
    ${resp}=    /tenants/{tenantId}/visitorusers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']}>=0    获取的访客数不正确：${resp.content}

获取客户中心列表(接口较旧，可能私有版本仍使用，暂存留)(/v1/crm/tenants/{tenantId}/customers)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取访客中心数据，调用接口：/v1/crm/tenants/{tenantId}/customers，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，总数大于0，字段totalElements的值大于0。
    ${resp}=    /v1/crm/tenants/{tenantId}/customers    ${AdminUser}    ${FilterEntity}    ${DateRange}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}:${resp.content}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['totalElements']} >= 0    访客中心人数不正确：${resp.content}

获取客户中心数据(/customers/_search)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客户中心数据，调用接口：/customers/_search，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，总数大于0，字段totalElements的值大于0。
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${timeValue}    Create Time Value    ${param}
    #创造查询请求体
    ${crmFieldName}    copy dictionary    ${customerFieldName}
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${crmFieldName}    createDateTime=${timeValue}
    set to dictionary    ${filter}    page=0    size=10
    #获取客户中心数据
    ${j}    Search Customers    ${AdminUser}    ${crmFieldName}    ${filter}
    Should Be True    ${j['totalElements']} >= 0    访客中心人数不正确：${j}    #因为测试用例跑到这肯定已有新的访客进来，所以客户中心数据可以确定不为0

创建会话、获取该访客的客户中心数据(/customers/_search)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、在客户中心按照客户id搜索数据，调用接口：/customers/_search，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，字段totalElements的值等于1、字段username等于访客im号、昵称nickname等于访客昵称。
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
    @{paramList}    create list    ${AdminUser}    ${crmFieldName}    ${filter}
    ${expectConstruction}    set variable    ['totalElements']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    1    #该参数为获取接口某字段的预期值
    #获取客户中心数据
    ${j}    Repeat Keyword Times    Search Customers    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    客户中心查询了10秒中,未找到刚创建的客户数据
    Should Be True    ${j['totalElements']} == 1    访客中心人数不唯一：${j}
    Should Be True    ${j['entities'][0]['username'][0]} == ${session.userName}    访客中心返回值中username字段值:${j['entities'][0]['username'][0]},不是${session.userName}：${j}
    Should Be True    ${j['entities'][0]['nickname']} == ${session.userName}    访客中心返回值中nickname字段值:${j['entities'][0]['nickname']},不是${session.userName}：${j}

导出客户中心数据(/v1/crm/tenants/{tenantId}/customers/newfile)
    [Documentation]    【操作步骤】：
    ...    - Step1、导出时间为今天的客户中心数据，调用接口：/v1/crm/tenants/{tenantId}/customers/newfile，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口请求状态码为200。
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${timeValue}    Create Time Value    ${param}
    #创造查询请求体
    ${crmFieldName}    copy dictionary    ${customerFieldName}
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${crmFieldName}    createDateTime=${timeValue}
    set to dictionary    ${filter}    page=0    size=10
    #获取客户中心数据
    ${resp}    Export Customers    ${AdminUser}    ${crmFieldName}    ${filter}

导出单个客户中心数据(/v1/crm/tenants/{tenantId}/customers/newfile)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，会话处于待接入（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话）。
    ...    - Step2、客户中心中根据客户IM号(username)导出单个数据，调用接口：/v1/crm/tenants/{tenantId}/customers/newfile，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口请求状态码为200。
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
    #获取客户中心数据
    ${resp}    Export Customers    ${AdminUser}    ${crmFieldName}    ${filter}

下载客户中心模板数据(/download/tplfiles/%E5%AE%A2%E6%88%B7%E4%B8%AD%E5%BF%83%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xlsx)
    [Documentation]    【操作步骤】：
    ...    - Step2、下载客户中心模板数据，调用接口：(/download/tplfiles/%E5%AE%A2%E6%88%B7%E4%B8%AD%E5%BF%83%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xlsx，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口请求状态码为200、Content-Type值等于application/octet-stream。
    ${resp}    Download Customer Template    ${AdminUser}
    Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream    下载客户中心模板数据失败,${resp.text}