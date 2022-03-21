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
    ...    3.
    #restapi注册一个用户
    ${userres}    Create New User    ${username}
    ${username}    set variable    ${userres['entities'][0]['username']}
    Sleep    ${time}    
    #用户登录
    login_page    login    ${platform}    ${drivername}    ${username}    ${username}
    #等待页面跳转
    Sleep    ${time}    
    
Login User Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${page_name}    ${page_element}    ${loginres}
    [Documentation]    
    #登录用户
    Login User    ${platform}    ${drivername}    ${username}
    #判断是否登录成功（通过页面元素判断）
    ${res}    element_judge    ${drivername}    ${page_name}    ${page_element}
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}
    
Register Login Page Switch Template
    [Arguments]    ${platform}    ${driver}    ${num}=    
    [Documentation]    注册登录页面频繁切换
    ...    
    #构建登录注册页面切换次数
    ${num}    Run Keyword If    "${num}" == "${EMPTY}"    Generate Random String    1    [NUMBERS]
    #构建注册的用户昵称和密码
    ${username}    Generate Random String    5    [LETTERS][NUMBERS]
    Log    ${username}    
    FOR    ${num}    IN RANGE    ${num} 
        #登录页面点击“注册账号”
        login_page    click_registered    ${platform}    ${driver}    click
        #用户名输入框输入用户名
        user_registered_page    send_registered_user    ${platform}    ${driver}    ${username}
        #输入用户密码
        user_registered_page    send_registered_password    ${platform}    ${driver}    ${username}
        #输入用户确认密码
        user_registered_page    send_registered_confirm_password    ${platform}    ${driver}    ${username}
        #点击服务条款
        user_registered_page    click_agreement    ${platform}    ${driver}
        #点击返回按钮
        user_registered_page    click_return    ${platform}    ${driver}
        Sleep    1    
    END    
    
    #判断页面元素是否存在

      

Login Backgroud
    [Arguments]
    [Documentation]    登录页面退到后台后，再次登录
    