*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../AgentRes.robot
Resource          ../../../commons/admin common/Setting/Questionnaire_Common.robot

*** Test Cases ***
获取问卷账号列表(/v1/tenants/{tenantId}/questionnaires/accounts)
    #获取问卷账号列表
    ${j}    Set Questionnaire    ${AdminUser}    get    ${EMPTY}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

创建问卷账号列表(/v1/tenants/{tenantId}/questionnaires/accounts)
    #创建问卷账号列表
    ${data}    set variable    {"type":"WJW" }
    ${j}    Set Questionnaire    ${AdminUser}    post    ${data}
    ${tenantid}    convert to string    ${AdminUser.tenantId}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['tenant_id']}    ${AdminUser.tenantId}    返回值中租户id不正确: ${j}
    should be equal    ${j['entity']['type']}    WJW    返回值中的类型不正确: ${j}
    should be equal    ${j['entity']['status']}    Enable    返回值中的状态不正确: ${j}
    Should Contain    ${j['entity']['username']}    ${tenantid}    返回值中的账号名称不正确: ${j}

获取问卷问题列表(/v1/tenants/{tenantId}/questionnaires/list)
    #获取问卷账号列表
    ${j}    Get Questionnaires List    WJW
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

删除问卷账号列表(/v1/tenants/{tenantId}/questionnaires/accounts)
    #创建问卷账号列表
    ${data}    set variable    {"type":"WJW" }
    ${j}    Set Questionnaire    ${AdminUser}    delete    ${data}
    ${tenantid}    convert to string    ${AdminUser.tenantId}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entity']['tenant_id']}    ${AdminUser.tenantId}    返回值中租户id不正确: ${j}
    should be equal    ${j['entity']['type']}    WJW    返回值中的类型不正确: ${j}
    should be equal    ${j['entity']['status']}    Deleted    返回值中的状态不正确: ${j}
    Should Contain    ${j['entity']['username']}    ${tenantid}    返回值中的账号名称不正确: ${j}
