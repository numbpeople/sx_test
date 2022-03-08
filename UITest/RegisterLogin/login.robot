*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot  

Suite Setup    connect_appium_method    ${driver.name}

*** Test Cases ***
登录(正确用户名和密码) 
    #构建请求参数
    ${drivername}    Set Variable    ${driver.name}
    ${username}    Generate Random String    4     [LOWER]    #创建用户名称
    ${userpassword}    Generate Random String    1    [NUMBERS]    #创建用户密码
    #打印构建的请求参数
    Log Many    ${drivername}    ${username}
    login_page    android_login    ${platform.platform}    ${driver.drivername}    ${username}    ${userpassword}
    ${res}    element_judge    ${driver.drivername}    login_page_element    a_version_element
    Log    ${res}    
    Should Not Be True    ${res}
