*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Library    Collections
Resource    ../Base.robot
Resource    ../../Variable_Env.robot
Resource    ../../UITeset_Env.robot
Resource    ../../RestApi/User/UserApi.robot
Resource    ../../Common/BaseCommon.robot
Resource    ../../Common/AppCommon/AppCommon.robot
Resource    ../../Common/UserCommon/UserCommon.robot


*** Variables ***
${timeout}     2

*** Keywords ***
Should Be exist
    [Documentation]    通过restapi验证用户是否存在
    [Arguments]   ${username}    ${code}
    &{pathParamter}    Create Dictionary    orgName=${baseRes.validOrgName}    appName=${baseRes.validAppName}    userName=${username}
    #设置请求集和
    ${Authorization}    Set Variable    Bearer ${Token.orgToken}
    &{requestHeader}    Create Dictionary    Content-Type=application/json    Authorization=${Authorization}
    # ${requestHeader}    设置restapi请求header
    Log    ${requestHeader}     
    @{arguments}    Create List    ${RestRes.alias}    ${requestHeader}    ${pathParamter}
    ${apiResponse}    Get Specific User     @{arguments}
    Log    ${apiResponse}    
    Should Be Equal As Integers    ${code}    ${apiResponse.statusCode} 
    
Set UserName Password
    #构建正确用户名格式：纯英文
    ${username}    Generate Random String    4    [LOWER]
    #构建正确用户名格式：英文、_、-
    ${random1}    Generate Random String    4    [LOWER]
    ${username1}    Set Variable    ${random1}-a_b
    #构建正确用户名格式：英文、数字
    ${random2}    Generate Random String    4    [LOWER]
    ${randomnum2}    Generate Random String    2    [NUMBERS]
    ${username2}    Set Variable    ${random1}${randomnum2}
    #构建正确用户名格式：纯数字
    ${min}    Set Variable    1
    ${max}    Set Variable    100000
    ${username3}    Evaluate    random.randint(${min},${max})    random  
    #构建错误的用户名格式：特殊字符、英文
    ${username4}    Set Variable    ${random2}@
    Log    ${username4}    
    #构建正确的用户名长度64位：英文
    ${username5}    Generate Random String    64    [LOWER]
    #构建正确的用户名长度超过64位：65英文
    ${username6}    Generate Random String    65    [LOWER]
    #用户名长度为错误格式：中文
    ${username7}    Set Variable    用户名
    Get Length    item
    #构建用户名密码
    ${password}    Generate Random String    1    [NUMBERS]
    #用户名和密码设置全局变量
    Set To Dictionary    ${login}    username=${username}    username1=${username1}    username2=${username2}    username3=${username3}
    ...    username4=${username4}    username5=${username5}    username6=${username6}    username7=${username7}     
    ...    password=${password}
    Set Global Variable    ${login}    ${login}
Determine Regist Page Element
    [Arguments]    ${drivername}    ${element}    ${platform}    ${drivername}
    [Documentation]    判断注册页面元素是否存在，如果存在则返回登录页面
    ${element_res}    element_judge    ${drivername}    registered_page_element    ${element}
    Run Keyword If    ${element_res}    user_registered_page     click_return     ${platform}    ${drivername}
Resgiter User Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${password}    ${password}    ${code}
    [Documentation]    
    ...    步骤1：点击【注册用户】
    ...    步骤2：输入用户名、密码、确认密码
    ...    步骤3：点击注册
    ...    步骤4：判断页面是否存在注册按钮，存在则返回，不存在则下一步
    ...    步骤5：通过restapi判断是否注册成功
    #注册用户参数:平台、设备名、用户名、密码、确认密码、接口返回的code值
    Log Many    ${platform}    ${drivername}    ${username}    ${password}    ${password}
    #点击登录页面注册账号
    login_page    click_registered    ${platform}    ${drivername}
    #注册页面注册账号
    user_registered_page    registered_user    ${platform}    ${drivername}    ${username}    ${password}    ${password}
    #等待一段时间，方便后边restapi查看用户
    Sleep    ${timeout}  
    #判断页面元素是不是存在（注册失败时，停留在注册页面，需要返回到登录页面）
    ${element_res}    element_judge    ${drivername}    registered_page_element    a_user_element
    Run Keyword If    ${element_res}    user_registered_page     click_return     ${platform}    ${drivername}
    #设置等待时间，用户注册完成后，不能立刻调用restapi
    Sleep    ${timeout}    
    #通过rest api验证用户是否注册成功
    Should Be exist    ${username}    ${code}