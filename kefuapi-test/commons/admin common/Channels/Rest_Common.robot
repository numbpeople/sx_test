*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar

*** Keywords ***
SendMsg By Rest
    [Arguments]    ${restapiurl}    ${content}    ${expires}='-1'    ${verb}='POST'
    ${str}=    Replace String    ${appkey}    \#    \/
    ${uri}=    set variable    /${str}/users/${users}/tenantApi/imchanel?imNumber=${target}
