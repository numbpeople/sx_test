*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Library    Collections
Resource    ../../UITeset_Env.robot
Resource    ../../Common/UserCommon/UserCommon.robot
Resource    ../Register/RegistetCommon.robot

*** Variables ***
${time}    5
${backgroundtime}    10

*** Keywords ***
Parameter Judge Empty
    [Arguments]    ${parameter}    ${newvalue}
    [Documentation]    判断传入的参数是否为空
    ${res}    Run Keyword If    "${parameter}"=="${EMPTY}"    Set Variable    ${newvalue}    
    ...    ELSE    Set Variable    ${parameter}
    Return From Keyword    ${res}

Login User
    [Arguments]    ${platform}    ${drivername}    ${username}    ${password}=
    [Documentation]   登录一个用户
    ...    需要传入用户名称（密码）、页面元素、页面元素是否存在
    ...    1.注册一个IM用户
    ...    2.使用注册的新用户登录
    #restapi注册一个用户
    ${userres}    Create New User    ${username}    ${password}
    ${username}    set variable    ${userres['entities'][0]['username']}
    Sleep    ${time}    
    #判断密码传入的密码是否为空
    ${newpassword}=    Parameter Judge Empty    ${password}    ${username}
    #用户登录
    login_page    login    ${platform}    ${drivername}    ${username}    ${newpassword}
    #等待页面跳转
    Sleep    ${time}    
    
Normal Login User Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${password}    ${pageelement}    ${loginres}
    [Documentation]    正确的用户名和密码登录
    #登录用户
    Login User    ${platform}    ${drivername}    ${username}    ${password}
    #判断传入的页面元素是否为空
    ${pageelement}=    Parameter Judge Empty    ${pageelement}   会话
    #判断页面是否登录成功（通过元素是否存在判断）
    ${res}    element_judge_text    ${platform}    ${drivername}    ${pageelement}
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    
LoginUser NoExit Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${pageelement}    ${loginres}
    [Documentation]    
    ...    1.使用不存在的用户登录  
    #用户登录
    login_page    login    ${platform}    ${drivername}    ${username}    ${username}
    Sleep    ${time}  
    #判断传入的页面元素是否为空
    ${pageelement}=    Parameter Judge Empty    ${pageelement}   会话
    #判断页面是否登录成功（通过元素是否存在判断）
    ${res}    element_judge_text    ${platform}    ${drivername}    ${pageelement}
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    Sleep    ${time}    
    
Error Userpass Login Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${pageelement}    ${loginres}
    [Documentation]    
    ...    1.使用错误的密码登录
    ${password}    Generate Random String    4    [NUMBERS]
    ${userres}    Create New User    ${username}    
    ${username}    set variable    ${userres['entities'][0]['username']}
    Sleep    ${time}    
    #用户登录
    login_page    login    ${platform}    ${drivername}    ${username}    ${password}
    Sleep    ${time}  
    #判断传入的页面元素是否为空
    ${pageelement}=    Parameter Judge Empty    ${pageelement}   会话
    #判断页面是否登录成功（通过元素是否存在判断）
    ${res}    element_judge_text    ${platform}    ${drivername}    ${pageelement}
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    Sleep    ${time}    
    
Login Background Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${pageelement}    ${loginres}
    [Documentation]    登录页面退到后台后，再次登录
    #注册一个新用户
    ${userres}    Create New User    ${username} 
    ${username}    set variable    ${userres['entities'][0]['username']}
    #输入用户名
    login_page    send_user_name    ${platform}    ${drivername}    ${username}
    #输入密码
    login_page    send_password    ${platform}    ${drivername}    ${username}
    #退到后台
    public_app_background    ${drivername}    ${backgroundtime}
    #点击登录
    login_page    click_login_button     ${platform}    ${drivername}
    Sleep    ${time}    
    #判断传入的页面元素是否为空
    ${pageelement}=    Parameter Judge Empty    ${pageelement}   会话
    #判断页面是否登录成功（通过元素是否存在判断）
    #判断是否登录成功
    ${res}    element_judge_text    ${platform}    ${drivername}    ${pageelement}
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    Sleep    ${time}  
    