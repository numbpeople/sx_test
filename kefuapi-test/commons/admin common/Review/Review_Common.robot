*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Review/QualityReviews_Api.robot
Resource          ../Setting/ReviewSettings_Common.robot

*** Keywords ***
Get Reviews
    [Arguments]    ${agent}    ${filter}    ${range}
    [Documentation]    获取质检数据
    #获取质检数据
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/qualityreviews    ${agent}    ${filter}    ${range}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    ${j}    to json    ${resp.text}
    Return From Keyword    ${j}

Search Reviews
    [Arguments]    ${agent}    ${filter}    ${range}
    [Documentation]    获取质检数据
    #获取质检数据
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    Get Reviews    ${agent}    ${filter}    ${range}
    \    Return From Keyword If    ${j['totalElements']} > 0    ${j}
    \    sleep    ${delay}
    Return From Keyword    {}

Get Qualityitems
    [Documentation]    获取租户下的质检评分项数据，包含id及分数
    ${j}    Set ReviewSettings    get    ${AdminUser}    ${EMPTY}
    ${length}    get length    ${j['entities']}
    should be equal    ${j['status']}    OK    质检评分项状态不正确: ${j}
    @{qualityResults}    create list
    ${score}    set variable    0
    : FOR    ${n}    IN RANGE    ${length}
    \    ${id}    evaluate    str(${j["entities"][${n}]["id"]})
    \    ${fullmark}    evaluate    str(${j["entities"][${n}]["fullmark"]})
    \    ${item}    create dictionary    itemId=${id}    score=${fullmark}
    \    ${item}    dumps    ${item}
    \    append to list    ${qualityResults}    ${item}
    \    ${opt}    set variable    ${j["entities"][${n}]["opt"]}
    \    ${score}    evaluate    ${score}${opt}${j["entities"][${n}]["fullmark"]}
    set global variable    ${score}    ${score}
    return from keyword    ${qualityResults}

Get Quality Review
    [Arguments]    ${sessionInfo}    ${data}=
    [Documentation]    获取某条质检记录的详细数据
    ${method}    set variable    get
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview    ${method}    ${AdminUser}    ${timeout}    ${sessionInfo}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Quality Review
    [Arguments]    ${sessionInfo}    ${qualityResults}
    [Documentation]    对质检记录进行质检评分
    ${comment}    set variable    This is a comment of quality review!
    ${data}    set variable    {"agentId":"${AdminUser.userId}", "attachments": [], "comment":"${comment}", "qualityResults": ${qualityResults}}
    ${data}    Replace String    ${data}    '    ${EMPTY}
    ${method}    set variable    post
    ${resp}=    /v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/steps/{stepNum}/qualityreview    ${method}    ${AdminUser}    ${timeout}    ${sessionInfo}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Submmit A Quality Appeal
    [Arguments]    ${agent}    ${range}    ${reviewId}
    [Documentation]    对已评分的质检记录提起申诉
    ${subject}    set variable    This is a subject of appeal
    ${content}    set variable    This is a content of appeal
    ${data}    set variable    {"reviewId":${reviewId}, "subject":"${subject}", "content":"${content}", "attachments":[]}
    ${method}    set variable    post
    ${resp}=    /v1/quality/tenants/{tenantId}/appeals    ${method}    ${agent}    ${range}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Get Appeal Amounts
    [Documentation]    获取租户下各个状态的胜诉记录数
    ${resp}=    /v1/quality/tenants/{tenantId}/appeal-amounts    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Search Appeal
    [Arguments]    ${agent}    ${range}    ${filter}    ${params}
    [Documentation]    筛选申诉记录
    ${method}    set variable    get
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${resp}=    /v1/quality/tenants/{tenantId}/appeals    ${method}    ${agent}    ${range}    ${params}
    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    \    ${j}    to json    ${resp.content}
    \    exit for loop if    ${j['totalElements']}>0
    \    sleep    ${delay}
    return from keyword    ${j}
