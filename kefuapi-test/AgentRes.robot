*** Variables ***
${kefuurl}        http://sandbox.kefu.easemob.com
${orgurl}         http://vpc10.kefu.easemob.com:8000
&{AdminUser}      username=    password=    status=Online    roles=    tenantId=    maxServiceSessionCount=10    wsconn=0
...               cookies=    session=    userId=    nicename=    browser=chrome    language=zh-CN    graylist=
...               resourcelist=
&{OrgAdminUser}    username=admin@org.com    password=ORGadmin    orgId=1034    cookies=    session=    userId=    nicename=
...               browser=phantomjs
&{AgentUser1}     username=    password=    status=    roles=    tenantId=    maxServiceSessionCount=    wsconn=0
...               cookies=    session=    userId=    nicename=
@{kefustatus}     Online    Busy    Leave    Hidden    # 第一个值必须是Online
@{SessionState}    ${empty}    Wait    Processing
${timeout}        ${30.0}
${delay}          1
${shortcutMessageGroupId}    ${EMPTY}
${shortcutMessageGroupName}    ${EMPTY}
${groupType}      System
@{shortcutMessages}
@{userTagIds}
@{visitorUserId}    6c701921-59b5-4776-b6e1-749ec8703307
&{visitorUser}    userId=29a68433-f95e-48bd-97e4-1ae53f68a462    nicename=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    username=webim-visitor-2CRVGCTG6HWGEJ7E9PGF
@{WeiboTechChannelType}    weibo    wechat
&{AgentFilterEntity}    page=0    size=8    keyValue=    orderBy=    orderMethod=    statuses=Enable,Submit
&{FilterEntity}    page=1    per_page=15    originType=${EMPTY}    state=Terminal,Abort    isAgent=${True}    techChannelId=    visitorName=
...               summaryIds=    sortOrder=desc    techChannelType=    categoryId=-1    subCategoryId=-1    userTagIds=    enquirySummary=
...               total_pages=1    total_entries=1    firstResponseTime=0    sessionTime=0    avgResponseTime=0    visitorMark=    sessionTag=
...               asc=false    channelId=    dateInterval=1d    sessionType=S_ALL    queryType=ORIGIN    visitorTag=    waitTime=60000
...               objectType=O_AGENT    locale=zh_CN    order=stateCreateTime    username=    dataAuth=ROLE_SYSTEM    top=true    queryTypes=OFFLINE
...               agentIds=    customerName=    transfered=    fromAgentCallback=    queueId=    withMessage=    sortField=stopDateTime
...               message=    hasQM=    groupId=    rangeValue=    qmActorId=    amsgCount=    vmsgCount=
...               agentUserId=    vip=    serviceSessionId=    type=    entryStates=Published    creatorId=    appealNumber=
...               agent_query=false    size=8    skill_group_export=false    # hasQM参数的值选择为：V_ALL、V_YES、V_NO; vip参数为待接入筛选使用，值默认为空，可为：true/false
&{orgEntity}      organName=${empty}    organId=${empty}
&{RobotFilter}    page=1    per_page=10    q=    type=0    pageIndex=1    pageSize=10    start=
...               end=    keyword=    source=
&{VisitorFilterEntity}    page=1    size=15    userTagIds=    categoryId=-1    subCategoryId=-1    visitorName=    summaryIds=
...               enquirySummary=    beginDateTime=    endDateTime=
&{DateRange}      beginDate=    endDate=    beginDateTime=    endDateTime=    beginWeekDate=    endWeekDate=    beginWeekDateTime=
...               endWeekDateTime=    beginMonthDate=    endMonthDate=    beginMonthDateTime=    endMonthDateTime=    stopDateFrom=    stopDateTo=    createDateFrom=    createDateTo=
${switchType}     0
&{commonphrasesVariables}    systemOnly=false    buildChildren=true
&{visitorUser}    userId=29a68433-f95e-48bd-97e4-1ae53f68a462    nicename=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    username=webim-visitor-2CRVGCTG6HWGEJ7E9PGF
&{MsgCenterEntity}    total_pages=1    total_entries=9    status=unread
&{SmsRemindEntity}    id=12    status=enable    remindType=remindType    remindName=
${targetchannel}    {u'appKey': u'easemob-demo#jianguo9', u'clientSecret': u'YXA6iYLgfPv-wEGCsFHIbvgciRZRh4M', u'serviceEaseMobIMPassword': u'123456', u'ispass': True, u'description': None, u'appName': u'jianguo9', u'orgName': u'easemob-demo', u'isrun': False, u'agentQueueId': None, u'clientId': u'YXA6GS5loMNxEeWyjKe374xQVA', u'tenantId': 13250, u'createDateTime': 1459239386000L, u'techChannelInfo': u'easemob-demo#jianguo9#0326test', u'serviceEaseMobIMNumber': u'0326test', u'experience': False, u'id': 21620, u'name': u'sdfdf'}
${easemobtechchannel}    {u'appKey': u'easemob-demo#jianguo9', u'clientSecret': u'YXA6iYLgfPv-wEGCsFHIbvgciRZRh4M', u'serviceEaseMobIMPassword': u'123456', u'ispass': True, u'description': None, u'appName': u'jianguo9', u'orgName': u'easemob-demo', u'isrun': False, u'agentQueueId': None, u'clientId': u'YXA6GS5loMNxEeWyjKe374xQVA', u'tenantId': 13250, u'createDateTime': 1459239386000L, u'techChannelInfo': u'easemob-demo#jianguo9#0326test', u'serviceEaseMobIMNumber': u'0326test', u'experience': False, u'id': 21620, u'name': u'sdfdf'}
&{GuestEntity}    userName=    userId=    chatGroupId=    chatGroupSeqId=    sessionServiceId=    sessionServiceSeqId=    startSessionTimestamp=
...               originType=app
&{MsgEntity}      type=    msg=    ext=
${retryTimes}     10
&{MsgFilter}      fromSeqId=0    size=10    lastSeqId=0
&{RobotRulesEntity}    page=1    per_page=15    q=
&{AgentQueue1}    queueId=    queueName=    channelData=
&{AgentMsgEntity}    msg=    type=    ext=
&{ProjectEntity}    id=
&{PriorityEntity}    渠道=Channel    关联=ChannelData    入口=UserSpecifiedChannel
${SeleniumTimeout}    20
&{OrgUser1}       username=    password=    name=    phone=    tenantId=
&{OrgAdmin1}      username=    password=    nicename=    phone=    model=
&{NotesEntity}    projectId=    tenantId=    userId=    userRoles=admin    page=0    size=20    ticketId=
...               sort=createdAt,desc    statusId=    visitorName=    assigned=    agentIds=    Authorization=
&{msgGateway}     im=    secondGateway=    rest=    # 设置发送消息的方式，如果im设置为1，则使用im，以此类推如果secondGateway设置1或任意值，则使用第二通道发送消息
&{ConDateRange}    beginDateTime=    endDateTime=    # 测试统计数据时用来筛选会话
&{ExistChannelEntity}    orgName=    appName=    restDomain=    serviceEaseMobIMNumber=    # 使用租户下已有的关联发消息，orgName加appName为appkey，serviceEaseMobIMNumber为关联的im服务号，restDomain为appkey所属集群rest地址
@{originType}     app    webim    weibo    weixin    phone    rest    slack
${ScheduleTimeout}    5
${daasDelay}      3
&{customerFieldName}    createDateTime=    lastSessionCreateDateTime=    nickname=    username=    customerTags=    truename=    email=   phone=
&{customerOperation}    createDateTime=RANGE    lastSessionCreateDateTime=RANGE    nickname=CONTAIN    username=CONTAIN    customerTags=CONTAIN_ANY    truename=CONTAIN    email=CONTAIN   phone=CONTAIN
&{evaluationdegreesName}    score1=非常不满意    score2=不满意    score3=一般    score4=满意   score5=非常满意
&{evaluationdegreesNameScore}    score1=1    score2=2    score3=3    score4=4   score5=5
${grayFunctionOption}        False    #判断增值功能测试用例是否执行，True即执行，False为不执行