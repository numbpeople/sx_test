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
Resource    ../Common/CollectionCommon/SuiteSetup/SuiteSetupCommon.robot

*** Keywords ***
UI Setup Init
    [Documentation]    测试用例执行初始化部分：包括如下：
    ...    - 一、测试用例初始化数据准备，包括：Token、Appkey、用户数据、群组信息、聊天室信息等
    ...    - 二、共享多线程之间，保证初始化变量在各个线程之间可用
    #创建连接session
    Create Alia Session
    #锁住初始化的操作
    Acquire Lock    setupLock
    Run Only Once    Setup
    Release Lock    setupLock
    #从线程池中取出共享的变量，以供其他线程使用
    Set Parallel Global Value
    connect_appium_method    ${driver.name}
    