*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/InitApi.robot

*** Keywords ***
Get Option Value
    [Arguments]    ${agent}    ${optionname}
    ${resp}=    /tenants/{tenantId}/options/{optionName}    ${agent}    get    ${optionname}    ${empty}    ${timeout}
    return from Keyword if    ${resp.status_code}==404    false
    ${j}    to json    ${resp.text}
    Return from Keyword    ${j['data'][0]['optionValue']}
