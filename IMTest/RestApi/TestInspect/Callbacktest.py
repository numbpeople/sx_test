#coding= utf-8
import sys
import unittest


sys.path.append("..")

from apiconfig import *
from Callback.OpertCallbak import *


class TestCallbackTestCase(unittest.TestCase):
    def setUp(self):
        self.CB = HxCallback(headers,addbody,modifybody)

    def testAddCB_1(self):
        u'''新增一个Callback'''
        self.assertEqual(self.CB.addcallback(),200)

    def QueryCBs_2(self):
        u'''查询Callback'''
        self.assertEqual(self.CB.querycallbacks(),200)

    def QueryCBDetail_3(self):
        u'''查询一个Callback祥情'''
        self.assertTrue(self.CB.queryCBDetail(), True)

    def ModifyCB_4(self):
        u'''修改一个Callback'''
        self.assertTrue(self.CB.modifyCB(), True)

    def DeleteCB_5(self):
        u'''删除一个Callback'''
        self.CB.deleteCB()
        self.assertFalse(self.CB.queryCBDetail(), False)

    def tearDown(self):
        self.CB = None