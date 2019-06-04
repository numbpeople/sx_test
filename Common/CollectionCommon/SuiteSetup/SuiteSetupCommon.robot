*** Settings ***
Resource          ../../TokenCommon/TokenCommon.robot
Resource          ../../AppCommon/AppCommon.robot
Resource          ../../UserCommon/UserCommon.robot
Resource          ../../GroupCommon/GroupCommon.robot
Resource          ../../ChatroomCommon/ChatroomCommon.robot

*** Keywords ***
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
    Get Valid And Invalid User Init    #初始化应用下用户信息
    Get Chatgroup Init    #初始化群组信息
    Get Chatroom Init    #初始化聊天室信息
    Set Model Case Run Status Init    #初始化模板case中，各条用例的执行状态
