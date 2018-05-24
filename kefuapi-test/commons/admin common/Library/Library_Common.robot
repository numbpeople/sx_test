*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../api/BaseApi/Library/Library_Api.robot

*** Keywords ***
Set Library Image
    [Arguments]    ${method}    ${agent}    ${filter}    ${file}=    ${itemId}=
    [Documentation]    获取/上传图片
    #打开图片文件
    ${fileData}    run keyword if    '${method}'=='post'    Open Image    ${file}
    #获取/上传图片
    ${resp}=    /v1/Tenants/{tenantId}/robot/media/items    ${method}    ${agent}    ${filter}    ${fileData}    ${itemId}    ${timeout}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='get' or '${method}'=='delete'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword if    '${method}'=='delete'    ${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}
    
Open Image
    [Arguments]    ${file}
    [Documentation]    打开图片
    #打开图片
    ${file_data}    evaluate    ('${file.filename}', open('${file.filepath}','rb'),'${file.contentType}',{'Expires': '0'})
    &{fileEntity}    Create Dictionary    file=${file_data}
    return from keyword    ${fileEntity}

Find Image Path
    [Documentation]    找到resource文件夹下的图片文件: image.gif
    #找到resource文件夹下的图片文件: image.gif
    ${picpath}    set variable    ${CURDIR}
    ${picpath}    evaluate    os.path.abspath(os.path.dirname('${picpath}')+os.path.sep+"..")    os
    ${picpath}    set variable    ${picpath}${/}${/}resource${/}${/}image.gif
    return from keyword    ${picpath}

Upload Library Image
    [Arguments]    ${agent}
    [Documentation]    上传一张图片到素材库
    #获取图片文件
    ${picpath}    Find Image Path
    &{fileEntity}    create dictionary    filename=image.gif    filepath=${picpath}    contentType=image/gif
    #上传素材库图片
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Set Library Image    post    ${agent}    ${filter}    ${fileEntity}
    Should Be equal    ${j['tenantId']}    ${agent.tenantId}    返回的tenantId不正确：${j}
    Should Be equal    ${j['objectType']}    ${fileEntity.contentType}    返回的contentType值不是${fileEntity.contentType}：${j}
    set to dictionary    ${fileEntity}    id=${j['id']}    objectId=${j['objectId']}
    return from keyword    ${fileEntity}

Set Library News
    [Arguments]    ${method}    ${agent}    ${filter}    ${data}=    ${newsId}=
    [Documentation]    获取/上传/修改/删除图文
    #获取/上传图片
    ${resp}=    /v1/Tenants/{tenantId}/robot/news/search    ${method}    ${agent}    ${filter}    ${data}    ${newsId}    ${timeout}
    run keyword if    '${method}'=='post'    Should Be Equal As Integers    ${resp.status_code}    201    不正确的状态码:${resp.status_code},${resp.text}
    run keyword if    '${method}'=='get' or '${method}'=='delete'    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code},${resp.text}
    return from keyword if    '${method}'=='delete'    ${resp.text}
    ${j}    to json    ${resp.text}
    return from keyword    ${j}

Create News Message
    [Arguments]    ${agent}
    [Documentation]    添加素材库图片
    #上传一张图片到素材库
    ${imageResult}    Upload Library Image    ${agent}
    #构造请求体
    &{articlesEntity}    create dictionary    order=0    content=<p>${AdminUser.tenantId}正文</p><p><img alt='' src='${kefuurl}/v1/Tenant/${agent.tenantId}/MediaFiles/${imageResult.objectId}' style='width:auto' /></p>    author=leoli    digest=正文    title=正文    restUrl=/v1/Tenants/${agent.tenantId}/robot/media/item    thumb_media_id=${imageResult.objectId}    text=正文    tenantId=${agent.tenantId}    prop=null    src=
    ${data}    set variable    {"tenantId":${articlesEntity.tenantId},"prop":${articlesEntity.prop},"articles":[{"order":${articlesEntity.order},"content":"${articlesEntity.content}","author":"${articlesEntity.author}","digest":"${articlesEntity.digest}","title":"${articlesEntity.title}","restUrl":"${articlesEntity.restUrl}","thumb_media_id":"${articlesEntity.thumb_media_id}","src":"${articlesEntity.src}","text":"${articlesEntity.text}","prop":${articlesEntity.prop},"tenantId":${articlesEntity.tenantId}}]}
    #添加素材库图文消息
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Set Library News    post    ${agent}    ${filter}    ${data}
    Should Be equal    ${j['tenantId']}    ${agent.tenantId}    返回的tenantId不正确：${j}
    Should Be equal    ${j['articles'][0]['thumb_media_id']}    ${imageResult.objectId}    返回的thumb_media_id不是${imageResult.objectId}：${j}
    set to dictionary    ${articlesEntity}    id=${j['articles'][0]['id']}    newsId=${j['articles'][0]['newsId']}    articleId=${j['articles'][0]['articleId']}
    return from keyword    ${articlesEntity}
