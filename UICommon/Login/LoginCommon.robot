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
LoginUser
    [Arguments]    ${username}    ${page_name}    ${page_element}    ${loginres}
    [Documentation]
    ...    需要传入用户名称（密码）、页面元素、页面元素是否存在
    ...    1.注册一个IM用户
    ...    2.使用注册的新用户登录
    ...    3.
    #restapi注册一个用户
    ${userres}    Create New User    ${username}
    ${username}    set variable    ${userres['entities'][0]['username']}
    Sleep    ${time}    
    #构建请求参数
    ${drivername}    Set Variable    ${driver.name}
    #用户登录
    login_page    login    ${platform.platform}    ${drivername}    ${username}    ${username}
    #等待页面跳转
    Sleep    ${time}    
    #判断是否登录成功（通过页面元素判断）
    ${res}    element_judge    ${drivername}    ${page_name}    ${page_element}
    Log    ${res}    
    Should Be Equal    ${res}        ${loginres}