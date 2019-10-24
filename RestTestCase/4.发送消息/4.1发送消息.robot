*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/SendMessageCommon/SendMessageCommon.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/SendMessageResult/SendMessage_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
给用户发送文本消息(/{orgName}/{appName}/messages)
    [Template]    Send Text Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

给用户发送图片消息(/{orgName}/{appName}/messages)
    [Template]    Send Picture Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

给用户发送语音消息(/{orgName}/{appName}/messages)
    [Template]    Send Audio Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送视频消息(/{orgName}/{appName}/messages)
    [Template]    Send Video Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

待编写：给用户发送透传消息(/{orgName}/{appName}/messages)
    [Template]    Send Text Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
