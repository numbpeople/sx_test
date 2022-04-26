*** Settings ***
Library    String
Library    Collections
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../../Common/UserCommon/UserCommon.robot
Resource    RegistetCommon.robot
Resource    ../../UITest_Env/SessionElement/SessionTabPageElement.robot
Resource    ../../UITest_Env/SessionElement/SystemNotificationElement.robot
Resource    UserLogout.robot

*** Variables ***
${time}    5
${backgroundtime}    5

*** Keywords ***
    
Get xPaths Used
    [Documentation]
    ...   1.根据平台判断登录、注册页面使用的xpath
    ${methods}    Set Variable    ${findby.xpath}
    ${session}    ${platform}    Change Xpath    ${AndroidSessionPageXpath}    ${iOSSessionPageXpath}
    ${login}    ${platform}    Change Xpath    ${AndroidLoginXpath}    ${iOSLoginXpath}
    ${mypage}    ${platform}    Change Xpath    ${AndroidMyPageElement}    ${iOSMyPageElement}
    ${notification}    ${platform}    Change Xpath    ${AndroidNotificationPageXpath}    ${iOSNotificationPageXpath}
    ${register}    ${platform}    Change Xpath    ${AndroidRegisterXpath}    ${iOSRegisterXpath}
    ${login}    ${platform}    Change Xpath    ${AndroidLoginXpath}    ${iOSLoginXpath}
    ${seting}    ${platform}    Change Xpath    ${AndroidSetingElement}    ${iOSSetingElement}
    Set Test Variable    ${methods}    
    Set Test Variable    ${notification}
    Set Test Variable    ${platform}  
    Set Test Variable    ${session}    
    Set Test Variable    ${login}   
    Set Test Variable    ${register}
    Set Test Variable    ${mypage}
    Set Test Variable    ${seting}
    
Login User
    [Arguments]    ${username}=    ${userpwd}=
    [Documentation]
    ...    1.注册一个用户
    ...    2.使用该用户登录
    #注册一个新用户
    ${userres}    Create New User    ${username}
    ${username}    set variable    ${userres['entities'][0]['username']}
    #注册成功后，等待登录
    Sleep    ${time}    
    #判断使用的xpath
    ${methods}    ${session}    ${login}    ${platform}    Login Page Operations    ${username}    ${userpwd}
    Return From Keyword    ${methods}    ${session}    ${login}    ${platform}
    
Login Page Operations
    [Documentation]    登录页面操作
    ...    1.输入用户名
    ...    2.输入密码
    ...    3.点击登录按钮
    [Arguments]    ${username}=    ${userpwd}=
    Get xPaths Used
    #等待页面元素出现
    Wait Until Page Contains Element    ${methods}=${login.login_name}    ${waitpagetime}
    #输入用户名
    Input Text    ${methods}=${login.login_name}    ${username}
    #输入用户密码
    Input Text    ${methods}=${login.login_pwd}    ${userpwd}
    #点击登录
    Click Element    ${methods}=${login.login_button}
    [Return]    ${methods}    ${session}    ${login}    ${platform}
        
Normal Login User Template
    [Documentation]    正确的用户名和密码登录
    [Arguments]    ${username}=    ${userpwd}=
    ${methods}    ${session}    ${login}    ${platform}    Login User    ${username}    ${userpwd}
    #等待页面出现
    Wait Until Page Contains Element    ${methods}=${session.session_tab}    ${waitpagetime} 
    #判断页面是否登录成功（通过元素是否存在判断）
    Page Should Contain Element    ${methods}=${session.session_tab} 
    #退出登录
    User Logout
    
User Login Not Exist Template
    [Documentation]    使用不存在的用户登录
    [Arguments]    ${username}    ${userpwd}
    ${methods}    ${session}    ${login}    ${platform}    Login Page Operations    ${username}    ${userpwd}
    Sleep    ${time}    
    Page Should Contain Element    ${methods}=${login.login_name}
    
Incorrect Password Login Template
    [Documentation]    使用错误的用户名密码登录
    [Arguments]    ${username}=    ${userpwd}=
    ${methods}    ${session}    ${login}    ${platform}    Login User     ${username}    ${userpwd}
    Sleep    ${time}    
    Page Should Contain Element    ${methods}=${login.login_name}
    
Register Login Template
    [Arguments]    ${username}=    ${userpwd}=
    [Documentation]    正确的用户名和密码登录
    #注册一个新用户
    Register User Template    ${username}    ${userpwd}    ${userpwd}    200
    #注册成功后，等待登录
    Sleep    ${time}    
    #判断使用的xpath
    Get xPaths Used
    #等待页面元素出现
    Wait Until Page Contains Element    ${methods}=${login.login_name}    ${waitpagetime}
    #输入用户名
    Input Text    ${methods}=${login.login_name}    ${username}
    #输入用户密码
    Input Text    ${methods}=${login.login_pwd}    ${userpwd}
    #点击登录
    Click Element    ${methods}=${login.login_button}
    #等待页面跳转
    Wait Until Page Contains Element    ${methods}=${session.session_tab}    ${waitpagetime}
    #判断页面是否登录成功（通过元素是否存在判断）
    Page Should Contain Element    ${methods}=${session.session_tab} 
    #退出登录
    User Logout     
    
    