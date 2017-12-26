#coding:utf-8

import sys
sys.path.append("..")

from apiconfig import *
import requests
import json

##setup callback parameters
CBName = "mycallback"

addbody = {"name":CBName,
    "msgTypes":["chat","chat_offline"],
    "hxSecret":"40088182666",
    "secret":"9582402158",
    "targetUrl":"http://121.41.60.67:8082/callback/",
    "status":1,
    "notifyUrl":"http://www.notify.com"}

modifybody = {"name":CBName,
    "msgTypes":["chat","chat_offline"],
    "hxSecret":"25257979",
    "secret":"89895656",
    "targetUrl":"http://121.41.60.67:8082/callback/",
    "status":1,
    "notifyUrl":"http://www.notify.com"}


class HxCallback:
    def __init__(self, headers, addbody,modifybody):
        self.headers = headers
        self.body = addbody
        self.modifybody = modifybody

    @ornament
    def addcallback(self):
        try:
            self.r = requests.post("%s/%s/%s/callbacks" %(url,org,app), data=json.dumps(self.body), headers=self.headers)
            #print r.json()
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    @ornament
    def querycallbacks(self):
        try:
            self.r = requests.get("%s/%s/%s/callbacks" %(url,org,app),headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r

    def queryCBDetail(self):
        try:
            self.r = requests.get("%s/%s/%s/callbacks/%s" %(url,org,app,CBName),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["entities"][0]["name"] == CBName:
                    print "get create callback details success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "get create callback details failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except (KeyError,requests.exceptions.ConnectionError),e:
            print "Your url is error or query callback failed: ", e
            print json.dumps(data1, sort_keys=True, indent=2)
            return False

    def modifyCB(self):
        try:
            self.r = requests.put("%s/%s/%s/callbacks/%s" %(url,org,app,CBName),data=json.dumps(self.modifybody),headers=self.headers)
            if self.r.status_code == 200:
                data1 = self.r.json()
                if data1["entities"][0]["actionParams"]["hxSecret"] == modifybody["hxSecret"] and data1["entities"][0]["actionParams"]["secret"] ==modifybody["secret"]:
                    print "callback modify success"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return True
                else:
                    print "callback modify Failed"
                    print json.dumps(data1, sort_keys=True, indent=2)
                    return False
            else:
                print "status code is %s, request error" % self.r.status_code
                print json.dumps(self.r.json(), sort_keys=True, indent=2)
                return False
        except requests.exceptions.ConnectionError,e:
            print "Your url is error: %s" % e
            return False

    @ornament
    def deleteCB(self):
        try:
            self.r = requests.delete("%s/%s/%s/callbacks/%s" %(url,org,app,CBName),data=json.dumps(self.modifybody),headers=self.headers)
        except requests.exceptions.ConnectionError,e:
            return "Your url is error: %s" % e
        else:
            return self.r