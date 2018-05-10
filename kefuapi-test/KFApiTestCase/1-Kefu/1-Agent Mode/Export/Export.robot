*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Library           ExcelLibrary
Library           ../../../../lib/ReadFile.py    
Library           ../../../../lib/KefuUtils.py    
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
    Should Match Regexp    ${j['content'][0]['ip']}    (([01]{0,1}\\d{0,1}\\d|2[0-4]\\d|25[0-5])\\.){3}([01]\\d{0,1}\\d{0,1}\\d|2[0-4]\\d|25[0-5])    不匹配ip的正则表达式，${j}

下载历史会话导出管理的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    1、创建一个历史会话并导出历史会话数据。    2、下载历史会话导出管理的数据
    #定义为局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建一个历史会话并导出历史会话数据
    ${session}    Create Terminal And Export HistoryFiles    ${AdminUser}
    #下载导出管理的数据
    ${result}    Download Export File    ${AdminUser}    ${session.id}
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    ${session.fileName}
    ${sheetname}    set variable    historyFile
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${csvPath}    ${result}
    #将csv文件转化成xls格式文件
    csv_to_xls_pd    ${csvPath}    ${sheetname}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    Conversation ID	CustomerID  Nickname  Message count   Agent  Full name  Created at  Connected at  Last replied at   Closed at   Transferred   Conversation types  Conversation tag  Channel account   Channel   Message detail  Conversation remarks
    @{sheetValue}    create list    ${session.sessionServiceId}    ${session.userName}    ${session.userName}    ${session.createDatetime}    ${session.startDateTime}    ${session.stopDateTime}
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 

导出下载成员管理-客服的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    1、创建坐席账号数据    2、导出成员管理-客服的数据
    #创建坐席账号并导出坐席数据
    @{paramList}    create list    ${AdminUser}
    ${agentInfo}    Run keyword And Export Specify Data    ${AdminUser}    Create Agent And Download Data    @{paramList}
    #下载导出管理的数据
    ${result}    Download Export File    ${AdminUser}    ${agentInfo.id}    #获取导出管理中文件的id值,并下载其文件
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    ${agentInfo.fileName}
    ${sheetname}    set variable    agentFile
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${csvPath}    ${result}
    #将csv文件转化成xls格式文件
    csv_to_xls_pd    ${csvPath}    ${sheetname}    ${xlsPath}
    #模板数据
    log dictionary    ${agentInfo}
    @{sheetName}    create list    客服昵称    邮箱    真实姓名    电话号码    工号    接待数    角色    在线状态    账户启用
    @{sheetValue}    create list    ${agentInfo.nicename}    ${agentInfo.username}    管理员    离线    ${agentInfo.status}    ${${agentInfo.maxServiceSessionCount}}
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 
    