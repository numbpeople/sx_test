*** Settings ***
Library    String
Library    Collections
Resource    ../Base.robot
Resource    ../../Variable_Env.robot
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../RestApi/User/UserApi.robot
Resource    ../../Common/BaseCommon.robot
Resource    ../../Common/AppCommon/AppCommon.robot
Resource    ../../Common/UserCommon/UserCommon.robot
Resource    ../../UITest_Env/RegisterLoginElement/RegisterPageElement.robot
Resource    ../../UITest_Env/RegisterLoginElement/LoginPageElement.robot
Resource    LoginCommon.robot



*** Variables ***
${time}     6
${backgroundtime}    10
${waitpagetime}    7

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
    #构建用户名密码
    ${spec_password}    Generate Random String    10    [NUMBERS]
    #用户名和密码设置全局变量
    Set To Dictionary    ${rightusername}    username=${username}    username1=${username1}    username2=${username2}    username3=${username3}    username5=${username5}    username8=${username8}
    Set To Dictionary    ${password}    spec_password=${spec_password}
    Set To Dictionary    ${errusername}    username4=${username4}    username6=${username6}    username7=${username7}
    Set Test Variable    ${rightusername}    ${rightusername}
    Set Test Variable    ${errusername}    ${errusername}
    Set Test Variable    ${password}    ${password}
    ${Length}    Get Length    ${rightusername}
    ${rightusernamevalue}    Get Dictionary Values    ${rightusername}
    ${i}    Set Variable    0
    FOR    ${i}    IN RANGE    ${Length}
        Record Temp User List    ${rightusernamevalue[${i}]}
    END
    

Change Xpath
    [Documentation]
    ...   1.根据平台判断页面使用的xpath
    [Arguments]    ${Android}    ${iOS}
    ${platform}    Convert To Lower Case    ${env.platform} 
    ${res}    Set Variable If    "${platform}" == "android"    ${Android}    ${iOS}  
    Return From Keyword    ${res}    ${platform}
    
Register Page No Register Button
    [Arguments]    ${methods}    ${login}    ${register}    ${username}    ${newpassword}    ${pwdconfirm}
    [Documentation]
    ...    注册页面，未点击注册按钮
    # 等待登录页面的“注册账号”元素出现
    Wait Until Page Contains Element    ${login.btn_register}    ${waitpagetime}
    #登录页面点击注册账号
    #id=com.hyphenate.easeim:id/tv_login_register
    Click Element    ${methods}=${login.btn_register}
    # 等待注册页面的“用户名输入框”元素出现
    Wait Until Page Contains Element    ${register.register_name}    ${waitpagetime}
    # id=com.hyphenate.easeim:id/et_login_name
    Input Text    ${methods}=${register.register_name}    ${username}
    # id=com.hyphenate.easeim:id/et_login_pwd
    Input Text    ${methods}=${register.register_pwd}    ${newpassword}
    # id=com.hyphenate.easeim:id/et_login_pwd_confirm
    Input Text    ${methods}=${register.register_pwd_confirm}    ${pwdconfirm}
    # id=com.hyphenate.easeim:id/cb_select
    Click Element    ${methods}=${register.select}
    
Register User Page
    [Arguments]    ${methods}    ${login}    ${register}    ${username}    ${newpassword}    ${pwdconfirm}
    Register Page No Register Button    ${methods}    ${login}    ${register}    ${username}    ${newpassword}    ${pwdconfirm}
    #点击“注册”按钮
    Click Element    ${methods}=${register.btn_register2}
    
Register User Template
    [Documentation]    注册页面封装(需要传入用户名、密码、确认密码)
    ...    1.登录页面点击【注册账号】
    ...    2.用户名输入框输入内容
    ...    3.输入确认密码
    ...    4.同意服务条款
    ...    5.点击注册按钮
    [Arguments]    ${username}    ${password}    ${pwdconfirm}    ${code}
    ${newpassword}    Set Variable If    "${password}" == "${EMPTY}"    ${username}    ${password}
    ${pwdconfirm}    Set Variable If    "${pwdconfirm}" == "${EMPTY}"    ${username}    ${pwdconfirm}
    #根据传入平台选择xpath
    Get xPaths Used
    Log Many    ${register}    ${login}    ${platform}
    Register User Page    ${methods}    ${login}    ${register}    ${username}    ${newpassword}    ${pwdconfirm}
    #等待时间写入输入库成功后，通过restapi查看注册是否成功
    Sleep    ${time}
    #无论注册成功还是失败，都返回登录页面
    Run Keyword And Ignore Error    Click Element        ${methods}=${register.back}
    #判断注册的用户是否注册成功
    Should Be exist    ${username}    ${code}

Register Login Page Swith
    [Arguments]    ${username}=    ${newpassword}=    ${pwdconfirm}=    ${num}=
    [Documentation]    注册登录页面频繁切换注册用户
    ...    
    Log    ${num}    
    #构建登录注册页面切换次数
    ${newnum}    Run Keyword If    "${num}" == "${EMPTY}"    Generate Random String     1    [NUMBERS]
    ...    ELSE    Set Variable    ${num}
    #构建注册的用户昵称和密码
    ${username}    Generate Random String    6    [LOWER][NUMBERS]
    Log    ${username}    
    #根据传入平台选择xpath
    Get xPaths Used
    ${i}    Set Variable    0
    #循环次数
    FOR    ${i}    IN RANGE    ${newnum}
        #从登陆页面进入到注册页面输入用户名和密码
        Register Page No Register Button    ${methods}    ${login}    ${register}    ${username}    ${newpassword}    ${pwdconfirm}
        ${num1}    Evaluate    ${newnum} - 1        
        Log Many    ${i}    ${num1}
        Exit For Loop If    "${i}" == "${num1}"
        #从注册页面返回登录页面
        Click Element    ${methods}=${register.back}
    END    
    Return From Keyword    ${methods}    ${register}    ${login}    ${platform}
    
Change LoginRegiter Page and Register Again Template
    [Arguments]    ${username}=    ${newpassword}=    ${pwdconfirm}=    ${num}=    ${code}=
    [Documentation]    注册登录页面频繁切换注册用户
    ...    
    ${methods}    ${register}    ${login}    ${platform}    Register Login Page Swith    ${username}    ${newpassword}    ${pwdconfirm}    ${num}
    #点击注册按钮
    Click Element    ${methods}=${register.btn_register2}
    #设置等待时间，用户注册完成后，不能立刻调用restapi
    Sleep    ${time}    
    #通过rest api验证用户是否注册成功
    Should Be exist    ${username}    ${code}
    
Change LoginRegiter Page and Login Again Template
    [Arguments]    ${username}=    ${newpassword}=    ${pwdconfirm}=    ${num}=    ${code}=
    [Documentation]    注册登录页面频繁切换注册用户
    ...    
    ${methods}    ${register}    ${login}    ${platform}    Register Login Page Swith    ${username}    ${newpassword}    ${pwdconfirm}    ${num}
    Click Element    ${methods}=${register.back}
    Normal Login User Template    ${username}    ${newpassword}
    #设置等待时间，用户注册完成后，不能立刻调用restapi
    Sleep    ${time}    
    #通过rest api验证用户是否注册成功
    Should Be exist    ${username}    ${code}
    
Register Existing User Template
    [Arguments]    ${username}    ${password}    ${pwdconfirm}
    #注册一个新用户
    ${userres}    Create New User    ${username}
    ${username}    set variable    ${userres['entities'][0]['username']}
    #通过UI页面注册一个已存在的用户
    ${newpassword}    Set Variable If    "${password}" == "${EMPTY}"    ${username}    ${password}
    ${pwdconfirm}    Set Variable If    "${pwdconfirm}" == "${EMPTY}"    ${username}    ${pwdconfirm}
    #根据传入平台选择xpath
    Get xPaths Used
    Log Many    ${register}    ${login}    ${platform}
    Register User Page    ${methods}    ${login}    ${register}    ${username}    ${newpassword}    ${pwdconfirm}
    #通过页面元素判断是否注册成功
    Page Should Contain Element    ${methods}=${register.back}