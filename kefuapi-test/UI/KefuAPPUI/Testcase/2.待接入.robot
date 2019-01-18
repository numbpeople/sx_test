*** Settings ***
Force Tags        Queue
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
Resource          ../Common/AgentMode/QueueCommon/QueueCommon.robot

*** Test Cases ***
待接入中查看新会话
    [Documentation]    【操作步骤】：
    ...    - Step1、页面自动切入到待接入页面
    ...    - Step2、创建一个新技能组中待接入的会话
    ...
    ...    【预期结果】：
    ...    待接入中可以看到该新会话，并看到待接入未读会话数
    #获取元素值
    ${tvBabTitleQueueElement}    set variable    ${QueuePageResDic.tv_tab_title_queue.element}    #待接入按钮
    ${rtvMsgTipElement}    set variable    ${QueuePageResDic.rtv_msg_tip.element}    #待接入会话未读数提示
    #进入到待接入页面
    Enter Specified PageModel
    #创建待接入会话
    Create Wait Conversation    app
    #多次判断指定元素是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Visible    ${rtvMsgTipElement}
    should be true    ${status}    待接入列表没有看到新会话未读消息数
    #获取待接入新会话数
    ${queueCount}    get text    ${rtvMsgTipElement}
    #判断待接入会话总数是否大于等于1
    Should Be True    ${queueCount} >= 1    待接入没有新会话进入
    ${activity}    Get Activity
    log    ${activity}
