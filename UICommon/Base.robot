*** Settings ***
Library    Lib/im_lib/Public.py
Library    Lib/im_lib/Bases_Public_method.py
Library    String
Library    Collections
Library    AppiumLibrary
Resource    ../Variable_Env.robot
Resource    ../UITest_Env/UITeset_Env.robot
Resource    ../RestApi/User/UserApi.robot
Resource    ../Common/BaseCommon.robot
Resource    ../Common/AppCommon/AppCommon.robot
Resource    ../Common/UserCommon/UserCommon.robot
Resource    ../Common/CollectionCommon/SuiteSetup/SuiteSetupCommon.robot
Resource    UIUserCommon/RegistetCommon.robot


*** Keywords ***
UI Test Data Teardown
    [Documentation]    测试用例集清理工作
    ...    - 1、删除用例中创建的用户
    Run Keyword And Ignore Error    Delete Temp Specific User For Test TearDown Loop    #删除用例中创建的用户
    
Open Test Application
    [Arguments]    ${platform}
    [Documentation]    根据${platform}判断执行平台，设置
    Log    ${platform}    
    #将传入的参数转换成小写
    ${newplatform}    Convert To Lower Case    ${platform}
    Log    ${newplatform}
    &{capabilities}    Create Dictionary    platformName=    platformVersion=    deviceName=    app=    appPackage=    appActivity=    uuid=    bundleId=    noReset=    automationName=
    #判断传入的参数是否为android，如果是则运行Android app，否则iOS app
    ${capabilities}    Set Variable If    "${newplatform}" == "android"     &{Android}    &{iOS}
    Log    ${capabilities}    
    #打开app
    Run Keyword If    "${newplatform}" == "android"    Open Application    http://127.0.0.1:4723/wd/hub    platformName=${capabilities.platformName}    platformVersion=${capabilities.platformVersion}    deviceName=${capabilities.deviceName}    app=${capabilities.app}    appPackage=${capabilities.appPackage}    appActivity=${capabilities.appActivity}    noReset=${capabilities.noReset}
    ...    ELSE    Open Application    http://127.0.0.1:4723/wd/hub    platformName=${capabilities.platformName}    platformVersion=${capabilities.platformVersion}    deviceName=${capabilities.deviceName}    app=${capabilities.app}    noReset=${capabilities.noReset}    automationName=${capabilities.automationName}    udid=${capabilities.uuid}
    Sleep    ${time}   
    
UI Setup Init
    [Documentation]    测试用例执行初始化部分：包括如下：
    ...    - 一、测试用例初始化数据准备，包括：Token、Appkey、用户数据、群组信息、聊天室信息等
    ...    - 二、共享多线程之间，保证初始化变量在各个线程之间可用
    # 创建连接session
    Create Alia Session
    # #锁住初始化的操作
    Acquire Lock    setupLock
    Run Only Once    Setup
    Release Lock    setupLock
    #从线程池中取出共享的变量，以供其他线程使用
    # Set Parallel Global Value
    Open Test Application    ${env.platform}