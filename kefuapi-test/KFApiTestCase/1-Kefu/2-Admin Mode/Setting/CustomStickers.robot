*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../commons/admin common/Setting/Stickers_Common.robot

*** Test Cases ***
获取自定义表情包(/v1/emoj/tenants/{tenantId}/packages)
    #获取表情包
    ${j}    Get Stickers    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['type']}    CUSTOM    返回值中type字段不等于CUSTOM: ${j}

上传自定义表情包(/v1/emoj/tenants/{tenantId}/packages)
    #获取当前的表情包个数
    ${length}    Get Stickers Numbers    ${AdminUser}
    Run Keyword If    ${length} >= 5    Fail    租户下的表情包超过5个，该用例会执行失败，标识为fail
    #上传表情包
    ${picpath}    Open Sticker File
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    should be equal    ${j['entities'][0]['fileName']}    beautiful_girl    返回值中压缩包里的图片名字与预期不符: ${j}
    should be equal    ${j['entities'][0]['packageName']}.zip    ${fileEntity.filename}    返回值中压缩包名称与预期不符: ${j}

删除自定义表情包(/v1/emoj/tenants/{tenantId}/packages)
    #上传表情包
    ${picpath}    Open Sticker File
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #删除表情包
    ${j}    Delete Stickers    ${AdminUser}    ${j['entities'][0]['packageId']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

排序自定义表情包(/v1/emoj/tenants/{tenantId}/packages/sort)
    #上传表情包
    ${picpath}    Open Sticker File
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    @{list}    Create List
    #获取当前的表情包个数
    ${length}    Get Stickers Numbers    ${AdminUser}
    Run Keyword If    ${length} >= 3    Fail    租户下的表情包超过3个，该用例会执行失败，标识为fail
    #上传多个表情包
    : FOR    ${i}    IN RANGE    2
    \    Upload Stickers    ${AdminUser}    ${fileEntity}
    #获取表情包
    ${j}    Get Stickers    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #将所有的packageId存入list
    : FOR    ${i}    IN    @{j['entities']}
    \    ${id}    convert to integer    ${i['id']}
    \    Append To List    ${list}    ${id}
    #将所得到的list进行排序
    ${k}    Sort Stickers    ${AdminUser}    ${list}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${k}

获取自定义表情包文件(/v1/emoj/tenants/{tenantId}/packages/{packageId}/files)
    #获取当前的表情包个数
    ${length}    Get Stickers Numbers    ${AdminUser}
    Run Keyword If    ${length} >= 5    Fail    租户下的表情包超过5个，该用例会执行失败，标识为fail
    #上传表情包
    ${picpath}    Open Sticker File
    ${fileEntity}    create dictionary    filename=stickers.zip    filepath=${picpath}    contentType=application/zip
    ${j1}    Upload Stickers    ${AdminUser}    ${fileEntity}
    should be equal    ${j1['status']}    OK    返回值中status不等于OK: ${j1}
    #获取表情文件
    ${j}    Get Stickers Files    ${AdminUser}    ${j1['entities'][0]['packageId']}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length} =    get length    ${j['entities']}
    Run Keyword if    ${length} == 0    Fail    租户下的表情包文件不存在，需要检查下，${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['tenantId']}    ${AdminUser.tenantId}    返回值中未包含tenantId字段: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['fileName']}    beautiful_girl    返回值中压缩包里的图片名字与预期不符: ${j}
    Run Keyword if    ${length} > 0    should be equal    ${j['entities'][0]['packageId']}    ${j1['entities'][0]['packageId']}    返回值中压缩包的id不是预期: ${j}
