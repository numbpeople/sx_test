*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Resource    ../../UITeset_Env.robot
Test Setup    connect_appium_method    ${driver.drivername}

*** Test Cases ***
登录(正确用户名和密码)
    Log    ${driver.drivername}    
    login_page    a_android_login    ${driver.drivername}    1111    1