*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/Export/Export_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot

*** Test Cases ***
导出管理(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    导出管理数据的测试用例步骤：
    ...
    ...    1、初始创建一个结束的会话
    ...
    ...    2、获取本地时间，使用Get My Export And Check Status函数，对比返回的创建时间值和本地时间的差值是否在一个范围内，如果在则返回初始结束的那条会话
    ...
    ...    3、将返回的导出历史会话数据做断言，比较tenantId、status、fileSize值等
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
    Create Terminal Conversation
    #导出历史会话数据
    Export My History    post    ${AdminUser}    ${filter}    ${range}
    #获取当前的时间
    @{localTime}    get time    year month day hour min sec
    ${i}    Get My Export And Check Status    ${AdminUser}    ${filter}    ${range}    ${localTime}
    run keyword if    '${i['fileSize']}' == '0.0'    Fail    导出历史会话的文件大小为0.0，${i}
    should be equal    ${i['tenantId']}    ${AdminUser.tenantId}    返回结果中租户id不正确，${i}
    should be equal    ${i['status']}    Finished    返回结果中status不是Finished，${i}

下载记录(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    下载记录的测试用例步骤：
    ...
    ...    1、初始创建一个结束的会话
    ...
    ...    2、获取本地时间，使用Get My Export And Check Status函数，对比返回的创建时间值和本地时间的差值是否在一个范围内，如果在则返回初始结束的那条会话
    ...
    ...    3、将返回的导出历史会话数据做下载记录接口断言，比较tenantId、fieldId、ip值等
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
    Create Terminal Conversation
    #导出历史会话数据
    Export My History    post    ${AdminUser}    ${filter}    ${range}
    #获取当前的时间
    @{localTime}    get time    year month day hour min sec
    ${i}    Get My Export And Check Status    ${AdminUser}    ${filter}    ${range}    ${localTime}
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
    Should Match Regexp    ${j['content'][0]['ip']}    (([01]{0,1}\\d{0,1}\\d|2[0-4]\\d|25[0-5])\\.){3}([01]\\d{0,1}\\d{0,1}\\d|2[0-4]\\d|25[0-5])    不匹配ip的正则表达式，${j}
