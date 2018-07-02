*** Settings ***
Resource          ../../../../commons/admin common/Customers/Customers_common.robot

*** Test Cases ***
获取客户基础资料所有字段(/v1/crm/tenants/{tenantId}/columndefinitions)
    [Documentation]    获取租户下客户基础资料设置中的所有字段
    #获取基础资料所有字段信息
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    #记录返回值中"系统字段"的数量,并验证所有"系统字段"开关状态是否为ENABLE
    ${length}    set variable    0
    :FOR    ${n}    IN    @{j['entity']}
    \    continue for loop if    '${n['systemColumn']}' == 'False'
    \    ${length}=    run keyword if    '${n['systemColumn']}' == 'True'    evaluate    ${length}+1
    \    run keyword if    '${n['systemColumn']}' == 'True'    should be true    '${n['columnStatus']}' == 'ENABLE'    接口返回系统字段开启状态不正确:${n}
    #验证"系统字段"总数量是否为9
    should be true    ${length} == 9    接口返回"系统字段"数量不正确:@{j['entity']}

新增自定义字段(/v1/crm/tenants/{tenantId}/columndefinitions)
    [Documentation]    新增"单行文本"格式的自定义字段
    #获取基础资料所有字段个数
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    ${lengthBefor}    get length    ${j['entity']}
    set suite variable    ${columnLength}    ${lengthBefor}
    #创建请求体
    ${curTime}    get time    epoch
    ${displayName}    set variable    column${curTime}
    ${columnType}    set variable    TEXT_STRING
    ${data}    set variable    {"displayName":"${displayName}","columnType":"${columnType}","visible":true,"columnDescribe":"","fromUrl":"","fromParam":""}
    #新增一个"单行文本"格式的自定义字段
    ${j}    Add Customer Columndefinition    ${AdminUser}    ${data}
    ${columnName}    set variable    ${j['entity']['columnName']}
    set suite variable    ${column}    ${columnName}
    #获取新增后基础资料所有字段个数,判断是否比新增前+1,并验证新增字段的其他返回值
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    ${lengthAfter}    get length    ${j['entity']}
    ${length}    evaluate    ${lengthBefor}+1
    should be equal    ${lengthAfter}   ${length}    接口返回总字段数量不正确:${j}
    should be equal    ${j['entity'][${lengthBefor}]['columnName']}    ${columnName}    接口返回columnName不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnStatus']}    DISABLE    接口返回columnStatus不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['displayName']}    ${displayName}    接口返回displayName不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['typeName']}    ${columnType}    接口返回typeName不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['typeDescribe']}    单行文本    接口返回typeDescribe不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['dateType']}    STRING    接口返回dateType不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['componentType']}    TEXT    接口返回componentType不正确:${j['entity'][${lengthBefor}]}

删除自定义字段(/v1/crm/tenants/{tenantId}/columndefinitions/{columnName})
    [Documentation]    删除上一个case新增的自定义字段
    #删除上一个case新增的自定义字段
    ${j}    Delete Customer Columndefinition    ${AdminUser}    ${column}
    should be equal    ${j['entity']['columnName']}    ${column}    接口返回columnName不正确:${j}
    #获取基础资料所有字段个数,判断是否与新增前一致
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    ${lengthAfter}    get length    ${j['entity']}
    should be equal    ${columnLength}    ${lengthAfter}    接口返回总字段数量不正确:${j}