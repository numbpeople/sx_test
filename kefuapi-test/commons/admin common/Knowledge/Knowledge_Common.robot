*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Library           urllib
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Knowledge/Knowledge_Api.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Keywords ***
Get Knowledge Categories Tree
    [Arguments]    ${agent}
    [Documentation]    获取知识库的所有菜单分类
    #获取知识库的菜单分类
    ${resp}=    /v1/tenants/{tenantId}/knowledge/categories/tree    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Categories Should Contain CategoryId
    [Arguments]    ${result}    ${preCategoryId}
    [Documentation]    对比结果中CategoryId是否等于预期
    :FOR    ${i}    IN    @{result}
    \    return from keyword if    ${i['categoryId']} == ${preCategoryId}    ${i}
    return from keyword    {}
    
Set Knowledge Category
    [Arguments]    ${method}    ${agent}    ${data}=    ${categoryId}=
    [Documentation]    新增/修改/删除知识库菜单分类
    #新增/修改/删除知识库菜单分类
    ${resp}=    /v1/tenants/{tenantId}/knowledge/categories    ${method}    ${agent}    ${data}    ${categoryId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Create Knowledge Category
    [Arguments]    ${agent}    ${parentId}=null
    [Documentation]    创建知识库菜单分类
    ...    参数：${agent}：账号信息
    ...    	     ${parentId}：代表添加的父级分类ID, 默认为null, 即根分类
    ...    
    ...    返回值：categoryId、name、level、rank, 即为：分类id, 分类名称, 级别(0代表是叶子, 1代表根或有叶子的层级),(rank不清楚)
    #创建请求体
    ${randoNumber}    Generate Random String    4    [NUMBERS]
    ${categoriesEntity}    create dictionary    name=${agent.tenantId}-${randoNumber}    parentId=${parentId}
    ${data}    set variable    {"name":"${categoriesEntity.name}","parentId":${categoriesEntity.parentId}}
    #添加知识库菜单分类
    ${j}    Set Knowledge Category    post    ${agent}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['name']}    ${categoriesEntity.name}    返回值name不是${categoriesEntity.name}：${j}
    should be equal    ${j['entity']['tenantId']}    ${agent.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}
    &{resultDic}    Create Dictionary    categoryId=${j['entity']['categoryId']}    name=${j['entity']['name']}    level=${j['entity']['level']}    rank=${j['entity']['rank']}    createDateTime=${j['entity']['createDateTime']}    lastUpdateDateTime=${j['entity']['lastUpdateDateTime']}
    Return From Keyword    ${resultDic}

Set Knowledge Entry
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}=    ${entryId}=
    [Documentation]    新增/修改/删除知识数据
    #新增/修改/删除知识数据
    ${resp}=    /v1/tenants/{tenantId}/knowledge/entries    ${method}    ${agent}    ${filter}    ${data}    ${entryId}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Create Knowledge Entry
    [Arguments]    ${agent}    ${filter}
    [Documentation]    创建知识
    ...    参数：${agent}：账号信息
    ${entryStates}    set variable    ${filter.entryStates}    #代表添加知识类型, 值为：Published、Drafting
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #创建请求体
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    &{entryEntity}    create dictionary    title=添加知识-${AdminUser.tenantId}-${randoNumber}    content=<p>add-knowledge-entry-${AdminUser.tenantId}-${randoNumber}</p>    categoryName=${categoryResult.name}    categoryId=${categoryResult.categoryId}    state=${entryStates}    embeddedMedias=[]    attachments=[]    rank=1    mainMediaId=0
    ${data}    set variable    {"title":"${entryEntity.title}","content":"${entryEntity.content}","categoryName":"${entryEntity.categoryName}","embeddedMedias":${entryEntity.embeddedMedias},"attachments":${entryEntity.attachments},"rank":${entryEntity.rank},"mainMediaId":${entryEntity.mainMediaId},"categoryId":${entryEntity.categoryId},"state":"${entryEntity.state}"}
    #添加知识
    ${j}    Set Knowledge Entry    post    ${AdminUser}    ${filter}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}
    should be equal    ${j['entity']['title']}    ${entryEntity.title}    返回值title不是${entryEntity.title}：${j}
    should be equal    ${j['entity']['content']}    ${entryEntity.content}    返回值content不是${entryEntity.content}：${j}
    should be equal    ${j['entity']['categoryId']}    ${entryEntity.categoryId}    返回值categoryId不是${entryEntity.categoryId}：${j}
    should be equal    ${j['entity']['state']}    ${entryEntity.state}    返回值state不是${entryEntity.state}：${j}
    should be true    "${j['entity']['rank']}" == "${entryEntity.rank}"    返回值rank不是${entryEntity.rank}：${j}
    #将返回结果存到字典里
    set to dictionary    ${entryEntity}    entryId=${j['entity']['entryId']}    url=${j['entity']['url']}    creatorId=${j['entity']['creatorId']}    creatorNickname=${j['entity']['creatorNickname']}    viewHtmlCount=${j['entity']['viewHtmlCount']}    createDateTime=${j['entity']['createDateTime']}    lastUpdateDateTime=${j['entity']['lastUpdateDateTime']}
    Return From Keyword    ${entryEntity}

Get Knowledge Entry Count
    [Arguments]    ${agent}
    [Documentation]    获取知识总数
    #获取知识总数
    ${resp}=    /v1/tenants/{tenantId}/knowledge/entries/count    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Set Send-Settings Method
    [Arguments]    ${method}    ${agent}    ${data}=
    [Documentation]    获取/修改知识发送方式
    #获取/修改知识发送方式
    ${resp}=    /v1/tenants/{tenantId}/knowledge/send-settings    ${method}    ${agent}    ${data}    ${timeout}
    &{apiResponse}    Return Result    ${resp}
    set to dictionary    ${apiResponse}    describetion=【实际结果】：获取/修改知识发送方式，返回实际状态码：${apiResponse.statusCode}，调用接口：${apiResponse.url}，接口返回值：${apiResponse.text}
    Return From Keyword    ${apiResponse}

List Should Correct
    [Arguments]    ${resultList}    ${sendTypeEntity}=
    [Documentation]    根据list结果，获取originType值为app、webim、weibo、weixin ; sendTypesendType为NEWS或TEXT
	:FOR    ${i}    IN    @{resultList}
	    \    ${originTypeStatus}    Run Keyword And Return Status    List Should Contain Value    ${originType}    ${i['originType']}
	    \    ${sendTypeStatus}    Run Keyword And Return Status    should be true    '${i['sendType']}' == 'NEWS' or '${i['sendType']}' == 'TEXT'
	    \    run keyword if    not ${originTypeStatus}    Fail    返回值中渠道不包含为：${i['originType']}的值,${resultList}
	    \    run keyword if    not ${sendTypeStatus}    Fail    返回值中发送方式不是：NEWS或TEXT,${resultList}
	    \    run keyword if    "${sendTypeEntity}" == "${EMPTY}"    Pass Execution    没有渠道与发送方式sendType值对应关系的字典变量，则不往下处理
	    \    ${sendTypeValue}    set variable    ${sendTypeEntity.${i['originType']}}    #根据渠道为key获取字典中的值
	    \    should be true    "${i['sendType']}" == "${sendTypeValue}"    返回值中${i['originType']}渠道与所定义的值不相等。实际值：${i['sendType']}，预期值：${sendTypeValue}

Get knowledge Template
    [Arguments]    ${agent}    ${fileName}    ${language}=zh-CN
    [Documentation]    获取知识库的模板
    #获取知识库的模板
    ${resp}=    /download/tplfiles/{fileName}.xlsx    ${agent}    ${fileName}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    Return From Keyword    ${resp}

Export knowledge Entry
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出取知识库的所有知识
    #导出取知识库的所有知识
    ${resp}=    /v1/tenants/{tenantId}/knowledge/export    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    Return From Keyword    ${resp} 

Entry Should Contain EntryId
    [Arguments]    ${result}    ${entryId}
    [Documentation]    判断结果中是否包含指定的entryId值,包含返回结果,否则返回{}
    :FOR    ${i}    IN    @{result}
    \    return from keyword if    ${i['entryId']} == ${entryId}    ${i}
    return from keyword    {}

Delete Knowledge Entry And Category With Specify Name
    [Documentation]    根据指定的名称删除知识库中知识和分类
    #删除知识库
    Delete Knowledge Entry With EntryName
    #删除知识库分类
    Delete Categories With CategoryName

Delete Categories With CategoryName
    [Documentation]    删除知识库分类
    #设置知识库分类名称包含指定关键字
    ${preCategoryName}=    convert to string    ${AdminUser.tenantId}
    #获取知识库的所有分类
    ${j}    Get Knowledge Categories Tree    ${AdminUser}
    :FOR    ${i}    IN    @{j['entities']}
    \    ${categoryName}=    convert to string    ${i['name']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${categoryName}    ${preCategoryName}
    \    ${userIdValue}    set variable    ${i['categoryId']}
    \    Run Keyword If    '${status}' == 'True'    Delete Category With CategoryId   ${AdminUser}    ${userIdValue}

Delete Category With CategoryId
    [Arguments]    ${agent}    ${categoryId}
    [Documentation]    根据分类id删除知识库分类
    ${j}    Set Knowledge Category    delete    ${agent}    ${EMPTY}    ${categoryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}

Delete Knowledge Entry With EntryName
    [Documentation]    删除所有的已发布和草稿的知识库数据
    @{entryStatesList}    create list    Published    Drafting
    :FOR    ${i}    IN    @{entryStatesList}
    \    Delete Knowledge Entry With EntryState    ${i}

Delete Knowledge Entry With EntryState
    [Arguments]    ${entryStates}
    [Documentation]    删除知识库数据
    #设置知识库知识名称包含指定关键字
    ${preEntryName}=    convert to string    ${AdminUser.tenantId}
    #创建筛选条件
    ${filter}    copy dictionary    ${FilterEntity}
    set to dictionary    ${filter}    page=0    size=100    type=0    entryStates=${entryStates}    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #获取知识库数据
    ${j}    Set Knowledge Entry    get    ${AdminUser}    ${filter}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    #循环删除知识库数据
    ${times}    set variable    ${j['totalPages']}
    Repeat Keyword    ${times} times    Delete Knowledge Entry For Loop    ${AdminUser}    ${filter}    ${preEntryName}

Delete Knowledge Entry For Loop
    [Arguments]    ${agent}    ${filter}    ${preEntryName}
    [Documentation]    循环删除知识库数据
    #获取知识库数据
    ${j}    Set Knowledge Entry    get    ${agent}    ${filter}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    #循环删除知识库数据
    :FOR    ${i}    IN    @{j['entities']}
    \    ${entryName}=    convert to string    ${i['title']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${entryName}    ${preEntryName}
    \    ${userIdValue}    set variable    ${i['entryId']}
    \    Run Keyword If    '${status}' == 'True'    Delete Knowledge Entry With EntryId   ${AdminUser}    ${filter}    ${userIdValue}
   
Delete Knowledge Entry With EntryId
    [Arguments]    ${agent}    ${filter}    ${entryId}
    #删除知识
    ${j}    Set Knowledge Entry    delete    ${agent}    ${filter}    ${EMPTY}    ${entryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}