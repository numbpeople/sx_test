*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***

${PushNoAuthorization}    {"error":"unauthorized","exception":"EasemobSecurityException","timestamp":1640078400634,"duration":0,"error_description":"Unable to authenticate (OAuth)"}
${PushNoAuthorizationDiffEntity}    {"error":"unauthorized","error_description":"Unable to authenticate (OAuth)"}

&{PushNoAuthorizationDictionary}    statusCode=401    reponseResult=${PushNoAuthorization}

${GetPush}    {"path":"/notifiers","uri":"https://a1-hsb.easemob.com/easemob-demo/imautotest-6488505469/notifiers","timestamp":1640076925457,"entities":[],"count":0,"action":"get","duration":1}    
${GetPushDiffEntity}    {"path":"%s","count":%s,"action":"%s"}    
&{GetPushDictionary}    statusCode=200    reponseResult=${GetPush}

${addhuawei}    {"path":"/notifiers","uri":"http://a1-hw.easemob.com/easemob-demo/hwwudi/notifiers","timestamp":1640073503494,"organization":"easemob-demo","application":"b8df84a6-cd1d-4fb5-a402-555fb8e3615b","entities":[{"uuid":"fe956559-a8e9-4f60-8251-cc438e3bdfe8","type":"notifier","name":"10492024","created":1640073503504,"modified":1640073503504,"disabled":false,"provider":"HUAWEIPUSH","environment":"PRODUCTION","packageName":"com.hyphenate.chatuidemo","certificate":"8o42az0cej2i2wgefk2y46yyed44sq4n","huaweiPushSettings":{"apiVersion":4,"activityClass":"com.hyphenate.chatuidemo.ui.SplashActivity"}}],"action":"post","duration":44,"applicationName":"hwwudi"}        
${addhuaweiDiffEntity}    {"path":"%s","organization":"%s","application":"%s","action":"%s","applicationName":"%s"}
&{addhuaweiDictionary}    statusCode=200    reponseResult=${addhuawei}

${addxiaomi}    {"path":"/notifiers","uri":"http://a1-hw.easemob.com/easemob-demo/hwwudi/notifiers","timestamp":1640140383281,"organization":"easemob-demo","application":"b8df84a6-cd1d-4fb5-a402-555fb8e3615b","entities":[{"uuid":"22d0579d-62cc-438d-ac1e-f56973c8f198","type":"notifier","name":"2882303761517426801","created":1640140383289,"modified":1640140383289,"disabled":false,"provider":"XIAOMIPUSH","environment":"PRODUCTION","packageName":"com.hyphenate.chatuidemo","certificate":"XZpWGpMfeEizuWn1Auh2Dg=="}],"action":"post","duration":36,"applicationName":"hwwudi"}    
${addxiaomiDiffEntity}    {"path":"%s","organization":"%s","application":"%s","entities":[{"provider":"%s"}],"action":"%s","applicationName":"%s"}
&{addxiaomiDictionary}    statusCode=200    reponseResult=${addxiaomi}

${deletehuawei}    {"path":"/notifiers","uri":"https://a1-hsb.easemob.com/easemob-demo/imautotest-5588191988/notifiers","timestamp":1640162884053,"organization":"easemob-demo","application":"b278627b-863c-4e86-8ec4-9b93a8982503","entities":[{"uuid":"9edb804a-9157-44bb-82ca-efe4e05ea75d","type":"notifier","name":"10492024","created":1640162883959,"modified":1640162883959,"disabled":false,"provider":"HUAWEIPUSH","environment":"PRODUCTION","packageName":"com.hyphenate.chatuidemo","certificate":"8o42az0cej2i2wgefk2y46yyed44sq4n","huaweiPushSettings":{"apiVersion":4,"activityClass":"com.hyphenate.chatuidemo.ui.SplashActivity"}}],"action":"delete","duration":9,"applicationName":"imautotest-5588191988"}
${deletehuaweiDiffEntity}    {"path":"%s","organization":"%s","application":"%s","entities":[{"uuid":"%s"}],"action":"%s","applicationName":"%s"}    
&{deletehuaweiDictionary}    statusCode=200    reponseResult=${deletehuawei}

${deletexiaomi}    {"path":"/notifiers","uri":"https://a1-hsb.easemob.com/easemob-demo/imautotest-9792597667/notifiers","timestamp":1640165703485,"organization":"easemob-demo","application":"52a900aa-e9cc-4d8a-8ac0-50325ce73176","entities":[{"uuid":"4c6435b0-2212-4ce9-96b4-dc5850701485","type":"notifier","name":"2882303761517426801","created":1640165703287,"modified":1640165703287,"disabled":false,"provider":"XIAOMIPUSH","environment":"PRODUCTION","packageName":"com.hyphenate.chatuidemo","certificate":"XZpWGpMfeEizuWn1Auh2Dg=="}],"action":"delete","duration":9,"applicationName":"imautotest-9792597667"}
${deletexiaomiDiffEntity}    {"path":"%s","organization":"%s","application":"%s","entities":[{"uuid":"%s"}],"action":"%s","applicationName":"%s"}
&{deletexiaomiDictionary}    statusCode=200    reponseResult=${deletexiaomi}