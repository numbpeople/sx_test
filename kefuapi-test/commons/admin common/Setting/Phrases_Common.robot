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
    run keyword if    '@{j['entities']}' == '[]'    Pass Execution    获取结果为空，标记为pass，不往下执行
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #循环删除包含${prePhrasesName}的常用语分类
    : FOR    ${i}    IN    @{j['entities']}
    \    ${PhrasesName}=    convert to string    ${i['phrase']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${PhrasesName}    ${prePhrasesName}
    \    Run Keyword If    '${status}' == 'True'    Set Phrases    ${AdminUser}    delete    ${orgEntity}
    \    ...    ${phrasesEntity}    ${EMPTY}    ${i['id']}
