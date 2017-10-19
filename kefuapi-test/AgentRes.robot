*** Variables ***
${kefuurl}        http://xw-kefu.bestwehotel.com
${orgurl}         http://vpc10.kefu.easemob.com:8000
&{AdminUser}      username=test@qq.com    password=test2015    status=Hidden    roles=    tenantId=    maxServiceSessionCount=    wsconn=0
...               cookies=    session=    userId=    nicename=    browser=chrome    language=en_US    graylist=
&{OrgAdminUser}    username=admin@org.com    password=ORGadmin    orgId=1034    cookies=    session=    userId=    nicename=
...               browser=chrome
&{AgentUser1}     username=    password=    status=    roles=    tenantId=    maxServiceSessionCount=    wsconn=0
...               cookies=    session=    userId=    nicename=
@{kefustatus}     Busy    Leave    Hidden    Online
@{SessionState}    ${empty}    Wait    Processing
${timeout}        ${5.0}
${delay}          1
${shortcutMessageGroupId}    ${EMPTY}
${shortcutMessageGroupName}    ${EMPTY}
${groupType}      System
@{shortcutMessages}
@{userTagIds}
@{visitorUserId}    6c701921-59b5-4776-b6e1-749ec8703307
&{visitorUser}    userId=29a68433-f95e-48bd-97e4-1ae53f68a462    nicename=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    username=webim-visitor-2CRVGCTG6HWGEJ7E9PGF
@{WeiboTechChannelType}    weibo    wechat
&{AgentFilterEntity}    page=0    size=8    keyValue=    orderBy=    orderMethod=
&{FilterEntity}    page=1    per_page=15    originType=${EMPTY}    state=Terminal,Abort    isAgent=${True}    techChannelId=    visitorName=
...               summaryIds=    sortOrder=desc    techChannelType=    categoryId=-1    subCategoryId=-1    userTagIds=    enquirySummary=
...               total_pages=1    total_entries=1    firstResponseTime=0    sessionTime=0    avgResponseTime=0    visitorMark=    sessionTag=
...               asc=false    channelId=    dateInterval=1d    sessionType=S_ALL    queryType=ORIGIN    visitorTag=    waitTime=60000
...               objectType=O_AGENT    locale=zh_CN    order=stateCreateTime    username=    dataAuth=ROLE_SYSTEM    top=true    queryTypes=OFFLINE
...               agentIds=    customerName=    transfered=    fromAgentCallback=    queueId=    withMessage=
&{orgEntity}      organName=${empty}    organId=${empty}
&{RobotFilter}    page=1    per_page=5    q=    type=0
&{VisitorFilterEntity}    page=1    size=15    userTagIds=    categoryId=-1    subCategoryId=-1    visitorName=    summaryIds=
...               enquirySummary=    beginDateTime=    endDateTime=
&{DateRange}      beginDate=    endDate=    beginDateTime=    endDateTime=    beginWeekDate=    endWeekDate=    beginWeekDateTime=
...               endWeekDateTime=    beginMonthDate=    endMonthDate=    beginMonthDateTime=    endMonthDateTime=
${switchType}     0
&{commonphrasesVariables}    systemOnly=false    buildChildren=true
&{visitorUser}    userId=29a68433-f95e-48bd-97e4-1ae53f68a462    nicename=webim-visitor-2CRVGCTG6HWGEJ7E9PGF    username=webim-visitor-2CRVGCTG6HWGEJ7E9PGF
&{MsgCenterEntity}    total_pages=1    total_entries=9    status=unread
&{SmsRemindEntity}    id=12    status=enable    remindType=remindType    remindName=
${targetchannel}    {u'appKey': u'easemob-demo#jianguo9', u'clientSecret': u'YXA6iYLgfPv-wEGCsFHIbvgciRZRh4M', u'serviceEaseMobIMPassword': u'123456', u'ispass': True, u'description': None, u'appName': u'jianguo9', u'orgName': u'easemob-demo', u'isrun': False, u'agentQueueId': None, u'clientId': u'YXA6GS5loMNxEeWyjKe374xQVA', u'tenantId': 13250, u'createDateTime': 1459239386000L, u'techChannelInfo': u'easemob-demo#jianguo9#0326test', u'serviceEaseMobIMNumber': u'0326test', u'experience': False, u'id': 21620, u'name': u'sdfdf'}
${easemobtechchannel}    {u'appKey': u'easemob-demo#jianguo9', u'clientSecret': u'YXA6iYLgfPv-wEGCsFHIbvgciRZRh4M', u'serviceEaseMobIMPassword': u'123456', u'ispass': True, u'description': None, u'appName': u'jianguo9', u'orgName': u'easemob-demo', u'isrun': False, u'agentQueueId': None, u'clientId': u'YXA6GS5loMNxEeWyjKe374xQVA', u'tenantId': 13250, u'createDateTime': 1459239386000L, u'techChannelInfo': u'easemob-demo#jianguo9#0326test', u'serviceEaseMobIMNumber': u'0326test', u'experience': False, u'id': 21620, u'name': u'sdfdf'}
&{RestEntity}     appName=    orgName=    token=    restDomain=    session=    serviceEaseMobIMNumber=    agentQueueId=
...               dutyType=    clientId=    clientSecret=    appKey=    channelName=    robotId=    secondQueueId=
...               secondRobotId=    agentQueueName=    secondQueueName=
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
@{graylist}       base
&{NotesEntity}    ProjectId=    OpenNum=    PendingNum=    SolvedNum=    AllNum=    UnassignedNum=    CustomNum=
...               NotesId=
