*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${SendMessage}    {"action":"post","application":"15d06290-8845-11e9-aa53-bfc3a12c4c5a","path":"/messages","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8214475750/messages","data":{"%s":"success"},"timestamp":1559816592395,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-8214475750"}
${SendMessageDiffEntity}    {"action":"post","application":"%s","data":{"%s":"success"},"organization":"%s","applicationName":"%s"}
&{SendMessageDictionary}    statusCode=200    reponseResult=${SendMessage}

${SendGroupMessage}    {"action":"post","application":"15d06290-8845-11e9-aa53-bfc3a12c4c5a","path":"/messages","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8214475750/messages","data":{"%s":"success"},"timestamp":1559816592395,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-8214475750"}
${SendGroupMessageDiffEntity}    {"action":"post","application":"%s","organization":"%s","applicationName":"%s"}
&{SendGroupMessageDictionary}    statusCode=200    reponseResult=${SendMessage}