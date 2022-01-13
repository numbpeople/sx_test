*** Settings ***
Resource    ../../Variable_Env.robot
Resource    ../BaseResullt.robot

*** Variables ***
${CallBack}    {"path":"/callbacks","uri":"https://a1-hsb.easemob.com/easemob-demo/easeim/callbacks","timestamp":1640749754294,"organization":"easemob-demo","application":"595139c6-01e8-4610-9ae4-42de70b480d6","entities":[{"acceptRestMessage":false,"interested":["roster","userStatus","groupchat","chat","recall","chatroom","muc","sensitiveWords","read_ack"],"name":"111","owner":"easemob-demo#easeim","forAppkey":"easemob-demo#easeim","msgTypes":["chat","chat_offline"],"action":1,"actionDataFormat":0,"actionParams":{"hxSecret":"40088182666","topic":"hcb","secret":"9582402158","uri":"http://cmpy87.natappfree.cc"},"expireStrategy":1,"errorStrategy":1,"status":1,"userPhone":"13400327635","appkeyBanExpire":300,"ruleId":"95e5e365-fddf-4e0a-b0eb-70ae0fc5b29b"}],"action":"post","duration":0,"applicationName":"easeim"}
${CallBackDiffEntity}    {"path":"/callbacks","uri":"%s","organization":"%s","application":"%s","entities":[{"acceptRestMessage":false,"interested":["roster","userStatus","groupchat","chat","recall","chatroom","muc","sensitiveWords","read_ack"],"name":"%s","owner":"%s","forAppkey":"%s","msgTypes":["chat","chat_offline"],"action":1,"actionDataFormat":0,"actionParams":{"hxSecret":"40088182666","topic":"hcb","secret":"9582402158","uri":"%s"},"expireStrategy":1,"errorStrategy":1,"status":1,"userPhone":"%s","appkeyBanExpire":%s}],"action":"%s","applicationName":"%s"}
&{CallBackDictionary}    statusCode=200    reponseResult=${CallBack}

${MoreCallBack}    {}
${MoreCallBackDiffEntity}    {}
&{MoreCallBackDictionary}    statusCode=200    reponseResult=${MoreCallBack}

${MsgHooks}    {"path":"/msghooks","uri":"https://a1-hsb.easemob.com/easemob-demo/shuang/msghooks","timestamp":1641884056494,"organization":"easemob-demo","application":"f7c41175-16d4-4cca-8026-86e5f206ff64","entities":[{"actionParams":{"defaultAction":0,"hxSecret":"HmaHMrDJzMHrIOV8","secret":"HmaHMrDJzMHrIOV8","timeout":200,"uri":"http://www.baidu.com"},"error_code":1,"id":"111","interested":["chat","groupchat","chatroom"],"msgTypes":["VIDEO","FILE","IMAGE","LOCATION","TEXT","VOICE","CUSTOM"],"name":"111","status":1}],"action":"post","duration":8,"applicationName":"shuang"}
${MsgHooksDiffEntity}    {"path":"%s","uri":"%s","organization":"%s","application":"%s","entities":[{"actionParams":{"uri":"%s"},"interested":["chat","groupchat","chatroom"],"msgTypes":["VIDEO","FILE","IMAGE","LOCATION","TEXT","VOICE","CUSTOM"],"name":"%s"}],"action":"%s","applicationName":"%s"}
&{MsgHooksDictionary}    statusCode=200    reponseResult=${MsgHooks}

${DeleteMsgHooks}    {"path":"/msghooks/xupqlpdf","uri":"http://a1.easemob.com/easemob-demo/shuang/msghooks/xupqlpdf","timestamp":1641981580498,"organization":"easemob-demo","application":"5d6c5f58-a650-4cdf-9399-5f7b57da51ba","entities":[],"action":"delete","duration":4,"applicationName":"shuang"}
${DeleteMsgHooksDiffEntity}    {"path":"%s","uri":"%s","organization":"%s","application":"%s","entities":[],"action":"%s","applicationName":"%s"}
&{DeleteMsgHooksDictionary}    statusCode=200    reponseResult=${DeleteMsgHooks}

${MoreMsgHooks}    {}
${MoreMsgHooksDiffEntity}    {}
&{MoreMsgHooksDictionary}    statusCode=200    reponseResult=${MoreMsgHooks}