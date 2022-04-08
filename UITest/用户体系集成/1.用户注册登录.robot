*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Resource    ../../UITest_Env/UITeset_Env.robot
Resource    ../../UICommon/UIUserCommon/RegistetCommon.robot
Resource    ../../UICommon/UIUserCommon/LoginCommon.robot
Resource    ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot
Resource    ../../UICommon/UIUserCommon/LoginCommon.robot

*** Test Cases *** 
注册用户成功
    [Documentation]    Create by shuang
    ...    1.注册用户名使用64位以内字符：纯英文、英文-_、英文数字、纯数字、64英文、大写字母
    ...    2.传入的参数分别为：用户名、密码、确认密码、判断码
    [Template]    Register User Template  
    [Setup]    Set UserName Password
    [Teardown]   UI Test Data Teardown 
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username}    ${statuscode.ricode}
    ${rightusername.username1}    ${rightusername.username1}    ${rightusername.username1}    ${statuscode.ricode}
    ${rightusername.username2}    ${rightusername.username2}    ${rightusername.username2}    ${statuscode.ricode}
    ${rightusername.username3}    ${rightusername.username3}    ${rightusername.username3}    ${statuscode.ricode}
    ${rightusername.username5}    ${rightusername.username5}    ${rightusername.username5}    ${statuscode.ricode}
    ${rightusername.username8}    ${rightusername.username8}    ${rightusername.username8}    ${statuscode.ricode}

注册用户失败
    [Documentation]     Create by shuang
    ...    1.注册用户失败:65位英文、特殊字符、中文、错误的确认密码
    [Template]    Register User Template  
    [Setup]    Set UserName Password
    ${errusername.username4}    ${errusername.username4}    ${errusername.username4}    ${statuscode.errcode}
    ${errusername.username6}    ${errusername.username6}    ${errusername.username6}    ${statuscode.errcode}
    ${errusername.username7}    ${errusername.username7}    ${errusername.username7}    ${statuscode.errcode}
    ${errusername.username7}    ${rightusername.username1}    ${errusername.spec_password}    ${statuscode.errcode}
    
    
登录用户-正确的用户名和密码
    [Documentation]    
    ...    使用正确的用户名和密码登录
    ...    1.使用restapi注册用户
    ...    2.登录页面直接登录
    [Template]    Normal Login User Template
    [Setup]    Set UserName Password
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}
    ${rightusername.username1}    ${rightusername.username1}
    ${rightusername.username2}    ${rightusername.username2}
    ${rightusername.username3}    ${rightusername.username3}
    ${rightusername.username5}    ${rightusername.username5}
    ${rightusername.username8}    ${rightusername.username8}

注册登录
    [Documentation]    
    ...    使用正确的用户名和密码登录
    ...    1.注册页面先注册一个用户
    [Template]    Register Login Template
    [Setup]    Set UserName Password
    [Teardown]    UI Test Data Teardown
     ${rightusername.username}    ${rightusername.username}
    
注册登录页面切换再注册
    [Documentation]    Cresate by shuang
    ...    1.传入的参数分别为：用户名、密码、确认密码、判断码
    [Template]    Change LoginRegiter Page and Register Again Template
    [Setup]    Set UserName Password
    [Teardown]   UI Test Data Teardown 
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username}    ${num}    ${statuscode.ricode}
    
注册登录页面切换再登录
    [Documentation]    Cresate by shuang
    ...    1.传入的参数分别为：用户名、密码、确认密码、判断码
    [Template]    Change LoginRegiter Page and Login Again Template
    [Setup]    Set UserName Password
    [Teardown]   UI Test Data Teardown 
    ${rightusername.username}    ${rightusername.username}    ${rightusername.username}    ${num}    ${statuscode.ricode}
    
注册-后台运行再注册
    [Documentation]    Cresate by shuang
    [Template]    Register Backgroud Template
    ${env.platform}    ${driver.name}    ${login.username}   ${login.pageelement}    ${login.rightcode}
    
用户退出登录
    [Documentation]    
    ...    验证用户退出登录。
    [Template]    Normal Login User Template
    [Setup]    Set UserName Password
    [Teardown]    UI Test Data Teardown
    ${rightusername.username}    ${rightusername.username}