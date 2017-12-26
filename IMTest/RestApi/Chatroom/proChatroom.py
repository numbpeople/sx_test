#coding:utf-8

import sys
sys.path.append("..")

from apiconfig import *
import requests
import json

class chatroom:
    def __init__(self,headers,CteroomBody,modifyBody,MultiMemBody):
        self.headers = headers
        self.CteroomBody = CteroomBody
        self.modifyBody = modifyBody
        self.MultiMemBody = MultiMemBody

    def Ctechatroom(self):
        # Create Chatroom
        try:
            self.r = requests.post("%s/%s/%s/chatrooms" % (url, org, app),data=json.dumps(self.CteroomBody),headers=self.headers)
            if self.r.status_code == 200:
                data = self.r.json()
                if data['data']['id']:
                    global RoomID
                    RoomID = data['data']['id']
                    print "Create chat room success, room id is: ", RoomID
                    print json.dumps(data, sort_keys=True, indent=2)
                    return True, RoomID
                else:
                    print "Create chat room Failed"
                    return False, None
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e, None

    def getAllRoom(self):
        # get all  Chatroom
        try:
            self.r = requests.get("%s/%s/%s/chatrooms" % (url, org, app),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["data"]:
                    print "get all chat room success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get all chat room failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def ModifyRoom(self,roomid):
        # modify the  Chatroom
        try:
            self.r = requests.put("%s/%s/%s/chatrooms/%s" % (url, org, app,roomid),data=json.dumps(self.modifyBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if data2['data'][0]['name'] == self.modifyBody["name"] and data2['data'][0]['maxusers'] == self.modifyBody["maxusers"]:
                        print "modify chat room success"
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "modify chat room failed"
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def getRoomDetail(self, roomid):
        # get the  Chatroom details
        try:
            self.r = requests.get("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1['data'][0]['name'] and data1['data'][0]['id']:
                    print "get chat room details success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get chat room details failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def InviteMemRoom(self, roomid,userroom):
        # Invite a member to  Chatroom
        try:
            self.r = requests.post("%s/%s/%s/chatrooms/%s/users/%s" % (url, org, app, roomid,userroom),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    members = []
                    for a in data2["data"][0]["affiliations"]:
                        for x, y in a.items():
                            members.append(y)
                    if userroom in members:
                        print "Invite chatroom member %s success" % userroom
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "Invite chatroom member %s failed" % userroom
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False


    def InvMultiMemRoom(self, roomid):
        # Invite multi member to Chatroom    ,
        try:
            self.r = requests.post("%s/%s/%s/chatrooms/%s/users" % (url, org, app, roomid),data=json.dumps(self.MultiMemBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    members = []
                    for a in data2["data"][0]["affiliations"]:
                        for x, y in a.items():
                            members.append(y)
                    if user3 in members and user4 in members:
                        print "Invite chatroom multi members %s %s success" % (user3,user4)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "Invite chatroom multi members %s %s failed" % (user3,user4)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def KickMemRoom(self, roomid, userroom):
        # Kick a member from Chatroom
        try:
            self.r = requests.delete("%s/%s/%s/chatrooms/%s/users/%s" % (url, org, app, roomid, userroom),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    members = []
                    for a in data2["data"][0]["affiliations"]:
                        for x, y in a.items():
                            members.append(y)
                    if userroom not in members:
                        print "Kick chatroom member %s success" % userroom
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "Kick chatroom member %s failed" % userroom
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def KickMultiMemRoom(self, roomid):
        # Kick multi member from Chatroom
        try:
            self.r = requests.delete("%s/%s/%s/chatrooms/%s/users/%s,%s" % (url, org, app, roomid,user3,user4),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    members = []
                    for a in data2["data"][0]["affiliations"]:
                        for x, y in a.items():
                            members.append(y)
                    if user3 not in members and user4 not in members:
                        print "Kick chatroom multi members %s %s success" % (user3, user4)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "Kick chatroom multi members %s %s failed" % (user3, user4)
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def getJoinAllRoom(self, roomuser):
        # get user joined all Chatroom
        try:
            self.r = requests.get("%s/%s/%s/users/%s/joined_chatrooms" % (url, org, app, roomuser),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["data"]:
                    print "get user %s join all room success" % roomuser
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get user %s join all room failed" % roomuser
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    @ornament
    def getAllRobot(self):
        # get all robots
        try:
            self.r = requests.get("%s/%s/%s/robots" % (url, org, app),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def SendMessRoom(self, roomid):
        # send messages to Chatroom
        sendMessRoom = {"target_type": "chatrooms",
                        "target": [roomid],
                        "msg": {
                            "type": "txt",
                            "msg": "this message is test chatroom from rest"
                        },
                        "from": "rest_auto"
                        }
        try:
            self.r = requests.post("%s/%s/%s/messages" % (url, org, app),data=json.dumps(sendMessRoom),headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: %s" % e
        else:
            return self.r

    def AddAdminRoom(self,roomid,roomuser):
        # add an chatroom admin
        AddAdminBody = {"newadmin": roomuser}
        try:
            self.r = requests.post("%s/%s/%s/chatrooms/%s/admin" % (url, org, app, roomid),data=json.dumps(AddAdminBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s/admin" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if roomuser in data2['data']:
                        print "add chatroom admin %s success" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "add chatroom admin %s failed" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False


    def getAdminList(self, roomid):
        # get an chatroom admin list
        try:
            self.r = requests.get("%s/%s/%s/chatrooms/%s/admin" % (url, org, app, roomid),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["data"]:
                    print "get admin list success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get admin list failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False


    def RmRoomAdmin(self, roomid, roomuser):
        # remove an chatroom admin
        try:
            self.r = requests.delete("%s/%s/%s/chatrooms/%s/admin/%s" % (url, org, app, roomid,roomuser),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s/admin" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    if roomuser not in data2["data"]:
                        print "remove chatroom admin %s success" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "remove chatroom admin %s failed" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def RoomMuteMember(self, roomid, roomuser):
        # mute a member
        MuteMemBody = {"usernames": [roomuser], "mute_duration": 86400000}
        try:
            self.r = requests.post("%s/%s/%s/chatrooms/%s/mute" % (url, org, app, roomid),data=json.dumps(MuteMemBody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s/mute" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    mutelist = []
                    for a in data2['data']:
                        mutelist.append(a["user"])
                    if roomuser in mutelist:
                        print "chatroom mute member %s success" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "chatroom mute member %s failed" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def getMuteList(self, roomid):
        # get mute membet list
        try:
            self.r = requests.get("%s/%s/%s/chatrooms/%s/mute" % (url, org, app, roomid),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1['data']:
                    print "get mute list success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get mute list failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def RmMuteMember(self, roomid,roomuser):
        # Remove a mute membet
        try:
            self.r = requests.delete("%s/%s/%s/chatrooms/%s/mute/%s" % (url, org, app, roomid, roomuser),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s/mute" % (url, org, app, roomid),headers=self.headers)
                if get.status_code == 200:
                    data2 = get.json()
                    mutelist = []
                    for a in data2['data']:
                        mutelist.append(a["user"])
                    if roomuser not in mutelist:
                        print "chatroom unmute member %s success" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return True
                    else:
                        print "chatroom unmute member %s failed" % roomuser
                        print json.dumps(data1, sort_keys=True, indent=2)
                        return False
                else:
                    print "status code is %s, request error" % get.status_code
                    print json.dumps(get.json(), sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False

    def DelChatRoom(self, roomid):
        # delete a chatroom
        try:
            self.r = requests.delete("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                get = requests.get("%s/%s/%s/chatrooms/%s" % (url, org, app, roomid),headers=self.headers)
                data2 = get.json()
                if get.status_code == 404 and roomid in data2["error_description"]:
                    print "delete chatroom id %s success" %roomid
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "delete chatroom id %s failed" % roomid
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False

            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError, e:
            print "Your url is error: %s" % e
            return False