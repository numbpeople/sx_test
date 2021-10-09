*** Variables ***
${AppNoOrganizationAuthorized}    {"error":"unauthorized","timestamp":1552912409578,"duration":0,"exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"No organization access authorized"}
${AppNoOrganizationAuthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"No organization access authorized"}
&{AppNoOrganizationAuthorizedDictionary}    statusCode=401    reponseResult=${AppNoOrganizationAuthorized}
${AppRegistrationNoOpen}    {"error":"unauthorized","exception":"EasemobSecurityException","timestamp":1570612439301,"duration":0,"error_description":"Open registration doesn't allow, so register user need token,"}
${AppRegistrationNoOpenDiffEntity}    {"error":"unauthorized","exception":"EasemobSecurityException","error_description":"Open registration doesn't allow, so register user need token,"}
&{AppRegistrationNoOpenDictionary}    statusCode=401    reponseResult=${AppRegistrationNoOpen}
${UserUnAuthorized}    {"error":"unauthorized","timestamp":1557112424231,"duration":0,"exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:post:f21bd880-6fac-11e9-83d8-2dc36a9ff75e:/users/f25f4a20-6fac-11e9-ae8b-7d1eeb7f6f99]"}
${UserUnAuthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.shiro.authz.UnauthorizedException","error_description":"Subject does not have permission [applications:%s:%s:/users%s]"}
&{UserUnAuthorizedDictionary}    statusCode=401    reponseResult=${UserUnAuthorized}
${NoAdminUserAccessAuthorized}    {"error":"unauthorized","timestamp":1557205950389,"duration":0,"exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"No admin user access authorized"}
${NoAdminUserAccessAuthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"No admin user access authorized"}
&{NoAdminUserAccessAuthorizedDictionary}    statusCode=401    reponseResult=${NoAdminUserAccessAuthorized}
${TokenAuthorizationIsBlank}    {"error":"group_authorization","timestamp":1558506436181,"duration":0,"exception":"com.easemob.group.exception.GroupAuthorizationException","error_description":"token is blank!"}
${TokenAuthorizationIsBlankDiffEntity}    {"error":"group_authorization","exception":"com.easemob.group.exception.GroupAuthorizationException","error_description":"token is blank!"}
&{TokenAuthorizationIsBlankDictionary}    statusCode=401    reponseResult=${TokenAuthorizationIsBlank}
${UnableToAuthenticate}    {"error":"unauthorized","timestamp":1559816593002,"duration":0,"exception":"EasemobSecurityException","error_description":"Unable to authenticate (OAuth)"}
${UnableToAuthenticateDiffEntity}    {"error":"unauthorized","exception":"EasemobSecurityException","error_description":"Unable to authenticate (OAuth)"}
&{UnableToAuthenticateDictionary}    statusCode=401    reponseResult=${UnableToAuthenticate}
${EasemobSecurityException1}    {"error":"auth_bad_access_token","exception":"EasemobSecurityException","timestamp":1569469646795,"duration":0,"error_description":"Unable to authenticate due to corrupt access token"}
${EasemobSecurityExceptionDiffEntity1}    {"error":"auth_bad_access_token","exception":"EasemobSecurityException","error_description":"Unable to authenticate due to corrupt access token"}
&{EasemobSecurityExceptionDictionary1}    statusCode=401    reponseResult=${EasemobSecurityException}
${EasemobSecurityException}    {"error":"unauthorized","exception":"com.easemob.im.exceptions.EasemobSecurityException","timestamp":1570613925656,"duration":1,"error_description":"Unable to authenticate (OAuth)"}
${EasemobSecurityExceptionDiffEntity}    {"error":"unauthorized","exception":"EasemobSecurityException","error_description":"Unable to authenticate (OAuth)"}
&{EasemobSecurityExceptionDictionary}    statusCode=401    reponseResult=${EasemobSecurityException}
