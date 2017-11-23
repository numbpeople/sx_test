*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../../AgentRes.robot
Resource          ../../../api/BaseApi/Settings/CustomStickersApi.robot

*** Keywords ***
Get Stickers
    [Arguments]    ${agent}
    [Documentation]    获取自定义表情
    #获取自定义表情
    ${resp}=    /v1/emoj/tenants/{tenantId}/packages    ${AdminUser}    ${timeout}    get    ${EMPTY}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Upload Stickers
    [Arguments]    ${agent}    ${files}
    [Documentation]    上传自定义表情
    #上传自定义表情
    ${file_data}    evaluate    ('${files.filename}', open('${files.filepath}','rb'),'${files.contentType}',{'Expires': '0'})
    &{file}    Create Dictionary    file=${file_data}
    ${resp}=    /v1/emoj/tenants/{tenantId}/packages    ${AdminUser}    ${timeout}    post    ${file}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Delete Stickers
    [Arguments]    ${agent}    ${packageId}
    [Documentation]    删除自定义表情
    #删除自定义表情
    ${resp}=    /v1/emoj/tenants/{tenantId}/packages/{packageId}    ${AdminUser}    ${timeout}    ${packageId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.content}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Sort Stickers
    [Arguments]    ${agent}    ${list}
    [Documentation]    排序自定义表情
    #排序自定义表情
    ${resp}=    /v1/emoj/tenants/{tenantId}/packages/sort    ${AdminUser}    ${timeout}    ${list}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}

Get Stickers Numbers
    [Arguments]    ${AdminUser}
    #获取表情包包含的个数
    ${j}    Get Stickers    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    ${length}    get length    ${j['entities']}
    Return From Keyword    ${length}

Clear Stickers
    #获取表情包
    ${j}    Get Stickers    ${AdminUser}
    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}
    #删除表情包
    : FOR    ${i}    IN    @{j['entities']}
    \    ${id}    convert to integer    ${i['id']}
    \    ${j}    Delete Stickers    ${AdminUser}    ${id}
    \    should be equal    ${j['status']}    OK    返回值中status不等于OK: ${j}

Get Stickers Files
    [Arguments]    ${agent}    ${packageId}
    [Documentation]    获取自定义表情文件
    #获取自定义表情文件
    ${resp}=    /v1/emoj/tenants/{tenantId}/packages/{packageId}/files    ${AdminUser}    ${timeout}    ${packageId}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp.status_code}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
