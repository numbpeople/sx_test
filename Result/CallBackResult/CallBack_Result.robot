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