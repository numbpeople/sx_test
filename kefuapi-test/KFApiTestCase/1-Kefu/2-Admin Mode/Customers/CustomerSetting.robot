*** Settings ***
Force Tags        customerSetting
Resource          ../../../../commons/admin common/Customers/Customers_common.robot

*** Test Cases ***
获取客户基础资料所有字段(/v1/crm/tenants/{tenantId}/columndefinitions)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客户基础资料所有字段，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口请求状态码为200、系统字段systemColumn等于True一共有9个。
    #获取基础资料所有字段信息
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    #记录返回值中"系统字段"的数量,并验证所有"系统字段"开关状态是否为ENABLE
    ${length}    set variable    0
    : FOR    ${n}    IN    @{j['entity']}
    \    continue for loop if    '${n['systemColumn']}' == 'False'
    \    ${length}=    run keyword if    '${n['systemColumn']}' == 'True'    evaluate    ${length}+1
    \    run keyword if    '${n['systemColumn']}' == 'True'    should be true    '${n['columnStatus']}' == 'ENABLE'    接口返回系统字段开启状态不正确:${n}
    #验证"系统字段"总数量是否为9
    should be true    ${length} == 9    接口返回"系统字段"数量不正确:@{j['entity']}

新增/编辑自定义字段(/v1/crm/tenants/{tenantId}/columndefinitions)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取客户基础资料所有字段，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions，接口请求状态码为200。
    ...    - Step2、新增一个"单行文本"格式的自定义字段，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions，接口请求状态码为200。
    ...    - Step3、获取新增后基础资料所有字段个数,判断是否比新增前+1,并验证新增字段的其他返回值，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions，接口请求状态码为200。
    ...    - Step4、编辑上面新增的自定义字段,将字段开关columnStatus更新为ENABLE，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions，接口请求状态码为200。
    ...    - Step5、获取租户下所有基础资料字段,找到该自定义字段,检查编辑是否有效，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口请求状态码为200、系统字段columnStatus等于ENABLE。
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
    ${entity}    set variable    ${j['entity']}
    #获取新增后基础资料所有字段个数,判断是否比新增前+1,并验证新增字段的其他返回值
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    ${lengthAfter}    get length    ${j['entity']}
    ${length}    evaluate    ${lengthBefor}+1
    should be equal    ${lengthAfter}    ${length}    接口返回总字段数量不正确:${j}
    should be equal    ${j['entity'][${lengthBefor}]['columnName']}    ${columnName}    接口返回columnName不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnStatus']}    DISABLE    接口返回columnStatus不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['displayName']}    ${displayName}    接口返回displayName不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['typeName']}    ${columnType}    接口返回typeName不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['typeDescribe']}    单行文本    接口返回typeDescribe不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['dateType']}    STRING    接口返回dateType不正确:${j['entity'][${lengthBefor}]}
    should be equal    ${j['entity'][${lengthBefor}]['columnType']['componentType']}    TEXT    接口返回componentType不正确:${j['entity'][${lengthBefor}]}
    #编辑上面新增的自定义字段,将字段开关columnStatus更新为ENABLE,编辑自定义字段的put方法的请求体与新增的post方法返回体的entity一致
    set to dictionary    ${entity}    columnStatus=ENABLE
    log    ${entity}
    ${j}    Update Customer Columndefinition    ${AdminUser}    ${entity}    ${column}
    should be true    "${j['entity']['columnStatus']}" == "ENABLE"    接口返回的columnStatus不正确:${j}
    #获取租户下所有基础资料字段,找到该自定义字段,检查编辑是否有效
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值status不正确:${j}
    : FOR    ${n}    IN    @{j['entity']}
    \    run keyword if    "${n['columnName']}" == "${column}"    should be true    "${n['columnStatus']}" == "ENABLE"    接口返回的columnStatus不正确,与编辑后的不符:${n}

删除自定义字段(/v1/crm/tenants/{tenantId}/columndefinitions/{columnName})
    [Documentation]    【操作步骤】：
    ...    - Step1、删除新增的自定义字段，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions/{columnName}，接口请求状态码为200。
    ...    - Step2、获取基础资料所有字段个数,判断是否与新增前一致，调用接口：/v1/crm/tenants/{tenantId}/columndefinitions，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口请求状态码为200、删除自定义字段后，接口返回总字段数量未改变。
    #删除上一个case新增的自定义字段
    ${j}    Delete Customer Columndefinition    ${AdminUser}    ${column}
    should be equal    ${j['entity']['columnName']}    ${column}    接口返回columnName不正确:${j}
    #获取基础资料所有字段个数,判断是否与新增前一致
    ${j}    Get Customer Columndefinitions    ${AdminUser}
    ${lengthAfter}    get length    ${j['entity']}
    should be equal    ${columnLength}    ${lengthAfter}    接口返回总字段数量不正确:${j}

新增/编辑/删除自定义分组(/v1/crm/tenants/{tenantId}/filters)
    [Documentation]    【操作步骤】：
    ...    - Step1、新增一个"最近一次会话创建时间"为"今天"的客户自定义分组，调用接口：/v1/crm/tenants/{tenantId}/filters，接口请求状态码为200。
    ...    - Step2、获取租户下所有客户自定义分组,检查是否有新增的数据，调用接口：/v1/crm/tenants/{tenantId}/filters，接口请求状态码为200。
    ...    - Step3、编辑自定义分组,将坐席是否可见visible字段更新为false，调用接口：/v1/crm/tenants/{tenantId}/filters，接口请求状态码为200。
    ...    - Step4、删除上面新增的自定义分组，调用接口：/v1/crm/tenants/{tenantId}/filters，接口请求状态码为200。
    ...    - Step5、获取租户下所有客户自定义分组,检查是否还包含已删除的数据，调用接口：/v1/crm/tenants/{tenantId}/filters，接口请求状态码为200。
    ...    - Step6、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口请求状态码为200，数据删除后查询不到被删数据。
    #创建时间返回值，类似：1512921600000,1513007940000
    ${param}    set variable    1    #筛选时间是哪个维度, 为：今天、昨天、本周、本月、上月
    ${timeValue}    Create Time Value    ${param}
    log    ${timeValue}
    #创建请求体
    ${curTime}    get time    epoch
    ${displayName}    set variable    today${curTime}
    ${data}    set variable    {"displayName":"${displayName}","visible":true,"type":"normal","conditionList":[{"fieldName":"lastSessionCreateDateTime","operation":"RANGE","value":"${timeValue}","param":"1"}],"status":"ENABLE"}
    #新增一个"最近一次会话创建时间"为"今天"的客户自定义分组
    ${j}    Add Customer Group    ${AdminUser}    ${data}
    should be equal    ${j['entity']['displayName']}    ${displayName}    接口返回的displayName不正确:${j}
    ${filterId}    set variable    ${j['entity']['filterId']}
    ${entity}    set variable    ${j['entity']}
    #获取租户下所有客户自定义分组,检查是否有新增的数据
    ${j}    Get Customer Group    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值status不正确:${j}
    ${length}    get length    ${j['entities']}
    ${length}    evaluate    ${length}-1
    : FOR    ${n}    IN    @{j['entities']}
    \    run keyword if    "${n}" == "${j['entities'][${length}]}"    should be true    "${n['filterId']}" == "${filterId}"    接口返回的最后一条数据不正确,与新增的不符:${j}
    #编辑自定义分组,将坐席是否可见visible字段更新为false,编辑自定义分组的put方法的请求体与新增的post方法返回体的entity一致
    set to dictionary    ${entity}    visible=false
    log    ${entity}
    ${j}    Update Customer Group    ${AdminUser}    ${entity}    ${filterId}
    should be true    "${j['entity']['visible']}" == "False"    接口返回的visible不正确:${j}
    #获取租户下所有客户自定义分组,找到该分组,检查编辑是否有效
    ${j}    Get Customer Group    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值status不正确:${j}
    : FOR    ${n}    IN    @{j['entities']}
    \    run keyword if    "${n['filterId']}" == "${filterId}"    should be true    "${n['visible']}" == "False"    接口返回的visible不正确,与编辑后的不符:${n}
    #删除上面新增的自定义分组
    ${j}    Delete Customer Group    ${AdminUser}    ${filterId}
    should be equal    ${j['entity']['filterId']}    ${filterId}    接口返回的filterId不正确:${j}
    #获取租户下所有客户自定义分组,检查是否还包含已删除的数据
    ${j}    Get Customer Group    ${AdminUser}
    should be equal    ${j['status']}    OK    接口返回值status不正确:${j}
    ${contain}=    Find Customer Group From Filters    ${j}    ${filterId}
    should be equal    ${contain}    False    接口返回的自定义分组不正确,包含了已删除的数据:${j}
