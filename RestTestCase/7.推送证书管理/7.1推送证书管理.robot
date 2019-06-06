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
Resource          ../../Common/SendMessageCommon/SendMessageCommon.robot
Resource          ../../Common/NotifierCertificateCommon/NotifierCertificateCommon.robot

*** Test Cases ***
待编写：删除华为证书
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：删除小米证书
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：上传华为证书
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：上传华为证书-证书已存在
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：上传小米证书
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：获取证书
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：获取证书-使用无效token
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：删除小米证书-使用无效token
    [Template]    Upload Certificate Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
