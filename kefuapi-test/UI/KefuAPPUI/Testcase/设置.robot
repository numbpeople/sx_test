*** Settings ***
Force Tags
Library           requests
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Resource          ../Variable.robot
Resource          ../Common/BaseCommon.robot
Resource          ../Common/CollectionCommon/Setup/SetupCommon.robot

*** Test Cases ***
进入设置页面-登出操作
    [Documentation]    【操作步骤】：
    ...    - Step1、页面自动切入到设置页面
    ...    - Step2、滑动到最底部，点击登出按钮
    ...
    ...    【预期结果】：
    ...    客户端app可以被登出成功
    #获取元素值
    ${ivAvatarElement}    set variable    ${ConversationPageResDic.iv_avatar.element}
    ${slidingMenuSettingItemElement}    set variable    ${SettingPageResDic.slidingmenu_settingItem.element}
    ${agentProfileLogoutElement}    set variable    ${SettingPageResDic.agentprofile_logout.element}
    ${btnLoginElement}    set variable    ${LoginPageResDic.btnLogin.element}
    #进入到设置页面
    Enter Specified PageModel    Setting
    #设置页面多次滑动，找到登出按钮
    ${status}    Find Element Swipe    ${agentProfileLogoutElement}
    should be true    ${status}    多次滑动后，指定的元素在页面中没有查看到
    #点击登出按钮
    Click Object Element    ${agentProfileLogoutElement}
    #多次判断登录按钮是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Enabled    ${btnLoginElement}
    should be true    ${status}    启动异常，登录按钮页面中没有查看到
