*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/agent common/Conversations/Conversations_Common.robot
Resource          ../../../../commons/agent common/Export/Export_Common.robot
Resource          ../../../../commons/agent common/History/History_Common.robot

*** Test Cases ***
导出管理(/tenants/{tenantId}/serviceSessionHistoryFiles)
    #定义为局部变量使用
    ${filter}    copy dictionary    ${FilterEntity}
    ${range}    copy dictionary    ${DateRange}
    #设置筛选开始时间为当天
    ${yyyy}    ${mm}    ${day}=    Get Time    year,month,day
    ${yn}=    Convert To Integer    ${yyyy}
    ${mn}=    Convert To Integer    ${mm}
    ${dn}=    Convert To Integer    ${day}
    ${mr}=    Monthrange    ${yn}    ${mn}
    set to dictionary    ${range}    beginDate=${yyyy}-${mm}-${mr[1]}T00%3A00%3A00.000Z
    #创建已结束的会话
    Create Terminal Conversation
    #导出历史会话数据
    Export My History    post    ${AdminUser}    ${filter}    ${range}
    #获取当前的时间
    @{localTime}    get time    year month day hour min sec
    ${i}    Get My Export And Check Status    ${AdminUser}    ${filter}    ${range}    ${localTime}
    should be equal    ${i['tenantId']}    ${AdminUser.tenantId}    返回结果中不包含租户id，${i}
    should be equal    ${i['status']}    Finished    返回结果中status不是Finished，${i}
