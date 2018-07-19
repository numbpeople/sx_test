*** Settings ***
Library           unittest
Library           requests
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Library           mode.py
Resource          env.robot
Resource          ../../../api/BaseApi/Note/NoteApi.robot
Resource          ../../../AgentRes.robot

*** Test Cases ***
startdemo
    [Documentation]    1、关闭所有demo
    ...    2、启动客服demo
    Comment    关闭所有app
    Close All Applications
    Comment    启动客服访客端app
    ${REMOTE_URL}    set variable    http://127.0.0.1:4723/wd/hub
    ${PLATFORM_NAME}    set variable    Android
    ${PLATFORM_VERSION}    set variable    4.4.
    ${DEVICE_NAME}    set variable    127.0.0.1:62001
    ${appPackage}    set variable    com.easemob.helpdeskdemo
    ${appActivity}    set variable    com.easemob.helpdeskdemo.ui.MainActivity
    Open Application    ${REMOTE_URL}    alias=myapp1    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    appPackage=${appPackage}
    ...    appActivity=${appActivity}
    ${width}    Get Window Width
    ${height}    Get Window Height
    set global variable    ${width}
    set global variable    ${height}

affirm_shop
    [Documentation]    1、进入商城
    ...    2、查找最上端显示名称
    ...    3、点击两次技能组按钮
    ...    4、确认商品列表中有四个商品
    go_shop
    Comment    最上端显示名称
    Element Should Be Enabled    //android.widget.ImageView
    Comment    指定技能组按钮
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/textview_customer
    Comment    商品列表
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/ib_shop_imageone
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/ib_shop_imagetwo
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/ib_shop_imagethree
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/ib_shop_imagefour

commodity_details
    [Documentation]    点击进入商品详情页面
    Comment    点击商品进入详情页面
    Click Element    com.easemob.helpdeskdemo:id/ib_shop_imagetwo
    Comment    向下滑动屏幕
    swipe_down
    Comment    确认详情
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/iv_buy_part1
    Element Should Be Enabled    com.easemob.helpdeskdemo:id/iv_buy_part2

contact_services
    [Documentation]    1、联系客服
    ...    2、点击发送商品连接
    ...    3、等待客服回复消息
    Comment    点击联系客服
    Click Element    //android.widget.TextView[@text='Connect to Customer Service']
    Comment    点击发送商品
    Click Element    com.easemob.helpdeskdemo:id/button_send
    Wait Until Element Is Visible    //android.widget.RelativeLayout[@index=1]    timeout=2
    Comment    清空聊天记录
    clean_chat_records
    Comment    返回主界面
    Go back
    Go back

skill_groups_button
    [Documentation]    1、点击技能组按钮
    ...    2、进入售前技术组发送消息
    ...    3、进入售后技术组发送消息
    Comment    点击技能组按钮，会有售前和售后选项
    Click Element    com.easemob.helpdeskdemo:id/textview_customer
    sleeps    1
    Comment    点击进入售前选项
    click a point    460    90
    Comment    等待出现清空按钮出现
    Wait Until Element Is Visible    com.easemob.helpdeskdemo:id/right_layout
    Input Text    com.easemob.helpdeskdemo:id/et_sendmessage    This is previous sales skill groups
    Click Element    com.easemob.helpdeskdemo:id/btn_send
    Wait Until Element Is Visible    //android.widget.TextView[@text='This is previous sales skill groups']
    clean_chat_records
    Go back
    Wait Until Element Is Visible    com.easemob.helpdeskdemo:id/textview_customer
    Click Element    com.easemob.helpdeskdemo:id/textview_customer
    sleeps    1
    Comment    点击进入售后选项
    click a point    460    170
    Comment    等待出现清空按钮出现
    Wait Until Element Is Visible    com.easemob.helpdeskdemo:id/right_layout
    Input Text    com.easemob.helpdeskdemo:id/et_sendmessage    This is after sales skill groups
    Click Element    com.easemob.helpdeskdemo:id/btn_send
    Wait Until Element Is Visible    //android.widget.TextView[@text='This is after sales skill groups']
    clean_chat_records
    Go back

t
    [Documentation]    1、点击技能组按钮
    ...    2、进入售前技术组发送消息
    ...    3、进入售后技术组发送消息
    log    ${RestEntity}
    log    ${AdminUser}
    ${resp}=    /tenants/{tenantId}/projects    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    set global variable    ${projectId}    ${j['entities'][0]['id']}
