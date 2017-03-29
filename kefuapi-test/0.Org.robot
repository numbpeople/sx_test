*** Settings ***
Suite Setup
Force Tags        org
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          AgentRes.robot
Resource          api/OrgApi.robot
Resource          commons/admin common/BaseKeyword.robot
Library           uuid
Resource          JsonDiff.robot
Library           jsonschema

*** Test Cases ***
org管理员登录(/v2/orgs/{orgId}/token)
    Create Session    orgadminsession    ${orgurl}
    set to dictionary    ${OrgAdminUser}    session=orgadminsession
    ${resp}=    /v2/orgs/{orgId}/token    post    ${OrgAdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}，错误原因：${resp.content}
    Should Not Be Empty    ${resp.content}    返回值为空
    ${j}    to json    ${resp.content}
    should be true    '${j['status']}'=='OK'    返回值status不正确，期望值：OK，实际值：${j['status']}
    should be true    '${j['entity']['user']['orgId']}'=='${OrgAdminUser.orgId}'    返回值orgId不正确，期望值：${OrgAdminUser.orgId}，实际值：${j['entity']['user']['orgId']}
    set to dictionary    ${OrgAdminUser}    cookies=${resp.cookies}    userId=${j['entity']['user']['userId']}    nicename=${j['entity']['user']['nicename']}
    set global variable    ${OrgAdminUser}    ${OrgAdminUser}
    log    ${OrgAdminUser}
