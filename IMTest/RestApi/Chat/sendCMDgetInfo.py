#coding:utf-8

import sys
sys.path.append("..")

from apiconfig import *
import requests
import json

#setup body parameters
sendCmdbody = { "target_type":"users",
    "target":[user1,user2],
    "msg":{
        "type":"cmd",
        "action":"action1"
        },
    "from":"rest"
}

sendCmdStartDebugbody = { "target_type":"users",
    "target":[user2],
    "msg":{
        "type":"cmd",
        "action":"em_start_debug"
        },
    "from":"rest"
}

sendCmdStopDebugbody = { "target_type":"users",
    "target":[user1],
    "msg":{
        "type":"cmd",
        "action":"em_stop_debug"
        },
    "from":"rest"
}

sendCmdUploadLogbody = { "target_type":"users",
    "target":[user1],
    "msg":{
        "type":"cmd",
        "action":"em_upload_log"
        },
    "from":"rest"
}

sendCmdChagServerbody = {
 "target_type":"users",
 "target":[user2],
    "msg":{
  "type":"cmd",
  "action":"em_change_servers"
 },
 "from":"rest",
     "ext": {"im_server":"118.193.28.212:31092",
             "rest_server":"118.193.28.212:31080"}
 }

sendCmdChagAppkeyboey = {
 "target_type":"users",
 "target":[user2],
    "msg":{
  "type":"cmd",
  "action":"em_change_appkey"
 },
 "from":"rest",
     "ext": {"appkey":"easemob-demo#chatdemoui"}
 }

sendBroadcastbody = {
"msg":{
        "type":"txt",
        "msg":""
        },
    "from":"Admin",
     "ext" : {
        "attr1" : "v1"
     }
}


class SendCmdGetInfo:
    def __init__(self, headers,sendCmdbody,sendCmdStartDebugbody,sendCmdStopDebugbody,sendCmdUploadLogbody,
                 sendCmdChagServerbody,sendCmdChagAppkeyboey,sendBroadcastbody):
        self.headers = headers
        self.sendCmdbody = sendCmdbody
        self.sendCmdStartDebugbody = sendCmdStartDebugbody
        self.sendCmdStopDebugbody = sendCmdStopDebugbody
        self.sendCmdUploadLogbody = sendCmdUploadLogbody
        self.sendCmdChagServerbody = sendCmdChagServerbody
        self.sendCmdChagAppkeyboey = sendCmdChagAppkeyboey
        self.sendBroadcastbody = sendBroadcastbody

    @ornament
    def sendCmdMess(self):
        #send a Cmd messages
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendCmdbody), headers=self.headers)
            #print r.json()
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def sendCmdStartDebugmess(self):
        #send a Cmd messages Start Debug
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendCmdStartDebugbody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def sendCmdStopDebugmess(self):
        #send a Cmd messages Stop Debug
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendCmdStopDebugbody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def sendCmdUploadLogMess(self):
        #send a Cmd messages upload log
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendCmdUploadLogbody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def sendCmdChagServerMess(self):
        # send a Cmd messages change server
        try:
            self.r = requests.post("%s/%s/%s/messages" % (url,org,app),data=json.dumps(self.sendCmdChagServerbody), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def sendCmdChagAppkeyMess(self):
        # send a Cmd messages change appkey
        try:
            self.r = requests.post("%s/%s/%s/messages" % (url,org,app),data=json.dumps(self.sendCmdChagAppkeyboey), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def getUserChatHistoryMess(self):
        # get user chat history message in sandbox
        try:
            #self.r = requests.get("%s/%s/%s/chatmessages?limit=100" % (url,org,app), headers=self.headers)
            self.r = requests.get("%s/%s/%s/chatmessages?ql=select+* order by timestamp desc" % (url, org, app), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    def NewUserHistoryMess(self):
        # get user chat history message in online
        try:
            self.r = requests.get("%s/%s/%s/chatmessages/%s" % (url, org, app, olddate), headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                result = data1['data'][0]['url']
                if result:
                    print "get history message success, url is: ", result
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get history message failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except (KeyError,requests.exceptions.ConnectionError), e:
            print "Your url is error or return result error: %s" % e
            print json.dumps(self.r.json(), sort_keys=True, indent=2)
            return False

    @ornament
    def getOfflineMessCout(self):
        # get user offline message count
        try:
            self.r = requests.get("%s/%s/%s/users/%s/offline_msg_count" % (url,org,app,user2), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def ChkOffliMessStat(self):
        # check  offline message status
        try:
            self.r = requests.get("%s/%s/%s/users/%s/offline_msg_status/QYyWT-5-c9ff5" % (url,org,app,user1), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    #Get User Chat History - Timestamp

    @ornament
    def sendBroadcastMess(self):
        # send a Broadcast messages
        try:
            self.r = requests.post("%s/%s/%s/fsmessages" % (url,org,app),data=json.dumps(self.sendBroadcastbody), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r