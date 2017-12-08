*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../../AgentRes.robot
Resource          ../../../../../commons/admin common/Members/Agents_Common.robot

*** Test Cases ***
获取所有的坐席列表数据(/v1/Admin/Agents)
    #设置局部变量
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #获取所有坐席列表
    ${j}    Set Agents    get    ${AdminUser}    ${agentFilter}    ${EMPTY}
    ${length}    get length    ${j['content']}
    run keyword if    ${length} == 0    Fail    该租户的客服列表返回为空，${j}
    should be true    ${j['totalElements']} > 0    该租户的客服列表返总数返回有误，${j}
    should be equal    ${j['content'][0]['tenantId']}    ${AdminUser.tenantId}    接口客服列表返回值中的tenantId字段不正确，${j}

新增坐席并查询坐席信息(/v1/Admin/Agents)
    #设置局部变量
    ${curTime}    get time    epoch
    ${name}    set variable    ${AdminUser.tenantId}${curTime}
    &{agent}=    create dictionary    username=${name}@qq.com    password=lijipeng123    maxServiceSessionCount=10    nicename=${name}    permission=1
    ...    roles=admin,agent
    ${data}=    set variable    {"nicename":"${agent.nicename}","username":"${agent.username}","password":"${agent.password}","confirmPassword":"${agent.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${agent.maxServiceSessionCount}","permission":${agent.permission},"roles":"${agent.roles}"}
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #新增坐席
    ${j}    Set Agents    post    ${AdminUser}    ${agentFilter}    ${data}
    should be equal    ${j['username']}    ${agent.username}    接口客服列表返回值中的username字段不正确，${j}
    should be equal    ${j['nicename']}    ${agent.nicename}    接口客服列表返回值中的nicename字段不正确，${j}
    should be equal    ${j['tenantId']}    ${AdminUser.tenantId}    接口客服列表返回值中的tenantId字段不正确，${j}
    should be equal    ${j['state']}    Offline    接口客服列表返回值中的state字段不正确，${j}
    should be equal    ${j['status']}    Enable    接口客服列表返回值中的Enable字段不正确，${j}
    should be equal    ${j['maxServiceSessionCount']}    ${${agent.maxServiceSessionCount}}    接口客服列表返回值中的maxServiceSessionCount字段不正确，${j}
    should be equal    ${j['roles']}    ${agent.roles}    接口客服列表返回值中的roles字段不正确，${j}
    #设置查询条件，根据账号查询客服
    set to dictionary    ${agentFilter}    keyValue=${agent.username}
    #获取所有坐席列表
    ${j}    Set Agents    get    ${AdminUser}    ${agentFilter}    ${EMPTY}
    should be true    ${j['totalElements']} == 1    根据账号查询结果不是唯一，${j}
    should be equal    ${j['content'][0]['tenantId']}    ${AdminUser.tenantId}    根据账号查询结果tenantId不正确，${j}
    should be equal    ${j['content'][0]['username']}    ${agent.username}    根据账号查询结果username不正确，${j}

新增坐席并删除坐席(/v1/Admin/Agents)
    #设置局部变量
    ${curTime}    get time    epoch
    ${name}    set variable    ${AdminUser.tenantId}${curTime}
    &{agent}=    create dictionary    username=${name}@qq.com    password=lijipeng123    maxServiceSessionCount=10    nicename=${name}    permission=1
    ...    roles=admin,agent
    ${data}=    set variable    {"nicename":"${agent.nicename}","username":"${agent.username}","password":"${agent.password}","confirmPassword":"${agent.password}","trueName":"","mobilePhone":"","agentNumber":"","maxServiceSessionCount":"${agent.maxServiceSessionCount}","permission":${agent.permission},"roles":"${agent.roles}"}
    ${agentFilter}    copy dictionary    ${AgentFilterEntity}
    #新增坐席
    ${j}    Set Agents    post    ${AdminUser}    ${agentFilter}    ${data}
    should be equal    ${j['username']}    ${agent.username}    接口客服列表返回值中的username字段不正确，${j}
    should be equal    ${j['nicename']}    ${agent.nicename}    接口客服列表返回值中的nicename字段不正确，${j}
    should be equal    ${j['tenantId']}    ${AdminUser.tenantId}    接口客服列表返回值中的tenantId字段不正确，${j}
    should be equal    ${j['state']}    Offline    接口客服列表返回值中的state字段不正确，${j}
    should be equal    ${j['status']}    Enable    接口客服列表返回值中的Enable字段不正确，${j}
    should be equal    ${j['maxServiceSessionCount']}    ${${agent.maxServiceSessionCount}}    接口客服列表返回值中的maxServiceSessionCount字段不正确，${j}
    should be equal    ${j['roles']}    ${agent.roles}    接口客服列表返回值中的roles字段不正确，${j}
    #删除坐席
    ${j1}    Delete AgentUser    ${j['userId']}
    Should Be Equal    ${j1['status']}    OK    接口返回中status不等于OK: {j1}
