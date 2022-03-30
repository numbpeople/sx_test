*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITeset_Env.robot
Resource    ../../UICommon/UIUserCommon/RegistetCommon.robot
Resource    ../../UICommon/UIUserCommon/LoginCommon.robot
Test Setup    Set UserName Password



*** Test Cases ***
注册用户
    [Documentation]    Create by shuang
    ...    1.注册用户名使用64位以内字符：纯英文、英文-_、英文数字、纯数字、64英文、65位英文、中文、大写字母
    [Template]    Resgiter User Template
    ${env.platform}    ${driver.name}    ${login.username}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username1}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username2}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username3}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username4}    ${login.errorcode}
    # ${env.platform}    ${driver.name}    ${login.username5}    ${login.rightcode}
    # ${env.platform}    ${driver.name}    ${login.username6}    ${login.errorcode}
    # ${env.platform}    ${driver.name}    ${login.username7}    ${login.errorcode}
    ${env.platform}    ${driver.name}    ${login.username8}    ${login.rightcode}
    
注册登录页面切换再注册
    [Documentation]    Cresate by shuang
    [Template]    Register Login Page Switch Template
    ${env.platform}    ${driver.name}    ${env.num}
    
登录用户 
    [Documentation]    Create by shuang
    [Template]    Normal Login User Template
    # ${env.platform}    ${driver.name}    ${login.username}    ${login.password}    ${login.pageelement}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username1}    ${login.password}    ${login.pageelement}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username2}    ${login.password}    ${login.pageelement}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username3}    ${login.password}    ${login.pageelement}    ${True}
    # ${env.platform}    ${driver.name}    ${login.username5}    ${login.password}    ${login.pageelement}    ${True}
    ${env.platform}    ${driver.name}    ${login.username8}    ${login.spec_password}    ${login.pageelement}    ${True}
 
登录-错误的密码
    [Documentation]    Create by shuang
    [Template]    Error Userpass Login Template
    ${env.platform}    ${driver.name}    ${login.username}    ${login.pageelement}    ${False}

登录-用户不存在
    [Documentation]    Create by shuang 
    [Template]    LoginUser NoExit Template
    ${env.platform}    ${driver.name}    ${login.username}    ${login.pageelement}    ${False}
    
登录-后台运行再登录
    [Documentation]    Cresate by shuang
    [Template]    Login Background Template
    ${env.platform}    ${driver.name}    ${login.username}    ${login.pageelement}    ${True}
 
注册-后台运行再注册
    [Documentation]    Cresate by shuang
    [Template]    Register Backgroud Template
    ${env.platform}    ${driver.name}    ${login.username}   ${login.pageelement}    ${login.rightcode}