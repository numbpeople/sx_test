*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar

*** Keywords ***
SendTxtMsg By Rest
    [Arguments]    ${restapijson}    ${content}    ${expires}='-1'    ${verb}='POST'
