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
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot
Force Tags    文件上传与下载

*** Test Cases ***
上传图片文件(/{orgName}/{appName}/chatfiles)
    [Template]    Upload Picture Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

上传语音文件(/{orgName}/{appName}/chatfiles)
    [Template]    Upload Audio Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

下载图片(/{orgName}/{appName}/chatfiles/{fileStream})
    [Template]    Download Picture Template
    ${contentType.JSON}    ${Token.orgToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

下载语音(/{orgName}/{appName}/chatfiles/{fileStream})
    [Template]    Download Audio Template
    ${contentType.JSON}    ${Token.orgToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

下载缩略图(/{orgName}/{appName}/chatfiles/{fileUUID})
    [Template]    Download Thumbnail Template
    ${contentType.JSON}    ${Token.orgToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${DownloadMediaFileDictionary.statusCode}    ${DownloadMediaFileDictionary.reponseResult}    ${DownloadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
