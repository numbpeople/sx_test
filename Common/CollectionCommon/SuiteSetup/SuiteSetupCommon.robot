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
Get username and name
    [Documentation]    #根据url判断超级管理员登录的用户名和密码
    #根据url判断超级管理员登录的用户名和密码
    #hsb
    ${username}    Set Variable If    "${RestRes.RestUrl}"=="http://a1-hsb.easemob.com"    easemob@easemob.com
    #vip6
    ...    "${RestRes.RestUrl}"=="http://a1-vip6.easemob.com"    1066280919@qq.com
    #hw
    ...    "${RestRes.RestUrl}"=="http://a1-hw.easemob.com"    13400327635@139.com
    #east
    ...    "${RestRes.RestUrl}"=="https://a41.easemob.com"    dee.wu@easemob.com
    #frank
    ...    "${RestRes.RestUrl}"=="https://a51.easemob.com"    1541499889@qq.com
    #sgp
    ...    "${RestRes.RestUrl}"=="https://a1-sgp.easemob.com"    shuangxi89710@163.com
    #ebs
    ...    "${RestRes.RestUrl}"=="http://a1.easemob.com"    easemobdemoadmin
    #hk
    ...    "${RestRes.RestUrl}"=="https://hk-test.easemob.com"    wwl@easemob.com
    #frank_aws
    ...    "${RestRes.RestUrl}"=="https://a71.easemob.com"    test@easemob.com
    #sgp_aws
    ...    "${RestRes.RestUrl}"=="https://a61.easemob.com"    wwltest@easemob.com 
    ${password}    Set Variable If    "${RestRes.RestUrl}"=="http://a1-hsb.easemob.com" or "${RestRes.RestUrl}"=="http://a1.easemob.com"   ${Password.password_ebs_hsb}
    ...    "${RestRes.RestUrl}"!="http://a1-hsb.easemob.com" or "${RestRes.RestUrl}"!="http://a1.easemob.com"    ${Password.other_password}
    # [Return]    ${username}    ${password}    
    Return From Keyword    ${username}    ${password}

Create Alia Session
    [Documentation]    创建rest链接
    #根据url判断超级管理员登录的用户名和密码
    ${username}    ${password}    Get username and name
    Set To Dictionary    ${RestRes}    username=${username}        password=${password}
    Create Session    session    ${RestRes.RestUrl}
    Create Session    consolesession    ${ManagementApi.ManagetmentUrl}
    set to dictionary    ${RestRes}    alias=session    consolealias=consolesession
    Log    ${RestRes}    
    set global variable    ${RestRes}    ${RestRes}
