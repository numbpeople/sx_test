#!/bin/bash

rest_server="http://a1.easemob.com"
org="easemob-demo"
app="coco"
user="easemobdemoadmin"
password="thepushbox123"

#Add the options you need，yes is "true"
#test send general message api
sendmessage="true"

#test add and delete and get callback api
callback="true"

#test send command message api
sendCommand="true"

#test chatgroup all get class api
getGroup="true"

#test chatgroup create and delete and modify api
OperateGroup="true"

#test chatroom all api
chatRoom="true"

#test all manage user api
UserManage="true"

#test upload and delete push certificate api
pushNotifiers="true"

#test random del data class api
DelOperate="false"

python start.py $rest_server $org $app $user $password $sendmessage $callback $sendCommand $getGroup $OperateGroup $chatRoom $UserManage $pushNotifiers $DelOperate
