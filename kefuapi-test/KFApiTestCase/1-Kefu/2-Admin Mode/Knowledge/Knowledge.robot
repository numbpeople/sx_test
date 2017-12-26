*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Knowledge/Knowledge_Common.robot

*** Test Cases ***
获取知识库的菜单分类(/v1/tenants/{tenantId}/knowledge/categories/tree)
    #获取知识库的菜单分类
    ${j}    Get Knowledge Categories    ${AdminUser}
    should be equal    ${j['status']}    OK
    ${length}    set variable    ${j['entities']}
