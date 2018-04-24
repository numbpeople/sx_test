*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot
Resource          ../../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
获取坐席模式的历史会话数据(/v1/Tenant/me/ServiceSessionHistorys)
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #获取坐席模式历史会话数据
    set to dictionary    ${filter}    isAgent=true    visitorName=${session.userName}    #isAgent为true，表示坐席模式查询
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    #断言接口返回字段值
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话不是唯一：${j}
    Should Be Equal    ${j['items'][0]['tenantId']}    ${AdminUser.tenantId}    坐席模式历史会话的租户id不正确：${j}
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${session.sessionServiceId}    坐席模式历史会话的会话id不正确：${j}
    Should Be Equal    ${j['items'][0]['agentUserId']}    ${AdminUser.userId}    坐席模式历史会话的agentUserId不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['userId']}    ${session.userId}    坐席模式历史会话的访客userid不正确：${j}
    Should Be Equal    ${j['items'][0]['visitorUser']['username']}    ${session.userName}    坐席模式历史会话的访客username不正确：${j}
    Should Be Equal    ${j['items'][0]['chatGroupId']}    ${session.chatGroupId}    坐席模式历史会话的访客chatGroupId不正确：${j}
    Should Be Equal    ${j['items'][0]['state']}    Terminal    坐席模式历史会话state不是Terminal：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${session.queueId}    坐席模式历史会话queueId不正确：${j}
    Should Be Equal    ${j['items'][0]['originType'][0]}    ${session.originType}    坐席模式历史会话originType不正确：${j}
    Should Not Be True    ${j['items'][0]['fromAgentCallback']}    坐席模式历史会话fromAgentCallback值不正确：${j}
    Should Not Be True    ${j['items'][0]['transfered']}    坐席模式历史会话transfered值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryDetail']}' == 'None'    坐席模式历史会话enquiryDetail值不正确：${j}
    Should Be True    '${j['items'][0]['enquiryTagNames']}' == 'None'    坐席模式历史会话enquiryTagNames值不正确：${j}
    Should Be Equal    ${j['items'][0]['enquirySummary']}    0    坐席模式历史会话enquirySummary值不正确：${j}

坐席模式下回呼历史会话(/v1/Tenant/me/ServiceSessionHistorys)
    #设置局部变量的字典
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #创建已结束的会话
    ${session}    Create Terminal Conversation
    #坐席回呼刚刚创建并结束的会话
    ${callBackSession}    Agent CallingBack Conversation    ${AdminUser}    ${session.userId}
    Should Be True    "${callBackSession['status']}" == "OK"    回呼会话返回后的status值不对，正常的结果OK：${callBackSession}
    Should Be True    "${callBackSession['entity']['state']}" == "Processing"    回呼会话返回后的接口state值不对，正常的结果为Processing：${callBackSession}
    Should Be True    "${callBackSession['entity']['visitorUser']['userId']}" == "${session.userId}"    回呼会话返回后的接口userId值不对，正常的结果为${session.userId}：${callBackSession}
    #获取进行中会话列表
    &{searchDic}    create dictionary    fieldName=${session.userId}    fieldValue=${session.userId}    fieldConstruction=['user']['userId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['user']['userId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${session.userId}    #该参数为获取接口某字段的预期值
    #获取会话对应的会话
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    回呼会话后，进行中会话不是预期值
    should be equal    ${j[0]['user']['nicename']}    ${session.userName}    获取到的会话昵称不正确, ${j}
    