*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../../Common/TokenCommon/TokenCommon.robot
Resource          ../../Common/AppCommon/AppCommon.robot
Resource          ../../Variable_Env.robot
Resource          ../../Result/APPResult/AppManagement_Result.robot
Resource          ../../Result/BaseResullt.robot

*** Test Cases ***
创建已存在的应用(/management/organizations/{orgName}/applications)
    [Template]    Create Exist Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppExistDictionary.statusCode}    ${AppExistDictionary.reponseResult}    ${AppExistDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AppExistDictionary.statusCode}    ${AppExistDictionary.reponseResult}    ${AppExistDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AppExistDictionary.statusCode}    ${AppExistDictionary.reponseResult}    ${AppExistDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

创建一个新的应用(/management/organizations/{orgName}/applications)
    [Template]    Create New Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppNewDictionary.statusCode}    ${AppNewDictionary.reponseResult}    ${AppNewDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AppNewDictionary.statusCode}    ${AppNewDictionary.reponseResult}    ${AppNewDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AppNewDictionary.statusCode}    ${AppNewDictionary.reponseResult}    ${AppNewDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取org下所有的应用app列表(/management/organizations/{orgName}/applications)
    [Template]    Get Applications List Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetAppListDictionary.statusCode}    ${GetAppListDictionary.reponseResult}    ${GetAppListDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetAppListDictionary.statusCode}    ${GetAppListDictionary.reponseResult}    ${GetAppListDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetAppListDictionary.statusCode}    ${GetAppListDictionary.reponseResult}    ${GetAppListDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取不存在的org下的应用app列表(/management/organizations/{orgName}/applications)
    [Template]    Get Applications List With Inexistent Org Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    False    #该条case不执行了，因为有超管token条件下，接口返回值会不同

获取指定的App信息(/management/organizations/{orgName}/applications)
    [Template]    Get Specific Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetSpecificAppDictionary.statusCode}    ${GetSpecificAppDictionary.reponseResult}    ${GetSpecificAppDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${GetSpecificAppDictionary.statusCode}    ${GetSpecificAppDictionary.reponseResult}    ${GetSpecificAppDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${GetSpecificAppDictionary.statusCode}    ${GetSpecificAppDictionary.reponseResult}    ${GetSpecificAppDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}

获取不存在的App信息(/management/organizations/{orgName}/applications)
    [Template]    Get Specific Application Template With Inexistent Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppNotFoundDictionary.statusCode}    ${AppNotFoundDictionary.reponseResult}    ${AppNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_ContentType}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_ContentType}
    ${EMPTY}    ${Token.orgToken}    ${AppNotFoundDictionary.statusCode}    ${AppNotFoundDictionary.reponseResult}    ${AppNotFoundDiffEntity}    ${ModelCaseRunStatus.OrgToken_EmptyContentType}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${ModelCaseRunStatus.EmptyOrgToken_EmptyContentType}
    ${contentType.JSON}    ${Token.bestToken}    ${AppNotFoundDictionary.statusCode}    ${AppNotFoundDictionary.reponseResult}    ${AppNotFoundDiffEntity}    ${ModelCaseRunStatus.BestToken_ContentType}
