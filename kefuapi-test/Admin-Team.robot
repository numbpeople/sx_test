*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          AgentRes.robot
Resource          KefuApi.robot
Resource          BaseKeyword.robot

*** Test Cases ***
批量创建坐席
    [Documentation]    [Tags] batch
    [Tags]    batch
    set test variable    ${tadmin}    ${AdminUser}
    : FOR    ${t}    IN RANGE    200
    \    &{AgentUser}=    create dictionary    username=${t}p1${tadmin.username}    password=test2015    maxServiceSessionCount=10    tenantId=${tadmin.tenantId}
    \    ${data}=    set variable    {"nicename":"${AgentUser.username}","username":"${AgentUser.username}","password":"${AgentUser.password}","confirmPassword":"${AgentUser.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${AgentUser.maxServiceSessionCount}","roles":"agent"}
    \    ${resp}=    /v1/Admin/Agents    post    ${tadmin}    ${AgentFilterEntity}    ${data}
    \    ...    ${timeout}
    \    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code}
