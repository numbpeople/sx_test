*** Settings ***
Documentation     | 灰度名称 | 灰度描述 | 灰度方式 | 灰度系统地址 |
...               | teamOverflow | 技能组溢出 | 公网内网灰度管理系统 | http://sandbox.kefumanage.easemob.com/grayctrl/login.html |
Force Tags        teamOverflow
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/RoutingApi.robot
Resource          ../../../JsonDiff/KefuJsonDiff.robot
Resource          ../../../commons/admin common/Setting/Routing_Common.robot
Resource          ../../../commons/admin common/BaseKeyword.robot
Resource          ../../../commons/admin common/Robot/Robot_Common.robot
Resource          ../../../api/IM/IMApi.robot
Resource          ../../../commons/Base Common/Base_Common.robot

*** Test Cases ***
添加、查询、编辑并删除rule(/v1/tenants/{tenantId}/waiting-queue-rulesets)
    [Documentation]    【操作步骤】：
    ...    - Step1、判断租户的增值功能【排队规则-技能组溢出】灰度开关状态，未开通灰度功能，不执行。
    ...    - Step2、获取坐席所在技能组列表，调用接口：/v1/tenants/{tenantId}/agents/{agentId}/skillgroups，接口请求状态码为200。
    ...    - Step3、添加技能组溢出规则，调用接口：/v1/tenants/{tenantId}/waiting-queue-rulesets，接口请求状态码为200。
    ...    - Step4、查询技能组溢出规则数据中是否有新添加的规则，调用接口：/v1/tenants/{tenantId}/waiting-queue-rulesets，接口请求状态码为200。
    ...    - Step5、修改新增的规则，调用接口：/v1/tenants/{tenantId}/waiting-queue-rulesets/{ruleId}，接口请求状态码为200。
    ...    - Step6、删除新增的规则，调用接口：/v1/tenants/{tenantId}/waiting-queue-rulesets/{ruleId}，接口请求状态码为200。
    ...    - Step7、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，请求状态码为200。
    #判断租户的增值功能，灰度开关状态
    ${status}    Check Tenant Gray Status
    Pass Execution If    not ${status}    该租户未开通灰度功能，不执行
    #获取坐席所在技能组列表
    ${j}    Get Agent QueueInfo    ${AdminUser}    ${AdminUser.userId}
    ${qid}    set variable    ${j['entities'][0]['queueId']}
    ${rname}    uuid 4
    #添加rule
    ${data}    set variable    {"rule_set_name":"${rname}","tenant_id":${AdminUser.tenantId},"type":"waiting","apply_to":"all","rules":[{"rule_id":"1","type":"and","criterion":"queue_length","operator":"gt","threshold":"1"}],"actions":[{"action_id":0,"action":"overflow","action_name":"溢出到配置的技能组","config":{"default_reserve_queue":${qid},"reserve_queue":${qid},"reserve_queue_from":"preset"}}],"rule_set_enable":"false"}
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets    post    ${AdminUser}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    添加rule返回不正确的状态码:${resp.status_code};${resp.text}
    ${j}    to json    ${resp.content}
    Should Be True    '${j['entity']['rule_set_name']}'=='${rname}'    添加rule返回不正确的rule name:${j}
    Should Be True    '${j['entity']['rule_set_enable']}'=='false'    添加rule返回不正确的rule 状态:${j}
    &{ruledict}    create dictionary    name=${rname}    enable=${j['entity']['rule_set_enable']}    id=${j['entity']['rule_set_id']}
    #查询rules中是否有新添加的rule
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rule返回不正确的状态码:${resp.status_code};${resp.text}
    Comment    ${j}    to json    ${resp.content}
    ${j}    to json    ${resp.text}
    set test variable    ${diffs1}    ${ruledict.name}${ruledict.enable}${ruledict.id}
    : FOR    ${i}    IN    @{j['entity']}
    \    set test variable    ${diffs2}    ${i['rule_set_name']}${i['rule_set_enable']}${i['rule_set_id']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Be True    '${diffs1}' == '${diffs2}'    未查询到添加的rule信息:${j}
    log    ${i}
    #开启rule
    ${s}    replace string    '${i}'    false    true
    ${s}    replace string    ${s}    '    "
    ${s}    replace string    ${s}    u"    "
    ${data}    strip string    ${s}    characters="
    ${data}    to json    ${data}
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets/{ruleId}    put    ${AdminUser}    ${data['rule_set_id']}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    开启rule返回不正确的状态码:${resp.status_code};${resp.text} \
    ${j}    to json    ${resp.content}
    Should Be True    '${j['entity']['rule_set_enable']}'=='true'    添加rule返回不正确的rule 状态:${j}
    set to dictionary    ${ruledict}    enable=${j['entity']['rule_set_enable']}
    #查询rules中是否有新添加的rule
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rule返回不正确的状态码:${resp.status_code};${resp.text} \
    ${j}    to json    ${resp.content}
    set test variable    ${diffs1}    ${ruledict.name}${ruledict.enable}${ruledict.id}
    : FOR    ${i}    IN    @{j['entity']}
    \    set test variable    ${diffs2}    ${i['rule_set_name']}${i['rule_set_enable']}${i['rule_set_id']}
    \    Run Keyword If    '${diffs1}' == '${diffs2}'    Exit For Loop
    Should Be True    '${diffs1}' == '${diffs2}'    未查询到编辑的rule信息:${j}
    #删除rule
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets/{ruleId}    delete    ${AdminUser}    ${i['rule_set_id']}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    删除rule返回不正确的状态码:${resp.status_code};${resp.text} \
    #查询删除后的rule信息是否还存在
    ${resp}=    /v1/tenants/{tenantId}/waiting-queue-rulesets    get    ${AdminUser}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    查询rule返回不正确的状态码:${resp.status_code};${resp.text}
    ${j}    to json    ${resp.content}
    run keyword if    "@{j['entity']}" == "[]"    Pass Execution    获取结果为空，该case通过
    set test variable    ${diffs1}    ${ruledict.name}${ruledict.enable}${ruledict.id}
    : FOR    ${i}    IN    @{j['entity']}
    \    set test variable    ${diffs3}    ${i['rule_set_name']}${i['rule_set_enable']}${i['rule_set_id']}
    \    Run Keyword If    '${diffs1}' == '${diffs3}'    Exit For Loop
    Should Not Be True    '${diffs1}' == '${diffs3}'    查询到已删除的rule信息:${j}
