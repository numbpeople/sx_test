*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${ActivateUser}    {"action":"Deactivate user","entities":[{"uuid":"410fc53a-8765-11e9-af58-03a1eefd77f7","type":"user","created":1559720456451,"modified":1559720456451,"username":"imautotest-9861698106","activated":false,"nickname":"imautotest-9861698106"}],"timestamp":1559720456682,"duration":18}
${ActivateUserDiffEntity}    {"action":"Deactivate user","entities":[{"uuid":"%s","type":"user","username":"%s","activated":false,"nickname":"%s"}]}
${DeactivateUser}    {"action":"activate user","timestamp":1542602404132,"duration":9}
${DeactivateUserDiffEntity}    {"action":"activate user"}
&{ActivateUserDictionary}    statusCode=200    reponseResult=${ActivateUser}
&{DeactivateUserDictionary}    statusCode=200    reponseResult=${DeactivateUser}
