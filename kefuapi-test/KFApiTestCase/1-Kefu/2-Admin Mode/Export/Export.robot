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
Resource          ../../../../commons/admin common/Setting/ConversationTags_Common.robot
Resource          ../../../../commons/admin common/Setting/CustomerTags_Common.robot

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

导出下载常用语的数据(/v1/tenants/{tenantId}/commonphrases/exportFile)
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

导出下载常用语模板(/download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx)
    [Documentation]    1、导出下载常用语模板
    #导出常用语模板
    ${result}    Export Commonphrases Template    ${AdminUser}    #导出常用语模板
    ${commonphrasesContent}    set variable    ${result.content}    #获取常用语下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    常用语下载模板
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${commonphrasesContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    一级分类(20个字以内)    常用语(1000个字以内)或二级分类(20个字以内)    常用语(1000个字以内)
    @{sheetValue}    create list    一级分类名称1    常用语1
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}        0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 7    Fail    因为常用语下载模板数据一共7行,所以导出的excel文件总行数应等于7,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 

导出下载会话标签的数据(/v1/Tenants/{tenantId}/ServiceSessionSummaries/exportfile)
    [Documentation]    1、创建会话标签    2、导出会话标签的数据    3、比较总行数大于2即可,后续再看如何校验多行情况
    #创建会话标签
    ${summaryInfo}    Create ServiceSessionSummary    ${AdminUser}
    #导出会话标签的数据
    ${result}    Export ServiceSessionSummaries    ${AdminUser}    #导出会话标签并下载其文件
    ${summaryContent}    set variable    ${result.content}    #获取会话标签下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    会话标签导出
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${summaryContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    一级会话标签(80个字以内)    二级会话标签     三级会话标签    四级会话标签    五级会话标签    六级会话标签    七级会话标签	八级会话标签    九级会话标签    十级会话标签
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
    run keyword if    ${rowCount} < 2    Fail    因为新增了一个会话标签数据,所以导出的excel文件总行数应大于等于2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 

导出下载会话标签-下载模板的数据(/download/tplfiles/%E4%BC%9A%E8%AF%9D%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx)
    [Documentation]    1、导出下载会话标签模板
    #导出会话标签模板
    ${result}    Export ServiceSessionSummary Template    ${AdminUser}    #导出会话标签模板
    ${summaryContent}    set variable    ${result.content}    #获取会话标签载返回值
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    会话标签下载模板
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${summaryContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    一级会话标签(80个字以内)    二级会话标签     三级会话标签    四级会话标签    五级会话标签    六级会话标签    七级会话标签	八级会话标签    九级会话标签    十级会话标签
    @{sheetValue}    create list
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}        0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 7    Fail    因为会话标签下载模板数据一共7行,所以导出的excel文件总行数应等于7,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 

导出下载客户标签的数据(/download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx)
    [Documentation]    1、创建客户标签    2、导出客户标签的数据    3、比较总行数大于2即可,后续再看如何校验多行情况
    #创建客户标签
    ${userTagInfo}    Create UserTag    ${AdminUser}
    #导出客户标签的数据
    ${result}    Export UserTag    ${AdminUser}    #导出客户标签并下载其文件
    ${userTagContent}    set variable    ${result.content}    #获取客户标签下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    客户标签导出
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${userTagContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    客户标签（最多50汉字，系统排重）
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
    run keyword if    ${rowCount} < 2    Fail    因为新增了一个客户标签数据,所以导出的excel文件总行数应大于等于2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList} 

导出下载客户标签-下载模板的数据(/download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx)
    [Documentation]    1、导出下载客户标签模板
    #导出客户标签模板
    ${result}    Export UserTag Template    ${AdminUser}    #导出客户标签模板
    ${userTagContent}    set variable    ${result.content}    #获取客户标签载返回值
    #保存文件
    ${path}    Find Specified Folder Path    testdata
    ${filename}    set variable    客户标签下载模板
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${userTagContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    客户标签（最多50汉字，系统排重）
    @{sheetValue}    create list    这里是客户标签1
    @{sheetValue1}    create list    这里是客户标签2
    @{sheetValue2}    create list    这里是客户标签3
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}        0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    @{thirdRrowsList}    Get Rows List    ${xlsPath}    2
    @{fourthRrowsList}    Get Rows List    ${xlsPath}    3
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 4    Fail    因为客户标签下载模板数据一共4行,所以导出的excel文件总行数应等于4,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}
    Should Be ExportFiles Excel Equal    ${sheetValue1}    ${thirdRrowsList}    ${sheetValue2}    ${fourthRrowsList}

# 导出下载知识库的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载留言的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载客户中心的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载质量检查的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载告警记录的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载机器人-知识规则的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载机器人-知识规则-下载模板的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载机器人-自定义菜单的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

# 导出下载机器人-自定义菜单-下载模板的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
