*** Settings ***
Force Tags        Conversation
Library           requests
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Resource          ../Common/BaseCommon.robot
Resource          ../Variable.robot
Resource          ../Common/CollectionCommon/Setup/SetupCommon.robot
Resource          ../Common/CollectionCommon/Setup/TestSetupCommon.robot
Resource          ../Common/AgentMode/ConversationCommon/ConversationCommon.robot

*** Variables ***

*** Test Cases ***
进入到进行中会话页面
    [Documentation]    【操作步骤】：
    ...    - Step1、登录成功后，自动进入到进行中会话页面
    ...
    ...    【预期结果】：
    ...    页面如预期进入到进行中页面
    #获取元素值
    ${tvTabTitleConversationElement}    set variable    ${ConversationPageResDic.tv_tab_title_conversation.element}
    #进入到进行中页面
    Enter Specified PageModel
    #多次判断会话按钮是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Enabled    ${tvTabTitleConversationElement}
    should be true    ${status}    启动异常，页面在10秒中没有进入到会话页面
    Comment    Start Activity    ${appPackage}    com.easemob.helpdesk.activity.history.HistoryChatActivity
    Comment    Start Activity    ${appPackage}    ${appPackage}.mvp.AgentChatActivity
    Comment    Start Activity    ${appPackage}    ${appPackage}.activity.agent.AgentProfileActivity
    ${activity}    Get Activity
    log    ${activity}

修改坐席状态
    [Documentation]    【操作步骤】：
    ...    - Step1、页面自动切入到进行中会话页面
    ...    - Step2、点击头像按钮
    ...    - Step3、点击切换坐席状态按钮
    ...    - Step4、点击确定按钮
    ...
    ...    【预期结果】：
    ...    状态可以被修改成功
    #获取元素值
    ${ivAvatarElement}    set variable    ${AvatarPageResDic.iv_avatar.element}    #头像按钮
    ${tvStatusElement}    set variable    ${AvatarPageResDic.tv_status.element}    #坐席状态按钮
    ${outMostContainerElement}    set variable    ${AvatarPageResDic.outmost_container.element}    #切换状态：空闲、忙碌、离开、隐身
    ${tvSaveElement}    set variable    ${AvatarPageResDic.tv_save.element}    #状态确认按钮
    #进入到进行中页面
    Enter Specified PageModel
    #点击头像按钮
    Click Object Element    ${ivAvatarElement}
    #点击坐席状态按钮
    Click Object Element    ${tvStatusElement}
    #设置页面多次滑动，找到登出按钮
    Comment    ${status}    Find Element Swipe With Status    ${outMostContainerElement}
    Comment    should be true    ${status}    多次滑动后，指定的元素在页面中没有查看到
    #点击切换坐席状态确定按钮
    Click Object Element    ${tvSaveElement}

会话自动调度
    [Documentation]    【操作步骤】：
    ...    - Step1、页面自动切入到进行中会话页面
    ...    - Step2、创建一个坐席所在技能组的会话
    ...    - Step3、会话会自动调度到坐席的进行中页面
    ...
    ...    【预期结果】：
    ...    会话可以在进行中会话页面看到新会话
    #获取元素值
    ${listItemLayoutElement}    set variable    ${ConversationPageResDic.list_item_layout.element}    #进行中会话的会话
    #进入到进行中页面
    Enter Specified PageModel
    #创建新会话
    ${session}    Create Wait Conversation Specific QueueName    ${AdminUser}    app    ${kefuAppAgentInfo}
    ${userName}    set variable    ${session.userName}
    #多次判断指定元素是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Visible    ${listItemLayoutElement}
    should be true    ${status}    会话没有自动调度到进行中会话列表，查看对应会话元素不存在
    #查看会话列表包含访客名称
    ${status}    Repeat Assert Keyword Times    Page Should Contain Text    ${userName}
    should be true    ${status}    会话没有自动调度到进行中会话列表

会话自动调度-客服发送消息
    [Documentation]    【操作步骤】：
    ...    - Step1、页面自动切入到进行中会话页面
    ...    - Step2、创建一个坐席所在技能组的会话
    ...    - Step3、会话会自动调度到坐席的进行中页面
    ...    - Step4、点击该新会话，进入到聊天窗口
    ...    - Step5、文本输入框中输入消息，并点击发送
    ...
    ...    【预期结果】：
    ...    会话可以在进行中会话页面看到新会话，并坐席发消息成功上屏
    #获取元素值
    ${listItemLayoutElement}    set variable    ${ConversationPageResDic.list_item_layout.element}    #进行中会话的会话
    ${conversationNicknameElement}    set variable    ${ConversationPageResDic.conversation_nickname.element}    #会话列表的昵称一行
    ${msgetChatElement}    set variable    ${ChatPageResDic.et_chat.element}    #消息输入框
    ${msgbtnSendElement}    set variable    ${ChatPageResDic.btn_send.element}    #消息输入框
    #进入到进行中页面
    Enter Specified PageModel
    #创建新会话
    ${session}    Create Wait Conversation Specific QueueName    ${AdminUser}    app    ${kefuAppAgentInfo}
    ${userName}    set variable    ${session.userName}
    #多次判断指定元素是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Visible    ${listItemLayoutElement}
    should be true    ${status}    会话没有自动调度到进行中会话列表，查看对应会话元素不存在
    #查看会话列表包含访客名称
    ${status}    Repeat Assert Keyword Times    Page Should Contain Text    ${userName}
    should be true    ${status}    会话没有自动调度到进行中会话列表
    #替换元素中的变量
    ${nicknameElement}    evaluate    "${conversationNicknameElement}" % ('${userName}')
    log    ${nicknameElement}
    #点击新会话列表
    Click Object Element    ${nicknameElement}
    #点击消息输入框
    Input Object Text    ${msgetChatElement}    agent send kefusdk msg
    #点击消息发送按钮
    Click Object Element    ${msgbtnSendElement}
