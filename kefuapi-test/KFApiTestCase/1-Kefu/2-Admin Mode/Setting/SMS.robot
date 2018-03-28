*** Settings ***
Force Tags        unused
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/BaseApi/Settings/RemindApi.robot

*** Test Cases ***
查询所有短信配置(/v1/tenants/{tenantId}/sms/reminds)
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds    ${AdminUser}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

添加超时短信配置(/v1/tenants/{tenantId}/sms/create-remind)
    ${data}=    set variable    {"tenantId":${AdminUser.tenantId},"remindType":"WaitingsessionTimeout","remindName":"待接入超时提醒","receiver":[{"userName":"421351841@qq.com","niceName":"myqq","queueId":10,"phone":"13810515454"}],"sendShortMessageTimeZone":"timeAllDuty","sendCount":1,"remainCount":100,"waitTimeout":60,"twoShortMessageDiffTime":70}
    ${resp}=    /v1/tenants/{tenantId}/sms/create-remind    ${AdminUser}    ${data}    ${timeout}
    @{code_list}    Create List    ${400}    ${200}
    List Should Contain Value    ${code_list}    ${resp.status_code}    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}

按id查询、更改、删除短信配置(/v1/tenants/{tenantId}/sms/reminds/{id}/status)
    #按id查询
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}    get    ${AdminUser}    ${SmsRemindEntity.id}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #按id更改
    ${data}    set variable    {"id":${SmsRemindEntity.id},"tenantId":${AdminUser.tenantId},"remindType":"WaitingsessionTimeout","remindName":"待接入超时提醒1","receiver":[{"userName":"421351841@qq.com","niceName":"myqq","queueId":10,"phone":"13810515454"}],"sendShortMessageTimeZone":"timeAllDuty","sendCount":1,"remainCount":100,"waitTimeout":60,"twoShortMessageDiffTime":70}
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}    put    ${AdminUser}    ${SmsRemindEntity.id}    ${data}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
    #按id删除
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}    delete    ${AdminUser}    ${SmsRemindEntity.id}    ${empty}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}

修改短信提醒开关(/v1/tenants/{tenantId}/sms/reminds/{id}/status)
    #按id更改
    ${resp}=    /v1/tenants/{tenantId}/sms/reminds/{id}/status    ${AdminUser}    ${SmsRemindEntity}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    log    ${j}
