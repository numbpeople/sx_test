#coding:utf-8

import sys
sys.path.append("..")

from apiconfig import *
import requests
import json

class Notifiers:
    def __init__(self,headers):
        self.headers = headers

    @ornament
    def getMulNotifier(self):
        # get multi notifiers
        try:
            self.r = requests.get("%s/%s/%s/notifiers?limit=10" % (url, org, app), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: ", e
        else:
            return self.r

    @ornament
    def UpNotifierHuaW(self):
        # upload HuaWei Nofitier
        upHuaWeiBody = {"name": "10493098",
            "provider": "HUAWEIPUSH",
            "environment": "PRODUCTION",
            "certificate": "8o42az0cej2i2wgefk2y46yyed44sq4n"
         }
        try:
            self.r = requests.post("%s/%s/%s/notifiers" % (url, org, app),
                                  data=json.dumps(upHuaWeiBody),
                                  headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: " % e
        else:
            return self.r

    @ornament
    def DelNotifierHuaW(self):
        # del HuaWei notifiers
        try:
            self.r = requests.delete("%s/%s/%s/notifiers/10493098" % (url, org, app), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: ", e
        else:
            return self.r

    @ornament
    def UpNotifierXiaoMi(self):
        # upload XiaoMi Nofitier
        upXiaoMiBody = {     "name": "2882308766617936952",
                "provider": "XIAOMIPUSH",
                "environment": "PRODUCTION",
                "certificate": "XZpWGpMfeEizuWn1Auh2Dg==",
                "packageName": "com.hyphenate.chatuidemo"
                }
        try:
            self.r = requests.post("%s/%s/%s/notifiers" % (url, org, app),
                                  data=json.dumps(upXiaoMiBody),
                                  headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: " % e
        else:
            return self.r

    @ornament
    def DelNotifiXiaoMi(self):
        # del XianMi notifiers
        try:
            self.r = requests.delete("%s/%s/%s/notifiers/2882308766617936952" % (url, org, app), headers=self.headers)
        except requests.exceptions.ConnectionError, e:
            return "Your url is error: ", e
        else:
            return self.r