*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/GroupCommon/GroupCommon.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/GroupResult/Group_Result.robot

*** Test Cases ***
创建一个新的群组(/{orgName}/{appName}/chatgroups)
    [Template]    Create New Chatgroup Template
    ${contentType.JSON}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${GroupNoAuthorizationDictionary.statusCode}    ${GroupNoAuthorizationDictionary.reponseResult}    ${GroupNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.appToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${CreateChatgroupDictionary.statusCode}    ${CreateChatgroupDictionary.reponseResult}    ${CreateChatgroupDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
