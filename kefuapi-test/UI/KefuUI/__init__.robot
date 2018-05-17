*** Settings ***
Suite Setup       KefuUI Setup    ${AdminUser}
Suite Teardown    KefuUI Teardown
Force Tags        ui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../api/MicroService/Webapp/TeamApi.robot
Resource          ../../api/MicroService/WebGray/WebGrayApi.robot
Resource          ../../api/MicroService/Permission/PermissionApi.robot
Resource          ../../UIcommons/Utils/baseUtils.robot
Library           uuid
Library           urllib
Library           Selenium2Library
Resource          ../../api/HomePage/Login/Login_Api.robot
Resource          ../../commons/admin common/BaseKeyword.robot
Resource          ../../commons/Base Common/Base_Common.robot
Resource          ../../commons/admin common/Channels/App_Common.robot
