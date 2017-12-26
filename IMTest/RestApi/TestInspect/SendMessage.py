#coding= utf-8
import sys
import unittest


sys.path.append("..")

from apiconfig import *
from Chat.sendmessages import *


class TestMessageTestCase(unittest.TestCase):
    def setUp(self):
        self.STM = TextMessage(headers,sendbody,sendbodytwo,
                               sendNoticebody,sendLocbody,sendForceNotibody,sendPushTitlebody,sendIgnoreNotibody,
                               sendPushBadgebody,sendPushIgnSoundbody,PushNewTitlebody)

    def testTM_1(self):
        u'''发送一个人消息'''
        self.assertEqual(self.STM.sendmessage(), 200)

    def testSendtwo_2(self):
        u'''发送两个人消息'''
        self.assertEqual(self.STM.send_two(),200)

    def getfriend_3(self):
        u'''获取好友名单'''
        self.assertEqual(self.STM.get_friend(),200)
    def testUpImage_4(self):
        u'验证上传图片'
        global imageurl
        statcode,imageurl = self.STM.uploadImage()
        self.assertEqual(statcode,200)
    def testsendImage_5(self):
        u'''发送图片消息'''
        sendImagebody = {"target_type": "users",
                         "target": [user1, user2],
                         "msg": {
                             "type": "img",
                             "url": imageurl,
                             "filename": "lorex.jpg",
                             "secret": "yK5a2qWnEeaRcJUaVNstNOVVTjuqBVyib-rF7Vw1xSVn28X4",
                             "size": {
                                 "width": 480,
                                 "height": 480
                             }
                         },
                         "from": "rest"
                         }
        print "image url is: ",imageurl
        self.assertEqual(self.STM.sendImageMess(sendImagebody),200)
    def testUpAudio_6(self):
        u'验证上传音频'
        global audiourl
        statcode,audiourl = self.STM.uploadAudio()
        self.assertEqual(statcode,200)

    def testsendAudio_7(self):
        u'''发送声音消息'''
        sendAudiobody = {"target_type": "users",
                         "target": [user1, user2],
                         "msg": {
                             "type": "audio",
                             "url": audiourl,
                             "filename": "audio sample.amr",
                             "secret": "dmNZWqWoEeaDymsQPaQ9I3Wcs05uXfMWGn0KuRdR87wqko70",
                             "size": {
                                 "width": 480,
                                 "height": 480
                             }
                         },
                         "from": "rest"
                         }
        print "audio url is: ",audiourl
        self.assertEqual(self.STM.sendAudioMess(sendAudiobody),200)
    def testUpVideo_8(self):
        u'验证上传视频'
        global videourl
        statcode,videourl = self.STM.uploadVideo()
        self.assertEqual(statcode,200)
    def testsendVideo_9(self):
        u'''发送视频消息'''
        sendVideobody = {"target_type": "users",
                         "target": [user1, user2],
                         "msg": {
                             "type": "video",
                             "url": videourl,
                             "filename": "111.mp4",
                             "length": 5,
                             "secret": "mIfRSqZJEeaei5tHtLW4f-e_Zh4N_-DOwtX4nFIOvUitGtHJ",
                             "thumb": "https://a1.easemob.com/easemob-demo/chatdemoui/chatfiles/f6a5a3a0-a64a-11e6-8a7b-51138be95708",
                             "thumb_secret": "9qWjqqZKEeaeHwuBpYinrXmDsuAtOTQ2Ad8JW34Gtdj5XrnD",
                             "file_length": 8699
                         },
                         "from": "rest"
                         }
        print "video url is: ", videourl
        self.assertEqual(self.STM.sendVideoMess(sendVideobody),200)
    def testsendNotic_10(self):
        u'''发送公告消息'''
        self.assertEqual(self.STM.sendNoticeMess(),200)

    def testsendLoc_11(self):
        u'''发送位置消息'''
        self.assertEqual(self.STM.sendLocMess(),200)

    def testForceNotifi_12(self):
        u'''发送强制通知'''
        self.assertEqual(self.STM.sendForceNotiMess(),200)

    def testPushTitle_13(self):
        u'''测试推送title'''
        self.assertEqual(self.STM.sendPushTitleMess(),200)

    def testIgnoreNotifi_14(self):
        u'''发送忽略通知'''
        self.assertEqual(self.STM.sendIgnoreNotiMess(),200)

    def testPushBadge_15(self):
        u'''推送标记'''
        self.assertEqual(self.STM.sendPushBadgeMess(),200)

    def testPushIgSound_16(self):
        u'''推送忽略声音'''
        self.assertEqual(self.STM.sendPushIgSoundMess(),200)

    def testPushNewTitle_17(self):
        u'''测试推送新的title格式'''
        self.assertEqual(self.STM.PushNewTitleMess(),200)


    def tearDown(self):
        self.STM = None