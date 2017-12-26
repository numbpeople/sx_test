#-*- coding:utf-8 -*-
"""
" RF测试结果解析脚本
" 该脚本用以检测RF测试结果并返回被RF标记为 FAIL 的用例信息
"""
import sys, json, requests

class RFParser(object):
    __f = None

    def __init__(self):
        pass

    def setup(self):
        argLen = len(sys.argv)
        if argLen < 2:
            print "Usage: python ParseRFResult.py [RF result file name]"
            return 0

        filename = sys.argv[1]
        with open(filename, "rb") as self.__f:
            list = self.doParse()
            if len(list) > 0:
                self.sendSMS(','.join(list))

    def sendSMS(self, message):
        url = "http://47.96.61.219:80/v1/sms"
        data = {
            "username": "ticket",
            "password": "ticketCI_test",
            "message": "API [%s] 检测失败" % message
        }
        headers = {"Content-Type": "application/json"}
        try:
            response = requests.post(url, headers=headers, data=json.dumps(data))
            if response.status_code == 200:
                print "SMS send success"
            else:
                print "SMS send failed[%s]" % response.text
        except Exception as e:
            print "SMS send failed[%s]" % e

    def doParse(self):
        failList = []
        for line in self.__f.readlines():
            cline = line.strip()
            if cline.startswith(">") == False:
                continue
            list = cline.split("|")
            if len(list) == 3:
                apiName = list[0]
                testState = list[1].strip()
                if cmp(testState, "FAIL") == 0:
                    name = apiName.split("(")[0][1:]
                    failList.append(name)
        return failList

if __name__ == "__main__":
    parser = RFParser()
    parser.setup()
