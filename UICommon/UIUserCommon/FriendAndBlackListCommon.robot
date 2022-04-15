*** Settings ***
Library    String
Library    Collections
Resource    ../../Common/UserCommon/FriendsAndBlacklistCommon.robot
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../Variable_Env.robot
Resource    ../../UITest_Env/RegisterLoginElement/LoginPageElement.robot
Resource    ../../UITest_Env/SessionElement/SessionTabPageElement.robot
Resource    ../../UITest_Env/SessionElement/SystemNotificationElement.robot
Resource    LoginCommon.robot
Resource    ../../Common/UserCommon/UserOnlineAndOffline.robot

*** Variables ***
${time}    5
${waitpagetime}    7
${KEYCODE_SEARCH}    66

*** Keywords ***
Get Nottification xPaths Used
    [Documentation]
    ...   1.根据平台判断登录、注册页面使用的xpath
    ${methods}    Set Variable    ${findby.xpath}
    ${notification}    ${platform}    Change Xpath    ${AndroidNotificationPageXpath}    ${iOSNotificationPageXpath}
    Return From Keyword    ${methods}    ${notification}

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

    
Apply Add Friend Template
    [Documentation]     
    ...    向其他用户发送添加好友申请
    ...    1.参数1：发起方，参数2：参数1的密码，参数3：接收方
    [Arguments]    ${username}    ${userpwd}    ${username1}
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #发起好友申请操作
    Add Friends Operation    ${methods}    ${session}    ${username1}
    #使用restapi（将用户强制离线）将用户退出登录
    Forcing User Offline    ${username}
    
Click Notification
    [Documentation]    
    ...   点击会话列表中的系统通知
    ${methods}    ${notification}    Get Nottification xPaths Used
    Wait Until Page Contains Element    ${notification.systemnotification}    ${waitpagetime}
    Click Element    ${notification.systemnotification}
    
Click Notification Green
    [Documentation]    点击系统通知中的同意
    ${methods}    ${notification}    Get Nottification xPaths Used  
    Wait Until Page Contains Element     ${notification.green}    ${waitpagetime}
    Click Element    ${notification.green}
    
Click Notification Refused
    [Documentation]    点击系统通知中的拒绝
    ${methods}    ${notification}    Get Nottification xPaths Used
    Wait Until Page Contains Element     ${notification.refused}    ${waitpagetime}
    Click Element    ${notification.refused}    
  
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
    
Check Friends List Templeate
    [Documentation]
    [Arguments]    ${username}    ${userpwd}    ${username1}
    #创建用户1和用户2，并登录用户1
    Create User And Login User    ${username}    ${userpwd}    ${username1}
    #用户2向用户1发起添加好友申请
    Rest Apply Add Friend    ${username}    ${username1}
    #点击会话列表中的系统通知
    Click Notification
    #点击系统通知中的同意
    Click Notification Green
    #查看好友列表是否存在好友
    
Delete Friend Template
    [Arguments]
    [Documentation]    删除好友
    ...    
Deleted Friends By User
    [Documentation]    用户被删除