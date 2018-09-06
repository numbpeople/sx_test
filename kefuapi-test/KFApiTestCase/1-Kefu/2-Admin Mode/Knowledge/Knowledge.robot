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
获取知识库的所有菜单分类(/v1/tenants/{tenantId}/knowledge/categories/tree)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识库菜单分类，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step2、获取菜单分类树中最新一条数据，应该包含该新增数据，调用接口：/v1/tenants/{tenantId}/knowledge/categories/tree，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK、字段categoryId值等于新增数据的categoryId值、字段name等于分类名称。
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #获取知识库的菜单分类
    ${j}    Get Knowledge Categories Tree    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    #断言结果中是否包含分类ID：CategoryId
    ${result}    Categories Should Contain CategoryId    ${j['entities']}    ${categoryResult.categoryId}
    run keyword if    ${result} == {}    接口中没有搜索到分类id：${categoryResult.categoryId}，${j}
    should be true    "${result['name']}" == "${categoryResult.name}"    返回值中分类名称不正确：${j}

创建知识库的菜单分类(/v1/tenants/{tenantId}/knowledge/categories)
    [Documentation]    【操作步骤】：
    ...    - Step1、添加知识库菜单分类，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK、字段name值等于分类名、字段tenantId等于租户id。 创建知识库菜单分类
    #创建请求体
    ${randoNumber}    Generate Random String    4    [NUMBERS]
    ${categoriesEntity}    create dictionary    name=${AdminUser.tenantId}-${randoNumber}    parentId=null
    ${data}    set variable    {"name":"${categoriesEntity.name}","parentId":${categoriesEntity.parentId}}
    #添加知识库菜单分类
    ${j}    Set Knowledge Category    post    ${AdminUser}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['name']}    ${categoriesEntity.name}    返回值name不是${categoriesEntity.name}：${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}

更新知识库的菜单分类名称(/v1/tenants/{tenantId}/knowledge/categories)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识库菜单分类，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step2、修改知识库菜单分类名称，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK、字段name值等于分类名、字段tenantId等于租户id。
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #创建请求体
    ${randoNumber}    Generate Random String    4    [NUMBERS]
    ${updateCategoryName}    set variable    update-${AdminUser.tenantId}-${randoNumber}
    ${parentId}    set variable    0
    ${data}    set variable    {"categoryId":${categoryResult.categoryId},"name":"${updateCategoryName}","tenantId":${AdminUser.tenantId},"level":${categoryResult.level},"rank":${categoryResult.rank},"createDateTime":"${categoryResult.createDateTime}","lastUpdateDateTime":"${categoryResult.lastUpdateDateTime}","parentId":${parentId},"hasNextBt":false,"hasPreBt":false}
    #修改知识库菜单分类名称
    ${j}    Set Knowledge Category    put    ${AdminUser}    ${data}    ${categoryResult.categoryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['name']}    ${updateCategoryName}    更新后返回值name不是${updateCategoryName}，修改前：${categoryResult.name}，返回值：${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}

删除知识库的菜单分类(/v1/tenants/{tenantId}/knowledge/categories)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识库菜单分类，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step2、删除知识库菜单分类名称，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK。
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #删除知识库菜单分类
    ${j}    Set Knowledge Category    delete    ${AdminUser}    ${EMPTY}    ${categoryResult.categoryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}

添加并发布知识(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识库菜单分类，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step2、创建知识并发布，调用接口：/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK、字段name值等于分类名、字段tenantId等于租户id，等等。
    ${filter}    copy dictionary    ${FilterEntity}
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #创建请求体
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${entryEntity}    create dictionary    title=添加知识-${AdminUser.tenantId}-${randoNumber}    content=<p>add-knowledge-entry-${AdminUser.tenantId}-${randoNumber}</p>    categoryName=${categoryResult.name}    categoryId=${categoryResult.categoryId}    state=Published
    ...    embeddedMedias=[]    attachments=[]    rank=1    mainMediaId=0
    ${data}    set variable    {"title":"${entryEntity.title}","content":"${entryEntity.content}","categoryName":"${entryEntity.categoryName}","embeddedMedias":${entryEntity.embeddedMedias},"attachments":${entryEntity.attachments},"rank":${entryEntity.rank},"mainMediaId":${entryEntity.mainMediaId},"categoryId":${entryEntity.categoryId},"state":"${entryEntity.state}"}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Published
    #创建知识并发布
    ${j}    Set Knowledge Entry    post    ${AdminUser}    ${filter}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}
    should be equal    ${j['entity']['title']}    ${entryEntity.title}    返回值title不是${entryEntity.title}：${j}
    should be equal    ${j['entity']['content']}    ${entryEntity.content}    返回值content不是${entryEntity.content}：${j}
    should be equal    ${j['entity']['categoryId']}    ${entryEntity.categoryId}    返回值categoryId不是${entryEntity.categoryId}：${j}
    should be equal    ${j['entity']['state']}    ${entryEntity.state}    返回值state不是${entryEntity.state}：${j}
    should be true    "${j['entity']['rank']}" == "${entryEntity.rank}"    返回值rank不是${entryEntity.rank}：${j}

将知识保存草稿(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识库菜单分类，调用接口：/v1/tenants/{tenantId}/knowledge/categories，接口请求状态码为200。
    ...    - Step2、将知识保存草稿，调用接口：/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，status字段的值等于OK、字段name值等于分类名、字段tenantId等于租户id，等等。
    ${filter}    copy dictionary    ${FilterEntity}
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Drafting
    #创建请求体
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${entryEntity}    create dictionary    title=添加知识-${AdminUser.tenantId}-${randoNumber}    content=<p>add-knowledge-entry-${AdminUser.tenantId}-${randoNumber}</p>    categoryName=${categoryResult.name}    categoryId=${categoryResult.categoryId}    state=${filter.entryStates}
    ...    embeddedMedias=[]    attachments=[]    rank=1    mainMediaId=0
    ${data}    set variable    {"title":"${entryEntity.title}","content":"${entryEntity.content}","categoryName":"${entryEntity.categoryName}","embeddedMedias":${entryEntity.embeddedMedias},"attachments":${entryEntity.attachments},"rank":${entryEntity.rank},"mainMediaId":${entryEntity.mainMediaId},"categoryId":${entryEntity.categoryId},"state":"${entryEntity.state}"}
    #将知识保存草稿
    ${j}    Set Knowledge Entry    post    ${AdminUser}    ${filter}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}
    should be equal    ${j['entity']['title']}    ${entryEntity.title}    返回值title不是${entryEntity.title}：${j}
    should be equal    ${j['entity']['content']}    ${entryEntity.content}    返回值content不是${entryEntity.content}：${j}
    should be equal    ${j['entity']['categoryId']}    ${entryEntity.categoryId}    返回值categoryId不是${entryEntity.categoryId}：${j}
    should be equal    ${j['entity']['state']}    ${entryEntity.state}    返回值state不是${entryEntity.state}：${j}
    should be true    "${j['entity']['rank']}" == "${entryEntity.rank}"    返回值rank不是${entryEntity.rank}：${j}

获取草稿知识(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建新的草稿知识，调用接口：/v1/tenants/{tenantId}/knowledge/categories，/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step2、获取知识草稿数据，调用接口：/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，包含刚刚添加的草稿知识，entryId字段等于添加的数据entryId值。
    ${filter}    copy dictionary    ${FilterEntity}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Drafting    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识并获取知识id
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    ${entryId}    set variable    ${entryResult.entryId}
    #获取草稿知识
    ${j}    Set Knowledge Entry    get    ${AdminUser}    ${filter}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    #判断结果中是否包含刚刚添加的操作知识
    ${i}    Entry Should Contain EntryId    ${j['entities']}    ${entryResult.entryId}
    run keyword if    "${i}" == "{}"    获取草稿知识数据中,并不包含刚刚添加的数据entryId:${entryResult.entryId} , ${j}

修改知识标题与内容(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识并发布，调用接口：/v1/tenants/{tenantId}/knowledge/categories，/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step2、修改刚创建的知识，调用接口：/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，包含刚刚添加的草稿知识，entryId字段等于添加的数据entryId值。
    ${filter}    copy dictionary    ${FilterEntity}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Published    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    ${entryId}    set variable    ${entryResult.entryId}
    #创建请求体
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${updateTitle}    set variable    update-title-${AdminUser.tenantId}-${randoNumber}
    ${updatecontent}    set variable    <p>update-content-${AdminUser.tenantId}-${randoNumber}</p>
    ${data}    set variable    {"entryId":${entryId},"categoryId":${entryResult.categoryId},"tenantId":${AdminUser.tenantId},"title":"${updateTitle}","content":"${updatecontent}","creatorId":"${entryResult.creatorId}","creatorNickname":"${entryResult.creatorNickname}","createDateTime":"${entryResult.createDateTime}","lastUpdateDateTime":"${entryResult.lastUpdateDateTime}","state":"${entryResult.state}","rank":${entryResult.rank},"viewHtmlCount":${entryResult.viewHtmlCount},"url":"${entryResult.url}","attachments":${entryResult.attachments},"embeddedMedias":${entryResult.embeddedMedias},"categoryName":"${entryResult.categoryName}","mainMediaId":${entryResult.mainMediaId}}
    #添加知识
    ${j}    Set Knowledge Entry    put    ${AdminUser}    ${filter}    ${data}    ${entryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}
    should be equal    ${j['entity']['title']}    ${updateTitle}    返回值title不是${updateTitle}：${j}
    should be equal    ${j['entity']['content']}    ${updatecontent}    返回值content不是${updatecontent}：${j}
    should be equal    ${j['entity']['categoryId']}    ${entryResult.categoryId}    返回值categoryId不是${entryResult.categoryId}：${j}
    should be equal    ${j['entity']['state']}    ${entryResult.state}    返回值state不是${entryResult.state}：${j}
    should be true    "${j['entity']['rank']}" == "${entryResult.rank}"    返回值rank不是${entryResult.rank}：${j}

删除知识(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识并发布，调用接口：/v1/tenants/{tenantId}/knowledge/categories，/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step2、删除刚创建的知识，调用接口：/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，包含刚刚添加的草稿知识，entryId字段等于添加的数据entryId值。
    ${filter}    copy dictionary    ${FilterEntity}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Published    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识并获取知识id
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    ${entryId}    set variable    ${entryResult.entryId}
    #删除知识
    ${j}    Set Knowledge Entry    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${entryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}

Delete Knowledge Entry And Category With Specify Name
    Delete Knowledge Entry And Category With Specify Name

获取所有知识总数(/v1/tenants/{tenantId}/knowledge/entries/count)
    [Documentation]    【操作步骤】：
    ...    - Step1、创建知识并发布，调用接口：/v1/tenants/{tenantId}/knowledge/categories，/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step2、创建知识并存为草稿，调用接口：/v1/tenants/{tenantId}/knowledge/entries，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，返回值中draftingCount字段值大于0、publishedCount字段值大于0。
    ${filter}    copy dictionary    ${FilterEntity}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Published    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    #将知识存草稿
    set to dictionary    ${filter}    entryStates=Drafting    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    #获取知识库所有知识总数
    ${j}    Get Knowledge Entry Count    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be true    ${j['entity']['draftingCount']} > 0    返回值draftingCount返回值不正确：${j}
    should be true    ${j['entity']['publishedCount']} > 0    返回值publishedCount返回值不正确：${j}

获取租户下知识发送方式(/v1/tenants/{tenantId}/knowledge/send-settings)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取租户下知识发送方式，调用接口：/v1/tenants/{tenantId}/knowledge/send-settings，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，status值为OK、渠道值为：app、webim、weibo、weixin、sendType为NEWS或TEXT。
    &{sendTypeEntity}    create dictionary    app=TEXT    webim=TEXT    weibo=TEXT    weixin=NEWS
    ${j}    Set Send-Settings Method    get    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    ${length}    get length    ${j['entities']}
    should be true    ${length} == ${4}    返回值不是四组 , ${j}
    List Should Correct    ${j['entities']}    ${sendTypeEntity}

修改租户下知识发送方式(/v1/tenants/{tenantId}/knowledge/send-settings)
    [Documentation]    【操作步骤】：
    ...    - Step1、修改租户下知识发送方式，调用接口：/v1/tenants/{tenantId}/knowledge/send-settings，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，status值为OK、渠道值为：app、webim、weibo、weixin、sendType为NEWS或TEXT。
    &{sendTypeEntity}    create dictionary    app=TEXT    webim=TEXT    weibo=TEXT    weixin=NEWS
    ${data}    set variable    [{"originType":"app","sendType":"${sendTypeEntity.app}"},{"originType":"webim","sendType":"${sendTypeEntity.webim}"},{"originType":"weibo","sendType":"${sendTypeEntity.weibo}"},{"originType":"weixin","sendType":"${sendTypeEntity.weixin}"}]
    ${j}    Set Send-Settings Method    put    ${AdminUser}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    ${length}    get length    ${j['entities']}
    should be true    ${length} == ${4}    返回值不是四组 , ${j}
    List Should Correct    ${j['entities']}    ${sendTypeEntity}

获取知识库的下载模板(/download/tplfiles/{fileName}.xlsx)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取知识库的下载模板，调用接口：/download/tplfiles/{fileName}.xlsx，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，Content-Type值为application/octet-stream。
    #设置下载的模板文件名称
    ${fileName}    set variable    %E7%9F%A5%E8%AF%86%E5%BA%93%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF
    #获取知识库的下载模板
    ${j}    Get knowledge Template    ${AdminUser}    ${fileName}
    should be equal    application/octet-stream    ${j.headers['Content-Type']}    接口返回的Content-Type不正确，不是application/octet-stream值，${j.headers}

导出知识库的所有知识(/v1/tenants/{tenantId}/knowledge/export)
    [Documentation]    【操作步骤】：
    ...    - Step1、获取知识库的下载模板，调用接口：/v1/tenants/{tenantId}/knowledge/export，接口请求状态码为200。
    ...    - Step2、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值数据中，Content-Type值为application/octet-stream。
    #导出知识库的所有知识
    ${j}    Export knowledge Entry    ${AdminUser}
    should be equal    application/octet-stream    ${j.headers['Content-Type']}    接口返回的Content-Type不正确，不是application/octet-stream值，${j.headers}
