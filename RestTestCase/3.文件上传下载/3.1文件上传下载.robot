*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/UserCommon/FriendsAndBlacklistCommon.robot
Resource          ../../Common/FileUploadDownloadCommon/FileUploadDownloadCommon.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/FileUploadDownloadResult/FileUploadDownload_Result.robot

*** Test Cases ***
上传图片文件(/{orgName}/{appName}/chatfiles)
    [Template]    Upload Picture Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #上传附件接口，发现没有token也可以请求成功。appkey：talent-leoli123#talent有正常返回错误，但是新创建的应用就不需要token也可以请求成功，比如：ljp#imautotest-4535950756。{"error":"unauthorized","exception":"EasemobSecurityException","timestamp":1557376127224,"duration":0,"error_description":"Unable to authenticate (OAuth)"}

上传语音文件(/{orgName}/{appName}/chatfiles)
    [Template]    Upload Audio Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #上传附件接口，发现没有token也可以请求成功。appkey：talent-leoli123#talent有正常返回错误，但是新创建的应用就不需要token也可以请求成功，比如：ljp#imautotest-4535950756。{"error":"unauthorized","exception":"EasemobSecurityException","timestamp":1557376127224,"duration":0,"error_description":"Unable to authenticate (OAuth)"}

待编写：下载语音(/{orgName}/{appName}/chatfiles/{fileStream})
    [Template]
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #上传附件接口，发现没有token也可以请求成功。appkey：talent-leoli123#talent有正常返回错误，但是新创建的应用就不需要token也可以请求成功，比如：ljp#imautotest-4535950756。{"error":"unauthorized","exception":"EasemobSecurityException","timestamp":1557376127224,"duration":0,"error_description":"Unable to authenticate (OAuth)"}

待编写：下载缩略图(/{orgName}/{appName}/chatfiles/{fileUUID})
    [Template]
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    #上传附件接口，发现没有token也可以请求成功。appkey：talent-leoli123#talent有正常返回错误，但是新创建的应用就不需要token也可以请求成功，比如：ljp#imautotest-4535950756。{"error":"unauthorized","exception":"EasemobSecurityException","timestamp":1557376127224,"duration":0,"error_description":"Unable to authenticate (OAuth)"}
