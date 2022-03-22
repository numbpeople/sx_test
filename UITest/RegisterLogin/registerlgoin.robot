*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot
Resource    ../../UICommon/Register/RegistetCommon.robot
Resource    ../../UICommon/Login/LoginCommon.robot
Test Setup    Set UserName Password



*** Test Cases ***
RegisterUser
    [Documentation]    Create by shuang
    ...    1.注册用户名使用64位以内字符：纯英文、英文-_、英文数字、纯数字、64英文、65位英文、中文、大写字母
    [Template]    Resgiter User Template
    # ${env.platform}    ${driver.name}    ${login.username}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username1}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username2}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username3}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username4}    ${login.errorcode}
    # ${env.platform}    ${driver.name}    ${login.username5}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username6}    ${login.errorcode}
    # ${env.platform}    ${driver.name}    ${login.username7}    ${login.errorcode}
    ${env.platform}    ${driver.name}    ${login.username8}    ${login.rightcode}
    
Register Login Page Switch
    [Documentation]    Cresate by shuang
    [Template]    Register Login Page Switch Template
    ${env.platform}    ${driver.name}    ${env.num}
    
Normal Login User 
    [Documentation]    Create by shuang
    [Template]    Normal Login User Template
    # ${env.platform}    ${driver.name}    ${login.username}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username1}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username2}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username3}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username5}    ${True}
    ${env.platform}    ${driver.name}    ${login.username8}    ${True}
 
Error Userpass Login
    [Documentation]    Create by shuang
    [Template]    Error Userpass Login Template
    ${env.platform}    ${driver.name}    ${login.username}    ${False}

Login User No Exit
    [Documentation]    Create by shuang 
    [Template]    LoginUser NoExit Template
    ${env.platform}    ${driver.name}    ${login.username}    ${False}
    
Login Background
    [Documentation]    Cresate by shuang
    [Template]    Login Background Template
    ${env.platform}    ${driver.name}    ${login.username}    ${True}
 
Register Background
    [Documentation]    Cresate by shuang
    [Template]    Register Backgroud Template
    ${env.platform}    ${driver.name}    ${login.username}   ${login.rightcode}