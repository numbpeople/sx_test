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
    [Documentation]    获取租户下各个状态的申诉记录数
    ${resp}=    /v1/quality/tenants/{tenantId}/appeal-amounts    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    should be equal    ${j['status']}    OK    接口返回值status不正确:${j}
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

Create Conversation And Review
    [Documentation]    提交质检申诉前,先创建会话,进行质检评分
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${dn}=    Convert To Integer    ${day}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${dn}T00%3A00%3A00.000Z
    set to dictionary    ${range}    endDate=${yyyy}-${mm}-${dn}T23%3A59%3A59.000Z
    set to dictionary    ${filter}    groupId=${session.queueId}
    #根据queueId筛选当天质检数据，预期结果是唯一数据
    ${j}=    Search Reviews    ${AdminUser}    ${filter}    ${range}
    run keyword if    ${j} == {}    Fail    根据技能组id(queueId)筛选当天质检数据，没有找到数据
    should be equal    ${j['status']}    OK    接口返回值status不正确:${j}
    should be true    '${j['totalElements']}' == '1'    接口返回数据不唯一:${j}
    should be equal    ${j['entities'][0]['serviceSessionId']}    ${session.sessionServiceId}    质检接口返回值serviceSessionId不正确:${j}
    #获取租户的质检评分项
    ${qualityResults}    Get Qualityitems
    #对该服务进行质检评分,并记录质检id
    ${sessionInfo}    create dictionary    serviceSessionId=${session.sessionServiceId}    stepNum=1
    ${j}=    Quality Review    ${sessionInfo}    ${qualityResults}
    should be equal    ${j["status"]}    OK    质检评分不正确:${j}
    ${reviewId}    set variable    ${j["entity"]["id"]}
    set global variable    ${reviewId}    ${reviewId}
    #记录各状态下申诉记录条数
    ${j}=    Get Appeal Amounts
    ${total}    set variable    ${j["entity"]["Total"]}
    ${wait}    set variable    ${j["entity"]["Wait"]}
    ${processing}    set variable    ${j["entity"]["Processing"]}
    ${terminal}    set variable    ${j["entity"]["Terminal"]}
    ${amounts}    create dictionary    total=${total}    wait=${wait}    processing=${processing}    terminal=${terminal}
    return from keyword    ${amounts}

Change Appeal Status
    [Arguments]    ${id}    ${data}
    [Documentation]    修改申诉状态
    ${resp}=    /v1/quality/tenants/{tenantId}/appeals/{id}    ${AdminUser}    ${timeout}    ${id}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Get Appeal Operations
    [Arguments]    ${id}
    [Documentation]    获取申诉的状态变更记录
    ${resp}=    /v1/quality/tenants/{tenantId}/appeals/{id}/operations    ${AdminUser}    ${timeout}    ${id}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}

Set Appeal Comment
    [Arguments]    ${method}    ${id}    ${data}=
    [Documentation]    新增/获取 申诉评论
    ${resp}=    /v1/quality/tenants/{tenantId}/appeals/{id}/comments    ${AdminUser}    ${timeout}    ${method}    ${id}    ${data}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    return from keyword    ${j}
