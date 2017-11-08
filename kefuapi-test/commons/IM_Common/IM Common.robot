*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../api/IM/IMApi.robot

*** Keywords ***
Upload File
    [Arguments]    ${rest}    ${files}    ${timeout}
    [Documentation]    使用第一通道上传文件
    #IM上传文件到服务器
    ${file_data}    evaluate    ('${files.filename}', open('${files.filepath}','rb'),'${files.contentType}',{'Expires': '0'})
    &{file}    Create Dictionary    file=${file_data}
    ${resp}=    /{orgName}/{appName}/chatfiles    ${restentity}    ${file}    ${timeout}
    Should Be Equal As Integers    ${resp.status_code}    200    不正确的状态码:${resp}
    ${j}    to json    ${resp.content}
    Return From Keyword    ${j}
