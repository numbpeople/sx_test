*** Settings ***
Force Tags        chatgroupManagement
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Variable_Env.robot
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/PushCommon/PushCommon.robot
Resource          ../../Result/BaseResullt.robot
Resource          ../../Result/PushResult/Push_Result.robot
Resource          ../../Common/CollectionCommon/TestTeardown/TestTeardownCommon.robot

*** Test Cases ***
获取所有证书
    [Template]    Get Push certificate Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetPushDictionary.statusCode}    ${GetPushDictionary.reponseResult}    ${GetPushDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${GetPushDictionary.statusCode}    ${GetPushDictionary.reponseResult}    ${GetPushDiffEntity}    ${ModelCaseRunStatus.AppToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${PushNoAuthorizationDictionary.statusCode}    ${PushNoAuthorizationDictionary.reponseResult}    ${PushNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

上传华为推送证书
    [Template]    Upload huawei Template
    ${contentType.JSON}    ${Token.orgToken}    ${addhuaweiDictionary.statusCode}    ${addhuaweiDictionary.reponseResult}    ${addhuaweiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${addhuaweiDictionary.statusCode}    ${addhuaweiDictionary.reponseResult}    ${addhuaweiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${PushNoAuthorizationDictionary.statusCode}    ${PushNoAuthorizationDictionary.reponseResult}    ${PushNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

删除华为推送证书
    [Template]    Delete huawei Template
    ${contentType.JSON}    ${Token.orgToken}    ${deletehuaweiDictionary.statusCode}    ${deletehuaweiDictionary.reponseResult}    ${deletehuaweiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.orgToken}    ${deletehuaweiDictionary.statusCode}    ${deletehuaweiDictionary.reponseResult}    ${deletehuaweiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}

上传小米推送证书
    [Template]    Upload xiaomi Template
    ${contentType.JSON}    ${Token.orgToken}    ${addxiaomiDictionary.statusCode}    ${addxiaomiDictionary.reponseResult}    ${addxiaomiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.orgToken}    ${addxiaomiDictionary.statusCode}    ${addxiaomiDictionary.reponseResult}    ${addxiaomiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${PushNoAuthorizationDictionary.statusCode}    ${PushNoAuthorizationDictionary.reponseResult}    ${PushNoAuthorizationDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}

删除小米推送证书
    [Template]    Delete xiaomi Template
    ${contentType.JSON}    ${Token.orgToken}    ${deletexiaomiDictionary.statusCode}    ${deletexiaomiDictionary.reponseResult}    ${deletexiaomiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${Token.appToken}    ${deletehuaweiDictionary.statusCode}    ${deletehuaweiDictionary.reponseResult}    ${deletehuaweiDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
