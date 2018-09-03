*** Settings ***
Library           unittest
Library           requests
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Resource          env.robot
Resource          ../../../api/BaseApi/Note/NoteApi.robot
Resource          ../../../AgentRes.robot

*** Test Cases ***
mall_homepage
    [Documentation]    【操作步骤】：
    ...    - Step1、进入商城
    ...    - Step2、查找页面title
    ...    - Step3、确认存在技能组按钮
    ...    - Step4、确认商品列表中有四个商品
    ...
    ...    【预期结果】：
    ...    - Step1、可以在商品列表中找到四个商品
    go_shop
    Comment    最上端显示名称
    Element Should Be Enabled    //android.widget.ImageView
    Comment    指定技能组按钮
    Element Should Be Enabled    ${packagename}:id/textview_customer
    Comment    商品列表
    Element Should Be Enabled    ${packagename}:id/ib_shop_imageone
    Element Should Be Enabled    ${packagename}:id/ib_shop_imagetwo
    Element Should Be Enabled    ${packagename}:id/ib_shop_imagethree
    Element Should Be Enabled    ${packagename}:id/ib_shop_imagefour

commodity_details
    [Documentation]    【操作步骤】：
    ...    - Step1、点击进入商品详情页面
    ...    - Step2、获取商品的详情
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、可以获取到商品的详情页面元素
    Comment    点击商品进入详情页面
    Click Element    ${packagename}:id/ib_shop_imagetwo
    Comment    向下滑动屏幕
    swipe_down
    Comment    确认详情
    Element Should Be Enabled    ${packagename}:id/iv_buy_part1
    Element Should Be Enabled    ${packagename}:id/iv_buy_part2

contact_services
    [Documentation]    【操作步骤】：
    ...    - Step1、联系客服
    ...    - Step2、点击发送商品连接
    ...    - Step3、等待客服回复消息
    ...
    ...    【预期结果】：
    ...    - Step1、进入客服页面
    ...    - Step2、可以发送商品连接
    ...    - Step3、能够收到客服回复的消息
    Comment    点击联系客服
    Click Element    //${TextView}[@text='Connect to Customer Service']
    Comment    点击发送商品
    Click Element    ${packagename}:id/button_send
    Wait Until Element Is Visible    //${RelativeLayout}[@index=1]    ${timeout}
    Comment    清空聊天记录
    clean_chat_records
    Comment    返回主界面
    Go back
    Go back

skill_groups_button
    [Documentation]    【操作步骤】：
    ...    - Step1、点击技能组按钮
    ...    - Step2、进入售前技术组发送消息
    ...    - Step3、进入售后技术组发送消息
    ...
    ...    【预期结果】：
    ...    - Step1、可以点击到技术能组按钮；
    ...    - Step2、正常进入售前技术能组发送消息；
    ...    - Step3、正常进入售后技术能组发送消息；
    Comment    点击技能组按钮，会有售前和售后选项
    Click Element    ${packagename}:id/textview_customer
    sleeps    1
    Comment    点击进入售前选项    使用座标点击
    click a point    460    90
    Comment    等待出现清空按钮出现
    Wait Until Element Is Visible    ${packagename}:id/right_layout
    Input Text    ${packagename}:id/et_sendmessage    This is previous sales skill groups
    Click Element    ${packagename}:id/btn_send
    Wait Until Element Is Visible    //${TextView}[@text='This is previous sales skill groups']
    Go back
    Wait Until Element Is Visible    ${packagename}:id/textview_customer
    Click Element    ${packagename}:id/textview_customer
    sleeps    1
    Comment    点击进入售后选项
    click a point    460    170
    Comment    等待出现清空按钮出现
    Wait Until Element Is Visible    ${packagename}:id/right_layout    ${timeout}    未出现清空按钮
    Input Text    ${packagename}:id/et_sendmessage    This is after sales skill groups
    Click Element    ${packagename}:id/btn_send
    Wait Until Element Is Visible    //${TextView}[@text='This is after sales skill groups']    ${timeout}    找到刚发送的消息
    Go back
