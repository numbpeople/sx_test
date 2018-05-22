*** Settings ***
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
Resource          ../../../../commons/admin common/Setting/Phrases_Common.robot
Resource          ../../../../commons/admin common/Setting/ConversationTags_Common.robot
Resource          ../../../../commons/admin common/Setting/CustomerTags_Common.robot
Resource          ../../../../commons/admin common/Knowledge/Knowledge_Common.robot
Resource          ../../../../commons/admin common/Robot/RobotSettings_Common.robot
Resource          ../../../../commons/admin common/Daas/Daas_Common.robot

*** Test Cases ***
下载历史会话导出管理的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    1、创建一个历史会话并导出历史会话数据。 2、下载历史会话导出管理的数据
    #定义为局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建一个历史会话并导出历史会话数据
    ${session}    Create Terminal And Export HistoryFiles    ${AdminUser}
    #下载导出管理的数据
    ${result}    Download Export File    ${AdminUser}    ${session.id}
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    历史会话导出
    ${sheetname}    set variable    historyFile
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${csvPath}    ${result}
    #将csv文件转化成xls格式文件
    csv_to_xls_pd    ${csvPath}    ${sheetname}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    Conversation ID    CustomerID    Nickname    Message count    Agent
    ...    Full name    Created at    Connected at    Last replied at    Closed at    Transferred
    ...    Conversation types    Conversation tag    Channel account    Channel    Message detail    Conversation remarks
    @{sheetValue}    create list    ${session.sessionServiceId}    ${session.userName}    ${session.userName}    ${session.createDatetime}    ${session.startDateTime}
    ...    ${session.stopDateTime}
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}

导出下载成员管理-客服的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    [Documentation]    1、创建坐席账号数据 2、导出成员管理-客服的数据
    #创建坐席账号并导出坐席数据
    @{paramList}    create list    ${AdminUser}
    ${agentInfo}    Run keyword And Export Specify Data    ${AdminUser}    Create Agent And Download Data    @{paramList}
    #下载导出管理的数据
    ${result}    Download Export File    ${AdminUser}    ${agentInfo.id}    #获取导出管理中文件的id值,并下载其文件
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
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
    @{sheetName}    create list    客服昵称    邮箱    真实姓名    电话号码    工号
    ...    接待数    角色    在线状态    账户启用
    @{sheetValue}    create list    ${agentInfo.nicename}    ${agentInfo.username}    管理员    离线    ${agentInfo.status}
    ...    ${${agentInfo.maxServiceSessionCount}}
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
    [Documentation]    1、创建常用语数据 2、导出常用语的数据 3、比较总行数大于2即可,后续再看如何校验多行情况
    #创建坐席账号并导出坐席数据
    @{paramList}    create list    ${AdminUser}
    ${commonphrasesInfo}    Create Commonphrases    ${AdminUser}
    #下载导出管理的数据
    ${result}    Commonphrases ExportFile    ${AdminUser}    #导出常用语并下载其文件
    ${commonphrasesContent}    set variable    ${result.content}    #获取常用语下载返回值
    ${commonphrasesFilename}    set variable    ${result.headers['Content-Disposition']}    #获取常用语下载文件名称
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
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
    ${path}    Find Specified Folder Path    tempdata
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
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
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
    [Documentation]    1、创建会话标签 2、导出会话标签的数据 3、比较总行数大于2即可,后续再看如何校验多行情况
    #创建会话标签
    ${summaryInfo}    Create ServiceSessionSummary    ${AdminUser}
    #导出会话标签的数据
    ${result}    Export ServiceSessionSummaries    ${AdminUser}    #导出会话标签并下载其文件
    ${summaryContent}    set variable    ${result.content}    #获取会话标签下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    会话标签导出
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${summaryContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    一级会话标签(80个字以内)    二级会话标签    三级会话标签    四级会话标签    五级会话标签
    ...    六级会话标签    七级会话标签    八级会话标签    九级会话标签    十级会话标签
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
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    会话标签下载模板
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${summaryContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    一级会话标签(80个字以内)    二级会话标签    三级会话标签    四级会话标签    五级会话标签
    ...    六级会话标签    七级会话标签    八级会话标签    九级会话标签    十级会话标签
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
    run keyword if    ${rowCount} != 7    Fail    因为会话标签下载模板数据一共7行,所以导出的excel文件总行数应等于7,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}

导出下载客户标签的数据(/download/tplfiles/%E5%AE%A2%E6%88%B7%E6%A0%87%E7%AD%BE%E6%A8%A1%E7%89%88.xlsx)
    [Documentation]    1、创建客户标签 2、导出客户标签的数据 3、比较总行数大于2即可,后续再看如何校验多行情况
    #创建客户标签
    ${userTagInfo}    Create UserTag    ${AdminUser}
    #导出客户标签的数据
    ${result}    Export UserTag    ${AdminUser}    #导出客户标签并下载其文件
    ${userTagContent}    set variable    ${result.content}    #获取客户标签下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
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
    ${path}    Find Specified Folder Path    tempdata
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
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
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

导出下载知识库的数据(/v1/tenants/{tenantId}/knowledge/export)
    [Documentation]    1、创建知识库 2、导出知识库的数据 3、比较总行数大于2即可,后续再看如何校验多行情况
    ${filter}    copy dictionary    ${FilterEntity}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Drafting    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识并
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    #导出客户标签的数据
    ${result}    Export knowledge Entry    ${AdminUser}    #导出知识库并下载其文件
    ${entryContent}    set variable    ${result.content}    #获取知识库下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    知识库导出
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${entryContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    分类Code    分类名    知识ID    知识Code    知识标题
    ...    知识内容
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
    run keyword if    ${rowCount} < 2    Fail    因为新增了一个知识库数据,所以导出的excel文件总行数应大于等于2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}

导出下载知识库-下载模板的数据(/download/tplfiles/{fileName}.xlsx)
    [Documentation]    1、导出下载知识库模板
    #设置下载的模板文件名称
    ${fileName}    set variable    %E7%9F%A5%E8%AF%86%E5%BA%93%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF
    #导出下载知识库模板
    ${result}    Get knowledge Template    ${AdminUser}    ${fileName}    #导出知识库模板
    ${userTagContent}    set variable    ${result.content}    #获取知识库下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    知识库模板
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${userTagContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    分类Code    分类名    知识ID    知识Code    知识标题
    ...    知识内容
    @{sheetValue}    create list    第三方分类标识,没有不设置。例如1/10/100    以/区分各级分类。新的分类系统会根据分类结构自动创建。创建时会忽略分类名称中的空格。例如：高一/语文/作文    已有ID更新标题和内容，ID 为空时会在分类下创建知识。如知识ID不存在或同一知识 ID 属于多个分类下，则无法导入知识。    知识Code 为第三方知识标识，没有不进行设置。例如:K001    20个字符，超过则无法正常导入。
    ...    允许导入文本格式内容，不限制大小
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 2    Fail    因为知识库下载模板数据一共2行,所以导出的excel文件总行数应等于2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}

导出下载机器人-知识规则的数据(/v3/Tenants/{tenantId}/robots/rule/export)
    [Documentation]    1、创建知识规则 2、导出知识规则的数据 3、比较总行数大于3即可,后续再看如何校验多行情况
    #创建知识规则
    ${ruleResult}    Create Robot Rule    ${AdminUser}
    #导出知识规则的数据
    ${result}    Export Robot Rules    ${AdminUser}    #导出知识规则并下载其文件
    ${ruleContent}    set variable    ${result.content}    #获取知识规则下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    机器人知识规则导出
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${ruleContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    模板导入说明：1、文件大小不得超过5M2、单次导入知识规则条目数量不得超过10003、如果不填写分类，默认加入根分类，如需增加分类，可直接添加列，并写入（x级分类，x为阿拉伯数字）4、分类字数不得超过30汉字，分类最多5级5、可以通过增加列来增加问题，问题列的增加格式同模板所示，问题最多20个；6、可以通过增加列来增加答案，答案最多5个，答案与答案不能重复7、仅支持文字类答案8、启用状态如果不填写，按照启用处理
    @{sheetValue}    create list    1级分类    2级分类    3级分类    问题问法1    问题问法2
    ...    问题问法3    问题问法4    问题问法5    答案1    是否启用
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} < 3    Fail    因为新增了一个知识规则数据,所以导出的excel文件总行数应大于等于3,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}

导出下载机器人-知识规则-下载模板的数据(/v3/Tenants/{tenantId}/robots/rule/template)
    [Documentation]    1、导出下载机器人-知识规则模板
    #导出机器人-知识规则模板
    ${result}    Get Robot Rules Template    ${AdminUser}    #导出机器人知识规则模板
    ${userTagContent}    set variable    ${result.content}    #获取机器人知识规则模板下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    机器人知识规则模板
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${userTagContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    模板导入说明：1、文件大小不得超过5M2、单次导入知识规则条目数量不得超过10003、如果不填写分类，默认加入根分类，如需增加分类，可直接添加列，并写入（x级分类，x为阿拉伯数字）4、分类字数不得超过30汉字，分类最多5级5、可以通过增加列来增加问题，问题列的增加格式同模板所示，问题最多20个；6、可以通过增加列来增加答案，答案最多5个，答案与答案不能重复7、仅支持文字类答案8、启用状态如果不填写，按照启用处理
    @{sheetValue}    create list    1级分类    2级分类    3级分类    问题问法1    问题问法2
    ...    问题问法3    问题问法4    问题问法5    答案1    是否启用
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 6    Fail    因为机器人知识规则下载模板数据一共6行,所以导出的excel文件总行数应等于6,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}

导出下载机器人-自定义菜单的数据(/v3/Tenants/{tenantId}/robots/menus/items/export)
    [Documentation]    1、创建自定义菜单 2、导出自定义菜单的数据 3、比较总行数大于2即可,后续再看如何校验多行情况
    #创建自定义菜单
    ${ruleResult}    Create Robot Parent Menu    ${AdminUser}
    #导出自定义菜单的数据
    ${result}    Export Robot Menu    ${AdminUser}    #导出自定义菜单并下载其文件
    ${menuContent}    set variable    ${result.content}    #获取自定义菜单下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    机器人自定义菜单导出
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${menuContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    菜单名字    第1级菜单    第2级菜单    第3级菜单    第4级菜单
    ...    答案
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
    run keyword if    ${rowCount} < 2    Fail    因为新增了一个自定义菜单数据,所以导出的excel文件总行数应大于等于2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}

导出下载机器人-自定义菜单-下载模板的数据(/v1/Tenants/{tenantId}/robot/menu/template/export)
    [Documentation]    1、导出下载机器人-自定义菜单-下载模板模板
    #导出机器人-知识规则模板
    ${result}    Download Robot Menu Template    ${AdminUser}    #导出机器人自定义菜单下载模板
    ${menuContent}    set variable    ${result.content}    #获取机器人自定义菜单下载模板下载返回值
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    机器人自定义菜单
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsxPath}    set variable    ${path}/${filename}.xlsx
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${xlsxPath}    ${menuContent}
    xlsx_to_xls    ${xlsxPath}    ${xlsPath}
    #模板数据
    @{sheetName}    create list    菜单名字    第1级菜单    第2级菜单    第3级菜单    第4级菜单
    ...    答案
    @{sheetValue}    create list    选择业务类型    对公业务    对公存款    外汇存款    定期外汇存款
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRrowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    log list    ${secondRrowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 7    Fail    因为机器人自定义菜单下载模板数据一共7行,所以导出的excel文件总行数应等于7,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}
    # 导出下载留言的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    # 导出下载告警记录的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)
    # 导出下载客户中心的数据(/tenants/{tenantId}/serviceSessionHistoryFiles)

导出下载质量检查的数据(/v1/tenants/{tenantId}/servicesessions/qualityreview/file)
    [Documentation]    1、创建一个已结束的会话并导出基础质检数据。 2、下载质检在导出管理中的数据
    #创建局部变量
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建一个已结束会话并导出质检记录
    @{paramList}    create list    ${AdminUser}
    ${sessionInfo}    Run keyword And Export Specify Data    ${AdminUser}    Create Terminal And Export QualityReviewFiles    @{paramList}
    #下载导出管理的数据
    ${result}    Download Export File    ${AdminUser}    ${sessionInfo.id}
    #保存文件
    ${path}    Find Specified Folder Path    tempdata
    ${filename}    set variable    质检记录导出
    ${sheetname}    set variable    qualityReview
    ${csvPath}    set variable    ${path}/${filename}.csv
    ${xlsPath}    set variable    ${path}/${filename}.xls
    #保存文件到本地目录
    save file    ${csvPath}    ${result}
    #将csv文件转化成xls格式文件
    csv_to_xls_pd    ${csvPath}    ${sheetname}    ${xlsPath}
    #模板数据
    log dictionary    ${sessionInfo}
    @{sheetName}    create list    客户ID    昵称    参与客服    坐席账号    真实姓名
    ...    会话创建时间    首次响应时长    平均响应时长    会话时长    会话标签    会话备注
    ...    访客消息数    客服消息数    满意度评价分数    满意度评价详情    质检总分    质检备注
    ...    质检员    关联名称    来源
    @{sheetValue}    create list    ${sessionInfo.userName}    ${sessionInfo.userName}    ${${sessionInfo.vmsgCount}}    ${${sessionInfo.amsgCount}}    #${${sessionInfo.qualityMark}}
    ...    [${sessionInfo.originType}]
    #读取xls表格数据
    @{firstRowsList}    Get Rows List    ${xlsPath}    0
    @{secondRowsList}    Get Rows List    ${xlsPath}    1
    log list    ${firstRowsList}
    #获取文件总行数
    ${sheetNames}    Get Sheet Names
    ${rowCount}    Get Row Count    ${sheetNames[0]}
    #判断导出数据总行数和导出与预期数据相等
    run keyword if    ${rowCount} != 2    Fail    因为只导出一个服务的数据,所以导出的excel文件总行数应为2,需要检查文件,路径:${xlsPath}
    Should Be ExportFiles Excel Equal    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRowsList}
