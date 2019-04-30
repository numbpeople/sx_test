*** Variables ***
${AppNoOrganizationAuthorized}    {"error":"unauthorized","timestamp":1552912409578,"duration":0,"exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"No organization access authorized"}
${AppNoOrganizationAuthorizedDiffEntity}    {"error":"unauthorized","exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"No organization access authorized"}
&{AppNoOrganizationAuthorizedDictionary}    statusCode=401    reponseResult=${AppNoOrganizationAuthorized}
${AppRegistrationNoOpen}    {"error":"unauthorized","timestamp":1554961578003,"duration":0,"exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"registration is not open, please contact the app admin"}
${AppRegistrationNoOpenDiffEntity}    {"error":"unauthorized","exception":"org.apache.usergrid.rest.exceptions.SecurityException","error_description":"registration is not open, please contact the app admin"}
&{AppRegistrationNoOpenDictionary}    statusCode=401    reponseResult=${AppRegistrationNoOpen}
