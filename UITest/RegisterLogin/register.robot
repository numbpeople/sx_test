*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot
Resource    ../../UICommon/Register/RegistetCommon.robot
Suite Setup    connect_appium_method    ${driver.name}
Test Setup    Set UserName Password


*** Test Cases ***
RegisterUser
    [Documentation]    Create by shuang
    ...    操作步骤：
    ...    1.使用不存在的用户名和密码注册
    ...    2.通过rest api调用获取用户详情验证
    ...    3.注册用户名使用64位以内字符：纯英文、英文-_、英文数字、纯数字
    [Template]    Resgiter User Template
    ${platform.platform}    ${driver.name}    ${login.username}    ${login.password}    ${login.password}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username1}    ${login.password}    ${login.password}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username2}    ${login.password}    ${login.password}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username3}    ${login.password}    ${login.password}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username4}    ${login.password}    ${login.password}    ${login.errorcode}
    ${platform.platform}    ${driver.name}    ${login.username5}    ${login.password}    ${login.password}    ${login.rightcode}
