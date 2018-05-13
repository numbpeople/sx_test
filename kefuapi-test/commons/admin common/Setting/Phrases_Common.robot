*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/PhrasesApi.robot

*** Keywords ***
Set Phrases
    [Arguments]    ${agent}    ${method}    ${orgEntity}    ${phrasesEntity}    ${data}=    ${id}=
    [Documentation]    常用语分类的增删改查
    #操作常用语分类
    ${resp}=    /v1/organs/{organName}/tenants/{tenantId}/commonphrases    ${agent}    ${method}    ${orgEntity}    ${phrasesEntity}    ${timeout}
    ...    ${data}    ${id}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} ,${resp.content}    \    ${EMPTY}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Clear Phrases
    #设置常用语名称模板
    ${prePhrasesName}=    convert to string    ${AdminUser.tenantId}
    #创建参数字典
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    #获取常用语分类
    ${j}    Set Phrases    ${AdminUser}    get    ${orgEntity}    ${phrasesEntity}    ${EMPTY}
    run keyword if     "@{j['entities']}" == "[]"    Pass Execution    获取结果为空，标记为pass，不往下执行
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #循环删除包含${prePhrasesName}的常用语分类
    : FOR    ${i}    IN    @{j['entities']}
    \    ${PhrasesName}=    convert to string    ${i['phrase']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${PhrasesName}    ${prePhrasesName}
    \    Run Keyword If    '${status}' == 'True'    Set Phrases    ${AdminUser}    delete    ${orgEntity}
    \    ...    ${phrasesEntity}    ${EMPTY}    ${i['id']}

Commonphrases ExportFile
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出常用语数据
    ${resp}=    /v1/tenants/{tenantId}/commonphrases/exportFile    ${agent}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code} ,${resp.content}
    Return From Keyword    ${resp}

Export Commonphrases Template
    [Arguments]    ${agent}    ${language}=zh-CN
    [Documentation]    导出常用语下载模板
    ${resp}=    /download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx    ${AdminUser}    ${timeout}    ${language}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    Return From Keyword    ${resp}

Create Commonphrases
    [Arguments]    ${agent}
    [Documentation]    创建分类和添加常用语数据
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在新建分类下新增公共常用语
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=1
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}
    Return From Keyword    ${phrasesEnt}