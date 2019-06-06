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

*** Test Cases ***
待编写：给用户发送文本消息-Content-Type
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送文本消息-Not Content-Type
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送文本消息-body参数格式不正确
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送文本消息-使用无效token
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送图片消息
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送语音消息
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送视频消息
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送透传消息
    [Template]    Send Message Template
    ${EMPTY}    ${Token.orgToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${UploadMediaUnAuthenticateDictionary.statusCode}    ${UploadMediaUnAuthenticateDictionary.reponseResult}    ${UploadMediaUnAuthenticateDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${EMPTY}    ${Token.appToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${EMPTY}    ${Token.bestToken}    ${UploadMediaFileDictionary.statusCode}    ${UploadMediaFileDictionary.reponseResult}    ${UploadMediaFileDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
