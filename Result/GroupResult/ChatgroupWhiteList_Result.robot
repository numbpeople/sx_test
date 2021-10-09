*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${GetWhiteList}    {"action":"get","application":"7e4a08ba-1773-4ac7-8f9a-26f270c53789","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-4700491019/chatgroups/159586831106049/white/users","entities":[],"data":["initvaliduser-1390914350"],"timestamp":1631592262881,"duration":0,"organization":"easemob-demo","count":1}
${GetWhiteListDiffEntity}    {"action":"%s","application":"%s","entities":[],"data":["%s"],"organization":"%s","count":1}
&{GetWhiteListDictionary}    statusCode=200    reponseResult=${GetWhiteList}

${AddToWhiteList}    {"action":"post","application":"b9d2a5ac-bd64-4dba-be18-c950f382c550","uri":"http://a1-hsb.easemob.com/easemob-demo/imautotest-5996485473/chatgroups/159598622343169/white/users/imautotest-8013037394","entities":[],"data":{"result":true,"action":"add_user_whitelist","user":"imautotest-8013037394","groupid":"159598622343169"},"timestamp":1631603508085,"duration":1,"organization":"easemob-demo"}
${AddToWhiteListDiffEntity}    {"action":"post","application":"%s","entities":[],"data":{"result":%s,"action":"%s","user":"%s","groupid":"%s"},"organization":"%s"}
&{AddToWhiteListDictionary}    statusCode=200    reponseResult=${AddToWhiteList}