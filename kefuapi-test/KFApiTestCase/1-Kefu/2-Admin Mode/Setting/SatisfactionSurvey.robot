*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/SatisfactionSurveyApi.robot
Resource          ../../../../commons/admin common/Setting/SatisfactionSurvey_Common.robot

*** Test Cases ***
获取满意度评价级别(/v1/tenants/{tenantId}/evaluationdegrees)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取满意度评价级别，调用接口：/v1/tenants/{tenantId}/evaluationdegrees，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #获取评价级别
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #获取评价级别id
    log    ${j['entities'][0]['id']}
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    Append To List    ${r1}    ${r2}
    \    ${level}=    Convert To String    ${j['entities'][${i}]['level']}
    set global variable    ${degreeId}    ${r1}
    set global variable    ${evaluationdegreeId}    ${degreeId[0]}

获取租户满意度评价标签(/v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户满意度评价标签，调用接口：/v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    set global variable    ${evaluationdegreeId}    ${degreeId}
    ${resp}=    /v1/tenants/{tenantId}/evaluationdegrees/{evaluationdegreeId}/appraisetags    ${AdminUser}    ${timeout}    ${evaluationdegreeId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    ${r1}    create list
    ${listlength}=    Get Length    ${j['entities']}
    log    ${listlength}
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${r2}=    Convert To String    ${j['entities'][${i}]['id']}
    \    ${name}=    Convert To String    ${j['entities'][${i}]['name']}

保存评分选项设置(/v1/tenants/{tenantId}/evaluationdegrees/batchupdate)
    [Documentation]    【操作步骤】：
    ...    - Step1、保存评分选项设置，调用接口：/v1/tenants/{tenantId}/evaluationdegrees/batchupdate，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200、status字段值等于OK、返回值数据总长度等于5。
    @{appraisetagsNameOne}    create list    非常不满意标签
    @{appraisetagsNameTwo}    create list    不满意标签
    @{appraisetagsNameThree}    create list    一般标签
    @{appraisetagsNameFour}    create list    满意标签
    @{appraisetagsNameFive}    create list    非常满意标签
    #将五组标签作为列表返回
    @{appraisetagsNameLists}    Append Appraisetag List    ${appraisetagsNameOne}    ${appraisetagsNameTwo}    ${appraisetagsNameThree}    ${appraisetagsNameFour}    ${appraisetagsNameFive}
    #将五组标签放入到字典中
    &{appraisetagsDic}    create dictionary
    set to dictionary    ${appraisetagsDic}    score1=${appraisetagsNameLists[0]}    score2=${appraisetagsNameLists[1]}    score3=${appraisetagsNameLists[2]}    score4=${appraisetagsNameLists[3]}    score5=${appraisetagsNameLists[4]}
    #构造请求体
    ${data}    Evaluationdegree Data    ${AdminUser}    ${appraisetagsDic}
    #保存评分选项设置
    ${j}    Save Evaluation Setting    ${AdminUser}    ${data}
    ${length}    get length    ${j['entities']}
    should be equal    ${j['status']}    OK    返回结果中status不是OK,${j}
    should be equal    ${length}    ${5}    返回结果中应该有五组数据,${j}

