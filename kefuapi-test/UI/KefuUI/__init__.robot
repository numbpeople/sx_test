*** Settings ***
Suite Setup       Browser Init    ${AdminUser}
Suite Teardown    Close Browser
Force Tags        ui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../api/MicroService/WebGray/WebGrayApi.robot
Resource          ../../UIcommons/Utils/baseUtils.robot
Library           uuid
Library           urllib
Library           Selenium2Library
