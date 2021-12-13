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
    [Documentation]    
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
给用户发送透传消息-开启debug(/{orgName}/{appName}/messages)
    [Template]    Send Open Debug Message Template
    [Documentation]    给用户发送透传消息（开启debug）
    ...    ceate by shuang
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
给用户发送透传消息-关闭debug(/{orgName}/{appName}/messages)
    [Template]    Send Close Debug Message Template
    [Documentation]    给用户发送透传消息（关闭debug）
    ...    ceate by shuang
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
    [Documentation]    - 待编写：给用户发送视频消息(/{orgName}/{appName}/messages)
    [Template]    Send Video Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

给用户发送扩展消息(/{orgName}/{appName}/messages)
    [Documentation]    发送扩展消息
    ...    created by shuang
    [Template]    Send ext Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendMessageDictionary.statusCode}    ${SendMessageDictionary.reponseResult}    ${SendMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

发送群文本消息
    [Template]    Send Group Message Template
    [Documentation]    created by wudi 
    ${contentType.JSON}    ${Token.orgToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
    
发送群语音消息
    [Template]    Send Group Audio Message Template
    [Documentation]    created by wudi 
    ${contentType.JSON}    ${Token.orgToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
发送群图片消息
    [Template]    Send Group Picture Message Template
    ${contentType.JSON}    ${Token.orgToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${EasemobSecurityExceptionDictionary.statusCode}    ${EasemobSecurityExceptionDictionary.reponseResult}    ${EasemobSecurityExceptionDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${SendGroupMessageDictionary.statusCode}    ${SendGroupMessageDictionary.reponseResult}    ${SendGroupMessageDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
   
