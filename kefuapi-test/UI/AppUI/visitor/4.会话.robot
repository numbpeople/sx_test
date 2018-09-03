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
Resource          ../../../commons/admin common/Note/Note_Common.robot
Resource          ../../../commons/agent common/Conversations/Conversations_Common.robot

*** Test Cases ***
conversation_detail
    [Documentation]    【操作步骤】：
    ...    - Step1、进入会话界面
    ...    - Step2、查看会话详情
    ...    - Step3、企业logo、企业名称、最有一条消息时间、最后一条消息内容、未读消息数
    ...
    ...    【预期结果】：
    ...    - Step1、有一条会话记录
    ...    - Step2、可以查到会话详情，logo, 名称，最后一条消息等
    go_Chat
    ${title}    Get Text    //*[contains(@text,'Conver')]
    should be equal    ${title}    Conversation    【实际结果】：没有进入到会话窗口
    Comment    座席端发一条文本消息
    ${AgentMessage}    set variable    this is agent, can i help you?
    ${j}    Agent Reply Message To Visitor    ${AdminUser}    ${leave_message.name}    txt    ${AgentMessage}
    should be true    ${j}    【实际结果】：座席端发送消息失败，${j}
    Comment    查看企业logo、企业名称、最有一条消息时间、最后一条消息内容、未读消息数等元素存在
    Wait Until Element Is Visible    ${packagename}:id/iv_avatar    ${timeout}
    Element Should Be Enabled    ${packagename}:id/tv_name
    Element Should Be Enabled    ${packagename}:id/tv_time
    Element Should Be Enabled    ${packagename}:id/tv_message
    Wait Until Element Is Visible    ${packagename}:id/tv_unread    ${timeout}
    Comment    从访客端获取座席的消息并对比
    ${message}    get text    ${packagename}:id/tv_message
    should be equal    ${message}    ${AgentMessage}    【实际结果】：获到的消息不是座席端发送的消息：${message}

sendtxt_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、打开会话详情
    ...    - Step2、给座席端发送文本消息
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的文本消息
    go_Chat
    click element    ${packagename}:id/tv_name
    ${visitor_txt}    set variable    this is visitor txt test message
    Input Text    ${packagename}:id/et_sendmessage    ${visitor_txt}
    click element    ${packagename}:id/btn_send
    ${j}    Should Contain Visitor Message In Processing Conversation    ${AdminUser}    ${leave_message.name}    txt    ${visitor_txt}
    should be true    ${j}    【实际结果】：进行中会话，并未找到指定的txt类型消息：${j}

send_phiz_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、给座席端发送表情消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的表情消息
    ${visitor_txt}    set variable    [:D][;)][:-o][:p][(H)]
    Input Text    ${packagename}:id/et_sendmessage    ${visitor_txt}
    click element    ${packagename}:id/btn_send
    ${j}    Should Contain Visitor Message In Processing Conversation    ${AdminUser}    ${leave_message.name}    txt    ${visitor_txt}
    should be true    ${j}    【实际结果】：进行中会话，并未找到指定的表情类型消息：${j}

send_image_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、给座席端发送图片消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的图片消息
    Wait Until Element Is Visible    ${packagename}:id/right_layout    ${timeout}
    Click Element    ${packagename}:id/btn_more
    Click Element    ${packagename}:id/chat_menu_pic
    click a point    ${width/2}    ${height/2}
    sleep    2
    click a point    ${width*0.7}    ${height*0.4}
    Wait Until Element Is Visible    ${packagename}:id/image    ${timeout}
    Click Element    ${packagename}:id/btn_less
    ${j}    Should Contain Visitor Message In Processing Conversation    ${AdminUser}    ${leave_message.name}    img
    should be true    ${j}    【实际结果】：进行中会话，并未找到指定的图片类型消息：${j}

send_audio_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、给座席端发送语音消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的语音消息
    log    模拟器中无法发送语音消息，点击录制语音无响应
    log    实体机启动kefu demo中报以下错误,可能实体机权限要求比较严格，需要开发放开activity权限
    log    error: Failed to start an Appium session, err was: Error: Permission to start activity denied.

send_file_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、给座席端发送文件消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的文件消息
    Wait Until Element Is Visible    ${packagename}:id/right_layout    ${timeout}
    Click Element    ${packagename}:id/btn_more
    Click Element    ${packagename}:id/chat_menu_file
    click a point    ${width/2}    ${height/2}
    sleep    2
    click a point    ${width*0.7}    ${height*0.4}
    Wait Until Element Is Visible    ${packagename}:id/image    ${timeout}
    Click Element    ${packagename}:id/btn_less
    ${j}    Should Contain Visitor Message In Processing Conversation    ${AdminUser}    ${leave_message.name}    file
    should be true    ${j}    【实际结果】：进行中会话，并未找到指定的文件类型消息：${j}

send_video_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、给座席端发送视频消息
    ...    备注：
    ...    发视频的方式可以分类【录制视频并发送】和【直接发送已经录制的短视频】两种。
    ...
    ...    如果要使用【录制视频并发送】，需要在实体机中，模拟器中录制按钮可能会无法点击；
    ...    如果要使用【直接发送已经录制的短视频】，可以在模拟器中，但需要给模拟器中先上传一段小视频，然后重启模拟器
    ...
    ...    使用其中一个需要将另一个的代码行注释掉：
    ...    【录制视频并发送】代码行：4-9行;
    ...    【直接发送已经录制的短视频】代码行：10-11行
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的视频消息
    Wait Until Element Is Visible    ${packagename}:id/right_layout    ${timeout}
    Click Element    ${packagename}:id/btn_more
    Click Element    ${packagename}:id/chat_menu_video
    Comment    Comment    录制视频并发送
    Comment    click element    ${packagename}:id/video_data_area
    Comment    click element    ${packagename}:id/recorder_start
    Comment    sleep    3
    Comment    click element    ${packagename}:id/recorder_stop
    Comment    click element    android:id/button1
    Comment    直接发送已经录制的短视频
    click element    //android.widget.GridView/android.widget.FrameLayout[@index='1']
    Click Element    ${packagename}:id/btn_less
    Wait Until Element Is Visible    ${packagename}:id/chatting_video_data_area    ${timeout}
    ${j}    Should Contain Visitor Message In Processing Conversation    ${AdminUser}    ${leave_message.name}    file
    should be true    ${j}    【实际结果】：进行中会话，并未找到指定的视频类型消息：${j}

send_location_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、给座席端发送位置消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的位置消息
    Click Element    ${packagename}:id/btn_more
    : FOR    ${i}    IN RANGE    3
    \    Click Element    ${packagename}:id/chat_menu_map
    \    sleep    3
    \    Click Element    ${packagename}:id/btn_location_send
    Wait Until Element Is Visible    ${packagename}:id/tv_location    ${timeout}
    Click Element    ${packagename}:id/btn_less
    ${j}    Should Contain Visitor Message In Processing Conversation    ${AdminUser}    ${leave_message.name}    loc
    should be true    ${j}    【实际结果】：进行中会话，并未找到指定的位置类型消息：${j}

send_commodityLink_to_Agent
    [Documentation]    【操作步骤】：
    ...    - Step1、给座席端发送商品连接图文消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、坐席端可以正常收到访客端的商品的图文的消息
    : FOR    ${i}    IN RANGE    3
    \    swipe_up
    Wait Until Element Is Visible    ${packagename}:id/bubble    ${timeout}    【实际结果】：没有找到商品链接
    Click Element    ${packagename}:id/button_send

Agent_send_txt
    [Documentation]    【操作步骤】：
    ...    - Step1、座席端给访客端发送文本消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、访客端可以正常收到座席端的发送的文本消息
    Comment    座席端给访客端发送文本消息
    clean_chat_records
    ${Agenttxt}    set variable    this is agent a txt message
    ${j}    Agent Reply Message To Visitor    ${AdminUser}    ${leave_message.name}    txt    ${Agenttxt}
    should be true    ${j}    【实际结果】：座席端发送消息失败，${j}
    Wait Until Element Is Visible    ${packagename}:id/tv_userid    ${timeout}    【实际结果】：没有找到用户发的消息
    ${message}    get text    ${packagename}:id/tv_chatcontent
    should be equal    ${message}    ${Agenttxt}    【实际结果】：获到的消息不是座席端发送的消息：${message}
    clean_chat_records

Agent_send_phiz
    [Documentation]    【操作步骤】：
    ...    - Step1、座席端给访客端发送表情消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、访客端可以正常收到座席端的发送的表情消息
    Comment    座席端给访客端发送表情消息
    clean_chat_records
    ${Agentphiz}    set variable    [<o)][(W)][:|][:p][:@][:-#]
    ${j}    Agent Reply Message To Visitor    ${AdminUser}    ${leave_message.name}    txt    ${Agentphiz}
    should be true    ${j}    【实际结果】：座席端发送消息失败，${j}
    Wait Until Element Is Visible    ${packagename}:id/tv_userid    ${timeout}    【实际结果】：没有找到用户发的消息
    ${phiz_message}    get text    ${packagename}:id/tv_chatcontent
    should be equal    ${phiz_message}    ${Agentphiz}    【实际结果】：获到的消息不是座席端发送的消息：${phiz_message}
    clean_chat_records

Agent_send_image
    [Documentation]    【操作步骤】：
    ...    - Step1、座席端给访客端发送图片消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、访客端可以正常收到座席端的发送的图片消息
    Comment    座席端给访客端发送图片消息
    clean_chat_records
    ${j}    Agent Reply Message To Visitor    ${AdminUser}    ${leave_message.name}    img
    should be true    ${j}    【实际结果】：座席端发送消息失败，${j}
    Wait Until Element Is Visible    ${packagename}:id/tv_userid    ${timeout}    【实际结果】：没有找到用户发的消息
    Element Should Be Enabled    ${packagename}:id/image
    click element    ${packagename}:id/image
    Element Should Be Enabled    ${packagename}:id/image
    go back

Agent_send_file
    [Documentation]    【操作步骤】：
    ...    - Step1、座席端给访客端发送文件消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、访客端可以正常收到座席端的发送的文件消息
    Comment    座席端给访客端发送文件消息
    clean_chat_records
    ${j}    Agent Reply Message To Visitor    ${AdminUser}    ${leave_message.name}    file
    should be true    ${j}    【实际结果】：座席端发送消息失败，${j}
    Wait Until Element Is Visible    ${packagename}:id/tv_userid    ${timeout}    【实际结果】：没有找到用户发的消息
    Element Should Be Enabled    ${packagename}:id/bubble
    ${filename}    get text    ${packagename}:id/tv_file_name
    should be equal    ${filename}    image.gif
    click element    ${packagename}:id/tv_file_name
    Wait Until Element Is Visible    android:id/button_once    ${timeout}
    click element    //android.widget.TextView[@text='Gallery']
    click element    //android.widget.TextView[@text='ES Image Browser']
    click element    android:id/button_once
    go back
