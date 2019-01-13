*** Settings ***
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Library           json
Resource          ../../../Variable.robot
Resource          ../../BaseCommon.robot

*** Keywords ***
Go To Conversation
    [Documentation]    切入到进行中会话页面
    #点击会话按钮
    Click Object Element    ${ConversationPageResDic.tv_tab_title_conversation.element}
