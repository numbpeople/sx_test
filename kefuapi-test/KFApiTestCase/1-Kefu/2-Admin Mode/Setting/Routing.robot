*** Settings ***
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           uuid
Resource          ../../../../AgentRes.robot
Resource          ../../../../api/MicroService/Webapp/OutDateApi.robot
Resource          ../../../../JsonDiff/KefuJsonDiff.robot

*** Test Cases ***
