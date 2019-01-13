*** Settings ***
Resource          ../../BaseCommon.robot
Resource          ../../../Variable.robot
Resource          ../../../../../commons/CollectionData/Base_Collection.robot
Library           requests
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String
Library           ../../../../../lib/Transition.py

*** Keywords ***
Setup Init Base
    Kefu Data Init    #客服账号登录、创建等初始化
    StartAPPSetup    #启动客服app应用程序
    PreInstant All Elements Resource    #引入所有模块的Element变量的resource文件
    PreInstant All Elements    #预加载对应模块的Element变量，转换成json和字典，定义全局变量供测试用例使用
    LoginApp    #登录客服app
    Comment    Transition Init    #实例化状态机

StartAPPSetup
    #关闭所有app清空包缓存
    Close All Applications
    Evaluate    os.system("adb -s ${DEVICE_NAME} shell pm clear ${packagename}")    os
    Open Application    ${REMOTE_URL}    alias=kefuapp    platformName=${PLATFORM_NAME}    platformVersion=${PLATFORM_VERSION}    deviceName=${DEVICE_NAME}    appPackage=${appPackage}
    ...    appActivity=${appActivity}
    #多次判断登录按钮是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Enabled    ${packagename}:id/btnLogin
    should be true    ${status}    启动异常，登录按钮页面中没有查看到

Transition Init
    [Documentation]    实例化状态机
    #实例化状态机
    ${model}    ${machine}    Return_Model    ${states}    ${transitions}
    Set Global Variable    ${model}    ${model}
    Set Global Variable    ${machine}    ${machine}

Transition Status
    log    ${TEST STATUS}
    log    ${model.state}
    log    ${TEST NAME}
    #根据&符号分割用例集名称
    @{pageModel} =    Split String    ${TEST NAME}    &
    ${length}    get length    ${pageModel}
    Comment    run keyword if    ${length} <= 1    FAIL    测试用例名称未包含模块或页面名称
    Comment    log    ${pageModel[1]}
    Comment    #取出自定义的模块名字前缀
    Comment    ${modelName}    set variable    ${pageModel[1]}
    Comment    #将状态更新为当前最新的状态
    Comment    log    ${model.do_${modelName}()}
    log    ${model.state}

Kefu Data Init
    [Documentation]    坐席账号初始化登录数据、获取灰度列表、获取租户所属organ信息、创建关联信息等的初始化工作
    Setup Init Data    #坐席账号初始化登录数据、获取灰度列表、获取租户所属organ信息、创建关联信息等的初始化工作

LoginApp
    [Documentation]    登录客服app
    #创建新的坐席账号供登录客服app使用
    ${kefuAppAgentInfo}    Create Agents And Add Queue    ${AdminUser}
    ${accountUsername}    set variable    ${kefuAppAgentInfo.agent.username}
    ${accountPassword}    set variable    ${kefuAppAgentInfo.agent.password}
    #获取元素值
    ${etAccountInputElement}    set variable    ${LoginPageResDic.etAccount.element}    #账号输入框
    ${etPwdInputElement}    set variable    ${LoginPageResDic.etPwd.element}    #密码输入框
    ${cbHiddenLoginElement}    set variable    ${LoginPageResDic.cb_hidden_login.element}    #隐身登录按钮
    ${btnLoginElement}    set variable    ${LoginPageResDic.btnLogin.element}    #登录按钮
    ${tenantExpireButtonElement}    set variable    ${TenantExpirePageResDic.tenant_expire_button.element}    #租户到期提醒弹窗
    #多次判断登录按钮是否存在
    ${status}    Repeat Assert Keyword Times    Element Should Be Enabled    ${btnLoginElement}
    should be true    ${status}    启动异常，登录按钮页面中没有查看到
    #激活账号输入框并输入
    Input Object Text    ${etAccountInputElement}    ${accountUsername}
    #激活密码输入框并输入
    Input Object Text    ${etPwdInputElement}    ${accountPassword}
    Comment    #点击隐身登录按钮
    Comment    Click Object Element    ${cbHiddenLoginElement}
    #点击登录按钮
    Click Object Element    ${btnLoginElement}
    #多次判断是否满足断言条件判断
    ${status}    Repeat Assert Keyword Times    Page Should Not Contain Element    ${btnLoginElement}
    should be true    ${status}    登录后仍可以查看到登录按钮元素，没有登录成功
    #多次判断是否满足断言条件判断
    ${status}    Repeat Assert Keyword Times    Page Should Contain Text    租户到期提醒    2
    #如果有租户过期弹窗，则清楚弹窗
    run keyword if    ${status}    Click Object Element    ${tenantExpireButtonElement}
    #设置${agentInfo}全局变量
    Set Global Variable    ${kefuAppAgentInfo}    ${kefuAppAgentInfo}
