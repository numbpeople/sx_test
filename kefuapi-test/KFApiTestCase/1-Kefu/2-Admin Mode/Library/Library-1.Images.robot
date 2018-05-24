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
上传素材库图片(/v1/Tenants/{tenantId}/robot/media/item)
    [Documentation]    上传素材库图片
    #获取图片文件
    ${picpath}    Find Image Path
    ${fileEntity}    create dictionary    filename=image.gif    filepath=${picpath}    contentType=image/gif
    #上传素材库图片
    ${filter}    copy dictionary    ${RobotFilter}
    ${j}    Set Library Image    post    ${AdminUser}    ${filter}    ${fileEntity}
    Should Be equal    ${j['tenantId']}    ${AdminUser.tenantId}    返回的tenantId不正确：${j}
    Should Be equal    ${j['objectType']}    ${fileEntity.contentType}    返回的contentType值不是${fileEntity.contentType}：${j}

获取素材库图片(/v1/Tenants/{tenantId}/robot/media/items)
    [Documentation]    获取素材库图片
    #上传一张图片到素材库
    ${imageResult}    Upload Library Image    ${AdminUser}
    ${filter}    copy dictionary    ${RobotFilter}
    #获取素材库图片
    ${j}    Set Library Image    get    ${AdminUser}    ${filter}
    Should Be equal    ${j['content'][0]['id']}    ${imageResult.id}    返回的id不是${imageResult.id}：${j}
    Should Be equal    ${j['content'][0]['objectId']}    ${imageResult.objectId}    返回的objectId不是${imageResult.objectId}：${j}

删除素材库图片(/v1/Tenants/{tenantId}/robot/media/item/{itemId})
    [Documentation]    删除素材库图片
    #上传一张图片到素材库
    ${imageResult}    Upload Library Image    ${AdminUser}
    ${filter}    copy dictionary    ${RobotFilter}
    #删除素材库图片
    ${j}    Set Library Image    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${imageResult.objectId}
    Should Be True    "${j}"=="1"    返回的结果不是1：${j}

按搜索删除素材库图片(/v1/Tenants/{tenantId}/robot/media/item/{itemId})
    [Documentation]    删除搜索素材库图片
    ${filter}    copy dictionary    ${RobotFilter}
    set to dictionary    ${filter}    per_page=100    q=image
    #获取素材库图片
    ${j}    Set Library Image    get    ${AdminUser}    ${filter}
    #删除搜索出来的素材库图片
    :FOR    ${i}    IN    @{j['content']}
    \    ${j}    Set Library Image    delete    ${AdminUser}    ${filter}    ${EMPTY}    ${i['objectId']}
    \    Should Be True    "${j}"=="1"    返回的结果不是1, 实际结果: ${j}
    