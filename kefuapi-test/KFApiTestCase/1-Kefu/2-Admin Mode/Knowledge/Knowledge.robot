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
    [Documentation]    1、创建知识库菜单分类    2、获取菜单分类树中最新一条数据
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
    [Documentation]    创建知识库菜单分类
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
    [Documentation]    1、创建知识库菜单分类    2、更新知识库的菜单分类名称
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
    [Documentation]    1、创建知识库菜单分类    2、删除知识库的菜单分类
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #删除知识库菜单分类
    ${j}    Set Knowledge Category    delete    ${AdminUser}    ${EMPTY}    ${categoryResult.categoryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}

添加并发布知识(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    创建知识并发布
    ${filter}    copy dictionary    ${FilterEntity}
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #创建请求体
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${entryEntity}    create dictionary    title=添加知识-${AdminUser.tenantId}-${randoNumber}    content=<p>add-knowledge-entry-${AdminUser.tenantId}-${randoNumber}</p>    categoryName=${categoryResult.name}    categoryId=${categoryResult.categoryId}    state=Published    embeddedMedias=[]    attachments=[]    rank=1    mainMediaId=0
    ${data}    set variable    {"title":"${entryEntity.title}","content":"${entryEntity.content}","categoryName":"${entryEntity.categoryName}","embeddedMedias":${entryEntity.embeddedMedias},"attachments":${entryEntity.attachments},"rank":${entryEntity.rank},"mainMediaId":${entryEntity.mainMediaId},"categoryId":${entryEntity.categoryId},"state":"${entryEntity.state}"}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Published
    #添加知识库菜单分类
    ${j}    Set Knowledge Entry    post    ${AdminUser}    ${filter}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    should be equal    ${j['entity']['tenantId']}    ${AdminUser.tenantId}    返回值tenantId不是${AdminUser.tenantId}：${j}
    should be equal    ${j['entity']['title']}    ${entryEntity.title}    返回值title不是${entryEntity.title}：${j}
    should be equal    ${j['entity']['content']}    ${entryEntity.content}    返回值content不是${entryEntity.content}：${j}
    should be equal    ${j['entity']['categoryId']}    ${entryEntity.categoryId}    返回值categoryId不是${entryEntity.categoryId}：${j}
    should be equal    ${j['entity']['state']}    ${entryEntity.state}    返回值state不是${entryEntity.state}：${j}
    should be true    "${j['entity']['rank']}" == "${entryEntity.rank}"    返回值rank不是${entryEntity.rank}：${j}

将知识保存草稿(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    将知识保存草稿
    ${filter}    copy dictionary    ${FilterEntity}
    #创建菜单分类
    ${categoryResult}    Create Knowledge Category    ${AdminUser}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Drafting
    #创建请求体
    ${randoNumber}    Generate Random String    5    [NUMBERS]
    ${entryEntity}    create dictionary    title=添加知识-${AdminUser.tenantId}-${randoNumber}    content=<p>add-knowledge-entry-${AdminUser.tenantId}-${randoNumber}</p>    categoryName=${categoryResult.name}    categoryId=${categoryResult.categoryId}    state=${filter.entryStates}    embeddedMedias=[]    attachments=[]    rank=1    mainMediaId=0
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
    [Documentation]    1、将知识保存草稿    2、获取草稿知识
    ${filter}    copy dictionary    ${FilterEntity}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Drafting    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识并获取知识id
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    ${entryId}    set variable    ${entryResult.entryId}
    #获取草稿知识
    ${j}    Set Knowledge Entry    get    ${AdminUser}    ${filter}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    #因为刚添加知识在数据第一个，所以获取最新一条知识进行判断
    should be equal    ${j['entities'][0]['entryId']}    ${entryResult.entryId}    返回值entryId不是${entryResult.entryId},实际entryId是：${j['entities'][0]['entryId']}：${j}

修改知识标题与内容(/v1/tenants/{tenantId}/knowledge/entries)
    [Documentation]    1、创建知识并发布    2、修改刚创建的知识
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
    [Documentation]    1、创建新的知识    2、删除该创建的知识
    ${filter}    copy dictionary    ${FilterEntity}
    #创建筛选条件
    set to dictionary    ${filter}    page=0    per_page=10    type=0    entryStates=Published    #entryStates：代表添加知识类型, 值为：Published、Drafting
    #创建新的知识并获取知识id
    ${entryResult}    Create Knowledge Entry    ${AdminUser}    ${filter}
    ${entryId}    set variable    ${entryResult.entryId}
    #删除知识
    ${j}    Set Knowledge Entry    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${entryId}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}

获取所有知识总数(/v1/tenants/{tenantId}/knowledge/entries/count)
    [Documentation]    1、创建新的知识与存知识草稿    2、获取所有的知识总数
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
    should be true    ${j['entity']['publishedCount']} > 0	返回值publishedCount返回值不正确：${j}

获取租户下知识发送方式(/v1/tenants/{tenantId}/knowledge/send-settings)
    [Documentation]    1、获取租户下知识发送方式    2、判断渠道值为：app、webim、weibo、weixin ; sendType为NEWS或TEXT
    ${j}    Set Send-Settings Method    get    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    ${length}    get length    ${j['entities']}
    should be true    ${length} == ${4}    返回值不是四组 , ${j}
    List Should Correct    ${j['entities']}

修改租户下知识发送方式(/v1/tenants/{tenantId}/knowledge/send-settings)
    [Documentation]    1、修改租户下知识发送方式    2、判断渠道值为：app、webim、weibo、weixin ; sendType为NEWS或TEXT
    &{sendTypeEntity}    create dictionary    app=TEXT    webim=TEXT    weibo=TEXT    weixin=NEWS
    ${data}    set variable    [{"originType":"app","sendType":"${sendTypeEntity.app}"},{"originType":"webim","sendType":"${sendTypeEntity.webim}"},{"originType":"weibo","sendType":"${sendTypeEntity.weibo}"},{"originType":"weixin","sendType":"${sendTypeEntity.weixin}"}]
    ${j}    Set Send-Settings Method    put    ${AdminUser}    ${data}
    should be equal    ${j['status']}    OK    返回值status不是OK：${j}
    ${length}    get length    ${j['entities']}
    should be true    ${length} == ${4}    返回值不是四组 , ${j}
    List Should Correct    ${j['entities']}    ${sendTypeEntity}

获取知识库的下载模板(/download/tplfiles/{fileName}.xlsx)
    #设置下载的模板文件名称
    ${fileName}    set variable    %E7%9F%A5%E8%AF%86%E5%BA%93%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF
    #获取知识库的下载模板
    ${j}    Get knowledge Template    ${AdminUser}    ${fileName}
    should be equal    application/octet-stream    ${j.headers['Content-Type']}    接口返回的Content-Type不正确，不是application/octet-stream值，${j.headers}

导出知识库的所有知识(/v1/tenants/{tenantId}/knowledge/export)
    #导出知识库的所有知识
    ${j}    Export knowledge Entry    ${AdminUser}
    should be equal    application/octet-stream    ${j.headers['Content-Type']}    接口返回的Content-Type不正确，不是application/octet-stream值，${j.headers}