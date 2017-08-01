*** Settings ***
Suite Setup       Login And Set Browser Cookies&localStorage    ${AdminUser}
Suite Teardown    Close Browser
Force Tags        ui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/KefuApi.robot
Resource          ../../api/TeamApi.robot
Library           uuid
Library           jsonschema
Library           urllib
Library           Selenium2Library
Resource          ../../UIcommons/Kefu/utils.robot
