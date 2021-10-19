*** Settings ***
Resource          ../../TokenCommon/TokenCommon.robot
Resource          ../../AppCommon/AppCommon.robot
Resource          ../../UserCommon/UserCommon.robot
Resource          ../../GroupCommon/GroupCommon.robot
Resource          ../../ChatroomCommon/ChatroomCommon.robot
Resource          ../../../Variable_Env.robot
Library           pabot.PabotLib

*** Keywords ***
Setup Init
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

Setup
    [Documentation]    测试用例执行初始化部分：包括如下：
    ...    - 1、设置超管Token等相关信息、或获取Org Token
    ...    - 2、在有设置超管Token条件下获取并设置应用数据，或创建新的应用
    ...    - 3、初始化Appkey的token信息
    ...    - 4、获取应用下用户数据
    ...    - 5、初始化群组信息
    ...    - 6、初始化聊天室信息
    ...    - 7、根据超管token指定情况，设置模板用例的执行状态
    Get OrgToken Or BestToken Init    #初始化console后台管理token或设置超管token
    Get Applications And Set AppName Init    #初始化组织下的应用信息
    Get AppToken Init    #初始化Appkey的token
    # Get UserToken init    #初始化usertoken
    Get Valid And Invalid User Init    #初始化应用下用户信息
    Get Chatgroup Init    #初始化群组信息
    Get Chatroom Init    #初始化聊天室信息
    Set Model Case Run Status Init    #初始化模板case中，各条用例的执行状态

Set Parallel Global Value
    [Documentation]    从线程池中取出共享的变量，以供其他线程使用
    #从线程池中取出共享的变量，以供其他线程使用
    &{ParallelRestRes}    Get Parallel Value For Key    ParallelRestRes
    &{ParallelToken}    Get Parallel Value For Key    ParallelToken
    &{ParallelbaseRes}    Get Parallel Value For Key    ParallelbaseRes
    &{ParallelRunModelCaseConditionDic}    Get Parallel Value For Key    ParallelRunModelCaseConditionDic
    &{ParallelModelCaseRunStatus}    Get Parallel Value For Key    ParallelModelCaseRunStatus
    &{ParallelvalidIMUserInfo}    Get Parallel Value For Key    ParallelvalidIMUserInfo
    Set Global Variable    ${RestRes}    ${ParallelRestRes}
    Set Global Variable    ${Token}    ${ParallelToken}
    Set Global Variable    ${baseRes}    ${ParallelbaseRes}
    Set Global Variable    ${RunModelCaseConditionDic}    ${ParallelRunModelCaseConditionDic}
    Set Global Variable    ${ModelCaseRunStatus}    ${ParallelModelCaseRunStatus}
    Set Global Variable    ${validIMUserInfo}    ${ParallelvalidIMUserInfo}

Create Alia Session
    #创建连接
    Create Session    session    ${RestRes.RestUrl}
    set to dictionary    ${RestRes}    alias=session
    set global variable    ${RestRes}    ${RestRes}
