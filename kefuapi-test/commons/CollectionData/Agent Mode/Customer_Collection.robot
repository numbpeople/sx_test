*** Settings ***
Resource          ../../agent common/Customers/Customers_Common.robot
Resource          ../../../AgentRes.robot

*** Keywords ***
Customer Setup
    comment

Customer Teardown
    [Documentation]    清除设置-客户中心设置的自动分组数据
    Clear Filters    #清除设置-客户中心设置的自动分组数据
