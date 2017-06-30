*** Settings ***
Suite Setup
Force Tags        ui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/KefuApi.robot
Library           uuid
Library           jsonschema
Library           urllib
Library           Selenium2Library

*** Test Cases ***
调度1：坐席登录（可接待状态），关闭机器人，通过绑定该坐席所在技能组的关联发消息，能自动调度
    #接口登录并打开浏览器
    Create Session    agent1session    ${kefuurl}
    ${resp}=    /login    agent1session    ${AgentUser1}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    set to dictionary    ${AgentUser1}    cookies=${resp.cookies}    tenantId=${j['agentUser']['tenantId']}    userId=${j['agentUser']['userId']}    roles=${j['agentUser']['roles']}    maxServiceSessionCount=${j['agentUser']['maxServiceSessionCount']}
    ...    session=agent1session
    set global variable    ${AgentUser1}    ${AgentUser1}
    @{t}=    Get Dictionary Keys    ${resp.cookies}
    open browser    ${kefuurl}    chrome    browser1
    : FOR    ${key}    IN    @{t}
    \    log    ${key}
    \    ${value}=    Get From Dictionary    ${resp.cookies}    ${key}
    \    Add Cookie    ${key}    ${value}
    ${cookies}=    Get Cookies
    go to    ${kefuurl}/mo/agent/chat
