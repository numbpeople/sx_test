*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Setting/Phrases_Common.robot
Resource          ../../../../api/BaseApi/Settings/PhrasesApi.robot

*** Test Cases ***
获取分类以及常用语列表(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，坐席模式获取个人常用语
    &{phrasesEntity}    create dictionary    systemOnly=false    buildChildren=true    buildCount=true
    #获取常用语分类
    ${j}    Set Phrases    ${AdminUser}    get    ${orgEntity}    ${phrasesEntity}    ${EMPTY}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Fail    租户下的没有个人常用语分类，需要检查下，${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}

添加分类(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}

添加公共常用语(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在新建分类下新增公共常用语
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=1
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

添加子分类(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在分类下新增子分类
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=0
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

修改公共常用语(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在新建分类下新增公共常用语
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=1
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}
    #修改公共常用语
    &{changePhrasesEnt}    create dictionary    id=${j['entity']['id']}    leaf=true    parentId=${phrasesEnt.parentId}    phrase=${AdminUser.tenantId}-${uuid}-${uuid}    brief=
    ${data1}    set variable    {"id":${changepHrasesEnt.id},"leaf":${changepHrasesEnt.leaf},"parentId":${changepHrasesEnt.parentId},"phrase":"${changepHrasesEnt.phrase}","brief":"${changepHrasesEnt.brief}"}
    ${j}    Set Phrases    ${AdminUser}    put    ${orgEntity}    ${phrasesEntity}    ${data1}
    ...    ${changePhrasesEnt.id}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${changepHrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

修改子分类名称(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在分类下新增子分类
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=0
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}
    #修改子分类名称
    &{changePhrasesEnt}    create dictionary    id=${j['entity']['id']}    leaf=false    parentId=${phrasesEnt.parentId}    phrase=${AdminUser.tenantId}-${uuid}-${uuid}
    ${data1}    set variable    {"id":${changepHrasesEnt.id},"leaf":${changepHrasesEnt.leaf},"parentId":${changepHrasesEnt.parentId},"phrase":"${changepHrasesEnt.phrase}"}
    ${j}    Set Phrases    ${AdminUser}    put    ${orgEntity}    ${phrasesEntity}    ${data1}
    ...    ${changePhrasesEnt.id}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${changepHrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}

删除分类(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #删除常用语分类
    ${j}    Set Phrases    ${AdminUser}    delete    ${orgEntity}    ${phrasesEntity}    ${EMPTY}
    ...    ${j['entity']['id']}
    should be equal    ${j['status']}    OK    获取status值不正确：${j}

删除公共常用语(/v1/organs/{organName}/tenants/{tenantId}/commonphrases)
    #创建参数字典，管理员模式获取公共常用语
    ${uuid}    Uuid 4
    &{phrasesEntity}    create dictionary    systemOnly=true    buildChildren=true    buildCount=true
    ${data}    set variable    {"parentId":0,"phrase":"${AdminUser.tenantId}-${uuid}"}
    #新增常用语分类
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data}
    should be equal    ${j['status']}    OK    获取常用语分类数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语分类没有返回数据，需要检查 \ ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    #在新建分类下新增公共常用语
    &{phrasesEnt}    create dictionary    parentId=${j['entity']['id']}    phrase=${AdminUser.tenantId}-${uuid}    leaf=1
    ${data1}    set variable    {"parentId":${phrasesEnt.parentId},"phrase":"${phrasesEnt.phrase}","leaf":${phrasesEnt.leaf}}
    ${j}    Set Phrases    ${AdminUser}    post    ${orgEntity}    ${phrasesEntity}    ${data1}
    should be equal    ${j['status']}    OK    获取常用语数据不正确：${j}
    ${length} =    get length    ${j['entity']}
    Run Keyword if    ${length} == 0    Fail    添加公共常用语没有返回数据，需要检查 ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值中tenantId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['parentId']}    ${phrasesEnt.parentId}    返回值中parentId值不正确: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entity']['phrase']}    ${phrasesEnt.phrase}    返回值中phrase字段值不正确: ${j}
    #删除共公常用语
    ${j}    Set Phrases    ${AdminUser}    delete    ${orgEntity}    ${phrasesEntity}    ${EMPTY}
    ...    ${j['entity']['id']}
    should be equal    ${j['status']}    OK    获取status值不正确：${j}

获取常用语模板(/download/tplfiles/%E5%AF%BC%E5%85%A5%E5%B8%B8%E7%94%A8%E8%AF%AD%E8%A7%84%E5%88%99.xlsx)
    ${resp}=    Export Commonphrases Template    ${AdminUser}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    #log    ${resp.headers.Content-Length}
    log    ${resp.headers}
    log    ${resp.headers['Content-Type']}
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream    获取知识库模板失败

导出常用语(/v1/tenants/{tenantId}/commonphrases/exportFile)
    ${resp}=    Commonphrases ExportFile    ${AdminUser}
    log    ${resp.headers}
    log    ${resp.headers['Content-Type']}
    # Should Be Equal    ${resp.headers['Content-Type']}    application/octet-stream; charset=UTF-8    导出常用语失败
