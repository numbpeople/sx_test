*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Library    Collections
Resource    ../../Common/UserCommon/UserCommon.robot
Resource    ../Register/RegistetCommon.robot


*** Keywords ***
LoginUser
    [Arguments]    ${userpassword}    ${page_element}    ${loginres}
    [Documentation]
    ...    需要传入用户名称（密码）、页面元素、页面元素是否存在
    ...    1.注册一个IM用户
    ...    2.使用注册的新用户登录
    ...    3.
    #restapi注册一个用户
    ${userres}    Create Temp User    ${userpassword}
    ${username}    set variable    ${userres['entities'][0]['username']}
    #构建请求参数
    ${drivername}    Set Variable    ${driver.name}
    #用户登录
    login_page    android_login    ${platform.platform}    ${drivername}    ${username}    ${userpassword}
    #判断是否登录成功（通过页面元素判断）
    ${res}    element_judge    ${driver.drivername}    login_page_element    ${page_element}
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}