*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/ReviewSettingApi.robot

*** Keywords ***
Set ReviewSettings
    [Arguments]    ${method}    ${agent}    ${data}    ${id}=
    [Documentation]    操作质检评分设置
    #操作质检评分设置
    ${resp}=    /v1/tenants/{tenantId}/qualityreviews/qualityitems    ${method}    ${agent}    ${timeout}    ${data}    ${id}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}, ${resp.text}
    run keyword if    ${resp.status_code}!=200    log    调用方法:Set ReviewSettings、返回的状态码:${resp.status_code}、请求地址:${resp.url}、返回结果:${resp.text}    level=ERROR
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Get Review TotalScores
    [Arguments]    ${result}
    [Documentation]    获取质检总分数
    #获取质检总分数
    ${minNum}    set variable    ${0}
    ${maxNum}    set variable    ${0}
    ${totalNum}    create dictionary
    #获取正数部分的综合
    : FOR    ${i}    IN    @{result}
    \    Continue For Loop If    '${i['opt']}' == '-'
    \    ${maxNum}    evaluate    ${maxNum} + ${${i['fullmark']}}
    #获取负数部分的综合
    : FOR    ${i}    IN    @{result}
    \    Continue For Loop If    '${i['opt']}' == '+'
    \    ${minNum}    evaluate    ${minNum} + ${${i['fullmark']}}
    set to dictionary    ${totalNum}    totalMinScore=${minNum}    totalMaxScore=${maxNum}
    Return From Keyword    ${totalNum}

Get Review ScoreMapping
    [Arguments]    ${method}    ${agent}
    [Documentation]    质检分数和分级的对应关系
    #质检分数和分级的对应关系
    ${resp}=    /v1/tenants/{tenantId}/qualityreviews/scoremapping    ${method}    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}, ${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Check PerScores
    [Arguments]    ${result}    ${perScore}    ${totalMinScore}
    [Documentation]    判断返回值maxScore和minScore值的情况
    #判断返回值maxScore和minScore值的情况
    : FOR    ${i}    IN    @{result}
    \    ${minScore}    evaluate    ${totalMinScore} + (${perScore} * (${i['standardScore']} - 1))
    \    ${maxScore}    evaluate    ${totalMinScore} + (${perScore} * (${i['standardScore']}))
    \    #判断每次数据返回值与基准是否相等
    \    ${status}    Run Keyword And Return Status    should be true    (${minScore} == ${i['minScore']}) and (${maxScore} == ${i['maxScore']})
    \    #如果判断有不相等则返回false
    \    Return From Keyword If    '${status}' == 'False'    false
    Return From Keyword    true

Search Review Category
    [Arguments]    ${id}
    [Documentation]    根据id搜索质检评分数据
    #根据id搜索质检评分数据
    ${j}    Set ReviewSettings    get    ${AdminUser}    ${EMPTY}
    : FOR    ${i}    IN    @{j['entities']}
    \    Return From Keyword If    '${i['id']}' == '${id}'    true
    Return From Keyword If    false

Clear Review Category
    [Documentation]    批量删除包含${preReviewName}的质检评分数据
    #设置质检名称模板
    ${preReviewName}=    convert to string    ${AdminUser.tenantId}
    #获取质检评分
    ${j}    Set ReviewSettings    get    ${AdminUser}    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #循环删除包含${preReviewName}的质检数据
    : FOR    ${i}    IN    @{j['entities']}
    \    ${reviewName}=    convert to string    ${i['name']}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${reviewName}    ${preReviewName}
    \    Run Keyword If    '${status}' == 'True'    Set ReviewSettings    delete    ${AdminUser}    ${EMPTY}
    \    ...    ${i['id']}
    #同步质检评分设置，需要执行，否则质检分布统计数据与真实会不对应
    Get Review ScoreMapping    post    ${AdminUser}
