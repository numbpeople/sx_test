*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot  
Suite Setup    connect_appium_method    ${driver.drivername}


*** Test Cases ***
正常注册用户（正确的用户名和密码）
    [Documentation]    Create by shuang
    ...    操作步骤：
    ...    1.使用不存在的用户名和密码注册
    ...    2.通过rest api调用获取用户详情验证
    #设置前提条件
    ${pf}    Set Variable    ${plateform.Android}
    ${drivername}    Set Variable    ${driver.drivername}
    ${username}    Generate Random String    4    [LOWER]
    #注册用户参数:平台、设备名、用户名、密码、确认密码
    user_registered_page    ${pf}    ${drivername}    ${username}    ${password}    ${password}
    #通过rest api验证用户是否注册成功

