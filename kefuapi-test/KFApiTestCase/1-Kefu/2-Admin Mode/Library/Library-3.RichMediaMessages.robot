*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           urllib
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Library/Library_Common.robot

*** Test Cases ***
添加素材库图文消息(/v1/Tenants/{tenantId}/robot/news)
    [Documentation]    【操作步骤】：
    ...    - Step1、上传素材库图片，调用接口：/v1/Tenants/{tenantId}/robot/media/item，接口请求状态码为200。
    ...    - Step2、添加素材库图文消息，调用接口：/v1/Tenants/{tenantId}/robot/news，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，tenantId字段的值等于租户id、字段thumb_media_id值等于图片的objectId值。
    #上传一张图片到素材库
    ${imageResult}    Upload Library Image    ${AdminUser}
    #构造请求体
    &{articlesEntity}    create dictionary    order=0    content=<p>${AdminUser.tenantId}正文</p><p><img alt='' src='${kefuurl}/v1/Tenant/${AdminUser.tenantId}/MediaFiles/${imageResult.objectId}' style='width:auto' /></p>    author=leoli    digest=正文    title=正文    restUrl=/v1/Tenants/${AdminUser.tenantId}/robot/media/item    thumb_media_id=${imageResult.objectId}    text=正文    tenantId=${AdminUser.tenantId}    prop=null    src=
    ${data}    set variable    {"tenantId":${articlesEntity.tenantId},"prop":${articlesEntity.prop},"articles":[{"order":${articlesEntity.order},"content":"${articlesEntity.content}","author":"${articlesEntity.author}","digest":"${articlesEntity.digest}","title":"${articlesEntity.title}","restUrl":"${articlesEntity.restUrl}","thumb_media_id":"${articlesEntity.thumb_media_id}","src":"${articlesEntity.src}","text":"${articlesEntity.text}","prop":${articlesEntity.prop},"tenantId":${articlesEntity.tenantId}}]}
    #添加素材库图文消息
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Set Library News    post    ${AdminUser}    ${filter}    ${data}
    Should Be equal    ${j['tenantId']}    ${AdminUser.tenantId}    返回的tenantId不正确：${j}
    Should Be equal    ${j['articles'][0]['thumb_media_id']}    ${imageResult.objectId}    返回的thumb_media_id不是${imageResult.objectId}：${j}

获取素材库图文消息(/v1/Tenants/{tenantId}/robot/news/search)
    [Documentation]    【操作步骤】：
    ...    - Step1、添加素材库图文消息，调用接口：/v1/Tenants/{tenantId}/robot/media/item，/v1/Tenants/{tenantId}/robot/news，接口请求状态码为200。
    ...    - Step2、根据图文消息文本名称，搜索素材库图文消息，调用接口：/v1/Tenants/{tenantId}/robot/news/search，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，接口返回200，各字段等于预期。
    #添加素材库图文消息
    ${newsResult}    Create News Message    ${AdminUser}
    ${newsId}    set variable    ${newsResult.newsId}
    #获取素材库图文消息
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    page=0    per_page=100    keyword=${AdminUser.tenantId}正文    source=0
    ${j}    Set Library News    get    ${AdminUser}    ${filter}    ${EMPTY}
    Should Be equal    ${j['content'][0]['articles'][0]['id']}    ${newsResult.id}    返回的id:${j['content'][0]['articles'][0]['id']},不是${newsResult.id}：${j}
    Should Be equal    ${j['content'][0]['articles'][0]['newsId']}    ${newsResult.newsId}    返回的newsId:${j['content'][0]['articles'][0]['newsId']},不是${newsResult.newsId}：${j}

删除素材库图文消息(/v1/Tenants/{tenantId}/robot/news/{newsId})
    [Documentation]    【操作步骤】：
    ...    - Step1、添加素材库图文消息，调用接口：/v1/Tenants/{tenantId}/robot/media/item，/v1/Tenants/{tenantId}/robot/news，接口请求状态码为200。
    ...    - Step2、删除素材库图文消息，调用接口：/v1/Tenants/{tenantId}/robot/news/{newsId}，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，返回值等于1。
    #添加素材库图文消息
    ${newsResult}    Create News Message    ${AdminUser}
    ${newsId}    set variable    ${newsResult.newsId}
    #获取素材库图文消息
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Set Library News    delete    ${AdminUser}    ${filter}    ${EMPTY}   ${newsId} 
    Should Be True    "${j}"=="1"    返回的结果不是1：${j}

按搜索删除素材库图文消息(/v1/Tenants/{tenantId}/robot/news/{newsId})
    [Documentation]    按搜索删除素材库图文消息
    [Documentation]    【操作步骤】：
    ...    - Step1、搜索内容包含：[租户id+正文]的内容素材库图文消息，调用接口：/v1/Tenants/{tenantId}/robot/news/search，接口请求状态码为200。
    ...    - Step2、删除素材库图文消息，调用接口：/v1/Tenants/{tenantId}/robot/news/{newsId}，接口请求状态码为200。
    ...    - Step3、判断返回值各字段情况。
    ...
    ...    【预期结果】：
    ...    接口返回值中，返回值等于1。
    #获取素材库图文消息
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    page=0    per_page=100    keyword=${AdminUser.tenantId}正文    source=0
    ${j}    Set Library News    get    ${AdminUser}    ${filter}    ${EMPTY}
    :FOR    ${i}    IN    @{j['content']}
    \    ${j}    Set Library News    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${i['newsId']}
    \    Should Be True    "${j}"=="1"    返回的结果不是1, 实际结果: ${j}
