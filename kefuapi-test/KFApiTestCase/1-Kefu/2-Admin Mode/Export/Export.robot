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
Resource          ../../../../commons/admin common/Setting/Phrases_Common.robot

*** Test Cases ***
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
    ${filename}    set variable    历史会话导出
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
    ${filename}    set variable    客服信息导出
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
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 2    Fail    因为只导出一个坐席的数据,所以导出的excel文件总行数应为2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 

导出常用语的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    1、创建常用语数据    2、导出常用语的数据    3、比较总行数大于2即可,后续再看如何校验多行情况
    #创建坐席账号并导出坐席数据
    @{paramList}    create list    ${AdminUser}
    ${commonphrasesInfo}    Create Commonphrases    ${AdminUser}
    #下载导出管理的数据
    ${result}    Commonphrases ExportFile    ${AdminUser}    #导出常用语并下载其文件
    ${commonphrasesContent}    set variable    ${result.content}    #获取常用语下载返回值
    ${commonphrasesFilename}    set variable    ${result.headers['Content-Disposition']}    #获取常用语下载文件名称
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    常用语导出
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${commonphrasesContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    一级分类(20个字以内)    常用语(1000个字以内)或二级分类(20个字以内)    常用语(1000个字以内)
    @{sheetValue}    create list
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} < 2    Fail    因为新增了一个常用语数据,所以导出的excel文件总行数应大于等于2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 
