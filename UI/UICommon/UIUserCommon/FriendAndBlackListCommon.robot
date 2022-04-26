*** Settings ***
Library    String
Library    Collections
Resource    ../../../Common/UserCommon/FriendsAndBlacklistCommon.robot
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../../Variable_Env.robot
Resource    ../../UITest_Env/RegisterLoginElement/LoginPageElement.robot
Resource    ../../UITest_Env/SessionElement/SessionTabPageElement.robot
Resource    ../../UITest_Env/SessionElement/SystemNotificationElement.robot
Resource    LoginCommon.robot
Resource    ../../UITest_Env/AddressBook/AddressBookTabElement.robot
Resource    ../../../Common/UserCommon/UserOnlineAndOffline.robot
Resource    ../UISettingCommon/SettingCommon.robot


*** Variables ***
${time}    5
${waitpagetime}    7
${KEYCODE_SEARCH}    66

*** Keywords ***
Get Adress Bool Xpath
    [Documentation]
    ...   1.根据平台判断登录、注册页面使用的xpath
    ${methods}    Set Variable    ${findby.xpath}
    ${adressbook}    ${platform}    Change Xpath    ${AndroidAdressBookXpath}    ${iOSAdressBookXpath}
    Set Test Variable    ${methods}    
    Set Test Variable    ${adressbook}
    Set Test Variable    ${platform}

Add Friends Operation
    [Documentation]
    ...    添加好友操作步骤
    [Arguments]    ${methods}    ${session}    ${username}
    #等待下个页面出现
    Wait Until Page Contains Element    ${methods}=${session.more_options}    ${waitpagetime} 
    # #点击右上角的“+”
    Click Element    ${methods}=${session.more_options}
     #等待下个页面出现
    Wait Until Page Contains Element    ${methods}=${session.add_friends}    ${waitpagetime} 
    #点击“添加好友”
    Click Element    ${methods}=${session.add_friends}
    #等待下个页面出现
    Wait Until Page Contains Element    ${methods}=${session.user_serarch_box}    ${waitpagetime}
    #搜索输入框中输入用户ID
    Input Text    ${methods}=${session.user_serarch_box}    ${username}
    
    Press Keycode    ${${KEYCODE_SEARCH}}
    Sleep    5    
    Press Keycode    ${${KEYCODE_SEARCH}}
    Sleep    20    
    
Create User And Login User
    [Documentation]
    ...
    [Arguments]    ${username}    ${userpwd}    ${username1}    
    #创建用户（接收方）
    ${userres}    Create New User    ${username1}
    #创建用户并且登录用户
    ${methods}    ${session}    ${login}    ${platform}    Login User    ${username}    ${userpwd}
    Wait Until Page Contains Element    ${methods}=${session.session_tab}    ${waitpagetime}
    Set Test Variable    ${methods}    
    Set Test Variable    ${session}    

Click Notification
    [Documentation]    
    ...   点击会话列表中的系统通知
    Get xPaths Used
    Wait Until Page Contains Element    ${notification.systemnotification}    ${waitpagetime}
    Click Element    ${notification.systemnotification}
    
Click Notification Green
    [Documentation]    点击系统通知中的同意
    Get xPaths Used  
    #等待元素出现
    Wait Until Page Contains Element    ${notification.count_green_button}    ${waitpagetime}
    #获取匹配元素的数量
    ${count}    Get Matching Xpath Count    ${notification.count_green_button}
    ${counter}    Set Variable    0
    FOR    ${counter}    IN    ${count}
        ${notification.green}     Set Variable    //android.view.ViewGroup[${counter}]/android.view.ViewGroup/android.widget.Button[@text="同意"]
        Wait Until Page Contains Element     ${notification.green}    ${waitpagetime}
        Click Element    ${notification.green}
    END
    
Click Notification Refused
    [Documentation]    点击系统通知中的拒绝
    Get xPaths Used
    Wait Until Page Contains Element     ${notification.refused}    ${waitpagetime}
    Click Element    ${notification.refused}    

Click Adress Book 
    [Documentation]    点击通讯录标签
    Get Adress Bool Xpath
    #点击通讯录tab，进入通讯录
    Click Element    ${methods}=${adressbook.address}
    #等待进入通讯录页面
    Wait Until Page Contains Element    ${methods}=${adressbook.new_friend_button}    ${waitpagetime}

Click Confirm Button
    [Documentation]    删除好友弹窗（确认）
    Wait Until Page Contains Element    ${methods}=${adressbook.confirm_button}    ${waitpagetime}
    Click Element    ${methods}=${adressbook.confirm_button}

Click Cancel Button
    [Documentation]    删除好友弹窗（取消）
    Wait Until Page Contains Element    ${methods}=${adressbook.cancel_button}    ${waitpagetime}
    Click Element    ${methods}=${adressbook.cancel_button}

Click Personal Data Set 
    [Documentation]    点击个人资料中设置
    Wait Until Page Contains Element    ${methods}=${adressbook.setting_button}
    Click Element    ${methods}=${adressbook.setting_button}

Click Friend
    [Documentation]    通讯列表中点击某个好友
    [Arguments]    ${username}
    ${adressbook.friend}    Set Variable If    "${platform}" == "android"    //android.view.ViewGroup/android.widget.TextView[@text="${username}"]    //XCUIElementTypeStaticText[@name="${username}"]
    Wait Until Page Contains Element    ${methods}=${adressbook.friend}
    Click Element    ${methods}=${adressbook.friend}

Click Back
    [Documentation]    点击返回按钮
    Get Adress Bool Xpath
    Click Element    ${methods}=${notification.back_button}
    Wait Until Page Contains Element    ${methods}=${adressbook.address}    ${waitpagetime}


Wipe Friend Operation
    [Documentation]    仅适用于iOS
    [Arguments]    ${username}
    #设置好友元素
    ${adressbook.friend}    Set Variable    //XCUIElementTypeStaticText[@name="${username}"]
    #获取元素列表中的坐标
    ${location}    Get Element Location    ${adressbook.friend}
    # ${size}    Get Element Size    ${adressbook.friend}
    ${size}    Set Variable    {"width":"375","height":"60"}
    #好友列表width:375，height:60
    ${start_x}    Evaluate    (${location["x"]}+${size["width"]})/2
    ${start_y}    Evaluate    (${location["y"]}+${size.["height"]})/2
    ${end_x}    Evaluate    ${location.x}/2
    #iOS好友列表中，选择好友滑动
    Swipe By Percent    ${start_x}    ${start_y}    ${end_x}    ${start_y}

Long Press Friend Operation
    [Documentation]    通讯录页面长按好友操作
    ...    仅适用于Android
    [Arguments]    ${username}
    ${adressbook.friend}    Set Variable    //android.view.ViewGroup/android.widget.TextView[@text="${username}"]
    Log    ${adressbook.friend}
    Wait Until Page Contains Element    ${adressbook.friend}
    Long Press    ${methods}=${adressbook.friend}

Delete Friend Button Operation
    [Documentation]    选择删除用户好友
    Wait Until Page Contains Element    ${methods}=${adressbook.delete_button}
    Click Element    ${methods}=${adressbook.delete_button}

Add Block Friend Operation
    [Documentation]    拉黑黑名单
    Wait Until Page Contains Element    ${methods}=${adressbook.add_block_button}
    Click Element    ${methods}=${adressbook.add_block_button}
    
Update Address Book Page Operation
    [Documentation]    通讯录页面刷新
    #新的好友按钮为开始位置
    Wait Until Page Contains Element    ${methods}=${adressbook.new_friend_button}
    ${startlocation}    Get Element Location    ${methods}=${adressbook.new_friend_button}
    #聊天室按钮为结束位置
    ${endlocation}    Get Element Location    ${methods}=${adressbook.chatrooms_button}
    #滑动刷新通讯录页面
    Log    ${startlocation["y"]}
    Log    ${endlocation["y"]}
    Swipe    5    ${startlocation["y"]}    5    ${endlocation["y"]}

    
Delete Friend
    [Documentation]    删除好友操作
    [Arguments]    ${username}
    #根据平台判断操作步骤
    IF    "${platform}" == "android"
        #Android：好友列表长按好友昵称
        Long Press Friend Operation    ${username}
        #删除好友
        Delete Friend Button Operation
        #确认删除
        Click Confirm Button
    ELSE
        #iOS：好友列表中选择好友昵称滑动
        Wipe Friend Operation    ${username}
        #等待删除按钮出现
        Wait Until Page Contains Element    ${adressbook.delete_button}    ${waitpagetime}
        #删除好友
        Delete Friend Button Operation
    END

Add Block Friend
    [Arguments]    ${username}
    IF    "${platform}" == "android"
        #Android：好友列表长按好友昵称
        Long Press Friend Operation    ${username}
        #加入黑名单
        Add Block Friend Operation    
    ELSE
        #iOS：好友列表中选择好友点击
        Click Friend    ${username}
        #点击个人资料右上角的设置按钮
        Click Personal Data Set
        #点击个人资料中的添加黑名单
        Wait Until Page Contains    ${adressbook.add_block_button}
        Click Element    ${methods}=${adressbook.add_block_button}
    END

Apply Add Friends Template
    [Documentation]     
    ...    向其他用户发送添加好友申请
    ...    1.参数1：发起方，参数2：参数1的密码，参数3：接收方
    [Arguments]    ${username}    ${userpwd}    ${username1}    ${runstatus}
    Should Not Be True    ${runstatus}
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #发起好友申请操作
    Add Friends Operation    ${methods}    ${session}    ${username1}
    #使用restapi（将用户强制离线）将用户退出登录
    Forcing User Offline    ${username}
    
Agreen Friends Request Operation Template
    [Documentation]
    ...    系统通知操作（同意）
    [Arguments]    ${username}    ${userpwd}    ${username1}
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #用户2向用户1发起添加好友申请
    Rest Apply Add Friend    ${username}    ${username1}
    #点击会话列表中的系统通知
    Click Notification
    #点击系统通知中的同意
    Click Notification Green
    #等待时间，通过rest验证是否添加成功
    Sleep    ${time}
    #rest获取好友列表，判断是否添加用户成功
    ${resusername}    Rest Get Friends Operation    ${username}    200
    Should Be Equal As Strings    ${username1}    ${resusername}
    #点击返回按钮
    Click Back
    #进入到通讯录页面
    Click Adress Book
    #判断通讯录页面存在好友
    Page Should Contain Text    ${username1} 
    
Refused Friends Request Operation Template
    [Documentation]
    ...    系统通知操作（拒绝）
    [Arguments]    ${username}    ${userpwd}    ${username1}
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #用户2向用户1发起添加好友申请
    Rest Apply Add Friend    ${username}    ${username1}
    #点击会话列表中的系统通知
    Click Notification
    #点击系统通知中的拒绝
    Click Notification Refused
    #等待时间，通过rest验证是否添加成功
    Sleep    ${time}
    #rest获取好友列表，判断是否添加用户成功
    ${resusername}    Rest Get Friends Operation    ${username}    200
    ${res}    Get Length    ${resusername}
    #拒绝好友申请，好友数量应该为0
    Should Be Equal As Integers    ${res}    0
    #点击返回按钮
    Click Back
    #进入到通讯录页面
    Click Adress Book
    #判断通讯录页面不存在好友
    Page Should Not Contain Text    ${username1} 
    
Add Multiple Friends Template
    [Documentation]
    ...    连续添加多个好友
    [Arguments]    ${username}    ${userpwd}    ${username1}    ${username2}
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #用户2向用户1发起添加好友申请
    Rest Apply Add Friend    ${username}    ${username1}
    #用户3向用户1发起添加好友申请
    Rest Apply Add Friend    ${username}    ${username2}
    #点击会话列表中的系统通知
    Click Notification
    #点击系统通知中的同意
    Click Notification Green
    #等待时间，通过rest验证是否添加成功
    Sleep    ${time}
    #rest获取好友列表，判断是否添加用户成功
    ${resusername}    Rest Get Friends Operation    ${username}    200
    Should Be Equal As Strings    ${username1}    ${resusername}
    #点击返回按钮
    Click Back
    #进入到通讯录页面
    Click Adress Book
    #判断通讯录页面存在好友2
    Page Should Contain Text    ${username1} 
    #判断通讯录页面存在好友3
    Page Should Contain Text    ${username2} 
    
Delete Friend Template
    [Arguments]    ${username}    ${userpwd}    ${username1}
    [Documentation]    删除好友
    ...    
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #RestApi用户添加好友
    Rest Add Friend    ${username}    ${username1}
    Sleep    ${time}
    #进入到通讯录页面
    Click Adress Book
    #判断通讯录页面存在好友2（期望存在好友2）
    Page Should Contain Text    ${username1} 
    #删除用户好友
    Delete Friend    ${username1}
    #刷新通讯录页面
    Update Address Book Page Operation
    #等待时间
    Sleep    ${time}
    #查看通讯录是否存在好友2
    Page Should Not Contain Element    ${username1} 

Deleted Friends By User Template
    [Documentation]    
    [Arguments]    ${username}    ${userpwd}    ${username1}  
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #RestApi用户添加好友
    Rest Add Friend    ${username}    ${username1}
    Sleep    ${time}
    #进入到通讯录页面
    Click Adress Book
    #判断通讯录页面存在好友2
    Page Should Contain Text    ${username1} 
    #好友2删除好友1
    Rest Delete Friend    ${username1}    ${username}
    #刷新通讯录页面
    Update Address Book Page Operation
    #等待时间
    Sleep    ${time}
    #查看通讯录是否存在好友2
    Page Should Not Contain Element    ${username1} 

Add BLocklist Templeate
    [Documentation]    将用户添加到黑名单
    [Arguments]    ${username}    ${userpwd}    ${username1}
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #RestApi用户添加好友
    Rest Add Friend    ${username}    ${username1}
    Sleep    ${time}
    #进入到通讯录页面
    Click Adress Book
    #判断通讯录页面存在好友2（期望存在好友2）
    Page Should Contain Text    ${username1} 
    #添加到黑名单
    Add Block Friend    ${username1} 

Blacklisted Templeate
    [Documentation]    将用户添加到黑名单
    [Arguments]    ${owerusername}    ${userpwd}    ${friendusername}
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${owerusername}    ${userpwd}    ${friendusername}
    #RestApi用户添加好友
    Rest Add Friend    ${owerusername}    ${friendusername}
    Sleep    ${time}
    #进入到通讯录页面
    Click Adress Book
    #判断通讯录页面存在好友2（期望存在好友2）
    Page Should Contain Text    ${friendusername} 
    #RestApi将用户添加到黑名单
    Rest Add User Blacklist    ${owerusername}    ${friendusername}
    #判断通讯录页面存在好友2（期望存在好友2）
    Page Should Contain Text    ${friendusername} 

Enter Blacklist Page Operation
    [Documentation]    进入到黑名单列表
    #点击【我】tab页面
    Click MyPage
    #点击【设置】按钮
    Click Setting
    #点击【隐私】按钮
    Click Privacy
    #点击【黑名单】按钮
    Click Blacklist


Remove Blacklist Templeate
    [Documentation]    将用户从黑名单中移除
    [Arguments]    ${owerusername}    ${userpwd}    ${friendusername}
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${owerusername}    ${userpwd}    ${friendusername}
    #RestApi用户添加好友
    Rest Add Friend    ${owerusername}    ${friendusername}
    #RestApi添加黑名单
    Rest Add User Blacklist    ${owerusername}    ${friendusername}
    #进入到黑名单页面
    Enter Blacklist Page Operation
    #将用户移除黑名单
    Removing Blacklist    ${friendusername}
    #RestApi确认是否移除黑名单
    Rest Get Blacklist    ${owerusername}
    #UI页面确认是否移除黑名单
    Swipe By Percent    569    393    569    1288
    Page Should Not Contain Element    ${blackname}