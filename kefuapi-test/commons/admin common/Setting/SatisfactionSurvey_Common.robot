*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Settings/SatisfactionSurveyApi.robot

*** Keywords ***
Get Evaluationdegree
    [Arguments]    ${agent}
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees    ${agent}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}
    
Get EvaluationdegreeIds
    [Arguments]    ${agent}
    [Documentation]    获取评分的id值
    ${j}    Get Evaluationdegree    ${agent}
    #获取评价级别id,并放置到字典中,key为score1、score2、score3、score4、score5
    &{evaluationdegreeDic}    create dictionary
    : FOR    ${i}    IN    @{j['entities']}
    \    set to dictionary    ${evaluationdegreeDic}    score${i['score']}=${i['id']}
    return from keyword    ${evaluationdegreeDic}
    
Save Evaluation Setting
    [Arguments]    ${agent}    ${data}
    [Documentation]    保存评分选项设置
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees/batchupdate    ${agent}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Append Appraisetag List
    [Arguments]    ${appraisetagsNameOne}    ${appraisetagsNameTwo}    ${appraisetagsNameThree}    ${appraisetagsNameFour}    ${appraisetagsNameFive}
    [Documentation]   将五组标签作为列表返回 
    @{appraisetagsList}    create list    ${appraisetagsNameOne}    ${appraisetagsNameTwo}    ${appraisetagsNameThree}    ${appraisetagsNameFour}    ${appraisetagsNameFive}
    @{appraisetagsLists}    create list
    :FOR    ${i}    IN    @{appraisetagsList}
    \    ${appraisetagsNameList}    Appraisetag List    ${i}
    \    Append To List    ${appraisetagsLists}    ${appraisetagsNameList}
    log list    ${appraisetagsLists}
    return from keyword    ${appraisetagsLists}

Appraisetag List
    [Arguments]    ${appraisetagsName}
    [Documentation]    拼接标签的列表结构
    &{appraisetagsDic}    create dictionary
    @{appraisetagsNameList}    create list
    :FOR    ${i}    IN    @{appraisetagsName}
    \    set to dictionary    ${appraisetagsDic}    name=${i}
    \    ${appraisetagsJson}    dumps    ${appraisetagsDic}
    \    Append To List    ${appraisetagsNameList}    ${appraisetagsJson}
    ${appraisetagsNameList}    replace string    '${appraisetagsNameList}'    '    ${EMPTY}
    log    ${appraisetagsNameList}
    return from keyword    ${appraisetagsNameList}

Evaluationdegree Data
    [Arguments]    ${agent}    ${appraisetagsDic}
    [Documentation]    拼接请求体
    #获取评分的id值
    &{evaluationdegreeDic}    Get EvaluationdegreeIds    ${agent}
    log    ${evaluationdegreeDic}
    #创建请求体
    @{dataList}    create list
    &{conditionsDic}    create dictionary
    @{keyList}    Get Dictionary Keys    ${evaluationdegreesName}
    ${keyLength}    get length    ${keyList}
    #将请求体放置到list中
    :FOR    ${i}    IN RANGE    ${keyLength}
    \    ${num}    evaluate    ${i} + 1
    \    ${json}    set variable    {"status":"Enable","name":"${evaluationdegreesName.score${num}}","level":${num},"appraiseTags":${appraisetagsDic.score${num}},"score":${num},"id":${evaluationdegreeDic.score${num}}}
    \    Append To List    ${dataList}    ${json}
    \    log    ${dataList}
    ${dataList}    replace string    '${dataList}'    \\\\    \\
    ${dataList}    replace string    ${dataList}    \\\\    \\
    ${dataList}    replace string    ${dataList}    u'    ${EMPTY}
    ${dataList}    replace string    ${dataList}    '    ${EMPTY}
    return from keyword    ${dataList}
