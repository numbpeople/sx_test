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

*** Test Cases ***
Look_space_leavemess
    [Documentation]    【操作步骤】：
    ...    - Step1、在无留言状态查看留言
    ...    - Step2、只显示 “No data here.”
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、能够进入留言页面，查到“No data here.”元素
    Comment    没有留言时，查看留言界面
    go_Note
    Wait Until Element Is Visible    //${TextView}[@text="Note"]
    Element Should Be Enabled    //${TextView}[@text="No data here."]

Create_space_Leavemess
    [Documentation]    【操作步骤】：
    ...    - Step1、进入留言页面
    ...    - Step2、不输入任何信息直接点击发送
    ...    - Step3、留言失败
    ...
    ...    【预期结果】：
    ...    - Step1、留言失败
    Comment    创建空留言，不输入内容直接send
    go_shop
    Comment    点击商品联系客服
    Click Element    ${packagename}:id/ib_shop_imageone
    Click Element    //${TextView}[@text='Connect to Customer Service']
    Comment    点击⊕更多，选择Note图标
    Wait Until Element Is Visible    ${packagename}:id/btn_more    ${timeout}
    Click Element    ${packagename}:id/btn_more
    Click Element    ${packagename}:id/chat_menu_leave_msg
    Wait Until Element Is Visible    //${TextView}[@text="Note"]
    Comment    点击多次send发送依然在Note页面
    Click Element    ${packagename}:id/rl_send
    Click Element    ${packagename}:id/rl_send
    Element Should Be Enabled    //${TextView}[@text="Note"]
    Element Should Be Enabled    ${packagename}:id/rl_send

Create_leavemess
    [Documentation]    【操作步骤】：
    ...    - Step1、正确输入留言内容，名字、电话等信息
    ...    - Step2、可以正常创建留言
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、创建留言成功
    Comment    创建留言
    Comment    输入内容、名字、电话、邮件、主题
    ${timestamp}    timestamps
    set to dictionary    ${leave_message}    name=user${timestamp}
    set global variable    ${leave_message.name}
    Input Text    ${packagename}:id/et_new_leave_content    ${leave_message.content}
    Input Text    ${packagename}:id/et_name    ${leave_message.name}
    Input Text    ${packagename}:id/et_phone    ${leave_message.phone}
    Input Text    ${packagename}:id/et_email    ${leave_message.email}
    Input Text    ${packagename}:id/et_theme    ${leave_message.theme}
    Comment    点击【发送】
    Click Element    //${TextView}[@text='Send']
    Wait Until Page Does Not Contain    //${TextView}[@text='Sending...']    ${timeout}
    Wait Until Element Is Visible    //${TextView}[@text='Submit successful']    ${timeout}
    Go back
    Go back

Look_leavemessage
    [Documentation]    【操作步骤】：
    ...    - Step1、进入留言页面
    ...    - Step2、查看刚才的留言消息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、可以查看到刚才的留言消息
    Comment    查看刚发的留言
    go_Note
    swipe_up
    ${leave_theme}    get text    ${packagename}:id/tv_name
    should contain any    ${leave_theme}    ${leave_message.theme}
    ${leave_content}    get text    ${packagename}:id/tv_content
    should contain any    ${leave_content}    ${leave_message.content}
    ${leave_date}    get text    ${packagename}:id/tv_date
    should contain any    ${leave_date}    PM    AM
    Comment    留言最下面显示No more.
    Wait Until Element Is Visible    //${TextView}[@text="No more."]    ${timeout}

leavemess_detail
    [Documentation]    【操作步骤】：
    ...    - Step1、进入留言详情页面
    ...    - Step2、比较留言内容，留言人name，email，theme等信息
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、留言各信息和输入信息的一致
    click element    ${packagename}:id/tv_name
    ${now_name}    get text    ${packagename}:id/tv_ticket_name
    should be equal    ${now_name}    ${leave_message.name}    【实际结果】：当前name是${now_name}，预期是${leave_message.name}
    ${now_phone}    get text    ${packagename}:id/tv_ticket_phone
    should be equal    ${now_phone}    ${leave_message.phone}    【实际结果】：当前phone是${now_phone}，预期是${leave_message.phone}
    ${now_email}    get text    ${packagename}:id/tv_ticket_email
    should be equal    ${now_email}    ${leave_message.email}    【实际结果】：当前email是${now_email}，预期是${leave_message.email}
    ${now_theme}    get text    ${packagename}:id/tv_ticket_theme
    should be equal    ${now_theme}    ${leave_message.theme}    【实际结果】：当前theme是${now_theme}，预期是${leave_message.theme}
    ${now_content}    get text    ${packagename}:id/tv_ticket_detail
    should be equal    ${now_content}    ${leave_message.content}    【实际结果】：当前detail是${now_content}，预期是${leave_message.content}

responses_text
    [Documentation]    【操作步骤】：
    ...    - Step1、点击"responses"进入评论编辑页面
    ...    - Step2、输入文本信息发表评论
    ...    - Step3、在responses评论区域显示刚发表的评论
    ...
    ...    【预期结果】：
    ...    - Step1、可以发表文字评论
    Comment    查看responses区域
    Element Should Be Enabled    //${TextView}[@text='Responses']
    Comment    点击进入评论编辑页面
    click element    ${packagename}:id/button_reply
    ${title}    get text    ${packagename}:id/txtTitle
    should be equal    ${title}    Reply    【实际结果】：页面title是${title}
    Input Text    ${packagename}:id/edittext    ${respones_info}
    click element    //${TextView}[@text="Send"]
    Wait Until Element Is Visible    ${packagename}:id/content
    ${content}    get text    ${packagename}:id/content
    should be equal    ${content}    ${respones_info}

responses_file
    [Documentation]    【操作步骤】：
    ...    - Step1、点击"responses"进入评论编辑页面
    ...    - Step2、选择附件发表评论
    ...    - Step3、在responses评论区域显示刚发表的附件信息
    ...
    ...    【预期结果】：
    ...    - Step1、可以发表附件信息
    Comment    点击进入评论编辑页面
    click element    ${packagename}:id/button_reply
    ${filename}    set variable    com_hyphenate_chatuidemo_96x96.png
    set global variable    ${filename}
    ${title}    get text    ${packagename}:id/txtTitle
    should be equal    ${title}    Reply    【实际结果】：页面title是${title}
    Comment    选择一个附件
    click element    ${packagename}:id/ib_add_file
    click a point    ${width/2}    ${height/2}
    sleep    2
    click a point    ${width*0.7}    ${height*0.4}
    Wait Until Element Is Visible    //${TextView}[@text="Send"]    5
    Comment    发送附件后在评论区可以查到刚发送的附件名称
    click element    //${TextView}[@text="Send"]
    swipe_down
    Element Should Be Enabled    //${TextView}[@text="${filename}"]

responses_audio
    [Documentation]    【操作步骤】：
    ...    - 模拟器中点击录音按钮有时不出现时长按钮，无法录音，因此仅能判断录音按钮存在与否，无法测试可以发送语音消息
    Comment    点击进入评论编辑页面
    click element    ${packagename}:id/button_reply
    ${title}    get text    ${packagename}:id/txtTitle
    should be equal    ${title}    Reply    【实际结果】：页面title是${title}
    Comment    点击麦克风出现录音按钮
    click element    ${packagename}:id/ib_record_btn
    Comment    Long Press    ${packagename}:id/record_menu_image_btn
    Element Should Be Enabled    ${packagename}:id/record_menu_image_btn
    Comment    click element    //${TextView}[@text="Send"]
    go back
    Comment    Element Should Be Enabled    ${packagename}:id/id_recorder_length

responses_text_file
    [Documentation]    【操作步骤】：
    ...    - Step1、同时输入文本和文件
    ...    - Step2、在responses评论区域显示刚发表的评论
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、可以同时发表文本和文件的评论
    Comment    查看responses区域
    Element Should Be Enabled    //${TextView}[@text='Responses']
    Comment    点击进入评论编辑页面
    click element    ${packagename}:id/button_reply
    ${title}    get text    ${packagename}:id/txtTitle
    ${filename2}    set variable    com_bignox_app_store_hd_96x96.png
    set global variable    ${filename2}
    should be equal    ${title}    Reply    【实际结果】：页面title是${title}
    Comment    同时输入文件和选择一个文件
    Input Text    ${packagename}:id/edittext    ${respones_info2}
    click element    ${packagename}:id/ib_add_file
    sleep    1
    click a point    ${width/2}    ${height/2}
    sleep    1
    click a point    ${width/4}    ${height/8}
    Wait Until Element Is Visible    //${TextView}[@text="Send"]
    click element    //${TextView}[@text="Send"]
    Comment    获取刚输入的文本和文件信息
    Wait Until Element Is Visible    //${TextView}[@text='Note Detail']
    swipe_down
    ${content}    get text    //${TextView}[@text='This is second respones infomation']
    should be equal    ${content}    ${respones_info2}
    Element Should Be Enabled    //${TextView}[@text="${filename2}"]
    go back

get_seat_leavemess
    [Documentation]    【操作步骤】：
    ...    - Step1、使用API从座席端获取访客端留言并返回留言
    ...    - Step2、使用返回的留言和发送的留言比较
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、座席端的留言内容和访客端发送的留言内容一致
    log    ${leave_message.name}
    ${alldata}    Get Ticket With Custom Filter    ${AdminUser}    ${leave_message.name}
    should be equal    ${alldata['content']}    ${leave_message.content}    【实际结果】：预期${leave_message.content}，实际为${alldata['content']}
    should be equal    ${alldata['creator']['name']}    ${leave_message.name}    【实际结果】：预期${leave_message.name}，实际${alldata['creator']['name']}
    should be equal    ${alldata['creator']['phone']}    ${leave_message.phone}    【实际结果】：预期${leave_message.phone}，实际${alldata['creator']['phone']}
    should be equal    ${alldata['creator']['email']}    ${leave_message.email}    【实际结果】：预期${leave_message.email}，实际${alldata['creator']['email']}
    should be equal    ${alldata['subject']}    ${leave_message.theme}    【实际结果】：预期${leave_message.theme}，实际${alldata['subject']}
    ${ticketId}    set variable    ${alldata['id']}
    set global variable    ${ticketId}

get_leavemess_response
    [Documentation]    【操作步骤】：
    ...    - Step1、坐座席端获取访客端留言评论并返回评论内容
    ...    - Step2、根据返回的评论内容和访客端数据对比
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、座席端收到的评论内容和访客端评论内容一致
    Comment    依赖上条用例获取${ticketId}
    Comment    ${filename}变量依赖【responses_file】用例
    log    ${ticketId}
    ${alldata}    Get Ticket Comment    ${AdminUser}    ${ticketId}
    Comment    返回第一条评论进行对比，只有文本消息
    should be equal    ${alldata[0]['creator']['name']}    ${leave_message.name}    【实际结果】：预期${leave_message.name}，实际${alldata[0]['creator']['name']}
    should be equal    ${alldata[0]['content']}    ${respones_info}    【实际结果】：预期${respones_info}，实际${alldata[0]['content']}
    Comment    返回第二条评论进行对比，只有文件消息
    should be equal    ${alldata[1]['creator']['name']}    ${leave_message.name}    【实际结果】：预期${leave_message.name}，实际${alldata[1]['creator']['name']}
    should be equal    ${alldata[1]['attachments'][0]['type']}    img    【实际结果】：预期类型img，实际${alldata[1]['attachments'][0]['type']}
    should be equal    ${alldata[1]['attachments'][0]['name']}    ${filename}    【实际结果】：预期${filename}，实际${alldata[1]['attachments'][0]['name']}
    Comment    返回第三条评论对比，有文本和文件消息
    should be equal    ${alldata[2]['creator']['name']}    ${leave_message.name}    【实际结果】：预期${leave_message.name}，实际${alldata[2]['creator']['name']}
    should be equal    ${alldata[2]['content']}    ${respones_info2}    【实际结果】：预期${respones_info2}，实际${alldata[2]['content']}
    should be equal    ${alldata[2]['attachments'][0]['name']}    ${filename2}    【实际结果】：预期${filename2}，实际${alldata[2]['attachments'][0]['name']}

seat_add_responses
    [Documentation]    【操作步骤】：
    ...    - Step1、座席端给留言添加一条评论
    ...
    ...
    ...    【预期结果】：
    ...    - Step1、座席端可以给留言添加评论
    Comment    依赖 [get_seat_leavemess ] 用例
    log    ${ticketId}
    ${result}    Add Comment For Ticket    ${AdminUser}    ${ticketId}    ${seat_reply_leavemess}
    log    【实际结果】：${result}

get_seat_responses
    [Documentation]    【操作步骤】：
    ...    - Step1、再次进入留言详情
    ...    - Step2、获取座席端的留言评论
    ...
    ...    【预期结果】：
    ...    - Step1、可以查看到座席端的留言评论
    click element    ${packagename}:id/tv_name
    swipe_down
    swipe_down
    Comment    //${TextView}[@text='Admin']
    ${seat_name}    get text    //${TextView}[@text='Admin']
    should be equal    ${seat_name}    Admin    【实际结果】：预期Admin，实际${seat_name}
    ${seat_content}    get text    //${TextView}[@text="${seat_reply_leavemess}"]
    should be equal    ${seat_content}    ${seat_reply_leavemess}    【实际结果】：预期${seat_reply_leavemess}，实际${seat_content}
    go back
