#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
kefuapi-ci 运行失败，短信报警和邮件通知等等
'''
import requests
import time
import hashlib
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from settings import Alarm_Email_Auth,  Alarm_SMS_Auth

import os, sys,inspect
from os.path import dirname
path = dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
sys.path.append(os.path.realpath('%s/..' % path))
reload(sys)
sys.setdefaultencoding('utf-8')

PhoneEmailNumber = {
        # u"戚俊琦": ("13341091983", "timo@easemob.com"),
        # u"张劲": ("15901460469", "zhangjin@easemob.com"),
        # u"邹晟": ("15801177971", "zousheng@easemob.com"),
        # u"尹亚兰": ("18201535234", "yinyl@easemob.com"),
        # u"王燕杰": ("13810738749", "wangyj@easemob.com"),
        # u"赵豫峰": ("15501211525", "zhaoyf@easemob.com"),
        # u"贾延超": ("18515332102", "jiayc@easemob.com"),
        # u"孙炎": ("18515550772", "sunyan@easemob.com"),
        # u"陈李玮": ("18611702718", "chenlw@easemob.com"),
        # u"李必胜": ("18710150110", "libisheng@easemob.com"),
        u"李继鹏": ("18612390240", "leoli@easemob.com"),
}


# QA_TEAM = [u"戚俊琦",u"张劲",u"邹晟", u"李必胜", u"尹亚兰", u"王燕杰", u"赵豫峰", u"孙炎", u"陈李玮", u"贾延超"]
# OP_TEAM = [u"戚俊琦",u"张劲",u"邹晟", u"李必胜", u"尹亚兰", u"王燕杰", u"赵豫峰", u"孙炎", u"陈李玮", u"贾延超"]

QA_TEAM = [u"李必胜",u"李继鹏"]
OP_TEAM = [u"李必胜"]


class SMS_EMAIL_Receiver:
    # 客服组所有人, 前置重要接受人
    kefu =  [k for k, v in PhoneEmailNumber.items()]

    # 测试工程师接收
    qa = QA_TEAM

    #调试
    admin = QA_TEAM
    tools = QA_TEAM
    debug = QA_TEAM


class Sender(object):
    def __init__ (self, predefined_recv='admin'):
        self.recv = None
        if predefined_recv is not None:
            self.buildRecvList(predefined_recv)

    def predefine(self,predefined_recv='admin'):
        self.recv = None
        if predefined_recv is not None:
            self.buildRecvList(predefined_recv)

    def buildRecvList(self, typ):
        # 预置接收，阻止ci_executor实际执行过程中的制定类型
        if self.recv is not None: return

        self.recv = {'sms': [],'email': []}
        receivers = getattr(SMS_EMAIL_Receiver, typ)
        for k, val in PhoneEmailNumber.items():
            if k in receivers:
                self.recv['sms'].append(val[0])
                self.recv['email'].append(val[1])
        print self.recv

    def getTimeStr(self):
        return time.strftime("%H:%M", time.localtime(time.time()))

    def send_sms(self, desc):
        # send by baidu api
        APP_ID=Alarm_SMS_Auth[0]
        TOKEN=Alarm_SMS_Auth[1]
        USER_ID="0"
        text = "Kefuapi_ci test failed, Detail: %s %s [Easemob KeFu System]" % (desc, self.getTimeStr())
        for rev in self.recv['sms']:
            if rev == '':
                continue
            DATA= '[{channel : "sms", description : "%s",receiver : "%s",business : "false"}]' % \
                  (text, rev)
            INPUT= '%s%s%s' % (TOKEN, APP_ID, DATA)
            SIGNATURE = hashlib.md5(INPUT).digest()
            header = {"appid": APP_ID, "token": TOKEN, "userid": USER_ID, "signature": SIGNATURE}
            resp = requests.post('http://gaojing.baidu.com/AlertList/push', data=DATA, headers=header)
            # retry for 400 error
            for r in range(2):
                if resp.status_code == 200:
                    print ('sent out sms to %s' % rev)
                    break
                else:
                    print ('sms to %s failed, resp:%s.' % (rev, resp.status_code))
            time.sleep(5)

    def send_email(self, ci, build, errorcode, logs):
        # logs to show
        to = self.recv['email']
        subject = '%s Build#%s failed with errorcode(E%s).' % (ci, build,errorcode)

        self.sendReportMail(subject, logs, to)

    def sendReportMail(self, sub, msg, to, attachment_data=None):
        """发送给指定接收人的邮件
        - 参数 sub: 邮件主题
        - 参数 msg: 邮件信息
        - 参数 to: 收件人列表
        - 返回值: True 成功, False 失败
        """
        from email.header import Header
        from email.utils import formataddr
        self.predefine('admin')

        to_list = ['<%s>' % user for user in to]
        cc_list = []
        mail_server = 'smtp.exmail.qq.com'
        mail_user = Alarm_Email_Auth[0]
        mail_pass = Alarm_Email_Auth[1]

        from_mail = mail_user
        htmlText = msg

        data = MIMEMultipart('related')
        data['Subject'] = sub
        data['From'] = formataddr((str(Header('KefuCI', 'utf-8')), from_mail))#
        data['To'] = ";".join(to_list)
        data['Cc'] = ";".join(cc_list)

        html = u"""\
            <html>
              <head>
                <style type="text/css" media="screen">
                body        { font-family: verdana, arial, helvetica, sans-serif; font-size: 12; }
                pre         { }
                </style>
              </head>
              <body>
                <p>Kefuapi_test failed, Detail:</p>
                <a class="mnav"></a>
                <p>%s</p>

              </body>
            </html>
            """

        text = htmlText.replace('\n', '<br>')
        data.attach(MIMEText(html % (text), 'html', "utf-8"))

        try:
            s = smtplib.SMTP()
            s.connect(mail_server)
            s.ehlo()
            s.starttls()
            s.ehlo()
            s.login(mail_user, mail_pass)
            s.sendmail(from_mail, to_list, data.as_string())
            s.quit()
            print('email report has been sented out: "%s", to:%s' % (sub, to))

            return True
        except Exception, e:
            print('Exception in sending out Email report. exception: \n' + str(e))

        return False


if __name__ == '__main__':
    s = Sender()
    # s.send_sms('test')
    s.sendReportMail('测试用例集：【Kefuapi-Test.Tool.Tools-Case】- -> 测试用例：【发送邮件】状态为FAIL', '1 != 2', ['leoli@easemob.com'])
