*** Settings ***
Suite Setup       set suite variable    ${session}    ${AdminUser.session}
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Resource          AgentRes.robot
Resource          KefuApi.robot

*** Test Cases ***
