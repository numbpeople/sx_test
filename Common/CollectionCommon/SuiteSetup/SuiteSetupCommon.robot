*** Settings ***
Resource          ../../TokenCommon/TokenCommon.robot
Resource          ../../AppCommon/AppCommon.robot
Resource          ../../UserCommon/UserCommon.robot

*** Keywords ***
Setup
    [Documentation]    测试用例执行初始化部分：包括如下：
    ...    - 1、设置超管Token等相关信息、或获取Org Token
    ...    - 2、在有设置超管Token条件下获取并设置应用数据，或创建新的应用
    ...    - 3、获取应用下用户数据
    Get Org Token
    Get Applications And Set AppName
    Get Valid And Invalid User
