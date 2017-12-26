#coding:utf-8

import sys
sys.path.append("..")

from apiconfig import *
import requests
import json

#setup body parameters
sendbody = {"target_type": "users",
                     "target": [user1],
                     "msg": {
                         "type": "txt",
                         "msg": messages
                     },
                     "from": "rest"
                     }

sendbodytwo={ "target_type":"users",
                 "target":[user1,user2],
                 "msg":{
                 "type":"txt",
                 "msg": messages
                  },
                  "from":"rest"
                }

sendNoticebody = {
    "target_type": "users",
    "target": [
        user2
    ],
    "msg": {
        "type": "txt",
        "msg": "公告标题"
    },
    "ext": {
      "info":[ {
            "txt": "测试文字a's'da'd'as'd'as'd"
        },
        {
            "img": "http://img002.21cnimg.com/photos/album/20160326/m600/B920004B5414AE4C7D6F2BAB2966491E.jpeg"
        },
        {
            "txt": "测试文字a's'da'd'as'd'as'd"
        }, {
            "img": "http://img002.21cnimg.com/photos/album/20160326/m600/B920004B5414AE4C7D6F2BAB2966491E.jpeg"
        },
        {
            "img": "http://img001.21cnimg.com/photos/album/20170220/m600/E6BA09D87E03DB8E06E5B1B8EC6958DC.gif"
        }]
    }
}

sendLocbody = { "target_type":"users",
    "target":[user2],
    "msg":{
      "addr":"中国北京市海淀区南大街2号院-1",
      "lat":"39.966334",
      "lng":"116.323123",
      "type":"loc"
    },
    "from":"rest"
}

sendForceNotibody = {"target_type" : "users",
 "target" : [user2],
 "msg" : {"type" : "txt","msg" : "hello from rest"},
 "from" : "admin",
 "ext" : {"em_force_notification":"true"} }

sendPushTitlebody = {"target_type":"users",
 "target":[user2],
 "msg" :
 {"type":"txt","msg":"hello"},
 "from":"test2",
"ext":{"em_apns_ext":{"em_push_title":"北京市海淀区中关村南大街2号数码大厦A座20层环信即时通讯云"}
}
}

PushNewTitlebody = {"target_type" : "users",
 "target": [user1],
 "msg":
 {"type":"txt","msg" : "this rest message for new push title"},
 "from":"rest",
"ext":{"em_apns_ext":{"em_push_name":"北京市海淀区","em_push_content":"this is content","extern":"11111"} }
}

sendIgnoreNotibody = {
    "target_type":"users",
    "target":[
      user1
    ],
    "msg":{
      "type":"txt",
      "msg":"hello from rest"
    },
    "from":"rest",
    "ext":{
      "em_ignore_notification":"true"
    }
  }

sendPushBadgebody = {"target_type" : "users",
 "target" : [user1],
 "msg" :
 {"type" : "txt",
 "msg" : "hello"},
 "from" : "rest",
"ext" : {"em_apns_ext" :{"em_push_badge":"37"}
}
}

sendPushIgnSoundbody = {"target_type" : "users",
 "target" : [user1],
 "msg" :
 {"type" : "txt",
 "msg" : "hello"},
 "from" : "rest",
"ext" : {"em_apns_ext" :{"em_push_ignore_sound":"false"}}
}

class TextMessage:
    def __init__(self, headers, body, bodytwo,sendNoticebody,sendLocbody,
                 sendForceNotibody,sendPushTitlebody,sendIgnoreNotibody,sendPushBadgebody,sendPushIgnSoundbody,
                 PushNewTitlebody):
        self.headers = headers
        self.body = body
        self.bodytwo = bodytwo
        #self.sendVideobody = sendVideobody
        self.sendNoticebody = sendNoticebody
        self.sendLocbody = sendLocbody
        self.sendForceNotibody = sendForceNotibody
        self.sendPushTitlebody = sendPushTitlebody
        self.sendIgnoreNotibody = sendIgnoreNotibody
        self.sendPushBadgebody = sendPushBadgebody
        self.sendPushIgnSoundbody = sendPushIgnSoundbody
        self.PushNewTitlebody = PushNewTitlebody

    @ornament
    def sendmessage(self):
        #send a messages to one user
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.body), headers=self.headers)
            #print r.json()
            #print "url is: %s,org is: %s,app is: %s" % (url,org,app)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def send_two(self):
        # send a messages to one user
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.bodytwo), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def get_friend(self):
        # get a user the friends list
        try:
            self.r = requests.get("%s/%s/%s/users/%s/contacts/users" %(url,org,app,user1), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendImageMess(self,sendImagebody):
        # send a Image messages to user
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(sendImagebody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendAudioMess(self,sendAudiobody):
        # send a audio messages to  user
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(sendAudiobody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendVideoMess(self,sendVideobody):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(sendVideobody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendNoticeMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendNoticebody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendLocMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendLocbody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendForceNotiMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendForceNotibody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendPushTitleMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendPushTitlebody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendIgnoreNotiMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendIgnoreNotibody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendPushBadgeMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendPushBadgebody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def sendPushIgSoundMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.sendPushIgnSoundbody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    @ornament
    def PushNewTitleMess(self):
        try:
            self.r = requests.post("%s/%s/%s/messages" %(url,org,app), data=json.dumps(self.PushNewTitlebody), headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" %e
        else:
            return self.r

    def uploadImage(self):
        uploadHeader = {'restrict-access': 'true',
                        'Authorization': "Bearer %s" % token}

        file = {'file': ('scenery.png', open('scenery.png', 'rb'), 'image/jpeg')}
        try:
            self.r = requests.post("%s/%s/%s/chatfiles/" %(url,org,app), files=file, headers=uploadHeader)
            if self.r.status_code == 200:
                data = self.r.json()
                print "image upload success"
                imageurl = data['uri'] + '/' + data['entities'][0]['uuid']
                print "image url is: ", imageurl
                return self.r.status_code, imageurl
            else:
                print "upload images failed",self.r.status_code,self.r.content
                return self.r.status_code,self.r.content
        except requests.exceptions.ConnectionError,e:
            print "Your url is error: %s" %e
            return "Your url is error ",  e

    def uploadAudio(self):
        uploadHeader = {'restrict-access': 'true',
                        'Authorization': "Bearer %s" % token}

        file = {'file': ('111.mp3', open('111.mp3', 'rb'))}
        try:
            self.r = requests.post("%s/%s/%s/chatfiles/" %(url,org,app), files=file, headers=uploadHeader)
            if self.r.status_code == 200:
                data = self.r.json()
                print "Audio upload success"
                audiourl = data['uri'] + '/' + data['entities'][0]['uuid']
                print "Audio url is: ", audiourl
                return self.r.status_code, audiourl
            else:
                print "upload Audio failed",self.r.status_code,self.r.content
                return self.r.status_code,self.r.content
        except requests.exceptions.ConnectionError,e:
            print "Your url is error",e
            return "Your url is error ",  e

    def uploadVideo(self):
        uploadHeader = {'restrict-access': 'true',
                        'Authorization': "Bearer %s" % token}

        file = {'file': ('345.mp4', open('345.mp4', 'rb'))}
        try:
            self.r = requests.post("%s/%s/%s/chatfiles/" %(url,org,app), files=file, headers=uploadHeader)
            if self.r.status_code == 200:
                data = self.r.json()
                print "video upload success"
                videourl = data['uri'] + '/' + data['entities'][0]['uuid']
                print "video url is: ", videourl
                return self.r.status_code, videourl
            else:
                print "upload video failed",self.r.status_code,self.r.content
                return self.r.status_code,self.r.content
        except requests.exceptions.ConnectionError,e:
            print "Your url is error",e
            return "Your url is error ",  e

