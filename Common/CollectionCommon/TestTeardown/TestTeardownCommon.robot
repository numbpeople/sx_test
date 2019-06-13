*** Settings ***
Resource          ../../UserCommon/UserCommon.robot
Resource          ../../../Variable_Env.robot

*** Keywords ***
Test Data Teardown
    [Documentation]    测试用例集清理工作
    ...    - 1、删除用例中创建的用户
    Run Keyword And Ignore Error    Delete Temp Specific User For Test TearDown Loop    #删除用例中创建的用户
