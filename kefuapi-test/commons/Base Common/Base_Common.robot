*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/InitApi.robot
Resource          ../Initializtion_Common/Initializtion_Common.robot
Resource          ../admin common/Channels/Phone_Common.robot

*** Keywords ***
Get Option Value
    [Arguments]    ${agent}    ${optionname}
    ${resp}=    /tenants/{tenantId}/options/{optionName}    ${agent}    get    ${optionname}    ${empty}    ${timeout}
    return from Keyword if    ${resp.status_code}==404    false
    ${j}    to json    ${resp.text}
    Return from Keyword    ${j['data'][0]['optionValue']}

Repeat Keyword Times
    [Arguments]    ${functionName}    ${expectConstruction}    ${expectValue}    @{paramList}
    [Documentation]    重试调用接口多次，判断结果是否包含预期的值，包含则返回结果，否则返回{}
    ...
    ...    【参数值】：
    ...    - ${functionName} ，代表接口封装后的关键字
    ...    - ${expectConstruction} ，接口返回值中应取的字段结构
    ...    - ${expectValue} ，获取接口某字段的预期值
    ...    - @{paramList}，接口封装后所需要传入的参数值
    ...
    ...    【返回值】：
    ...    - 调用${functionName}接口，返回结果中，匹配${expectConstruction}字段结构，值等于${expectValue}的数据结构
    : FOR    ${i}    IN RANGE    ${retryTimes}
    \    ${j}    run keyword    ${functionName}    @{paramList}
    \    #适配最新的返回结构，获取返回值
    \    ${status}    Run Keyword And Return Status    Dictionary Should Contain Key    ${j}    statusCode
    \    run keyword if    ${status}    Set Suite Variable    ${j}    ${j.text}
    \    #返回结果为空，则进入下次循环
    \    Continue For Loop If    "${j}" == "[]"
    \    #想要获取返回值中应取的字段结构，即${j}返回值中，获取${expectConstruction}结构的值 ，例如：${j['data'][0]}
    \    ${dataRes}    set variable    ${j${expectConstruction}}
    \    return from keyword if    "${dataRes}" == "${expectValue}"    ${j}
    \    sleep    ${delay}
    return from keyword    {}

Set Option
    [Arguments]    ${agent}    ${optionname}    ${value}
    [Documentation]    1.${optionname} \ ${value} 的值不能加引号
    ...    2.${value}的值只能为小写的true和false
    ${data}    set variable    {"value":${value}}
    ${resp}=    /tenants/{tenantId}/options/{optionName}    ${agent}    put    ${optionname}    ${data}    ${timeout}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Return Result
    [Arguments]    ${resp}
    [Documentation]    封装返回值结果
    ...
    ...    【参数值】：
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${resp} | 必填 | 接口返回的对象，其中包含请求地址、状态码、返回值 |
    ...
    ...    【返回值】
    ...    | 进行二次封装，将请求状态、请求地址、状态码、返回值进行返回：status、url、statusCode、text |
    ...
    ...    【调用方式】
    ...    | 获取进行中会话 | ${j} | Return Result | ${resp} |
    ...
    ...    【函数操作步骤】
    ...    | Step 1 | 构造返回字典，返回请求状态、请求地址、状态码、返回值：status、url、statusCode、text |
    ...    | Step 2 | 如果请求返回值为空，则返回值为空字符串 |
    #构造返回字典
    &{apiResponse}    Copy Dictionary    ${ApiResponse}
    ${text}    set variable    ${EMPTY}
    #如果返回值resp.text不为空，则设置返回值，否则text设置为空值
    ${status}    Run Keyword And Return Status    Should Not Be Equal    "${resp.text}"    "${EMPTY}"
    set to dictionary    ${apiResponse}    status=${ResponseStatus.OK}    url=${resp.url}    statusCode=${resp.status_code}    text=${text}
    Return From Keyword If    not ${status}    ${apiResponse}
    #设置请求返回值
    ${text}    to json    ${resp.text}
    set to dictionary    ${apiResponse}    status=${ResponseStatus.OK}    url=${resp.url}    statusCode=${resp.status_code}    text=${text}
    Return From Keyword    ${apiResponse}

Get GrayList
    [Arguments]    ${agent}=${AdminUser}
    [Documentation]    获取灰度列表，包括增值功能和开关设置
    #获取灰度列表信息并保存
    ${j}    Get Tenant GrayLists    ${agent}
    #base加入灰度默认值中
    @{graylist}    Create List    base
    #添加所有灰度name到graylist
    : FOR    ${i}    IN    @{j['entities']}
    \    Append to List    ${graylist}    ${i['grayName']}
    #添加所有控制页面显示option项为true的optionNaem到graylist
    @{optionlist}    create list    agentVisitorCenterVisible    robotOptimizationStatus    growingioEnable
    : FOR    ${i}    IN    @{optionlist}
    \    ${t}    Get Option Value    ${agent}    ${i}
    \    Run Keyword If    '${t}'=='true'    Append to List    ${graylist}    ${i}
    #获取自定义事件推送是否灰度
    ${j}    Initdata    ${agent}
    Run Keyword If    ${j['showCallback']}    Append to List    ${graylist}    showCallback
    #获取呼叫中心是否灰度
    ${j}    Get PhoneTechChannel    ${agent}
    Run Keyword If    "${j}" != "[]"    Append to List    ${graylist}    phone
    log    ${graylist}
    set global variable    ${tenantGrayList}    ${graylist}

Check Tenant Gray Status
    [Arguments]    ${grayName}=
    [Documentation]    检查租户增值功能或灰度功能的状态
    ...
    ...    【参数值】
    ...    | 参数名 | 是否必填 | 参数含义 |
    ...    | ${grayName} | 选填 | 灰度名称，例如：audioVideo |
    ...
    ...    【返回值】
    ...    | 根据测试用例的tag名或根据增值功能名称，判断功能增值开通状态。开通返回True，未开通返回False |
    ...
    ...    【调用方式】
    ...    | 获取租户的增值功能状态 | ${status} | Check Tenant Gray Status |
    ...    | 获取音视频增值功能状态 | ${status} | Check Tenant Gray Status | audioVideo |
    ...    | 判断是否执行测试用例 | Pass Execution If | not ${status} | 该租户未开通增值功能，不执行 |
    ...
    ...    【增值功能开关】
    ...    | 灰度名称 | 灰度功能描述 |
    ...    | teamOverflow | 技能组溢出 |
    ...    | marketing | 自动消息 |
    ...    | audioToMsg | 语音转文字 |
    ...    | slack | slack渠道 |
    ...    | rest | rest api |
    ...    | webChannelConfigEnable | 网页插件配置 |
    ...    | agentInputStateEnable | 旗舰-坐席输入状态 |
    ...    | reganswer | 关键词匹配 |
    ...    | statsReport | 自定义报表 |
    ...    | isAllowedMax | 坐席最大接待数 |
    ...    | historyNoTimeLimit | 历史消息不限 |
    ...    | msgRecall | 旗舰-消息撤回 |
    ...    | ticket | 工单 |
    ...    | waitListNumberEnable | 旗舰-显示排队人数 |
    ...    | msgPredictEnable | 旗舰-坐席消息预知 |
    ...    | audioVideo | 视频客服 |
    ...    | iframeTrusted | iframe授权 |
    ...    | agentCallVisitor | 主动发起弹窗会话 |
    ...    | blessbag | 红包 |
    ...    | noteCategory | 自定义留言分类 |
    ...    | callcenter | 呼叫中心 |
    ...    | voice | 客户之声 |
    ...    | iframeExParams | iframe参数传输 |
    ...    | ssocfg | 单点登录 |
    ...    | supervise | 现场监控 |
    ...    | timeplan | 时间计划 |
    ...    | dispatchTag | 根据客户标签优先分配系统规则 |
    ...    | dispatchWeibo | 根据微博用户身份优先分配系统规则 |
    ...    | questionnaireEnable | 第三方问卷调查 |
    ...    | mergerVideo | 视频合并 |
    ...    | enableCloseDefaultChat | 机器人默认设置-图片默认回复 |
    ...    | noteCreateSources | 留言筛选工单 |
    ...    | canGetHistoryTicket | 历史会话获取工单信息 |
    ...    | ticketJavaVersion | 新版工单后台 |
    ...    | ticketMultiLevelsHelptopic | 工单帮助主题支持多级分类 |
    ...    | visitorCenterImport | 管理面板-客户中心显示导入和下载模板按钮 |
    ...    | browserConfirm | 刷新页面时确认框提示 |
    ...    | customMagicEmoji | 自定义魔法表情 |
    ...    | noBlackList | 客服模式下不显示黑名单按钮 |
    ...    | whisper | 旗舰-耳语 |
    ...    | thridPartyRobot | 第三方机器人 |
    ...    | autoCreateAppointedVisitor | 网页插件访客端-根据specifiedUserName创建访客身份 |
    ...    | agentMessageInterceptorEnable | 坐席端发消息过滤（私有部署专用，忽略） |
    ...    | scheduleOrderByQueueEnable | 技能组接待优先级调度 |
    ...    | thridPartyKnowledgeBase | 第三方知识库 |
    ...    | is36kr | 36氪专用 |
    ...    | robotStatistic | 机器人统计 |
    ...    | qualityRandom | 随机质检功能 |
    ...    | historyCallbackConfirm | 回呼确认 |
    ...    | sms | 短信渠道 |
    ...    | cloneRobotKnowledge | 克隆知识规则 |
    ...    | assignAgentWhileOffline | 指定坐席不与预调度发生关系 |
    ...    | ticket30Filters | 无 |
    ...    | customUrl | 客户中心自定义字段配置接口 |
    ...    | cta | 图文消息支持采集电话号码的CTA弹层 |
    ...    | webpluginMenu | 网页访客端支持导航栏形式的信息栏设置-坐席前端 |
    ...    | chatMode | 布局上，只有聊天界面 |
    ...    | customRules | 自定义业务规则 |
    ...    | isTicketTrial | 工单使用菜单 |
    ...    | httpPolling | 使用轮询 |
    ...    | guessUSay | 我猜你想 -- 百度机器人 |
    ...    | agentVisitorCenterVisible | 坐席模式下可以查看客户中心 |
    ...    | robotOptimizationStatus | 知识规则优化 |
    ...    | growingioEnable | 全站访客统计 |
    ...    | showCallback | 自定义事件推送 |
    #控制是否执行增值功能，在文件AgentRes.robot里grayFunctionOption变量控制，判断增值功能测试用例是否执行，True即执行，False为不执行
    Return From Keyword If    ${grayFunctionOption}    True
    #获取灰度列表，包括增值功能和开关设置
    # ${j}    Get GrayList    ${agent}
    #判断指定灰度功能的灰度状态
    Run Keyword And Return If    "${grayName}" != "${EMPTY}"    Check Specific GrayName Status    ${grayName}
    #移除默认的tag设置：base
    Remove Values From List    ${TEST TAGS}    base
    ${index}    Get Index From List    ${tenantGrayList}    ${TEST TAGS[0]}
    #如果灰度列表没有该key或者option未打开，返回False，开通则返回True
    log    ${TEST TAGS[0]}
    log    ${tenantGrayList}
    log    ${index}
    Return From Keyword If    ${index}==-1    False
    Return From Keyword    True

Check Specific GrayName Status
    [Arguments]    ${grayName}
    [Documentation]    判断指定灰度功能的灰度状态
    ${specifyindex}    Get Index From List    ${tenantGrayList}    ${grayName}
    Return From Keyword If    ${specifyindex}==-1    False
    Return From Keyword    True
