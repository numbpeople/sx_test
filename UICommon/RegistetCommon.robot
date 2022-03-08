*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Library    Collections
Resource    ../Variable_Env.robot
Resource    ../UITeset_Env.robot
Resource    ../RestApi/User/UserApi.robot
Resource    ../Common/BaseCommon.robot
Resource    ../Common/AppCommon/AppCommon.robot
Resource    ../Common/UserCommon/UserCommon.robot

*** Keywords ***
判断用户是否存在
    [Documentation]    通过rest api验证用户是否存在
    [Arguments]   ${username}    ${code}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${username}
    #设置请求集和
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    ${apiResponse}    Get Specific User     @{arguments}
    Log    ${apiResponse}    
    Should Be Equal    ${code}    ${apiResponse.statusCode}
    
构建随机用户名和密码
    #构建用户名格式包含（纯英文）
    ${username}    Generate Random String    4    [LOWER]
    #构建用户名格式包含(英文、_、-)
    ${random1}    Generate Random String    4    [LOWER]
    ${username1}    Set Variable    ${random1}-a_b
    #构建用户名格式包含(英文、数字)
    ${random2}    Generate Random String    4    [LOWER]
    ${randomnum2}    Generate Random String    2    [NUMBERS]
    ${username2}    Set Variable    ${random1}${randomnum2}
    #构建用户名格式纯数字
    ${min}    Set Variable    1
    ${max}    Set Variable    100000
    ${username3}    Evaluate    random.randit(${min},${max})    random    
    #构建用户名密码
    ${password}    Generate Random String    1    [NUMBERS]
    #用户名和密码设置全局变量
    Set To Dictionary    ${login}    username=${username}    username1=${username1}    username2=${username2}    password=${password}
    Set Global Variable    ${login}    ${login}
    
 注册用户
    [Arguments]    ${platform}    ${drivername}    ${username}    ${password}    ${password}    ${code}
    #注册用户参数:平台、设备名、用户名、密码、确认密码、接口返回的code值
    Log Many    ${platform}    ${drivername}    ${username}    ${password}    ${password}
    login_page    click_registered    ${platform}    ${drivername}
    user_registered_page    registered_user    ${platform}    ${drivername}    ${username}    ${password}    ${password}
    #通过rest api验证用户是否注册成功
    判断用户是否存在    ${username}    ${code}