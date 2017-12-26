#coding= utf-8
import sys
import unittest

sys.path.append("..")

from apiconfig import *
from Chat.proNotifier import *

class TestNotifiers(unittest.TestCase):

    def setUp(self):
        self.Notifier = Notifiers(headers)
    def testGetNotifier_1(self):
        u'验证获取多个Notifiers'
        self.assertEqual(self.Notifier.getMulNotifier(),200)
    def testUpNotifiHuaW_2(self):
        u'验证上传华为推送证书'
        self.assertEqual(self.Notifier.UpNotifierHuaW(),200)
    def testDelHuaWeiNoti_3(self):
        u'验证删除华为推送证书'
        self.assertEqual(self.Notifier.DelNotifierHuaW(),200)
    def testUpXiaoMiNoti_4(self):
        u'验证上传小米推送证书'
        self.assertEqual(self.Notifier.UpNotifierXiaoMi(),200)
    def testDelXizoMiNotifi_5(self):
        u'验证删除小米推送证书'
        self.assertEqual(self.Notifier.DelNotifiXiaoMi(),200)
