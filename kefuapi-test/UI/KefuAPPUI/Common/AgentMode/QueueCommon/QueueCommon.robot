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
Go To Queue
    [Documentation]    切入到待接入页面
    #点击待接入按钮
    Click Object Element    ${QueuePageResDic.tv_tab_title_queue.element}
