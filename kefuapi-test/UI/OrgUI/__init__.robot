*** Settings ***
Suite Setup
Force Tags        ui
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Resource          ../../AgentRes.robot
Resource          ../../api/KefuApi.robot
Resource          ../../JsonDiff/OrgJsonDiff.robot
Resource          ../../api/OrgApi.robot
Resource          ../../commons/admin common/BaseKeyword.robot
Resource          ../../UIcommons/Org/dashboard.robot
Library           uuid
Library           urllib
Library           Selenium2Library
