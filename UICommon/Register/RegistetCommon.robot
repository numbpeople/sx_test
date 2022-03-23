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
Resource    ../Login/LoginCommon.robot



*** Variables ***
${time}     2
${backgroundtime}    10

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
    [Arguments]    ${len}=
    [Documentation]    创建用户名
    ...    1.如果长度存在则按照期望的长度构建，如果不存在则随机创建
    ${number}    Evaluate    random.randint(3,10)    
    ${newlen}    Run Keyword If    "${len}" =="${EMPTY}"    Set Variable    ${number}
    ...    ELSE    Set Variable    ${len}
    #构建正确用户名格式：纯英文
    ${username}    Generate Random String    ${newlen}    [LOWER]
    #构建正确用户名格式：英文、_、-
    ${random1}    Generate Random String    ${newlen}    [LOWER]
    ${username1}    Set Variable    ${random1}-${random1}
    #构建正确用户名格式：英文、数字
    ${random2}    Generate Random String    ${newlen}    [LOWER]
    ${randomnum2}    Generate Random String    ${newlen}    [NUMBERS]
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
    #使用大写字母注册
    ${username8}    Generate Random String    ${newlen}    [UPPER]    
    Get Length    item
    #构建用户名密码
    ${spec_password}    Generate Random String    65    [NUMBERS]
    #用户名和密码设置全局变量
    Set To Dictionary    ${login}    username=${username}    username1=${username1}    username2=${username2}    username3=${username3}
    ...    username4=${username4}    username5=${username5}    username6=${username6}    username7=${username7}    username8=${username8}
    ...    ${spec_password}
    Set Global Variable    ${login}    ${login}
Determine Regist Page Element
    [Arguments]    ${drivername}    ${element}    ${platform}    ${drivername}
    [Documentation]    判断注册页面元素是否存在，如果存在则返回登录页面
    ${element_res}    element_judge    ${drivername}    registered_page_element    ${element}
    Run Keyword If    ${element_res}    user_registered_page     click_return     ${platform}    ${drivername}

Resgiter User Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${code}
    [Documentation]    
    ...    步骤1：点击【注册用户】
    ...    步骤2：输入用户名、密码、确认密码
    ...    步骤3：点击注册
    ...    步骤4：判断页面是否存在注册按钮，存在则返回，不存在则下一步
    ...    步骤5：通过restapi判断是否注册成功
    #注册用户参数:平台、设备名、用户名、密码、确认密码、接口返回的code值
    Log Many    ${platform}    ${drivername}    ${username}
    #点击登录页面注册账号
    login_page    click_registered    ${platform}    ${drivername}
    #注册页面注册账号(用户名和密码一样)
    user_registered_page    registered_user    ${platform}    ${drivername}    ${username}    ${username}    ${username}
    #等待一段时间，方便后边restapi查看用户
    Sleep    ${time}  
    #判断页面元素是不是存在（注册失败时，停留在注册页面，需要返回到登录页面）
    ${element_res}    element_judge_text    ${drivername}    注册
    Run Keyword If    ${element_res}    user_registered_page     click_return     ${platform}    ${drivername}
    #设置等待时间，用户注册完成后，不能立刻调用restapi
    Sleep    ${time}    
    #通过rest api验证用户是否注册成功
    Should Be exist    ${username}    ${code}
    
Login Page Name
    [Arguments]    ${platform}    ${driver}    ${username}
    [Documentation]    封装登录页面与注册页面切换，最终停留在登录页面
    #登录页面点击“注册账号”
    login_page    click_registered    ${platform}    ${driver}    click
    #用户名输入框输入用户名
    user_registered_page    send_registered_user    ${platform}    ${driver}    ${username}
    #输入用户密码
    user_registered_page    send_registered_password    ${platform}    ${driver}    ${username}
    #输入用户确认密码
    user_registered_page    send_registered_confirm_password    ${platform}    ${driver}    ${username}
    #点击服务条款
    user_registered_page    click_agreement    ${platform}    ${driver}
    #点击返回按钮
    user_registered_page    click_return    ${platform}    ${driver}
    Sleep    1  
        
Register Login Page Switch Template
    [Arguments]    ${platform}    ${driver}    ${num}    
    [Documentation]    注册登录页面频繁切换注册用户
    ...    
    Log    ${num}    
    #构建登录注册页面切换次数
    ${newnum}    Run Keyword If    "${num}" == "${EMPTY}"    Generate Random String     1    [NUMBERS]
    ...    ELSE    Set Variable    ${num}
    #构建注册的用户昵称和密码
    ${username}    Generate Random String    6    [LOWER][NUMBERS]
    Log    ${username}    
    FOR    ${i}    IN RANGE    ${newnum} 
      Login Page Name    ${platform}    ${driver}    ${username}
    END    
    #判断页面元素是否存在
    element_judge_text    ${driver}    注册账号
    #登录页面点击“注册账号”
    login_page    click_registered    ${platform}    ${driver}    click
    #注册用户
    user_registered_page    registered_user    ${platform}    ${driver}    ${username}    ${username}    ${username}
    #设置等待时间，用户注册完成后，不能立刻调用restapi
    Sleep    ${time}    
    #通过rest api验证用户是否注册成功
    Should Be exist    ${username}    200
    
Register Backgroud Template
    [Arguments]    ${platform}    ${drivername}    ${username}    ${code}
    [Documentation]    登录页面退到后台后，再次登录
    #登录页面点击注册账号
    login_page    click_registered    ${platform}    ${drivername}
    #注册页面输入用户名
    user_registered_page    send_registered_user     ${platform}    ${drivername}    ${username}
    #注册页面输入密码
    user_registered_page    send_registered_password     ${platform}    ${drivername}    ${username}
    #注册页面输入确认密码
    user_registered_page    send_registered_confirm_password     ${platform}    ${drivername}    ${username}
    #注册页面点击同意条款
    user_registered_page    click_agreement     ${platform}    ${drivername}
    #退到后台等待一段时间
    public_app_background    ${drivername}    ${backgroundtime}
    Sleep    ${time}    
    #注册页面点击注册
    user_registered_page    click_registered_button     ${platform}    ${drivername}
    #等待时间，进行restapi检验
    Sleep    ${time}    
    #rest api判断用户是否注册成功
    Should Be exist    ${username}    ${code}