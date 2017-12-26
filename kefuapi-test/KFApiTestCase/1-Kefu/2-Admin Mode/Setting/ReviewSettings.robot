*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Setting/ReviewSettings_Common.robot

*** Test Cases ***
获取质检评分设置(/v1/tenants/{tenantId}/qualityreviews/qualityitems)
    #获取质检评分设置
    ${j}    Set ReviewSettings    get    ${AdminUser}    ${EMPTY}
    ${length}    get length    ${j['entities']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be true    ${length} > 0    默认的数据结果为空 ,${j}

新增质检并获取质检数据(/v1/tenants/{tenantId}/qualityreviews/qualityitems)
    #新增质检并获取质检数据
    ${uuid}    Uuid 4
    ${name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${qualityItems}    create dictionary    description=自动化测试新增测试数据    fullmark=66    name=${name}    opt=+
    ${data}    set variable    {"name":"${qualityItems.name}","fullmark":"${qualityItems.fullmark}","description":"${qualityItems.description}","opt":"${qualityItems.opt}"}
    ${j}    Set ReviewSettings    post    ${AdminUser}    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['description']}    ${qualityItems.description}    返回值中description不正确: ${j}
    should be true    ${${j['entity']['fullmark']}} - ${${qualityItems.fullmark}} == 0    返回值中fullmark不正确: ${j}
    should be equal    ${j['entity']['name']}    ${qualityItems.name}    返回值中name不正确: ${j}
    should be equal    ${j['entity']['opt']}    ${qualityItems.opt}    返回值中opt不正确: ${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId不正确: ${j}
    #根据id搜索质检数据
    ${status}    Search Review Category    ${j['entity']['id']}
    should be true    '${status}' == 'true'    数据未被找到，需要检查该数据，${j}
    #同步质检评分设置
    ${j}    Get Review ScoreMapping    post    ${AdminUser}
    ${length}    get length    ${j['entities']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be true    ${length} == 5    默认质检分数总数不是5个数据 ,${j}

新增质检并删除质检数据(/v1/tenants/{tenantId}/qualityreviews/qualityitems)
    #新增质检并删除质检数据
    ${uuid}    Uuid 4
    ${name}    set variable    ${AdminUser.tenantId}-${uuid}
    ${qualityItems}    create dictionary    description=自动化测试新增测试数据    fullmark=66    name=${name}    opt=+
    ${data}    set variable    {"name":"${qualityItems.name}","fullmark":"${qualityItems.fullmark}","description":"${qualityItems.description}","opt":"${qualityItems.opt}"}
    ${j}    Set ReviewSettings    post    ${AdminUser}    ${data}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['description']}    ${qualityItems.description}    返回值中description不正确: ${j}
    should be true    ${${j['entity']['fullmark']}} - ${${qualityItems.fullmark}} == 0    返回值中fullmark不正确: ${j}
    should be equal    ${j['entity']['name']}    ${qualityItems.name}    返回值中name不正确: ${j}
    should be equal    ${j['entity']['opt']}    ${qualityItems.opt}    返回值中opt不正确: ${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId不正确: ${j}
    #根据id搜索质检数据
    ${j1}    Set ReviewSettings    delete    ${AdminUser}    ${EMPTY}    ${j['entity']['id']}
    should be equal    ${j1['status']}    OK    返回值中status不等于OK: ${j1}
    #同步质检评分设置
    ${j}    Get Review ScoreMapping    post    ${AdminUser}
    ${length}    get length    ${j['entities']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be true    ${length} == 5    默认质检分数总数不是5个数据 ,${j}

获取质检分布统计数据(/v1/tenants/{tenantId}/qualityreviews/scoremapping)
    #获取质检评分设置
    ${j}    Set ReviewSettings    get    ${AdminUser}    ${EMPTY}
    ${length}    get length    ${j['entities']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #获取质检总得分
    ${totalScore}    Get Review TotalScores    ${j['entities']}
    ${totalMinScore}    set variable    ${totalScore.totalMinScore}    #最低得分
    ${totalMaxScore}    set variable    ${totalScore.totalMaxScore}    #最高得分
    #计算分数平均差
    ${perScore}    evaluate    (${totalMinScore} + ${totalMaxScore})/5
    #获取质检评分设置
    ${j}    Get Review ScoreMapping    post    ${AdminUser}
    ${length}    get length    ${j['entities']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be true    ${length} == 5    默认质检分数总数不是5个数据 ,${j}
    #判断接口中maxScore和minScore值
    ${status}    Check PerScores    ${j['entities']}    ${perScore}    -${totalMinScore}
    should be true    '${status}' == 'true'    判断接口中maxScore和minScore不正确, ${j}
