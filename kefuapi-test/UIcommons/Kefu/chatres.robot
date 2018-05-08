*** Settings ***
Resource          ../Utils/baseUtils.robot
Resource          ../../commons/agent common/Queue/Queue_Common.robot
Resource          ../../commons/agent common/Conversations/Conversations_Common.robot

*** Variables ***
${chatbasejson}    {"navigator":{"Agent":{"uri":"/mo/agent/webapp/sessions/chat","GrayKey":"base","ResourceKey":"agent_currentsession"}},"elements":[{"name":"header","xPath":"//*[@id='em-chat']/header/h1","text":{"zh_CN":"会话","en_US":"Conversations"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]},{"name":"maxnumberlabel","xPath":"//*[@id='em-chat']/header/div[2]/label","text":{"zh_CN":"最大接待人数","en_US":"Maximum conversations"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}
${chatlistlistr}    '{"elements":[{"name":"li","xPath":"//*[@id=\\'em-chat\\']/div[1]/div/div[1]/div/div[3]/ul/li[%d]","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[{"name":"class","value":{"zh_CN":"em-chat-itm-visitor%s%s","en_US":"em-chat-itm-visitor%s%s"}}],"elements":[{"name":"sourcespan","xPath":"/div[1]/span","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[{"name":"class","value":{"zh_CN":"channel-source-%s","en_US":"channel-source-%s"}}],"elements":[]},{"name":"visitorp","xPath":"/div[2]/p[1]","text":{"zh_CN":"%s","en_US":"%s"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}]}'
${chattest}       {"navigator":{"Admin":{"uri":"/mo/admin/webapp/current","ShowKey":"base"}},"elements":[{"name":"header","xPath":".//*[@id='em-session']/header/h1","text":{"zh_CN":"当前会话","en_US":"Ongoing"},"op":"show","attributes":[],"elements":[]},{"name":"filterspan","xPath":"//*[@id='em-session']/header/span[2]","text":{"zh_CN":"","en_US":""},"op":"show","attributes":[{"name":"name","value":{"zh_CN":"filter","en_US":"filter"}}],"elements":[{"name":"filtericon","xPath":"//*[@id='em-session']/header/span[2]/span[1]","text":{"zh_CN":"","en_US":""},"op":"show","attributes":[],"elements":[]},{"name":"filter","xPath":"//*[@id='em-session']/header/span[2]/span[2]","text":{"zh_CN":"筛选排序","en_US":"Sort"},"op":"show","attributes":[],"elements":[]}]},{"name":"refreshspan","xPath":"//*[@id='em-session']/header/span[1]","text":{"zh_CN":"","en_US":""},"op":"show","attributes":[{"name":"name","value":{"zh_CN":"refresh","en_US":"refresh"}}],"elements":[{"name":"refreshtextspan","xPath":"//*[@id='em-session']/header/span[1]/span","text":{"zh_CN":"刷新","en_US":"Refresh"},"op":"show","attributes":[],"elements":[]}]}]}
@{chatlistliclassattributes}    ' noAnswer'    ' selected'
${maxcallinselectorstr}    '{"elements":[{"name":"div","xPath":"//*[@id=\\'em-chat\\']/header/div[2]/div","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[{"name":"class","value":{"zh_CN":"ui-cmp-select white small%s","en_US":"ui-cmp-select white small%s"}}],"elements":[{"name":"numselectorspan","xPath":"/span","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[{"name":"class","value":{"zh_CN":"ui-cmp-selectbar","en_US":"ui-cmp-selectbar"}},{"name":"title","value":{"zh_CN":"%d","en_US":"%d"}},{"name":"selval","value":{"zh_CN":"%d","en_US":"%d"}}],"elements":[{"name":"numselectorspanlabel","xPath":"/label","text":{"zh_CN":"%d","en_US":"%d"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}]}]}'
${maxcallinlistr}    '{"elements":[{"name":"li","xPath":"/html/body/ul[1]/li[%d]","text":{"zh_CN":"","en_US":""},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[{"name":"class","value":{"zh_CN":"ui-itm-select","en_US":"ui-itm-select"}}],"elements":[{"name":"label","xPath":"/label","text":{"zh_CN":"%d","en_US":"%d"},"op":"show","opjson":"","GrayKey":"base","ResourceKey":"base","attributes":[],"elements":[]}]}]}'
@{actviedattributes}    ''    ' activated'

*** Keywords ***
chat smoketest case 
    [Arguments]    ${agent}
    set test variable    ${maxnum}    1
    #设置状态为在线，接待数为1
    ${j}    Set Agent Status    ${agent}    ${kefustatus[0]}
    ${j}    Set Agent MaxServiceUserNumber    ${agent}    ${maxnum}
    #跳转到进行中会话页面并检查页面元素
    switch browser    ${agent.session}
    goto and checkchatebasejson    ${agent}
    #格式化昵称状态字符串并检查基本元素
    #默认状态ul属性为hide，状态li无属性
    @{p}    create List    '${agent.nicename}'    ${elementstatelist[4]}    ${elementstatelist[0]}    ${elementstatelist[0]}    ${elementstatelist[0]}
    ...    ${elementstatelist[0]}
    ${jbase}    Format String To Json    format avatarloginstatstr    @{p}
    Check Base Elements    ${agent.language}    ${jbase['elements']}
    #点击弹出状态选择列表，格式化状态列表字符串并检查基本元素
    click element    xpath=${jbase['elements'][0]['xPath']}
    #点击 后状态ul无属性，在线状态li为selected
    @{p}    create List    '${agent.nicename}'    ${elementstatelist[0]}    ${elementstatelist[2]}    ${elementstatelist[0]}    ${elementstatelist[0]}
    ...    ${elementstatelist[0]}
    Format String And Check Elements    ${agent}    format avatarloginstatstr    @{p}
    #格式化最大接待人数字符串并检查基本元素
    @{p}    create List    ${elementstatelist[0]}    ${maxnum}
    Format String And Check Elements    ${agent}    format maxcallinselectorstr    @{p}

format chatlistlistr
    [Arguments]    ${liindex}    ${origintype}    ${visitorname}    ${noanswer}    ${selected}
    [Documentation]    ${i}为li的序号，如li1，li2
    ${s}    evaluate    ${chatlistlistr} % (${liindex},${noanswer},${selected},${noanswer},${selected},'${origintype}','${origintype}','${visitorname}','${visitorname}')
    [Return]    ${s}

format maxcallinselectorstr
    [Arguments]    ${actived}    ${num}
    ${s}    evaluate    ${maxcallinselectorstr} % (${actived},${actived},${num},${num},${num},${num},${num},${num})
    return from keyword    ${s}

format maxcallinlistr
    [Arguments]    ${selectednum}
    ${linum}    evaluate    ${selectednum}+1
    ${s}    evaluate    ${maxcallinlistr} % (${linum},${selectednum},${selectednum})
    return from keyword    ${s}

goto and checkchatebasejson
    [Arguments]    ${agent}
    Check Base Module    ${kefuurl}    ${agent}    ${chatbasejson}

Set MaxServiceUserNumber By UI
    [Arguments]    ${MaxServiceUserNumber}
    [Documentation]    参数说明：
    ...    ${MaxServiceUserNumber}:需要设置的最大接待数
    #点击最大接待数显示位置
    @{p}    create List    ${elementstatelist[0]}    0
    ${jbase}    Format String To Json    format maxcallinselectorstr    @{p}
    click element    xpath=${jbase['elements'][0]['xPath']}
    #弹出的界面中选择对应数字的接待数
    @{p}    create List    ${MaxServiceUserNumber}
    ${jbase}    Format String To Json    format maxcallinlistr    @{p}
    click element    xpath=${jbase['elements'][0]['xPath']}

Set AgentStatus By UI
    [Arguments]    ${agent}    ${statusindex}
    [Documentation]    参数说明：
    ...    ${MaxServiceUserNumber}:需要设置的最大接待数，从0开始（Online），1（Busy）...
    @{p}    create List    '${agent.nicename}'    ${elementstatelist[4]}    ${elementstatelist[0]}    ${elementstatelist[0]}    ${elementstatelist[0]}
    ...    ${elementstatelist[0]}
    ${jbase}    Format String To Json    format avatarloginstatstr    @{p}
    #点击弹出状态选择列表后，再点击选择状态
    set test variable    ${basexpath}    ${jbase['elements'][0]['xPath']}
    set test variable    ${ulxpath}    ${jbase['elements'][0]['elements'][1]['xPath']}
    set test variable    ${lixpath}    ${jbase['elements'][0]['elements'][1]['elements'][${statusindex}]['xPath']}
    click element    xpath=${basexpath}
    click element    xpath=${basexpath}${ulxpath}${lixpath}

Session In Waitings And Not In Visitors By Specified Time
    [Arguments]    ${agent}    ${filter}    ${range}    ${specifiedtime}    ${visitorname}
    #检查结果
    sleep    ${specifiedtime}
    Session In Waitings    ${agent}    ${filter}    ${range}
    Session Not In Visitors    ${agent}    ${visitorname}

Session In Waitings
    [Arguments]    ${agent}    ${filter}    ${range}
    #检查结果
    ${j}    Get Waiting    ${agent}    ${filter}    ${range}
    Should Be True    ${j['totalElements']} ==1    查询结果为空：${j}
    #获取进行中会话列表

Session Not In Visitors
    [Arguments]    ${agent}    ${visitorname}
    #获取会话对应的会话
    ${j}    Get Processing Session    ${agent}
    should not contain    ${j}    ${visitorname}    接口返回结果不为空

Clear Agent All Sessions
    [Arguments]    ${agent}    ${filter}    ${range}
    #检查结果
    Stop All Processing Conversations    ${agent}
    Stop Specified Sessions In Waitings    ${agent}    ${filter}    ${range}

AutoSchedule Case
    [Arguments]    ${Admin}    ${agent}    ${serviceSessionPreScheduleEnable}    ${scheduleOnDutyOnlyEnable}    ${WorkState}    ${EnableSchedule}
    [Documentation]    参数说明：
    ...    ${Admin}:管理员，用来设置各接口
    ...    ${agent}:测试坐席，可为管理员或坐席
    ...    ${serviceSessionPreScheduleEnable}:是否开启预调度，只能为小写的false或true，不能加引号
    ...    ${scheduleOnDutyOnlyEnable}:是否开启仅上班调度，只能为小写的false或true，不能加引号
    ...    ${WorkState}:设置上班或下班，只能为小写的on或off，不能加引号
    ...    ${EnableSchedule}:是否能调度，只能是${true}或${false}
    #是否开启预调度
    Set Option    ${Admin}    serviceSessionPreScheduleEnable    ${serviceSessionPreScheduleEnable}
    #开关打开是仅上班调度
    Set Option    ${Admin}    scheduleOnDutyOnlyEnable    ${scheduleOnDutyOnlyEnable}
    #设置上下班
    Set Worktime Ext    ${WorkState}    ${Admin}    ${timeScheduleId}
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${agent}
    #步骤7：发送消息，并指定到新技能组
    ${guest}    Generate Uuidguest    app
    Send Uuidmsg By Specified Queue    ${restentity}    ${guest}    ${suitequeue.queueName}
    #设置筛选条件：
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guest.userName}    page=0
    #检查会话进入进行中：格式化会话列表json并检查ui
    @{p}    create list    1    ${guest.originType}    ${guest.userName}    ${elementstatelist[1]}    ${elementstatelist[2]}
    Run Keyword If    ${EnableSchedule}    Format String And Check Elements    ${agent}    format chatlistlistr    @{p}
    ...    ELSE    Session In Waitings And Not In Visitors By Specified Time    ${agent}    ${filter}    ${range}    3
    ...    ${guest.userName}
    [Teardown]    Clear Agent All Sessions    ${agent}    ${filter}    ${range}

KeepaliveSchedule By Change MaxServiceUserNumber Case
    [Arguments]    ${Admin}    ${agent}    ${serviceSessionPreScheduleEnable}    ${scheduleOnDutyOnlyEnable}    ${WorkState}    ${EnableSchedule}
    [Documentation]    参数说明：
    ...    ${Admin}:管理员，用来设置各接口
    ...    ${agent}:测试坐席，可为管理员或坐席
    ...    ${serviceSessionPreScheduleEnable}:是否开启预调度，只能为小写的false或true，不能加引号
    ...    ${scheduleOnDutyOnlyEnable}:是否开启仅上班调度，只能为小写的false或true，不能加引号
    ...    ${WorkState}:设置上班或下班，只能为小写的on或off，不能加引号
    ...    ${EnableSchedule}:是否能调度，只能是${true}或${false}
    ...    ${EnableSchedule}:是否能调度，只能是${true}或${false}
    Set Agent MaxServiceUserNumber    ${agent}    0
    #是否开启预调度
    Set Option    ${Admin}    serviceSessionPreScheduleEnable    ${serviceSessionPreScheduleEnable}
    #开关打开是仅上班调度
    Set Option    ${Admin}    scheduleOnDutyOnlyEnable    ${scheduleOnDutyOnlyEnable}
    #设置上下班
    Set Worktime Ext    ${WorkState}    ${Admin}    ${timeScheduleId}
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${agent}
    #步骤7：发送消息，并指定到新技能组
    ${guest}    Generate Uuidguest    app
    Send Uuidmsg By Specified Queue    ${restentity}    ${guest}    ${suitequeue.queueName}
    #设置筛选条件并搜索待接入：
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guest.userName}    page=0
    Session Should Be In Watings    ${agent}    ${filter}    ${range}
    sleep    1
    Set MaxServiceUserNumber By UI    1
    @{p}    create list    1    ${guest.originType}    ${guest.userName}    ${elementstatelist[1]}    ${elementstatelist[2]}
    Run Keyword If    ${EnableSchedule}    Format String And Check Elements    ${agent}    format chatlistlistr    @{p}
    ...    ELSE    Session In Waitings And Not In Visitors By Specified Time    ${agent}    ${filter}    ${range}    3
    ...    ${guest.userName}
    [Teardown]    Clear Agent All Sessions    ${agent}    ${filter}    ${range}

KeepaliveSchedule By Change Status Case
    [Arguments]    ${Admin}    ${agent}    ${status}    ${serviceSessionPreScheduleEnable}    ${scheduleOnDutyOnlyEnable}    ${WorkState}
    ...    ${EnableSchedule}
    [Documentation]    参数说明：
    ...    ${Admin}:管理员，用来设置各接口
    ...    ${agent}:测试坐席，可为管理员或坐席
    ...    ${serviceSessionPreScheduleEnable}:是否开启预调度，只能为小写的false或true，不能加引号
    ...    ${scheduleOnDutyOnlyEnable}:是否开启仅上班调度，只能为小写的false或true，不能加引号
    ...    ${WorkState}:设置上班或下班，只能为小写的on或off，不能加引号
    ...    ${EnableSchedule}:是否能调度，只能是${true}或${false}
    Set Agent Status    ${agent}    ${status}
    #是否开启预调度
    Set Option    ${Admin}    serviceSessionPreScheduleEnable    ${serviceSessionPreScheduleEnable}
    #开关打开是仅上班调度
    Set Option    ${Admin}    scheduleOnDutyOnlyEnable    ${scheduleOnDutyOnlyEnable}
    #设置上下班
    Set Worktime Ext    ${WorkState}    ${Admin}    ${timeScheduleId}
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${agent}
    #步骤7：发送消息，并指定到新技能组
    ${guest}    Generate Uuidguest    app
    Send Uuidmsg By Specified Queue    ${restentity}    ${guest}    ${suitequeue.queueName}
    #设置筛选条件并搜索待接入：
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guest.userName}    page=0
    Session Should Be In Watings    ${agent}    ${filter}    ${range}
    sleep    1
    Set AgentStatus By UI    ${agent}    0
    @{p}    create list    1    ${guest.originType}    ${guest.userName}    ${elementstatelist[1]}    ${elementstatelist[2]}
    #检查是否进行中有会话，或者会话停留在进行中
    Run Keyword If    ${EnableSchedule}    Format String And Check Elements    ${agent}    format chatlistlistr    @{p}
    ...    ELSE    Session In Waitings And Not In Visitors By Specified Time    ${agent}    ${filter}    ${range}    3
    ...    ${guest.userName}
    [Teardown]    Clear Agent All Sessions    ${agent}    ${filter}    ${range}

Specify Agent AutoSchedule Case
    [Arguments]    ${Admin}    ${agent}    ${serviceSessionPreScheduleEnable}    ${MaxServiceUserNumber}
    [Documentation]    参数说明：
    ...    ${Admin}:管理员，用来设置各接口
    ...    ${agent}:测试坐席，可为管理员或坐席
    ...    ${serviceSessionPreScheduleEnable}:是否开启预调度，只能为小写的false或true，不能加引号
    ...    ${MaxServiceUserNumber}:接待数，0关闭调度，1开启调度
    #设置接待数
    Set Agent MaxServiceUserNumber    ${agent}    ${MaxServiceUserNumber}
    #关闭预调度排队
    Set Option    ${Admin}    serviceSessionJudgeOverloadEnable    false
    #是否开启预调度
    Set Option    ${Admin}    serviceSessionPreScheduleEnable    ${serviceSessionPreScheduleEnable}
    #设置为全天调度开关打开是仅上班调度
    Set Option    ${Admin}    scheduleOnDutyOnlyEnable    false
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${agent}
    #步骤7：发送消息，并指定坐席
    ${guest}    Generate Uuidguest    app
    Send Uuidmsg By Specified Agent    ${restentity}    ${guest}    ${agent.username}
    #设置筛选条件：
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guest.userName}    page=0
    #检查会话进入进行中：格式化会话列表json并检查ui
    @{p}    create list    1    ${guest.originType}    ${guest.userName}    ${elementstatelist[1]}    ${elementstatelist[2]}
    Format String And Check Elements    ${agent}    format chatlistlistr    @{p}
    [Teardown]    Clear Agent All Sessions    ${agent}    ${filter}    ${range}

Specify Agent KeepaliveSchedule Case
    [Arguments]    ${Admin}    ${agent}    ${serviceSessionPreScheduleEnable}
    [Documentation]    参数说明：
    ...    ${Admin}:管理员，用来设置各接口
    ...    ${agent}:测试坐席，可为管理员或坐席
    ...    ${serviceSessionPreScheduleEnable}:是否开启预调度，只能为小写的false或true，不能加引号
    ...    ${MaxServiceUserNumber}:接待数，0关闭调度，1开启调度
    #设置接待数
    Set Agent MaxServiceUserNumber    ${agent}    0
    #关闭预调度排队
    Set Option    ${Admin}    serviceSessionJudgeOverloadEnable    true
    #是否开启预调度
    Set Option    ${Admin}    serviceSessionPreScheduleEnable    ${serviceSessionPreScheduleEnable}
    #设置为全天调度开关打开是仅上班调度
    Set Option    ${Admin}    scheduleOnDutyOnlyEnable    false
    #跳转到进行中会话页面并确认页面加载完毕
    goto and checkchatebasejson    ${agent}
    #步骤7：发送消息，并指定坐席
    ${guest}    Generate Uuidguest    app
    Send Uuidmsg By Specified Agent    ${restentity}    ${guest}    ${agent.username}
    #设置筛选条件并搜索待接入，确认会话指定时间内未被调度：
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    set to dictionary    ${filter}    visitorName=${guest.userName}    page=0
    Session In Waitings And Not In Visitors By Specified Time    ${agent}    ${filter}    ${range}    3    ${guest.userName}
    #设置接待人数为1，可接待状态
    Set MaxServiceUserNumber By UI    1
    #检查会话进入进行中：格式化会话列表json并检查ui
    @{p}    create list    1    ${guest.originType}    ${guest.userName}    ${elementstatelist[1]}    ${elementstatelist[2]}
    Format String And Check Elements    ${agent}    format chatlistlistr    @{p}
    [Teardown]    Clear Agent All Sessions    ${agent}    ${filter}    ${range}
