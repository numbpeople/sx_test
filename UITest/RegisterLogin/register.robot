*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot
Resource    ../../UICommon/RegistetCommon.robot
Suite Setup    connect_appium_method    ${driver.name}
Test Setup    构建随机用户名和密码


*** Test Cases ***
正常注册用户(不存在的用户名)
    [Documentation]    Create by shuang
    ...    操作步骤：
    ...    1.使用不存在的用户名和密码注册
    ...    2.通过rest api调用获取用户详情验证
    ...    3.注册正确格式的用户名：纯英文、英文-_、英文数字、纯数字
    [Template]    注册用户
    ${platform.platform}    ${driver.name}    ${login.username}    ${login.password}    ${login.password}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username1}    ${login.password}    ${login.password}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username2}    ${login.password}    ${login.password}    ${login.rightcode}
    ${platform.platform}    ${driver.name}    ${login.username3}    ${login.password}    ${login.password}    ${login.rightcode}
