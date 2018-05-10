*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/History/HistoryApi.robot
Resource          ../../../api/BaseApi/Export/Export_Api.robot
Resource          ../Conversations/Conversations_Common.robot

*** Variables ***
${diffCreatetimeValue}    10

*** Keywords ***
Get My Export
    [Arguments]    ${method}    ${agent}    ${filter}    ${range}    ${userId}=    ${language}=en-US
    [Documentation]    查询我的导出管理数据
    #查询我的管理导出数据
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles    ${method}    ${agent}    ${timeout}    ${filter}    ${range}    ${userId}    ${language}
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
    \    ${status}    Run_keyword_and_return_status    Should Be Equal    ${j}    {}
    \    run keyword if    ${status}    Fail    导出数据后，对比没有增加
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

Download Export File
    [Arguments]    ${agent}    ${serviceSessionHistoryFileId}
    [Documentation]    下载导出管理数据的文件
    #下载导出管理数据的文件
    ${resp}=    /tenants/{tenantId}/serviceSessionHistoryFiles/{serviceSessionHistoryFileId}/file    ${agent}    ${serviceSessionHistoryFileId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.content}
    Return From Keyword    ${resp.content}

Create Terminal And Export HistoryFiles
    [Arguments]    ${agent}
    [Documentation]    创建一个历史会话并导出历史会话数据
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
    ${j}    Get My Export    get    ${agent}    ${filter}    ${range}
    ${preCount}    set variable    ${j['totalElements']}
    #导出历史会话数据
    Export My History    post    ${agent}    ${filter}    ${range}    ${EMPTY}    #zh-CN
    #获取当前的时间
    @{localTime}    get time    year month day hour min sec
    ${i}    Get My Export And Diff Counts    ${agent}    ${filter}    ${range}    ${preCount}
    ${status}    Run_keyword_and_return_status    Should Be Equal    ${i}    {}
    run keyword if    ${status}    Fail    导出历史会话数据后，数据一直不是Finished
    run keyword if    '${i['fileSize']}' == '0.0'    Fail    导出历史会话的文件大小为0.0，${i}
    should be equal    ${i['tenantId']}    ${agent.tenantId}    返回结果中租户id不正确，${i}
    should be equal    ${i['status']}    Finished    返回结果中status不是Finished，${i}
    #将导出管理中该数据的id放到字典中
    set to dictionary    ${session}     mediaId=${i['mediaId']}    fileName=${i['fileName']}    id=${i['id']}
    Return From Keyword    ${session}

Run keyword And Export Specify Data
    [Arguments]    ${agent}    ${functionName}    @{paramList}
    [Documentation]    1、导出指定关键字模块的数据    2、判断导出管理中是否包含导出数据    3、将导出的数据返回
    #定义为局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #对比前的导出管理总数
    ${j}    Get My Export    get    ${agent}    ${filter}    ${range}
    ${preCount}    set variable    ${j['totalElements']}
    #导出指定关键字模块的数据
    ${specifyResult}    run keyword    ${functionName}    @{paramList}
    #获取当前的时间
    ${i}    Get My Export And Diff Counts    ${agent}    ${filter}    ${range}    ${preCount}
    ${status}    Run_keyword_and_return_status    Should Be Equal    ${i}    {}
    run keyword if    ${status}    Fail    导出历史会话数据后，数据一直不是Finished
    run keyword if    '${i['fileSize']}' == '0.0'    Fail    导出历史会话的文件大小为0.0，${i}
    should be equal    ${i['tenantId']}    ${agent.tenantId}    返回结果中租户id不正确，${i}
    should be equal    ${i['status']}    Finished    返回结果中status不是Finished，${i}
    #将导出管理中该数据的id放到字典中
    set to dictionary    ${specifyResult}     mediaId=${i['mediaId']}    fileName=${i['fileName']}    id=${i['id']}
    Return From Keyword    ${specifyResult}

Find Specified Folder Path
    [Arguments]    ${folderName}
    [Documentation]    找到项目一级的文件夹的路径值
    #找到Testdata文件夹的路径值
    ${path}    set variable    ${CURDIR}
    ${path}    evaluate    os.path.abspath(os.path.dirname('${path}')+os.path.sep+"..")    os
    ${path}    set variable    ${path}${/}${folderName}
    ${path}=    Replace String    ${path}    \\    /
    # evaluate    os.chmod('${path}',stat.S_IXGRP)	os,stat    #给文件夹赋权限
    # evaluate    os.chmod('${path}',stat.S_IWOTH)	os,stat    #给文件夹赋权限
    # evaluate    os.chmod('${path}',stat.S_IRWXO)	os,stat    #给文件夹赋权限
    return from keyword    ${path}

Get Rows List
    [Arguments]    ${xlsPath}    ${rowNum}
    [Documentation]    查找当前行的数据,并将数据放置到数组中
    Open Excel    ${xlsPath}
    ${sheetNames}    Get Sheet Names
    ${rowValues}    Get Row Values    ${sheetNames[0]}    ${rowNum}
    ${length}    get length    ${rowValues}
    @{sheetValueList}    create list
    :FOR    ${i}    IN   @{rowValues}
    \    #判断类型是否为空
    \    ${if_empty}    Run_keyword_and_return_status    Should Be Equal    ${i[1]}    ${Empty}
    \    ${if_float}    is_float    ${i[1]}    #判断是否为float-浮点型
    \    Continue For Loop If    ${if_empty}
    \    ##判断类型是否为float,将转化成int放置到数组中
    \    ${convertInt}    Run_keyword_if    ${if_float}    Convert To Integer    ${i[1]}
    \    Run_keyword_if    ${if_float}    Append To List    ${sheetValueList}    ${convertInt}
    \    Continue For Loop If    ${if_float}
    \    #替换消息中\n字符串为空
    \    ${rowValue}    Replace String    ${i[1]}    \n    ${EMPTY}
    \    #将值最左面的空格去除
    \    ${rowValue}    evaluate    "${rowValue}".lstrip()
    \    #将编码后的字符进行解码
    # \    ${rowValue}    format_code    ${rowValue}
    \    ${rowValue}    evaluate	'${rowValue}'.decode('utf-8')
    \    Append To List    ${sheetValueList}    ${rowValue}
    log list    ${sheetValueList}
    return from keyword    ${sheetValueList}

Should Be ExportFiles Excel Equal
    [Arguments]    ${sheetName}    ${firstRowsList}    ${sheetValue}    ${secondRrowsList}  
    [Documentation]    对比表格中的每行数据
    #断言模板数据是否在实际接口值中
    :FOR    ${i}    IN    @{sheetName}
    \    log    ${i}
    \    List Should Contain Value    ${firstRowsList}    ${i}    数据${i}不在firstRowsList模板列表内
    #断言模板数据是否在实际接口值中
    :FOR    ${i}    IN    @{sheetValue}
    \    List Should Contain Value    ${secondRrowsList}    ${i}    数据${i}不在模板列表内