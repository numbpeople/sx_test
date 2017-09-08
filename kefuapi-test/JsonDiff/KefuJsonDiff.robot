*** Settings ***
Library           Collections

*** Variables ***
${loginJson}      {"success":"登录成功","agentUser":{"tenantId":11927,"userId":"c0aeb174-7774-4ced-9d99-3ca827d2b1db","userType":"Agent","userScope":"Tenant","nicename":"Admin","password":"","username":"0808@test.com","roles":"admin,agent","createDateTime":"2016-08-08 19:28:50","lastUpdateDateTime":"2016-12-01 11:19:07","status":"Enable","state":"Hidden","maxServiceSessionCount":2,"trueName":"","mobilePhone":"","welcomeMessage":"您好，Admin为您服务","bizId":"11927","scope":"Tenant","onLineState":"Hidden","currentOnLineState":"Hidden"},"token":{"name":"SESSION","value":"ce954db3-656a-400c-9b5d-bf246c52ee30","expires":604800}}
${initdataJson}    {"sessionId":"eae9ebce-398c-4d6e-886a-b7d8ca88b8c6","showInfo":false,"showRobot":false,"lang":"zh-CN","experienceEaseMobChannelIM":"zktest1","role":"admin,agent","ossConfig":{"url":"http://oss-cn-hangzhou.aliyuncs.com","bucketName":"kefu-sandbox-avatar","accessKeyId":"J8fpJPxfK601qrbc","policy":"eyJleHBpcmF0aW9uIjogIjIxMTUtMTItMTBUMDA6MDA6MDBaIiwgImNvbmRpdGlvbnMiOiBbWyJjb250ZW50LWxlbmd0aC1yYW5nZSIsIDAsIDEwNDg1NzYwMF1dfQ==","signature":"fIgaTd7lrpAM6HLjmobX/B+JaVM="},"showCallback":false,"resource":"/tenants/5478/agents/cec9204c-13ca-4e5c-a171-db7071573e20/1480929543793","allowAgentChangeMaxSessions":false,"bonusEnable":false,"showGrowingIo":false,"robot":false}
${infosJson}      {"status":"OK","entity":{"orgName":"easemob","orgId":1}}
${targetchannelJson}    {"tenantName":"fds1111","tenantAvatar":"0","tenantLogo":null,"channelId":10302,"orgName":"easemob-demo","appName":"testxtmvip","imServiceNumber":"0427","run":true,"restDomain":"a1-vip1.easemob.com"}
${easemobtechchannelJson}    {"id":12172,"tenantId":27874,"name":"体验关联","description":"环信测试帐号关联","orgName":"123zj","appName":"kefusandbox","clientId":"YXA62qhzsLBvEeaJ85Fg8Cxi9A","clientSecret":"YXA6P5lXxZdEcn6JxmQ43sm86b0qgTM","serviceEaseMobIMNumber":"138280","serviceEaseMobIMPassword":null,"createDateTime":"2016-12-14","ispass":true,"isrun":true,"dutyType":"None","agentQueueId":null,"secondQueueId":null,"robotId":null,"secondRobotId":null,"usermail":null,"password":null,"token":null,"techChannelInfo":null,"experience":true,"appKey":"123zj#kefusandbox"}
${AgentsMeJson}    {"userId":"93dbcb2b-40c2-45b5-80c6-1ad3a837877d","maxServiceUserNumber":50,"status":"Online"}
${TenantsMeAgentsMeJson}    {"tenantId":5929,"userId":"93dbcb2b-40c2-45b5-80c6-1ad3a837877d","userType":"Agent","userScope":"Tenant","nicename":"Admin","password":"","username":"0329@test.com","roles":"admin,agent","createDateTime":"2016-03-29 19:43:18","lastUpdateDateTime":"2016-12-06 14:28:28","status":"Enable","state":"Online","maxServiceSessionCount":1,"trueName":"","mobilePhone":"","welcomeMessage":"您好，Admin为您服务","avatar":"/images/uikit/default_agent.png","bizId":"5929","scope":"Tenant","onLineState":"Online","currentOnLineState":"Online"}
${TenantsMeJson}    {"tenantId":27854,"name":"fsd","description":null,"crateDateTime":1481105464000,"lastUpdateDateTime":1481105464000,"status":"Eanble","phone":"13810515454","address":null,"isExperience":null,"avatar":null,"logo":null,"organId":1,"organName":"easemob","agentMaxNum":10,"creator":null,"domain":null}
${optionJson}     {"optionId":"790da2e0-ac09-4f79-a6f6-6dcb9bcf2187","tenantId":27865,"optionName":"WelcomeMsgTenantEnable","optionValue":"false","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"}
${optionsJson}    {"status":"OK","count":11,"data":[{"optionId":"5d620947-9d06-46bc-b710-2813684a0561","tenantId":27865,"optionName":"GreetingMsgTenantContent","optionValue":"您好，有什么可以帮助您的吗？","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"50e2cf23-c46c-4767-a189-7c21319523d4","tenantId":27865,"optionName":"GreetingMsgTenantEnable","optionValue":"true","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"63ac1d06-6e42-4e64-a2c3-c6c3ea2c589e","tenantId":27865,"optionName":"serviceSessionPreScheduleEnable","optionValue":"true","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"0a994eea-8351-4a43-ab1a-d3f6b148a572","tenantId":27865,"optionName":"serviceSessionPreScheduleTimeout","optionValue":"60","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"02ce880d-8d06-477d-9019-6534c91c81c4","tenantId":27865,"optionName":"stopServiceSessionEnable","optionValue":"false","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"c380a996-986c-4c00-8b0b-adaf2b85f6b7","tenantId":27865,"optionName":"stopServiceSessionMessage","optionValue":"会话已结束。","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"ab55e302-0c60-4f70-b286-54021e07fafc","tenantId":27865,"optionName":"timeOffWorkEnable","optionValue":"false","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"45076521-a4c9-4592-9340-80b8385b619d","tenantId":27865,"optionName":"timeOffWorkMessage","optionValue":"现在是下班时间，请留言。","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"51e6d839-152a-4085-8383-6f295a1c5c6d","tenantId":27865,"optionName":"waitingSessionMax","optionValue":"200","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"ba76aec3-0b84-4702-8932-9798c1afc34d","tenantId":27865,"optionName":"WelcomeMsgTenantContent","optionValue":"欢迎使用客服系统","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"},{"optionId":"790da2e0-ac09-4f79-a6f6-6dcb9bcf2187","tenantId":27865,"optionName":"WelcomeMsgTenantEnable","optionValue":"false","createDateTime":"2016-12-10 03:03:27","lastUpdateDateTime":"2016-12-10 03:03:27"}]}
${targetchannelsJson}    ${EMPTY}
${AgentQueueJson}    ${EMPTY}
${userSpecifiedQueueIdJson}    {"optionId":"1571bfe7-5cac-48aa-91c3-9170ecfa11c8","tenantId":13250,"optionName":"userSpecifiedQueueId","optionValue":"false","createDateTime":"2016-04-13 10:34:17","lastUpdateDateTime":"2016-12-13 03:21:07"}
${qualityreviewJson}    {"firstResTime":0,"avgResTime":0,"workTime":26,"stepId":1,"agentName":"0222test1a加汉字-老朱","agentId":"db7395d4-d48b-4bc2-ba80-1693db84003f","serviceSessionId":"4f41af29-a5cd-40cb-951c-53f09a7ae468","tenantId":5884,"techChannelId":10302,"queueId":6532,"state":"Terminal","chatGroupId":2685206,"messageSeqId":1,"agentUserType":1,"createDatetime":"2016-12-28 19:06:23","startDateTime":"2016-12-28 19:06:23","stopDateTime":"2016-12-28 19:06:49","techChannelType":"easemob","summarys":[[{"id":3943,"name":"咨询1修改修改修改修改1","color":1532742911,"parentId":0},{"id":3944,"name":"功能咨询1","color":255,"parentId":3943}]],"enquirySummary":"","techChannelName":"体验关联","originType":["weixin"],"visitorUser":{"userId":"49ce5ee0-c227-43c4-bffa-d6c72ddd5a67","nicename":"5884-1482922991","username":"5884-1482922991"},"summarysDetail":"咨询1修改修改修改修改1-功能咨询1"}

*** Keywords ***
loginJsonDiff
    [Arguments]    ${base}    ${instance}
    Dictionary Should Contain Key    ${instance}    success
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['success']}'!='${instance['success']}'    set to dictionary    ${r1}    succsess=invalid
    Run Keyword If    '${base['agentUser']['userType']}'!='${instance['agentUser']['userType']}'    set to dictionary    ${r1}    agentUser.userType=invalid
    Run Keyword If    '${base['agentUser']['userScope']}'!='${instance['agentUser']['userScope']}'    set to dictionary    ${r1}    agentUser.userScope=invalid
    Run Keyword If    '${base['agentUser']['username']}'!='${instance['agentUser']['username']}'    set to dictionary    ${r1}    agentUser.username=invalid
    Run Keyword If    '${base['agentUser']['status']}'!='${instance['agentUser']['status']}'    set to dictionary    ${r1}    agentUser.status=invalid
    Run Keyword If    '${base['agentUser']['state']}'!='${instance['agentUser']['state']}'    set to dictionary    ${r1}    agentUser.state=invalid
    Run Keyword If    '${base['agentUser']['scope']}'!='${instance['agentUser']['scope']}'    set to dictionary    ${r1}    agentUser.scope=invalid
    Run Keyword If    '${base['agentUser']['onLineState']}'!='${instance['agentUser']['onLineState']}'    set to dictionary    ${r1}    agentUser.onLineState=invalid
    Run Keyword If    '${base['agentUser']['currentOnLineState']}'!='${instance['agentUser']['currentOnLineState']}'    set to dictionary    ${r1}    agentUser.currentOnLineState=invalid
    Run Keyword If    '${base['token']['name']}'!='${instance['token']['name']}'    set to dictionary    ${r1}    token.name=invalid
    Run Keyword If    '${base['token']['expires']}'!='${instance['token']['expires']}'    set to dictionary    ${r1}    token.expires=invalid
    Run Keyword If    '${instance['agentUser']['tenantId']}'!='${instance['agentUser']['bizId']}'    set to dictionary    ${r1}    'agentUser.tenantId==agentUser.bizId'=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

initdataJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['sessionId']}'!='${instance['sessionId']}'    set to dictionary    ${r1}    sessionId=invalid
    Run Keyword If    '${base['role']}'!='${instance['role']}'    set to dictionary    ${r1}    role=invalid
    ${resouce1}    ${t1}=    Split String From Right    ${base['resource']}    /    1
    ${resouce2}    ${t2}=    Split String From Right    ${instance['resource']}    /    1
    Run Keyword If    '${resouce1}'!='${resouce2}'    set to dictionary    ${r1}    resource=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

infosJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    ${l1}    Get Length    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

AgentsMeJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['userId']}'!='${instance['userId']}'    set to dictionary    ${r1}    userId=invalid
    Run Keyword If    '${base['maxServiceUserNumber']}'!='${instance['maxServiceUserNumber']}'    set to dictionary    ${r1}    maxServiceUserNumber=invalid
    Run Keyword If    '${base['status']}'!='${instance['status']}'    set to dictionary    ${r1}    status=invalid
    ${l1}    Get Length    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

TenantsMeAgentsMeJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['tenantId']}'!='${instance['tenantId']}'    set to dictionary    ${r1}    tenantId=invalid
    Run Keyword If    '${base['userId']}'!='${instance['userId']}'    set to dictionary    ${r1}    userId=invalid
    Run Keyword If    '${base['userType']}'!='${instance['userType']}'    set to dictionary    ${r1}    userType=invalid
    Run Keyword If    '${base['userScope']}'!='${instance['userScope']}'    set to dictionary    ${r1}    userScope=invalid
    Run Keyword If    '${base['nicename']}'!='${instance['nicename']}'    set to dictionary    ${r1}    nicename=invalid
    Run Keyword If    '${base['username']}'!='${instance['username']}'    set to dictionary    ${r1}    username=invalid
    Run Keyword If    '${base['roles']}'!='${instance['roles']}'    set to dictionary    ${r1}    roles=invalid
    Run Keyword If    '${base['createDateTime']}'!='${instance['createDateTime']}'    set to dictionary    ${r1}    createDateTime=invalid
    Run Keyword If    '${base['state']}'!='${instance['state']}'    set to dictionary    ${r1}    state=invalid
    Run Keyword If    '${base['maxServiceSessionCount']}'!='${instance['maxServiceSessionCount']}'    set to dictionary    ${r1}    maxServiceSessionCount=invalid
    #Run Keyword If    '${base['trueName']}'!='${instance['trueName']}'    set to dictionary    ${r1}    trueName=invalid
    Run Keyword If    '${base['password']}'!='${instance['password']}'    set to dictionary    ${r1}    password=invalid
    #Run Keyword If    '${base['mobilePhone']}'!='${instance['mobilePhone']}'    set to dictionary    ${r1}    mobilePhone=invalid
    #Run Keyword If    '${base['welcomeMessage']}'!='${instance['welcomeMessage']}'    set to dictionary    ${r1}    welcomeMessage=invalid
    Run Keyword If    '${base['bizId']}'!='${instance['bizId']}'    set to dictionary    ${r1}    bizId=invalid
    Run Keyword If    '${base['scope']}'!='${instance['scope']}'    set to dictionary    ${r1}    scope=invalid
    Run Keyword If    '${base['onLineState']}'!='${instance['onLineState']}'    set to dictionary    ${r1}    onLineState=invalid
    Run Keyword If    '${base['currentOnLineState']}'!='${instance['currentOnLineState']}'    set to dictionary    ${r1}    currentOnLineState=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

TenantsMeJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['tenantId']}'!='${instance['tenantId']}'    set to dictionary    ${r1}    tenantId=invalid
    Run Keyword If    '${base['organId']}'!='${instance['organId']}'    set to dictionary    ${r1}    organId=invalid
    Run Keyword If    '${base['organName']}'!='${instance['organName']}'    set to dictionary    ${r1}    organName=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

targetchannelJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['tenantName']}'!='${instance['tenantName']}'    set to dictionary    ${r1}    tenantName=invalid
    Run Keyword If    '${base['tenantAvatar']}'!='${instance['tenantAvatar']}'    set to dictionary    ${r1}    tenantAvatar=invalid
    Run Keyword If    '${base['tenantLogo']}'!='${instance['tenantLogo']}'    set to dictionary    ${r1}    tenantLogo=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

optionJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['tenantId']}'!='${instance['tenantId']}'    set to dictionary    ${r1}    tenantId=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

userSpecifiedQueueIdJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['tenantId']}'!='${instance['tenantId']}'    set to dictionary    ${r1}    tenantId=invalid
    Run Keyword If    '${base['optionName']}'!='${instance['optionName']}'    set to dictionary    ${r1}    optionName=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}

qualityreviewJsonDiff
    [Arguments]    ${base}    ${instance}
    #比较基准json和返回json里的关键变量是否一致
    &{r1}    create dictionary    ValidJson=${true}
    Run Keyword If    '${base['tenantId']}'!='${instance['tenantId']}'    set to dictionary    ${r1}    tenantId=invalid
    Run Keyword If    '${base['optionName']}'!='${instance['optionName']}'    set to dictionary    ${r1}    optionName=invalid
    ${l1}    Get Length    ${r1}
    log    ${r1}
    Run Keyword If    ${l1}>1    set to dictionary    ${r1}    ValidJson=${false}
    Return From Keyword    ${r1}
