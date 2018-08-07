*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Members/AgentQueue_Common.robot
Resource          ../../../../commons/admin common/BaseKeyword.robot
Resource          ../../../../commons/admin common/Setting/Routing_Common.robot
Resource          ../../../../commons/agent common/Customers/Customers_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../../commons/Base Common/Base_Common.robot
Resource          ../../../../commons/admin common/Setting/ConversationTags_Common.robot

*** Test Cases ***
获取访客列表(/v1/Agents/me/Visitors)
    [Documentation]    【操作步骤】：
    ...    - Step1、坐席模式-进行中会话，获取坐席进行中会话接口。
    ...    - Step2、判断/v1/Agents/me/Visitors接口返回值${j[0]['user']['tenantId']}
    ...
    ...    【预期结果】：
    ...    如果坐席进行中会话数不为0，则判断接口第一条数据的tenantId值，等于${AdminUser.tenantId}。
    [Tags]    test1
    #Step1、获取进行中会话列表，并获取会话数
    &{j}    Get Processing Session    ${AdminUser}
    ${text}    set variable    ${j.text}
    ${status}    set variable    ${j.status}
    ${url}    set variable    ${j.url}
    ${length}    get length    ${text}
    #Step2、判断返回接口返回值${text[0]['user']['tenantId']}
    Run Keyword If    ${length} > 0    should be equal    '${text[0]['user']['tenantId']}'    '${AdminUser.tenantId}'    【实际结果】：在操作步骤2时，调用接口：${url}后，判断['user']['tenantId']预期值：${AdminUser.tenantId},实际值为：${text[0]['user']['tenantId']}，接口返回结果：${text}

获取空访客列表(/v1/Agents/me/Visitors)
    [Documentation]    【操作步骤】：
    ...    - Step1、坐席模式-进行中会话，获取坐席进行中会话数。
    ...    - Step2、如果进行中会话数大于50个，则标记为失败，不继续执行，否则关闭所有会话。
    ...    - Step3、查询坐席模式-进行中会话的接口返回值。
    ...
    ...    【预期结果】：
    ...    获取坐席的进行中会话请求地址：/v1/Agents/me/Visitors，请求返回值等于：[]。
    #Step1、获取进行中会话列表，并获取会话数
    &{j}    Get Processing Session    ${AdminUser}
    ${text}    set variable    ${j.text}
    ${status}    set variable    ${j.status}
    ${url}    set variable    ${j.url}
    ${length}    get length    ${text}
    #Step2、如果进行中会话数大于50个，则标记为失败，不继续执行，否则关闭所有会话。
    Run Keyword If    ${length} > 50    Fail    进行中会话超过50个会话，case不允许执行
    #批量结束进行中会话
    Stop Processing Conversations    ${AdminUser}    ${text}
    #Step3、查询坐席模式-进行中会话的会话数结果值。
    &{j1}    Get Processing Session    ${AdminUser}
    ${text1}    set variable    ${j1.text}
    ${status1}    set variable    ${j1.status}
    ${url1}    set variable    ${j1.url}
    #【预期结果】：获取坐席的进行中会话请求地址：/v1/Agents/me/Visitors，请求返回值等于：[]。
    should be true    ${text1} == []    【实际结果】：在操作步骤3时，调用接口：${url1}后，判断返回值预期值：[],实际值为：${text1}，接口返回结果：${text1}

获取进行中会话访客列表最后一条消息(/v1/Agents/me/Visitors)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、访客发送一条消息，例如：789e3f68-0a75-4880-a069-2f01550b1714，该消息作为检查最后一条消息的预期值。
    ...    - Step3、获取接口/v1/Agents/me/Visitors，访客列表检查lastChatMessage下的msg值。
    ...    - Step4、如果获取到的消息不是预期，尝试重试取多次，再对比结果。
    ...
    ...    【预期结果】：
    ...    从接口（/v1/Agents/me/Visitors）获取到访客发送的最后一条消息的值，应该等于789e3f68-0a75-4880-a069-2f01550b1714。
    #Step1、创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #Step2、访客发送一条消息，作为检查最后一条消息的预期值
    ${uuid}    Uuid 4
    set to dictionary    ${sessionInfo.msgEntity}    msg=${uuid}
    Send Message    ${restentity}    ${sessionInfo.guestEntity}    ${sessionInfo.msgEntity}
    #Step3、获取接口/v1/Agents/me/Visitors，访客列表检查lastChatMessage下的msg值。
    &{searchDic}    create dictionary    fieldName=msg    fieldValue=${uuid}    fieldConstruction=['lastChatMessage']['body']['bodies'][0]['msg']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['lastChatMessage']['body']['bodies'][0]['msg']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${uuid}    #该参数为获取接口某字段的预期值
    #Step4、如果获取到的消息不是预期，尝试重试取多次，再对比结果。
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中会话不属于转接后的坐席
    should be equal    ${j[0]['serviceSessionId']}    ${sessionInfo.sessionServiceId}    获取到的会话id不正确, ${j}

获取进行中会话背景颜色标识(/v1/Agents/me/Visitors)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、获取接口/v1/Agents/me/Visitors，如果返回的进行中数据，每个会话id均不是发起的会话，尝试重试取10次。
    ...    - Step3、检查backgroundColorFlag、hasUnReadMessage、isNewSession等的初始值。
    ...
    ...    【预期结果】：
    ...    从接口（/v1/Agents/me/Visitors）获取到访客发送的最后一条消息的值，应该等于789e3f68-0a75-4880-a069-2f01550b1714。
    #Step1、访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    &{searchDic}    create dictionary    fieldName=backgroundColorFlag    fieldValue=${sessionInfo.sessionServiceId}    fieldConstruction=['serviceSessionId']
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${searchDic.fieldName}    ${searchDic.fieldValue}    ${searchDic.fieldConstruction}
    ${expectConstruction}    set variable    [0]['serviceSessionId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${sessionInfo.sessionServiceId}    #该参数为获取接口某字段的预期值
    #Step2、获取接口/v1/Agents/me/Visitors，如果返回的进行中数据，每个会话id均不是发起的会话，尝试重试取10次。
    ${j}    Repeat Keyword Times    Get Processing Conversations With FieldName    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    坐席进行中接口返回结果中，根据会话id搜索不到相应的会话
    #Step3、检查backgroundColorFlag、hasUnReadMessage、isNewSession等的初始值。
    should be true    ${j[0]['backgroundColorFlag']}    获取到的backgroundColorFlag不是true, ${j}
    should be true    ${j[0]['hasUnReadMessage']}    获取到的hasUnReadMessage不是true, ${j}
    should be true    not ${j[0]['isNewSession']}    获取到的isNewSession不是false, ${j}
    should be true    ${j[0]['unReadMessageCount']}>0    获取到的unReadMessageCount不大于0, ${j}
    should be true    '${j[0]['transferedFrom']}' == 'None'    获取到的transferedFrom默认不是None, ${j}

根据会话Id获取official-accounts信息(/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/official-accounts)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、调用接口/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/official-accounts。
    ...    - Step3、检查返回结果中，字段status为OK，type等于SYSTEM。
    ...
    ...    【预期结果】：
    ...    检查返回结果中，字段status为OK，type等于SYSTEM。
    #Step1、访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    #Step2、调用接口/v1/tenants/{tenantId}/servicesessions/{serviceSessionId}/official-accounts。
    ${j}=    Get Official-accounts    ${AdminUser}    ${sessionInfo.sessionServiceId}
    #Step3、检查返回结果中，字段status为OK，type等于SYSTEM。
    should be equal    ${j['status']}    OK    返回值中status值不正确：${j}
    should be equal    ${j['entity']['type']}    SYSTEM    返回值中type值不正确：${j}

获取会话的满意度评价状态(/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、调用接口/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus，接口请求状态码为200。
    ...    - Step3、检查返回结果中，字段status为OK，type等于SYSTEM。
    ...
    ...    【预期结果】：
    ...    检查返回结果中，字段status为OK，type等于SYSTEM。
    #Step1、访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    #Step2、调用接口/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus，接口请求状态码为200。
    ${j}    Get EnquiryStatus    ${AdminUser}    ${sessionInfo.userId}
    #Step3、检查返回结果中，字段status为OK，count等于1。
    Should Be Equal    ${j['status']}    OK    获取接口返回status不是OK: ${j}
    Should Be Equal    '${j['count']}'    '1'    获取接口返回count不是1: ${j}

获取会话的满意度已评价状态(/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、坐席手动发起满意度评价邀请，调用接口：/v6/tenants/{tenantId}/serviceSessions/{serviceSessionId}/inviteEnquiry。
    ...    - Step3、访客输入数字 1 进行会话评价。
    ...    - Step4、调用接口获取满意度评价状态：/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus，接口请求状态码为200，并且接口返回值data数据值为over。
    ...    - Step5、检查返回结果中，字段status为OK，count等于1，data为over。
    ...
    ...    【预期结果】：
    ...    检查返回结果中，字段status为OK，type等于SYSTEM。
    #创建消息体字典，如${MsgEntity}
    ${MsgEntity}    create dictionary    msg=test msg!    type=txt    ext={}
    #Step1、访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    #Step2、坐席手动发起满意度评价邀请，调用接口：/v6/tenants/{tenantId}/serviceSessions/{serviceSessionId}/inviteEnquiry。
    ${j}    Send InviteEnquiry    ${AdminUser}    ${sessionInfo.sessionServiceId}
    Should Be Equal    ${j['status']}    OK    消息内容不正确：${j}
    #设置发送的文本消息为：1
    set to dictionary    ${MsgEntity}    msg=1    # 1代表5星、2代表4星 ......
    #Step3、访客输入数字 1 进行会话评价。
    Send Message    ${restentity}    ${sessionInfo}    ${MsgEntity}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${sessionInfo.sessionServiceId}    #该参数为Get EnquiryStatus接口的参数值
    ${expectConstruction}    set variable    ['data'][0]    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    over    #该参数为获取接口某字段的预期值
    #Step4、调用接口获取满意度评价状态：/tenants/{tenantId}/serviceSessions/{serviceSessionId}/enquiryStatus，接口请求状态码为200，并且接口返回值data数据值为over。
    ${j}    Repeat Keyword Times    Get EnquiryStatus    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中不包含预期的over值
    #Step5、检查返回结果中，字段status为OK，count等于1，data为over。
    Should Be Equal    ${j['status']}    OK    获取接口返回status不是OK: ${j}
    Should Be Equal    '${j['count']}'    '1'    获取接口返回count不是1: ${j}
    Should Be Equal    ${j['data'][0]}    over    获取接口返回data不是over: ${j}

获取会话的会话标签信息(/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、获取会话标签信息，调用接口：/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults，接口请求状态码为200。
    ...    - Step3、检查返回值，为[]。
    ...
    ...    【预期结果】：
    ...    检查返回结果中，字段status为OK，type等于SYSTEM。
    #Step1、访客发起会话，坐席接入到进行中会话。
    ${sessionInfo}    Create Processiong Conversation
    #Step2、获取会话标签信息，调用接口：/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults，接口请求状态码为200
    ${j}    Set ServiceSessionSummaryResults    get    ${AdminUser}    ${sessionInfo.sessionServiceId}
    #Step3、检查返回值，为[]。
    should be equal    '${j}'    '[]'    获取接口返回结果不正确: ${j}

添加会话的会话标签信息(/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults)
    [Documentation]    【操作步骤】：
    ...    - Step1、访客发起新会话，坐席从待接入接入会话到进行中会话列表（创建技能组->调整路由规则顺序->新访客发起消息->待接入搜索会话->手动接入会话->获取坐席的进行中会话）。
    ...    - Step2、添加会话标签信息，调用接口：/v1/Tenants/{tenantId}/ServiceSessions/{serviceSessionId}/ServiceSessionSummaryResults，接口请求状态码为200。
    ...    - Step3、检查返回值，为空。
    ...
    ...    【预期结果】：
    ...    检查返回结果中，请求结果为空。
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #创建参数字典
    &{conversationTagEntity}    create dictionary    systemOnly=false    buildCount=true
    #获取会话标签数据
    ${j}    Get Conversation Tags    get    ${AdminUser}    0    ${conversationTagEntity}
    #获取标签中第一个根节点的叶子标签id值
    ${tagId}    Get Conversation TagId    ${j}
    #判断租户下是否存在会话标签，没有则不执行一下步骤
    run keyword if    ${tagId} == 0    Pass Execution    该租户下没有会话标签，不执行一下case
    #获取添加标签的id
    ${data}    set variable    [${tagId}]
    #获取会话会话标签信息
    ${j}    Set ServiceSessionSummaryResults    post    ${AdminUser}    ${sessionInfo.sessionServiceId}    ${data}
    Should Be True    '${j}' == '${EMPTY}'    获取接口返回结果不正确: ${j}

获取会话的会话备注信息(/tenants/{tenantId}/serviceSessions/{serviceSessionId}/comment)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #获取会话会话备注信息
    ${j}    Set Comment    get    ${AdminUser}    ${sessionInfo.sessionServiceId}    ${EMPTY}
    run keyword if    '${j}' != '${EMPTY}'    Should Be Equal    ${j['serviceSessionId']}    ${sessionInfo.sessionServiceId}    获取接口返回会话id不正确: ${j}

添加会话的会话备注信息(/tenants/{tenantId}/serviceSessions/{serviceSessionId}/comment)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #创建字典和请求体
    ${secs}    Get Time    epoch
    &{commentEntity}    create dictionary    serviceSessionId=${sessionInfo.sessionServiceId}    comment=${AdminUser.tenantId}_${secs}
    ${data}    set variable    {"serviceSessionId":"${commentEntity.serviceSessionId}","comment":"${commentEntity.comment}"}
    #添加会话会话备注信息
    ${j}    Set Comment    post    ${AdminUser}    ${sessionInfo.sessionServiceId}    ${data}
    Should Be Equal    ${j['serviceSessionId']}    ${sessionInfo.sessionServiceId}    获取接口返回会话id不正确: ${j}

获取未读消息数(/v1/Tenants/me/Agents/me/UnReadTags/Count)
    #获取未读消息数
    ${j}    Get UnRead Count    ${AdminUser}
    Should Be True    ${j}>=0    未读消息数不正确,${j}

标记消息为已读(/v1/tenants/{tenantId}/sessions/{serviceSessionId}/messages/read)
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #标记消息为已读
    ${data}    set variable    lastSeqId=0
    ${j}    Read Message    ${AdminUser}    ${sessionInfo.sessionServiceId}    ${data}
    ${state}    Run Keyword And Return Status    Should Be True    '${j}' == 'True' or '${j}' == 'False'
    should be true    ${state}    获取接口返回结果不正确: ${j}

客服转接会话到其他技能组(/v1/ServiceSession/{serviceSessionId}/AgentQueue/{queueId})
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #客服转接会话到其他技能组
    ${j}    Tansfer Conversation To Queue    ${AdminUser}    ${sessionInfo.sessionServiceId}    ${sessionInfo.queueId}
    should be true    ${j}    获取接口返回结果不是True: ${j}

客服转接会话到其他坐席(/v6/tenants/{tenantId}/servicesessions/{serviceSessionId}/transfer)
    [Documentation]    1.创建坐席 2.创建进行中会话 3.转接会话给该坐席 4.当前会话中获取该会话是否属于该坐席
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #将转接预调度关闭掉
    ${data}    set variable    {"value":false}
    ${optionResult}    Set Option Value    ${AdminUser}    put    serviceSessionTransferPreScheduleEnable    ${data}
    Should Be Equal    '${optionResult['status']}'    'OK'    设置转接预调度结果status不为OK：${optionResult}
    #设置创建坐席请求参数
    ${uuid}    Uuid 4
    ${name}    set variable    ${AdminUser.tenantId}${uuid}
    &{agent}=    create dictionary    username=${name}@qq.com    password=lijipeng123    maxServiceSessionCount=10    nicename=${name}    permission=1
    ...    roles=admin,agent
    ${data}=    set variable    {"nicename":"${agent.nicename}","username":"${agent.username}","password":"${agent.password}","confirmPassword":"${agent.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${agent.maxServiceSessionCount}","permission":${agent.permission},"roles":"${agent.roles}"}
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #创建坐席并获取坐席id
    ${agentInfo}    Create Agent    ${AdminUser}    ${agentFilter}    ${data}
    ${userId}    set variable    ${agentInfo['userId']}
    #获取坐席所在技能组
    ${agentInQueueIds}    Get Agent QueueInfo    ${AdminUser}    ${userId}
    ${agentInQueueId}    set variable    ${agentInQueueIds['entities'][0]['queueId']}
    #创建会话并手动接入到进行中会话
    ${sessionInfo}    Create Processiong Conversation
    #创建转接请求体
    ${transferData}    set variable    {"agentUserId":"${userId}","queueId":${agentInQueueId}}
    #客服转接会话到其他技能组
    ${j}    Tansfer Conversation To Agent    ${AdminUser}    ${sessionInfo.sessionServiceId}    ${sessionInfo.queueId}    ${transferData}
    should be true    '${j['status']}' == 'OK'    获取接口返回status不是OK: ${j}
    #设置查询当前会话的参数
    set to dictionary    ${filter}    state=Processing    isAgent=${False}    visitorName=${sessionInfo.userName}
    #创建Repeat Keyword Times的参数list
    @{paramList}    create list    ${AdminUser}    ${filter}    ${range}    #该参数为Get EnquiryStatus接口的参数值
    ${expectConstruction}    set variable    ['items'][0]['agentUserId']    #该参数为接口返回值的应取的字段结构
    ${expectValue}    set variable    ${userId}    #该参数为获取接口某字段的预期值
    #获取会话满意度评价结果
    ${j}    Repeat Keyword Times    Get Current Conversation    ${expectConstruction}    ${expectValue}    @{paramList}
    Run Keyword If    ${j} == {}    Fail    接口返回结果中会话不属于转接后的坐席
    Should Be Equal    ${j['items'][0]['serviceSessionId']}    ${sessionInfo.sessionServiceId}    获取接口会话id不正确: ${j}
    Should Be Equal    ${j['items'][0]['agentUserNiceName']}    ${name}    获取接口返回agentUserNiceName不正确: ${j}

从待接入接起会话查看attribute、track、会话信息、历史消息接口并关闭，查看历史会话、访客中心
    [Documentation]    从待接入接起会话，查看attribute和track信息，查看会话信息和历史消息接口并关闭；
    ...    管理员和坐席模式下的历史会话中均有该会话；管理员和坐席模式下的访客中心中均有该访客
    #初始化参数：消息、渠道信息、客户信息
    set test variable    ${originType}    weixin
    ${curTime}    get time    epoch
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${GuestEntity.userName}
    #根据访客昵称查询待接入列表
    Comment    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${range}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    log    ${a}
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    访客昵称不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${restentity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}
    #查看attribute是否调用成功
    ${j}    Get Attribute    ${AdminUser}    ${GuestEntity.sessionServiceId}
    Should Be Equal    ${j['status']}    OK    获取attribute失败：${j}
    #查看track是否调用成功
    # ${j}    Get Track    ${AdminUser}    ${GuestEntity.sessionServiceId}
    # Should Not Be Empty    ${j['status']}    获取track失败：${j}
    #查询访客会话信息是否正确
    ${j}    Get Single Visitor    ${AdminUser}    ${GuestEntity.userId}
    Should Be Equal    ${j['chatGroupId']}    ${GuestEntity.chatGroupId}    chatGroupId不正确：${j}
    Should Be Equal    ${j['techChannelId']}    ${restentity.channelId}    关联id不正确：${j}
    Should Be Equal    ${j['tenantId']}    ${AdminUser.tenantId}    tenantId不正确：${j}
    Should Be Equal    ${j['nicename']}    ${GuestEntity.userName}    tenantId不正确：${j}
    Should Be Equal    ${j['userId']}    ${GuestEntity.userId}    tenantId不正确：${j}
    #查询访客历史消息是否正确
    set to dictionary    ${MsgFilter}    size=50
    ${j}    Get Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}
    : FOR    ${a}    IN    @{j['messages']}
    \    ${tmsg}=    set variable if    '${a['body']['bodies'][0]['type']}'=='txt'    ${a['body']['bodies'][0]['msg']}    ${empty}
    \    ${diff1}=    replace string    ${tmsg}    \n    ${empty}
    \    ${diff2}=    replace string    ${MsgEntity.msg}    \n    ${empty}
    \    Exit For Loop If    '${diff1}'=='${diff2}'
    Should Be Equal    ${a['body']['bodies'][0]['msg']}    ${MsgEntity.msg}    消息内容不正确：${a}
    Should Be Equal    ${a['body']['bodies'][0]['type']}    ${MsgEntity.type}    消息类型不正确：${a}
    Should Be Equal    ${a['body']['serviceSessionId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    ${a['sessionServiceId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    '${a['tenantId']}'    '${AdminUser.tenantId}'    tenantId不正确：${a}
    Should Be Equal    ${a['body']['visitorUserId']}    ${GuestEntity.userId}    访客id不正确：${a}
    Should Be Equal    ${a['body']['channel_id']}    ${restentity.channelId}    关联id不正确：${a}
    #关闭会话
    Stop Processing Conversation    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}
    #获取管理员模式下客户中心
    set to dictionary    ${filter}    page=0
    ${j}    Get Admin Customers    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['numberOfElements']} ==1    访客中心人数不正确：${j}
    #获取坐席模式下客户中心
    ${j}    Get Agent Customers    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['numberOfElements']} ==1    访客中心人数不正确：${j}
    set to dictionary    ${filter}    page=1
    #6.管理员模式下查询该访客的历史会话
    set to dictionary    ${filter}    isAgent=false
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话未查到该会话：${j}
    #7.坐席模式下查询该访客的会话
    set to dictionary    ${filter}    isAgent=true
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话：${j}
    #以下为统计相关的代码注释掉
    #以下为统计相关的代码注释掉
    #查询今日会话数，今日消息数，今日坐席消息数
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${todayNewsession}    Convert To Integer    ${resp.content}
    Comment    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${todayMsgCount}=    Convert To Integer    ${resp.content}
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${j}    to json    ${resp.content}
    Comment    :FOR    ${i}    IN    @{j}
    Comment    \    Exit For Loop If    '${i['agentNiceName']}'=='${AdminUser.nicename}'
    Comment    ${todayAgentSession}=    Convert To Integer    ${i['count']}
    #查询今日会话数，今日消息数，今日客服新进会话数
    Comment    :FOR    ${i}    IN RANGE    ${retryTimes}
    Comment    \    ${resp}=    /v1/Tenant/me/ChatMessage/Statistics/TodayTotalMessageCount    ${AdminUser}    ${timeout}
    Comment    \    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    \    Exit For Loop If    ${resp.content} >${todayMsgCount}
    Comment    \    sleep    ${delay}
    Comment    Should Be True    ${resp.content} >${todayMsgCount}    今日消息不正确：测试前消息数(${resp.content})，测试后消息数(${todayMsgCount})
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/ToDayNewServiceSessionCount    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    Should Be True    ${resp.content} ==${todayNewsession}+1    今日新进会话数不正确：测试会话数(${resp.content})，测试后会话数(${todayNewsession})
    Comment    ${resp}=    /v1/Tenant/me/ServiceSession/Statistics/CurrentDayServiceSessionCountGroupByAgent    ${AdminUser}    ${timeout}
    Comment    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    Comment    ${j}    to json    ${resp.content}
    Comment    :FOR    ${i}    IN    @{j}
    Comment    \    Exit For Loop If    '${i['agentNiceName']}'=='${AdminUser.nicename}'
    Comment    Should Be True    ${i['count']}==${todayAgentSession}+1    今日客服新进会话数不正确：${i['count']}==${todayAgentSession}+1

从待接入接起会话，接收访客消息并回复后关闭
    #初始化参数：消息、渠道信息、客户信息
    set test variable    ${originType}    weixin
    ${curTime}    get time    epoch
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${GuestEntity.userName}
    set to dictionary    ${range}    beginDate=${empty}    endDate=${empty}
    #根据访客昵称查询待接入列表
    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${range}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${j}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${j}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${j}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    log    ${a}
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    访客昵称不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${restentity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}
    #查询访客历史消息是否正确
    set to dictionary    ${MsgFilter}    size=50
    ${j}    Get Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}
    : FOR    ${a}    IN    @{j['messages']}
    \    ${tmsg}=    set variable if    '${a['body']['bodies'][0]['type']}'=='txt'    ${a['body']['bodies'][0]['msg']}    ${empty}
    \    ${diff1}=    replace string    ${tmsg}    \n    ${empty}
    \    ${diff2}=    replace string    ${MsgEntity.msg}    \n    ${empty}
    \    Exit For Loop If    '${diff1}'=='${diff2}'
    Should Be Equal    ${a['body']['bodies'][0]['msg']}    ${MsgEntity.msg}    消息内容不正确：${a}
    Should Be Equal    ${a['body']['bodies'][0]['type']}    ${MsgEntity.type}    消息类型不正确：${a}
    Should Be Equal    ${a['body']['serviceSessionId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    ${a['sessionServiceId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    '${a['tenantId']}'    '${AdminUser.tenantId}'    tenantId不正确：${a}
    Should Be Equal    ${a['body']['visitorUserId']}    ${GuestEntity.userId}    访客id不正确：${a}
    Should Be Equal    ${a['body']['channel_id']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    startSessionTimestamp=${j['startSessionTimestamp']}    sessionServiceSeqId=${a['sessionServiceSeqId']}
    #坐席发送消息
    ${curTime}    get time    epoch
    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    ${j}    Agent Send Message    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}    ${AgentMsgEntity}
    Should Be Equal    '${j['fromUser']['bizId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['tenantId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['nicename']}'    '${AdminUser.nicename}'    坐席nicename信息不正确：${j}
    Should Be Equal    '${j['fromUser']['username']}'    '${AdminUser.username}'    坐席username信息不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['msg']}'    '${AgentMsgEntity.msg}'    消息内容不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['type']}'    '${AgentMsgEntity.type}'    消息类型不正确：${j}
    #8.关闭会话
    ${j}    Stop Processing Conversation    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    ${rs}=    Should Be Not Contain In JsonList    ['user']['nicename']    ${GuestEntity.userName}    @{j}
    Should Be True    ${rs}    会话关闭失败

从待接入接起会话，发送满意度评价，关闭会话后，历史会话中查询满意度评价信息
    #初始化参数：消息、渠道信息、客户信息
    set test variable    ${originType}    weixin
    ${curTime}    get time    epoch
    #创建技能组
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${GuestEntity.userName}
    set to dictionary    ${range}    beginDate=${empty}    endDate=${empty}
    #根据访客昵称查询待接入列表
    set to dictionary    ${filter}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${filter}    ${range}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    Should Not Be True    ${j['items'][0]['vip']}    非vip用户显示为vip：${resp.content}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    : FOR    ${a}    IN    @{j}
    \    Exit For Loop If    '${a['user']['nicename']}'=='${GuestEntity.userName}'
    log    ${a}
    Should Be Equal    ${a['user']['nicename']}    ${GuestEntity.userName}    访客昵称不正确：${a}
    Should Be Equal    ${a['techChannelName']}    ${restentity.channelName}    关联信息不正确：${a}
    Should Be Equal    ${a['techChannelId']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    userId=${a['user']['userId']}    chatGroupId=${a['chatGroupId']}    sessionServiceId=${a['serviceSessionId']}    chatGroupSeqId=${a['lastChatMessage']['chatGroupSeqId']}
    #查询访客历史消息是否正确
    set to dictionary    ${MsgFilter}    size=50
    ${j}    Get Messages    ${AdminUser}    ${GuestEntity.chatGroupId}    ${MsgFilter}
    : FOR    ${a}    IN    @{j['messages']}
    \    ${tmsg}=    set variable if    '${a['body']['bodies'][0]['type']}'=='txt'    ${a['body']['bodies'][0]['msg']}    ${empty}
    \    ${diff1}=    replace string    ${tmsg}    \n    ${empty}
    \    ${diff2}=    replace string    ${MsgEntity.msg}    \n    ${empty}
    \    Exit For Loop If    '${diff1}'=='${diff2}'
    Should Be Equal    ${a['body']['bodies'][0]['msg']}    ${MsgEntity.msg}    消息内容不正确：${a}
    Should Be Equal    ${a['body']['bodies'][0]['type']}    ${MsgEntity.type}    消息类型不正确：${a}
    Should Be Equal    ${a['body']['serviceSessionId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    ${a['sessionServiceId']}    ${GuestEntity.sessionServiceId}    会话id不正确：${a}
    Should Be Equal    '${a['tenantId']}'    '${AdminUser.tenantId}'    tenantId不正确：${a}
    Should Be Equal    ${a['body']['visitorUserId']}    ${GuestEntity.userId}    访客id不正确：${a}
    Should Be Equal    ${a['body']['channel_id']}    ${restentity.channelId}    关联id不正确：${a}
    set to dictionary    ${GuestEntity}    startSessionTimestamp=${j['startSessionTimestamp']}    sessionServiceSeqId=${a['sessionServiceSeqId']}
    #坐席发送消息
    ${curTime}    get time    epoch
    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    ${j}    Agent Send Message    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}    ${AgentMsgEntity}
    Should Be Equal    '${j['fromUser']['bizId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['tenantId']}'    '${AdminUser.tenantId}'    坐席tenantId信息不正确：${j}
    Should Be Equal    '${j['fromUser']['nicename']}'    '${AdminUser.nicename}'    坐席nicename信息不正确：${j}
    Should Be Equal    '${j['fromUser']['username']}'    '${AdminUser.username}'    坐席username信息不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['msg']}'    '${AgentMsgEntity.msg}'    消息内容不正确：${j}
    Should Be Equal    '${j['body']['bodies'][0]['type']}'    '${AgentMsgEntity.type}'    消息类型不正确：${j}
    #发送满意度评价
    ${j}    Send InviteEnquiry    ${AdminUser}    ${GuestEntity.sessionServiceId}
    Should Be Equal    ${j['status']}    OK    消息内容不正确：${j}
    #关闭会话
    ${j}    Stop Processing Conversation    ${AdminUser}    ${GuestEntity.userId}    ${GuestEntity.sessionServiceId}
    #查询进行中会话是否有该访客
    ${j}    Get Processing Conversation    ${AdminUser}
    ${rs}=    Should Be Not Contain In JsonList    ['user']['nicename']    ${GuestEntity.userName}    @{j}
    Should Be True    ${rs}    会话关闭失败
    #访客评价会话
    set to dictionary    ${MsgEntity}    msg=1    # 1代表5星、2代表4星 ......
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #坐席模式下查询该访客的会话
    set to dictionary    ${filter}    isAgent=true
    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    Should Be True    ${j['total_entries']} ==1    坐席模式历史会话查询到该会话：${j}
    #管理员模式下查询该访客的历史会话
    set to dictionary    ${filter}    isAgent=false
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    Get History    ${AdminUser}    ${filter}    ${range}
    \    Exit For Loop If    (${j['items'][0]['enquirySummary']} > 0) & (${j['total_entries']} == 1)
    \    sleep    ${delay}
    Should Be True    ${j['total_entries']} ==1    管理员模式历史会话未查到该会话：${j}
    Should Be True    ${j['items'][0]['enquirySummary']} == 5    管理员模式历史会话下会话满意度评价不正确：${j}
