*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Review/Review_Common.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot

*** Test Cases ***
对已质检评分的会话提起申诉(/v1/quality/tenants/{tenantId}/appeals)
    [Tags]
    [Setup]
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建会话并进行质检评分
    ${amounts}=    Create Conversation And Review
    #对质检记录提起申诉
    ${j}=    Submmit A Quality Appeal    ${AdminUser}    ${range}    ${reviewId}
    should be equal    ${j["status"]}    OK    质检提起申诉不正确:${j}
    should be equal    ${j["entity"]["status"]}    Wait    质检提起申诉不正确:${j["entity"]["status"]}
    ${appealNumber}    set variable    ${j["entity"]["appealNumber"]}
    ${id}    set variable    ${j["entity"]["id"]}
    #    set to dictionary    ${filter}    creatorId=${j["entity"]["creatorId"]}
    #根据申诉单号搜索申诉列表检查是否有记录
    set to dictionary    ${filter}    page=0    appealNumber=${appealNumber}
    #    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&timeBegin=${range.beginDate}&timeEnd=${range.endDate}&creatorId=${filter.creatorId}&appealNumber=${filter.appealNumber}
    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&appealNumber=${filter.appealNumber}
    ${j}=    Search Appeal    ${AdminUser}    ${range}    ${filter}    ${params}
    should be equal    ${j["status"]}    OK    质检申诉状态不正确:${j}
    #验证申诉记录是否与预期一致
    ${subject}    set variable    This is a subject of appeal
    ${content}    set variable    This is a content of appeal
    should be true    ${j["totalElements"]}==1    接口返回数据不唯一:${j}
    should be equal    ${j['entities'][0]['appealNumber']}    ${appealNumber}    接口返回值appealNumber不正确:${j['entities'][0]['appealNumber']}
    should be equal    ${j['entities'][0]['content']}    ${content}    接口返回值content不正确:${j['entities'][0]['content']}
    should be equal    ${j['entities'][0]['subject']}    ${subject}    接口返回值subject不正确:${j['entities'][0]['subject']}
    should be equal    ${j['entities'][0]['creatorId']}    ${AdminUser.userId}    接口返回值creatorId不正确:${j['entities'][0]['creatorId']}
    should be equal    ${j['entities'][0]['id']}    ${id}    接口返回值id不正确:${j['entities'][0]['id']}
    should be equal    ${j['entities'][0]['reviewId']}    ${reviewId}    接口返回值reviewId不正确:${j['entities'][0]['reviewId']}
    should be equal    ${j['entities'][0]['status']}    Wait    接口返回值status不正确:${j['entities'][0]['status']}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    接口返回值tenantId不正确:${j['entities'][0]['tenantId']}

验证管理员的申诉记录数(/v1/quality/tenants/{tenantId}/appeal-amounts)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建会话并进行质检评分
    ${amounts}=    Create Conversation And Review
    #对质检记录提起申诉
    ${j}=    Submmit A Quality Appeal    ${AdminUser}    ${range}    ${reviewId}
    should be equal    ${j["status"]}    OK    质检提起申诉不正确:${j}
    should be equal    ${j["entity"]["status"]}    Wait    质检提起申诉不正确:${j["entity"]["status"]}
    ${appealNumber}    set variable    ${j["entity"]["appealNumber"]}
    ${id}    set variable    ${j["entity"]["id"]}
    #根据申诉单号搜索申诉列表检查是否有记录
    set to dictionary    ${filter}    page=0    appealNumber=${appealNumber}
    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&appealNumber=${filter.appealNumber}
    ${j}=    Search Appeal    ${AdminUser}    ${range}    ${filter}    ${params}
    should be equal    ${j["status"]}    OK    质检申诉状态不正确:${j}
    #在新增了一条质检申诉后,验证各状态下的申诉记录数是否与预期一致
    ${total}=    evaluate    ${amounts.total}+1
    ${wait}=    evaluate    ${amounts.wait}+1
    ${processing}    set variable    ${amounts.processing}
    ${terminal}    set variable    ${amounts.terminal}
    ${j}=    Get Appeal Amounts
    should be true    ${j["entity"]["Total"]}==${total}    质检申诉tatal状态数不正确:${j}
    should be true    ${j["entity"]["Wait"]}==${wait}    质检申诉wait状态数不正确:${j}
    should be true    ${j["entity"]["Processing"]}==${processing}    质检申诉processing状态数不正确:${j}
    should be true    ${j["entity"]["Terminal"]}==${terminal}    质检申诉terminal状态数不正确:${j}
    #修改申诉记录的状态为Processing
    ${appealStatus}    set variable    Processing
    ${data}    set variable    {"status":"${appealStatus}"}
    ${j}=    Change Appeal Status    ${id}    ${data}
    should be equal    ${j["status"]}    OK    质检申诉修改状态不正确:${j}
    should be true    ${j["entity"]["appealNumber"]}==${appealNumber}    质检申诉修改状态返回值appealNumber不正确:${j}
    should be true    ${j["entity"]["id"]}==${id}    质检申诉修改状态返回值id不正确:${j}
    should be equal    ${j["entity"]["status"]}    ${appealStatus}    质检申诉修改状态返回值status不正确:${j}
    #再次验证各状态下的申诉记录数是否与预期一致
    ${wait}=    evaluate    ${wait}-1
    ${processing}=    evaluate    ${processing}+1
    ${j}=    Get Appeal Amounts
    should be true    ${j["entity"]["Total"]}==${total}    质检申诉tatal状态数不正确:${j}
    should be true    ${j["entity"]["Wait"]}==${wait}    质检申诉wait状态数不正确:${j}
    should be true    ${j["entity"]["Processing"]}==${processing}    质检申诉processing状态数不正确:${j}
    should be true    ${j["entity"]["Terminal"]}==${terminal}    质检申诉terminal状态数不正确:${j}
    #修改申诉记录的状态为Terminal
    ${appealStatus}    set variable    Terminal
    ${data}    set variable    {"status":"${appealStatus}"}
    ${j}=    Change Appeal Status    ${id}    ${data}
    should be equal    ${j["status"]}    OK    质检申诉修改状态不正确:${j}
    should be true    ${j["entity"]["appealNumber"]}==${appealNumber}    质检申诉修改状态返回值appealNumber不正确:${j}
    should be true    ${j["entity"]["id"]}==${id}    质检申诉修改状态返回值id不正确:${j}
    should be equal    ${j["entity"]["status"]}    ${appealStatus}    质检申诉修改状态返回值status不正确:${j}
    #再次验证各状态下的申诉记录数是否与预期一致
    ${processing}=    evaluate    ${processing}-1
    ${terminal}=    evaluate    ${terminal}+1
    ${j}=    Get Appeal Amounts
    should be true    ${j["entity"]["Total"]}==${total}    质检申诉tatal状态数不正确:${j}
    should be true    ${j["entity"]["Wait"]}==${wait}    质检申诉wait状态数不正确:${j}
    should be true    ${j["entity"]["Processing"]}==${processing}    质检申诉processing状态数不正确:${j}
    should be true    ${j["entity"]["Terminal"]}==${terminal}    质检申诉terminal状态数不正确:${j}

验证申诉的状态变更记录(/v1/quality/tenants/{tenantId}/appeals/{id}/operations)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建会话并进行质检评分
    ${amounts}=    Create Conversation And Review
    #对质检记录提起申诉
    ${j}=    Submmit A Quality Appeal    ${AdminUser}    ${range}    ${reviewId}
    should be equal    ${j["status"]}    OK    质检提起申诉不正确:${j}
    should be equal    ${j["entity"]["status"]}    Wait    质检提起申诉不正确:${j["entity"]["status"]}
    ${appealNumber}    set variable    ${j["entity"]["appealNumber"]}
    ${id}    set variable    ${j["entity"]["id"]}
    #根据申诉单号搜索申诉列表检查是否有记录
    set to dictionary    ${filter}    page=0    appealNumber=${appealNumber}
    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&appealNumber=${filter.appealNumber}
    ${j}=    Search Appeal    ${AdminUser}    ${range}    ${filter}    ${params}
    should be equal    ${j["status"]}    OK    质检申诉状态不正确:${j}
    #修改申诉记录的状态为Processing
    ${appealStatus}    set variable    Processing
    ${data}    set variable    {"status":"${appealStatus}"}
    ${j}=    Change Appeal Status    ${id}    ${data}
    should be equal    ${j["status"]}    OK    质检申诉修改状态不正确:${j}
    #修改申诉记录的状态为Terminal
    ${appealStatus}    set variable    Terminal
    ${data}    set variable    {"status":"${appealStatus}"}
    ${j}=    Change Appeal Status    ${id}    ${data}
    should be equal    ${j["status"]}    OK    质检申诉修改状态不正确:${j}
    #验证申诉的状态变更记录是否与预期一致
    ${j}=    Get Appeal Operations    ${id}
    should be equal    ${j["status"]}    OK    质检申诉状态变更记录不正确:${j}
    should be true    ${j["totalElements"]}==3    质检申诉状态变更记录不正确:${j["totalElements"]}
    should be true    ${j["entities"][0]["appealId"]}==${id}    质检申诉状态变更记录appealId不正确:${j["entities"][0]["appealId"]}
    should be equal    ${j["entities"][0]["optType"]}    Create    质检申诉状态变更记录optType不正确:${j["entities"][0]["optType"]}
    should be equal    ${j["entities"][0]["optProperties"]["status"]}    Wait    质检申诉状态变更记录status不正确:${j["entities"][0]["optProperties"]["status"]}
    should be true    ${j["entities"][1]["appealId"]}==${id}    质检申诉状态变更记录appealId不正确:${j["entities"][1]["appealId"]}
    should be equal    ${j["entities"][1]["optType"]}    Update    质检申诉状态变更记录optType不正确:${j["entities"][1]["optType"]}
    should be equal    ${j["entities"][1]["optProperties"]["status"][0]}    Wait    质检申诉状态变更记录status不正确:${j["entities"][1]["optProperties"]["status"]}
    should be equal    ${j["entities"][1]["optProperties"]["status"][1]}    Processing    质检申诉状态变更记录status不正确:${j["entities"][1]["optProperties"]["status"]}
    should be true    ${j["entities"][2]["appealId"]}==${id}    质检申诉状态变更记录appealId不正确:${j["entities"][2]["appealId"]}
    should be equal    ${j["entities"][2]["optType"]}    Update    质检申诉状态变更记录optType不正确:${j["entities"][2]["optType"]}
    should be equal    ${j["entities"][2]["optProperties"]["status"][0]}    Processing    质检申诉状态变更记录status不正确:${j["entities"][2]["optProperties"]["status"]}
    should be equal    ${j["entities"][2]["optProperties"]["status"][1]}    Terminal    质检申诉状态变更记录status不正确:${j["entities"][2]["optProperties"]["status"]}

申诉记录中添加评论(/v1/quality/tenants/{tenantId}/appeals/{id}/comments)
    #设置局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建会话并进行质检评分
    ${amounts}=    Create Conversation And Review
    #对质检记录提起申诉
    ${j}=    Submmit A Quality Appeal    ${AdminUser}    ${range}    ${reviewId}
    should be equal    ${j["status"]}    OK    质检提起申诉不正确:${j}
    should be equal    ${j["entity"]["status"]}    Wait    质检提起申诉不正确:${j["entity"]["status"]}
    ${appealNumber}    set variable    ${j["entity"]["appealNumber"]}
    ${id}    set variable    ${j["entity"]["id"]}
    #根据申诉单号搜索申诉列表检查是否有记录
    set to dictionary    ${filter}    page=0    appealNumber=${appealNumber}
    ${params}=    set variable    page=${filter.page}&size=${filter.per_page}&appealNumber=${filter.appealNumber}
    ${j}=    Search Appeal    ${AdminUser}    ${range}    ${filter}    ${params}
    should be equal    ${j["status"]}    OK    质检申诉状态不正确:${j}
    #在申诉记录中添加评论
    ${comment}    set variable    This is a comment of appeal
    ${data}    set variable    {"attachments":[], "content":"${comment}", "entities":[], "first":"true", "last":"last", "number":0, "numberOfElements":0, "size":2000, "status":"OK", "totalElements":0, "tatalPages":0}
    ${j}=    Set Appeal Comment    post    ${id}    ${data}
    should be equal    ${j["status"]}    OK    申诉评论状态不正确:${j}
    should be equal    ${j["entity"]["appealId"]}    ${id}    申诉评论appealId不正确:${j}
    ${commentId}    set variable    ${j["entity"]["id"]}
    #获取申诉记录的评论
    ${j}=    Set Appeal Comment    get    ${id}
    should be equal    ${j["status"]}    OK    申诉评论状态不正确:${j}
    should be equal    ${j["entities"][0]["appealId"]}    ${id}    申诉评论appealId不正确:${j}
    should be equal    ${j["entities"][0]["content"]}    ${comment}    申诉评论content不正确:${j}
    should be equal    ${j["entities"][0]["id"]}    ${commentId}    申诉评论commentId不正确:${j}
