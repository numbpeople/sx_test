*** Settings ***
Force Tags        tool
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../AgentRes.robot
Resource          ../api/KefuApi.robot
Resource          ../commons/admin common/BaseKeyword.robot
Library           uuid
Resource          ../api/RoutingApi.robot
Resource          ../commons/admin common/admin_common.robot
Resource          ../commons/agent common/agent_common.robot
Library           OperatingSystem
Resource          ../api/IMApi.robot
Resource          ../commons/IM_Common/IM Common.robot
Library           ../lib/ReadFile.py
Resource          Tools-Resource.robot
Library           ExcelLibrary

*** Variables ***
${datadir}        ${CURDIR}${/}${/}resource

*** Test Cases ***
批量删除技能组
    #设置技能组名称模板
    ${preQueuename}=    convert to string    ${AdminUser.tenantId}
    #获取所有技能组列表
    ${queuelist}=    Get Agentqueue    #返回字典
    ${queueNameList}=    Get Dictionary Keys    ${queuelist}
    ${listlength}=    Get Length    ${queueNameList}
    log    ${queuelist}
    #循环判断技能组名称是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${queueName}=    convert to string    ${queueNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${queueName}    ${preQueuename}
    \    ${queueIdValue}=    Get From Dictionary    ${queuelist}    ${queueNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Agentqueue    ${queueIdValue}

批量删除坐席
    #设置客服账号名称模板
    ${preUsername}=    convert to string    ${AdminUser.tenantId}
    #获取所有客服列表
    ${agentlist}=    Get Agents    #返回字典
    ${userNameList}=    Get Dictionary Keys    ${agentlist}
    ${listlength}=    Get Length    ${userNameList}
    log    ${agentlist}
    #循环判断技能组名称是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${username}=    convert to string    ${userNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${username}    ${preUsername}
    \    ${userIdValue}=    Get From Dictionary    ${agentlist}    ${userNameList[${i}]}
    \    Run Keyword If    '${status}' == 'True'    Delete Agent    ${userIdValue}

批量删除关联
    #设置关联对比模板
    ${preChannelname}=    convert to string    ${AdminUser.tenantId}
    #获取所有关联列表
    ${channellist}=    Get Channels    #返回字典
    ${channelNameList}=    Get Dictionary Keys    ${channellist}
    ${listlength}=    Get Length    ${channelNameList}
    log    ${channellist}
    #循环判断返回值中是否包含模板信息，是则删除，不是则跳过
    : FOR    ${i}    IN RANGE    ${listlength}
    \    ${channelname}=    convert to string    ${channelNameList[${i}]}
    \    ${status}=    Run Keyword And Return Status    Should Contain    ${channelname}    ${preChannelname}
    \    ${channelIdValue}=    Get From Dictionary    ${channellist}    ${channelNameList[${i}]}
    \    Run Keyword If    ${status}    Close Conversations By ChannelId    ${channelIdValue}
    \    Run Keyword If    ${status}    Delete Channel    ${channelIdValue}

批量创建待接入
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    Comment    set to dictionary    ${restentity}    serviceEaseMobIMNumber=kefuchannelimid_951630    orgName=1100170223012838    appName=kefuchannelapp27800
    Comment    set to dictionary    ${restentity}    serviceEaseMobIMNumber=shenliang    orgName=shenliang    appName=sldemo    token=YWMt6R0TrEH1EeeTJWs4ubcFKQAAAAAAAAAAAAAAAAAAAAEk52BQF04R5pRlM4iZaoFAAgMAAAFcRBd9owBPGgBKcyU2NQ5_Xp_s6Q_uICN_PJPT0g-ZNH-eGKPrQunlNQ
    : FOR    ${i}    IN RANGE    10000
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}-${curTime}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms

批量创建会话、接入
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    Comment    set to dictionary    ${restentity}    serviceEaseMobIMNumber=kefuchannelimid_951630    orgName=1100170223012838    appName=kefuchannelapp27800
    : FOR    ${i}    IN RANGE    191
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}-${curTime}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${AdminUser}    ${i['userWaitQueueId']}
    \    sleep    50ms

批量创建会话、接入并关闭
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    : FOR    ${i}    IN RANGE    1
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}-${curTime}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${AdminUser}    ${i['userWaitQueueId']}
    \    sleep    50ms
    sleep    1s
    #关闭进行中会话
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${AdminUser}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms

批量创建会话、接入并回复消息
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    Comment    set to dictionary    ${restentity}    serviceEaseMobIMNumber=kefuchannelimid_951630    orgName=1100170223012838    appName=kefuchannelapp27800
    : FOR    ${i}    IN RANGE    1
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}-${curTime}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${AdminUser}    ${i['userWaitQueueId']}
    \    sleep    50ms
    #坐席回复消息
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    ${curTime}    get time    epoch
    \    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    \    Agent Send Message    ${AdminUser}    ${i['user']['userId']}    ${i['serviceSessionId']}    ${AgentMsgEntity}
    \    sleep    50ms

批量创建会话、接入、回复消息并关闭
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    Comment    set to dictionary    ${restentity}    serviceEaseMobIMNumber=kefuchannelimid_951630    orgName=1100170223012838    appName=kefuchannelapp27800
    : FOR    ${i}    IN RANGE    1
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}-${curTime}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${AdminUser}    ${i['userWaitQueueId']}
    \    sleep    50ms
    sleep    1
    #坐席回复消息
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    ${curTime}    get time    epoch
    \    ${AgentMsgEntity}    create dictionary    msg=${curTime}:agent test msg!    type=txt
    \    Agent Send Message    ${AdminUser}    ${i['user']['userId']}    ${i['serviceSessionId']}    ${AgentMsgEntity}
    \    sleep    50ms
    sleep    1
    #关闭进行中会话
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${AdminUser}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms

发送多种格式消息
    [Documentation]    发送各种格式的消息
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #文件基准
    &{fileEntity}    create dictionary    url=    filename=    filepath=    contentType=    size={"width":0,"height":0}
    ...    type=
    #初始化参数：消息、渠道信息、客户信息
    set test variable    ${originType}    app
    ${curTime}    get time    epoch
    #创建技能组
    ${agentqueue}    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    ${MsgEntity}    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    ${GuestEntity}    create dictionary    userName=${AdminUser.tenantId}-${curTime}    originType=${originType}
    #将规则排序设置为渠道优先
    Set RoutingPriorityList    入口    渠道    关联
    #发送消息并创建访客（tenantId和发送时的时间组合为访客名称，每次测试值唯一）
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    set to dictionary    ${FilterEntity}    visitorName=${GuestEntity.userName}
    set to dictionary    ${DateRange}    beginDate=${empty}    endDate=${empty}
    #根据访客昵称查询待接入列表
    set to dictionary    ${FilterEntity}    visitorName=${guestentity.userName}
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    Should Be True    ${j['total_entries']} ==1    查询结果为空：${resp.content}
    Should Be Equal    ${j['items'][0]['userName']}    ${guestentity.userName}    访客名称不正确：${resp.content}
    Should Be Equal    ${j['items'][0]['queueId']}    ${queueentityA.queueId}    技能组id不正确：${resp.content}
    #根据查询结果接入会话
    Access Conversation    ${AdminUser}    ${j['items'][0]['userWaitQueueId']}
    #1、发送文本格式消息
    set to dictionary    ${MsgEntity}    msg=测试文本消息格式
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #2、发送图片格式消息
    ${picpath}    set variable    ${datadir}${/}${/}IMG_0024.JPG
    set to dictionary    ${fileEntity}    filename=IMG_0024.JPG    filepath=${picpath}    contentType=image/jpeg    type=img
    ${j}=    Upload File    ${restentity}    ${fileEntity}    ${timeout}
    ${share-secret}    set variable    ${j['entities'][0]['share-secret']}
    ${uuid}    set variable    ${j['entities'][0]['uuid']}
    set to dictionary    ${fileEntity}    url=http://${restentity.restDomain}/${restentity.orgName}/${restentity.appName}/chatfiles/${uuid}    secret=${share-secret}
    set to dictionary    ${MsgEntity}    msg={"type":"${fileEntity.type}","url":"${fileEntity.url}","secret":"${fileEntity.secret}","filename":"${fileEntity.filename}","size":${fileEntity.size}}    key=filename
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #3、发送文件格式消息
    ${filepath}    set variable    ${datadir}${/}${/}IMG_0024.JPG
    set to dictionary    ${fileEntity}    filename=IMG_0024.JPG    filepath=${filepath}    contentType=image/jpeg    type=file
    ${j}=    Upload File    ${restentity}    ${fileEntity}    ${timeout}
    ${share-secret}    set variable    ${j['entities'][0]['share-secret']}
    ${uuid}    set variable    ${j['entities'][0]['uuid']}
    set to dictionary    ${fileEntity}    url=http://${restentity.restDomain}/${restentity.orgName}/${restentity.appName}/chatfiles/${uuid}    secret=${share-secret}
    set to dictionary    ${MsgEntity}    msg={"type":"${fileEntity.type}","url":"${fileEntity.url}","secret":"${fileEntity.secret}","filename":"${fileEntity.filename}","size":${fileEntity.size}}    key=filename
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #4、发送语音格式消息
    ${audiopath}    set variable    ${datadir}${/}${/}audio.amr
    set to dictionary    ${fileEntity}    filename=audio.amr    filepath=${audiopath}    contentType=audio/amr    type=audio
    ${j}=    Upload File    ${restentity}    ${fileEntity}    ${timeout}
    ${share-secret}    set variable    ${j['entities'][0]['share-secret']}
    ${uuid}    set variable    ${j['entities'][0]['uuid']}
    set to dictionary    ${fileEntity}    url=http://${restentity.restDomain}/${restentity.orgName}/${restentity.appName}/chatfiles/${uuid}    secret=${share-secret}
    set to dictionary    ${MsgEntity}    msg={"type":"${fileEntity.type}","url":"${fileEntity.url}","secret":"${fileEntity.secret}","filename":"${fileEntity.filename}","size":${fileEntity.size}}    key=filename
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #5、发送视频邀请格式消息
    set to dictionary    ${MsgEntity}    msg=邀请客服进行实时视频    type=txt    ext={"type":"rtcmedia/video","msgtype":{"liveStreamInvitation":{"msg":"邀请客服进行实时视频","orgName":"${restentity.orgName}","appName":"${restentity.appName}","userName":"${GuestEntity.userName}","imServiceNumber":"${restentity.serviceEaseMobIMNumber}","resource":"${originType}"}},"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #6、发送order订单格式消息
    ${orderEntity}    create dictionary    imageName=IMG_0024.JPG    type=custom    img_url=C:/Users/leo/Desktop/picture/IMG_0024.JPG    title=测试order消息    desc=端午节粽子四
    ...    order_title=订单号：123456789012345678901234567890    price=￥1200    item_url=http://kefu.easemob.com
    set to dictionary    ${MsgEntity}    msg=order    ext={"imageName":"${orderEntity.imageName}","type":"${orderEntity.type}","msgtype":{"order":{"img_url":"${orderEntity.img_url}","title":"${orderEntity.title}","desc":"${orderEntity.desc}","order_title":"${orderEntity.order_title}","price":"${orderEntity.price}","item_url":"${orderEntity.item_url}"}}}
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #7、发送track订单格式消息
    ${orderEntity}    create dictionary    imageName=IMG_0024.JPG    type=custom    img_url=C:/Users/leo/Desktop/picture/IMG_0024.JPG    title=测试track消息    desc=端午节粽子四
    ...    order_title=订单号：123456789012345678901234567890    price=￥1200    item_url=http://kefu.easemob.com
    set to dictionary    ${MsgEntity}    msg=track    ext={"imageName":"${orderEntity.imageName}","type":"${orderEntity.type}","msgtype":{"track":{"img_url":"${orderEntity.img_url}","title":"${orderEntity.title}","desc":"${orderEntity.desc}","order_title":"${orderEntity.order_title}","price":"${orderEntity.price}","item_url":"${orderEntity.item_url}"}}}
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}
    #8、发送位置格式消息
    ${locEntity}    create dictionary    addr=西城区西便门桥    lat=39.9053    lng=116.36302    type=loc
    set to dictionary    ${MsgEntity}    msg={"addr":"${locEntity.addr}","lat":${locEntity.lat},"lng":${locEntity.lng},"type":"${locEntity.type}"}    key=addr    ext={"weichat":{"originType":"${originType}","queueName":"${queueentityA.queueName}"}}
    Send Message    ${restentity}    ${GuestEntity}    ${MsgEntity}

批量创建坐席
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    : FOR    ${t}    IN RANGE    200
    \    &{AgentUser}=    create dictionary    username=${AdminUser.tenantId}${t}    password=test2015    maxServiceSessionCount=10    tenantId=${AdminUser.tenantId}
    \    ${data}=    set variable    {"nicename":"${AgentUser.username}","username":"${AgentUser.username}@qq.com","password":"${AgentUser.password}","confirmPassword":"${AgentUser.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${AgentUser.maxServiceSessionCount}","roles":"agent"}
    \    ${resp}=    /v1/Admin/Agents    post    ${AdminUser}    ${AgentFilterEntity}    ${data}
    \    ...    ${timeout}
    \    log    ${resp.content}
    \    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
    \    sleep    200ms

批量创建坐席（从excel读取）
    @{account}=    Read Xls File    z:/网电坐席开通环信账号.xlsx    Sheet2
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    : FOR    ${t}    IN    @{account}
    \    ${d}    Decode Bytes To String In Dict    ${t}
    \    ${max}    convert to number    ${d['maxServiceSessionCount']}
    \    ${max}    convert to integer    ${max}
    \    ${data}=    set variable    {"nicename":"${d['nicename']}","username":"${d['username']}","password":"${d['password']}","confirmPassword":"${d['confirmPassword']}","trueName":"${d['trueName']}","mobilePhone":"${d['mobilePhone']}","agentNumber":"${d['agentNumber']}","maxServiceSessionCount":"${max}","roles":"${d['roles']}"}
    \    ${resp}=    /v1/Admin/Agents    post    ${AdminUser}    ${AgentFilterEntity}    ${data}
    \    ...    ${timeout}
    \    log    ${resp.content}
    \    sleep    500ms

批量发消息给机器人并转人工
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=app    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    Comment    set to dictionary    ${restentity}    serviceEaseMobIMNumber=kefuchannelimid_951630    orgName=1100170223012838    appName=kefuchannelapp27800
    Comment    set to dictionary    ${restentity}    serviceEaseMobIMNumber=shenliang    orgName=shenliang    appName=sldemo    token=YWMt6R0TrEH1EeeTJWs4ubcFKQAAAAAAAAAAAAAAAAAAAAEk52BQF04R5pRlM4iZaoFAAgMAAAFcRBd9owBPGgBKcyU2NQ5_Xp_s6Q_uICN_PJPT0g-ZNH-eGKPrQunlNQ
    : FOR    ${i}    IN RANGE    100
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}-${curTime}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    50ms
    \    set to dictionary    ${msgentity}    msg=${i}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms

批量创建会话、接入并关闭，访客马上回复评价
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #将规则排序设置为渠道优先
    #Set RoutingPriorityList    渠道    关联    入口
    #判断渠道是否有绑定关系
    #${j}    Get Routing
    #${listlength}=    Get Length    ${j['content']}
    #判断如果没有渠道数据，使用post请求，反之使用put请求
    #Run Keyword If    ${listlength} == 0    Add Routing    ${originTypeentity}    ${queueentityA.queueId}
    #Run Keyword If    ${listlength} > 0    Update Routing    ${originTypeentity}    ${queueentityA.queueId}
    #发送消息并创建200访客
    : FOR    ${i}    IN RANGE    100
    \    ${curTime}    get time    epoch
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=${curTime}:test msg!    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    200ms
    sleep    1s
    #接入200个访客
    set to dictionary    ${FilterEntity}    per_page=200
    ${resp}    Search Waiting Conversation    ${AdminUser}    ${FilterEntity}    ${DateRange}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j['items']}
    \    Access Conversation    ${AdminUser}    ${i['userWaitQueueId']}
    \    sleep    50ms
    sleep    1s
    #关闭进行中会话，访客发评价
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${AdminUser}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    ${guestentity}=    create dictionary    userName=${AdminUser.tenantId}-${i}    originType=${originTypeentity.originType}
    \    ${msgentity}=    create dictionary    msg=1    type=txt    ext={"weichat":{"originType":"${originTypeentity.originType}"}}
    \    Send Message    ${restentity}    ${guestentity}    ${msgentity}
    \    sleep    50ms

批量关闭进行中会话
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    #关闭进行中会话
    ${resp}=    /v1/Agents/me/Visitors    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    : FOR    ${i}    IN    @{j}
    \    Stop Processing Conversation    ${AdminUser}    ${i['user']['userId']}    ${i['serviceSessionId']}
    \    sleep    50ms

批量创建坐席和技能组，并添加坐席到技能组
    set test variable    ${AgentCount}    10000
    set test variable    ${PerAgent}    2
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    @{agentslist}    create list    ${empty}
    set global variable    @{agentslist}
    : FOR    ${i}    IN RANGE    ${AgentCount}
    \    #添加坐席
    \    &{AgentUser}=    create dictionary    username=${AdminUser.tenantId}-${i}-3    password=test2015    maxServiceSessionCount=10    tenantId=${AdminUser.tenantId}
    \    ${data}=    set variable    {"nicename":"${AgentUser.username}","username":"${AgentUser.username}@qq.com","password":"${AgentUser.password}","confirmPassword":"${AgentUser.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${AgentUser.maxServiceSessionCount}","roles":"agent"}
    \    ${resp}=    /v1/Admin/Agents    post    ${AdminUser}    ${AgentFilterEntity}    ${data}
    \    ...    ${timeout}
    \    ${j}    to json    ${resp.content}
    \    Append To list    ${agentslist}    ${j['userId']}
    \    #每n个坐席创建一个技能
    \    ${t}    evaluate    ${i}%${PerAgent}
    \    Run Keyword If    ${t} == 1    Create Queue And Add Agents To Queue    ${AdminUser}    ${agentslist}    ${AdminUser.tenantId}-Queue-${i}-3
    \    sleep    100ms

批量创建并关闭有效会话
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Create Channel
    #发送消息并创建访客
    #初始化参数：消息、渠道信息、客户信息
    ${curTime}    get time    epoch
    ${originTypeentity}=    create dictionary    name=网页渠道    originType=webim    key=IM    dutyType=Allday
    ${agentqueue}=    create dictionary    queueName=${AdminUser.tenantId}${curTime}A
    ${queueentityA}=    Add Agentqueue    ${agentqueue}    ${agentqueue.queueName}    #创建一个技能组
    #
    Repeat Keyword    242    Close Valid New Session    ${AdminUser}    ${restentity}    webim

批量关闭待接入
    Create Session    testsession    ${kefuurl}
    ${resp}=    /login    testsession    ${AdminUser}    ${timeout}
    ${j}    to json    ${resp.content}
    set to dictionary    ${AdminUser}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=testsession    nicename=${j['agentUser']['nicename']}
    Repeat Keyword    100    Close Waiting Sessions    ${AdminUser}    ${FilterEntity}    ${DateRange}
