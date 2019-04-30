*** Settings ***
Library           requests
Library           RequestsLibrary
Library           Collections
Library           json
Resource          ../Common/TokenCommon/TokenCommon.robot
Resource          ../Common/AppCommon/AppCommon.robot
Resource          ../Variable_Env.robot
Resource          ../Result/APPResult/AppManagement_Result.robot
Resource          ../Result/BaseResullt.robot

*** Test Cases ***
创建已存在的应用(/management/organizations/{orgName}/applications)
    [Template]    Create Exist Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppExistDictionary.statusCode}    ${AppExistDictionary.reponseResult}    ${AppExistDiffEntity}    ${RunStatus.RUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    ${AppExistDictionary.statusCode}    ${AppExistDictionary.reponseResult}    ${AppExistDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    ${AppExistDictionary.statusCode}    ${AppExistDictionary.reponseResult}    ${AppExistDiffEntity}    ${RunStatus.RUN}    ${RunStatus.RUN}

创建一个新的应用(/management/organizations/{orgName}/applications)
    [Template]    Create New Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppNewDictionary.statusCode}    ${AppNewDictionary.reponseResult}    ${AppNewDiffEntity}    ${RunStatus.RUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    ${AppNewDictionary.statusCode}    ${AppNewDictionary.reponseResult}    ${AppNewDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    ${AppNewDictionary.statusCode}    ${AppNewDictionary.reponseResult}    ${AppNewDiffEntity}    ${RunStatus.RUN}    ${RunStatus.RUN}

获取org下所有的应用app列表(/management/organizations/{orgName}/applications)
    [Template]    Get Applications List Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetAppListDictionary.statusCode}    ${GetAppListDictionary.reponseResult}    ${GetAppListDiffEntity}    ${RunStatus.RUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    ${GetAppListDictionary.statusCode}    ${GetAppListDictionary.reponseResult}    ${GetAppListDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    ${GetAppListDictionary.statusCode}    ${GetAppListDictionary.reponseResult}    ${GetAppListDiffEntity}    ${RunStatus.RUN}    ${RunStatus.RUN}

获取不存在的org下的应用app列表(/management/organizations/{orgName}/applications)
    [Template]    Get Applications List With Inexistent Org Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.RUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ...    #该条case不执行了，因为有超管token条件下，接口返回值会不同

获取指定的App信息(/management/organizations/{orgName}/applications)
    [Template]    Get Specific Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${GetSpecificAppDictionary.statusCode}    ${GetSpecificAppDictionary.reponseResult}    ${GetSpecificAppDiffEntity}    ${RunStatus.RUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    ${GetSpecificAppDictionary.statusCode}    ${GetSpecificAppDictionary.reponseResult}    ${GetSpecificAppDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    ${GetSpecificAppDictionary.statusCode}    ${GetSpecificAppDictionary.reponseResult}    ${GetSpecificAppDiffEntity}    ${RunStatus.RUN}    ${RunStatus.RUN}

获取不存在的App信息(/management/organizations/{orgName}/applications)
    [Template]    Get Specific Application Template With Inexistent Application Template
    ${contentType.JSON}    ${Token.orgToken}    ${AppNotFoundDictionary.statusCode}    ${AppNotFoundDictionary.reponseResult}    ${AppNotFoundDiffEntity}    ${RunStatus.RUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${Token.orgToken}    ${AppNotFoundDictionary.statusCode}    ${AppNotFoundDictionary.reponseResult}    ${AppNotFoundDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${EMPTY}    ${EMPTY}    ${AppNoOrganizationAuthorizedDictionary.statusCode}    ${AppNoOrganizationAuthorizedDictionary.reponseResult}    ${AppNoOrganizationAuthorizedDiffEntity}    ${RunStatus.NORUN}    ${RunStatus.NORUN}
    ${contentType.JSON}    ${Token.bestToken}    ${AppNotFoundDictionary.statusCode}    ${AppNotFoundDictionary.reponseResult}    ${AppNotFoundDiffEntity}    ${RunStatus.RUN}    ${RunStatus.RUN}
