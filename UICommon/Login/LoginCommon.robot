*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Library    Collections
Resource    ../../Common/UserCommon/UserCommon.robot


*** Keywords ***
LoginUser
    #restapi注册一个用户
    ${userpassword}    Set Variable    1
    ${userres}    Create Temp User    ${userpassword}
    ${username}    set variable    ${userres['entities'][0]['username']}
    #构建请求参数
    ${drivername}    Set Variable    ${driver.name}
    #打印构建的请求参数
    login_page    android_login    ${platform.platform}    ${drivername}    ${username}    ${userpassword}
    ${res}    element_judge    ${driver.drivername}    login_page_element    a_version_element
    Log    ${res}    
    Should Not Be True    ${res}