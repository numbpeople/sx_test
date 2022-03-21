*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot
Resource    ../../UICommon/Register/RegistetCommon.robot
Resource    ../../UICommon/Login/LoginCommon.robot
Suite Setup    connect_appium_method    ${driver.name}
Test Setup    Set UserName Password



*** Test Cases ***
RegisterUser
    [Documentation]    Create by shuang
    ...    1.注册用户名使用64位以内字符：纯英文、英文-_、英文数字、纯数字、64英文、65位英文、中文
    [Template]    Resgiter User Template
    ${platform.platform}    ${driver.name}    ${login.username}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username1}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username2}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username3}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username4}    ${login.errorcode}
    ${platform.platform}    ${driver.name}    ${login.username5}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username6}    ${login.errorcode}
    ${platform.platform}    ${driver.name}    ${login.username7}    ${login.errorcode}
Login
    [Documentation]    Create by shuang
    ...    1.登录用户
    [Template]    LoginUser
    ${login.username}    ${page_name}    ${a_version_element}    ${False}

