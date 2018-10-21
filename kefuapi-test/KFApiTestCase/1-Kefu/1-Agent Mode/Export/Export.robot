*** Settings ***
Force Tags        agentExport
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Library           ../../../../lib/ExcelLibraryExtra/ExcelLibraryExtra.py
Library           ../../../../lib/ReadFile.py
Library           ../../../../lib/KefuUtils.py
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/Export/Export_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot

*** Test Cases ***
导出管理(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、获取导出管理数据总数，作为导出历史会话的判断依据，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles，接口请求状态码为200。
    ...    - Step3、坐席在历史会话中，导出刚结束的会话，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles，接口请求状态码为200。
    ...    - Step4、调用导出管理接口，获取数据总数应 +1，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles，接口请求状态码为200。
    ...    - Step5、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK，tenantId字段等于租户id，fileSize字段应不等于，并大于0.0。
    #定义为局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${yn}=    Convert To Integer    ${yyyy}
    ${mn}=    Convert To Integer    ${mm}
    ${dn}=    Convert To Integer    ${day}
    ${mr}=    Monthrange    ${yn}    ${mn}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #添加customerName为消息测试的访客，作为导出条件
    set to dictionary    ${filter}    customerName=${session.userName}
    #对比前的导出管理总数
    ${j}    Get My Export    get    ${AdminUser}    ${filter}    ${range}
    ${preCount}    set variable    ${j['totalElements']}
    #导出历史会话数据
    Export My History    post    ${AdminUser}    ${filter}    ${range}
    #获取当前的时间
    @{localTime}    get time    year month day hour min sec
    ${i}    Get My Export And Diff Counts    ${AdminUser}    ${filter}    ${range}    ${preCount}
    log    ${i}
    ${status}    Run_keyword_and_return_status    Should Be Equal    ${i}    {}
    run keyword if    ${status}    Fail    导出历史会话数据后，数据一直不是Finished
    run keyword if    '${i['fileSize']}' == '0.0'    Fail    导出历史会话的文件大小为0.0，${i}
    should be equal    ${i['tenantId']}    ${AdminUser.tenantId}    返回结果中租户id不正确，${i}
    should be equal    ${i['status']}    Finished    返回结果中status不是Finished，${i}

下载记录(/tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/downloadDetails)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话->关闭进行中的会话->查询历史会话是否包含该会话）。
    ...    - Step2、获取导出管理数据总数，作为导出历史会话的判断依据，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles，接口请求状态码为200。
    ...    - Step3、坐席在历史会话中，导出刚结束的会话，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles，接口请求状态码为200。
    ...    - Step4、调用导出管理接口，获取数据总数应 +1，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles，接口请求状态码为200。
    ...    - Step5、接口返回值中，status字段的值等于OK，tenantId字段等于租户id，fileSize字段应不等于，并大于0.0。
    ...    - Step6、创建单个导出数据的下载记录，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/downloadDetails，接口请求状态码为200。
    ...    - Step6、创建单个导出数据的下载记录，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/downloadDetails，接口请求状态码为200。
    ...    - Step7、获取单个导出数据的下载记录，调用接口：/tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/downloadDetails，接口请求状态码为200。
    ...    - Step8、判断接口返回值情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，字段ip不等于空、字段tenantId等于租户id、agentUserId等于操作的坐席Id。
    #定义为局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${yn}=    Convert To Integer    ${yyyy}
    ${mn}=    Convert To Integer    ${mm}
    ${dn}=    Convert To Integer    ${day}
    ${mr}=    Monthrange    ${yn}    ${mn}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #添加customerName为消息测试的访客，作为导出条件
    set to dictionary    ${filter}    customerName=${session.userName}
    #对比前的导出管理总数
    ${j}    Get My Export    get    ${AdminUser}    ${filter}    ${range}
    ${preCount}    set variable    ${j['totalElements']}
    #导出历史会话数据
    Export My History    post    ${AdminUser}    ${filter}    ${range}
    #获取当前的时间
    @{localTime}    get time    year month day hour min sec
    ${i}    Get My Export And Diff Counts    ${AdminUser}    ${filter}    ${range}    ${preCount}
    ${status}    Run_keyword_and_return_status    Should Be Equal    ${i}    {}
    run keyword if    ${status}    Fail    导出历史会话数据后，数据一直不是Finished
    run keyword if    '${i['fileSize']}' == '0.0'    Fail    导出历史会话的文件大小为0.0，${i}
    should be equal    ${i['tenantId']}    ${AdminUser.tenantId}    返回结果中租户id不正确，${i}
    should be equal    ${i['status']}    Finished    返回结果中status不是Finished，${i}
    #获取单个导出数据的下载记录
    ${j}    Set Download Records    post    ${AdminUser}    ${i['id']}
    #获取单个导出数据的下载记录
    ${j}    Set Download Records    get    ${AdminUser}    ${i['id']}
    run keyword if    '${j['content'][0]['ip']}' == '${EMPTY}'    Fail    导出的ip值为空，${j}
    should be equal    ${j['content'][0]['tenantId']}    ${AdminUser.tenantId}    返回结果中租户id不正确，${i}
    should be equal    ${j['content'][0]['agentUserId']}    ${AdminUser.userId}    返回结果中userid不正确，${i}
    should be equal    ${j['content'][0]['fileId']}    ${i['id']}    返回结果中fileId不正确，${i}
    # Should Match Regexp    ${j['content'][0]['ip']}    (([01]{0,1}\\d{0,1}\\d|2[0-4]\\d|25[0-5])\\.){3}([01]\\d{0,1}\\d{0,1}\\d|2[0-4]\\d|25[0-5])    不匹配ip的正则表达式，${j}
