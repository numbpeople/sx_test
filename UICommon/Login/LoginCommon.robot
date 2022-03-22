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

*** Keywords ***
Login User
    [Arguments]    ${platform}    ${drivername}    ${username}
    [Documentation]   登录一个用户
    ...    需要传入用户名称（密码）、页面元素、页面元素是否存在
    ...    1.注册一个IM用户
    ...    2.使用注册的新用户登录
    #restapi注册一个用户
    ${userres}    Create New User    ${username}
    ${username}    set variable    ${userres['entities'][0]['username']}
    Sleep    ${time}    
    #用户登录
    login_page    login    ${platform}    ${drivername}    ${username}    ${username}
    #等待页面跳转
    Sleep    ${time}    
    
Normal Login User Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${loginres}
    [Documentation]    正确的用户名和密码登录
    #登录用户
    Login User    ${platform}    ${drivername}    ${username}
    #判断是否登录成功（通过页面元素判断）
    ${res}    element_judge_text    ${drivername}    会话
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    
LoginUser NoExit Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${loginres}
    [Documentation]    
    ...    1.使用不存在的用户登录  
    #用户登录
    login_page    login    ${platform}    ${drivername}    ${username}    ${username}
    Sleep    ${time}  
    ${res}    element_judge_text    ${drivername}    会话
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    Sleep    ${time}    
    
Error Userpass Login Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${loginres}
    [Documentation]    
    ...    1.使用错误的密码登录
    ${password}    Generate Random String    4    [NUMBERS]
    ${userres}    Create New User    ${username}    
    ${username}    set variable    ${userres['entities'][0]['username']}
    Sleep    ${time}    
    #用户登录
    login_page    login    ${platform}    ${drivername}    ${username}    ${password}
    Sleep    ${time}  
    ${res}    element_judge_text    ${drivername}    会话
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    Sleep    ${time}    
    
Login Backgroud
    [Arguments]
    [Documentation]    登录页面退到后台后，再次登录
    