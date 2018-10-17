#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
kefuapi-ci 运行失败，短信报警和邮件通知等等
'''
import requests
import time
import hashlib
import smtplib
from smtplib import SMTP_SSL
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from settings import Alarm_Email_Auth,  Alarm_SMS_Auth

import os, sys,inspect
from os.path import dirname
import string
import tarfile
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
#         u"李继鹏": ("18612390240", "leoli@easemob.com"),
#         u"李继鹏": ("18612390240", "260553619@qq.com"),
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
#         print self.recv
#         print 'self.recv: %s' % self.recv

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
        - 参数 attachment_data: 附件地址
        - 返回值: True 成功, False 失败
        """
        from email.header import Header
        from email.utils import formataddr
#         print 'to: %s' % to

        # 判断参数为unicode类型，则转换为list
        if isinstance(to, unicode):
            to = to.encode('utf-8')
#             to = to[0:]
#             to = to[:-1]
            to = to.split(",") 
        
        # 转化为[<'leoli@easemob.com'>, <'260553619@qq.com'>] 格式
        to_list = ['<%s>' % user for user in to]
        print 'to_list: %s' % to_list
        cc_list = []
        mail_user = Alarm_Email_Auth[0]
        mail_pass = Alarm_Email_Auth[1]
        mail_server = Alarm_Email_Auth[2]
        port = Alarm_Email_Auth[3]

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
                <p>Kefuapi-test result, Detail:</p>
                <a class="mnav"></a>
                <p>%s</p>

              </body>
            </html>
            """

        text = htmlText.replace('\n', '<br>')
#         data.attach(MIMEText(html % (text), 'html', "utf-8"))
        data.attach(MIMEText(msg, 'html', "utf-8"))
        # 构造附件1，传送当前目录下的 test.txt 文件
        
        # 判断传入参数是路径或者文件。如果是文件则取当前目录下所有html文件作为附件
#         if os.path.isdir(attachment_data):
#             dirs = os.listdir(attachment_data)
#             for i in dirs:               # 循环读取路径下的文件并筛选输出
#                 if os.path.splitext(i)[1] == ".html":  # 筛选html文件
#                     print papath + '/' + i              # 输出所有的html文件
#                     path = papath + '/' + i              # 输出所有的html文件
#                     att1 = MIMEText(open(path, 'rb').read(), 'base64', 'utf-8')
#                     att1["Content-Type"] = 'application/octet-stream'
#                     # 这里的filename可以任意写，写什么名字，邮件中显示什么名字
#                     att1["Content-Disposition"] = 'attachment; filename='+i+''
#                     data.attach(att1)
#     
#         if os.path.isfile(attachment_data):
#             parent = os.path.abspath(attachment_data + '../..')
#             dirs = os.listdir(parent)
#             for i in dirs:               # 循环读取路径下的文件并筛选输出
#                 if os.path.splitext(i)[1] == ".html":  # 筛选html文件
#                     path = parent + '/' + i    # 输出所有的html文件
#                     path=path.replace("\\", "/")
#                     att1 = MIMEText(open(path, 'rb').read(), 'base64', 'utf-8')
#                     att1["Content-Type"] = 'application/octet-stream'
#                     # 这里的filename可以任意写，写什么名字，邮件中显示什么名字
#                     att1["Content-Disposition"] = 'attachment; filename='+i+''
#                     data.attach(att1)
        
        reportpath = os.path.abspath(attachment_data + '../..')
        self.make_targz(reportpath+"/report.tar.gz",reportpath)
        att1 = MIMEText(open(reportpath+"/report.tar.gz", 'rb').read(), 'base64', 'utf-8')
        # 这里的filename可以任意写，写什么名字，邮件中显示什么名字
        att1["Content-Disposition"] = 'attachment; filename="客服自动化测试报告.tar"'
        data.attach(att1)
        
        try:
            if port == '465':
                print 'use 465 port'
                s = smtplib.SMTP_SSL(mail_server,port)
                #s.set_debuglevel(1)
            else:
                print 'use 25 port'
                s = smtplib.SMTP()
                s.connect(mail_server,port)
                s.ehlo()
                s.starttls()
                s.ehlo()
            s.login(mail_user, mail_pass)
            s.sendmail(from_mail, to_list, data.as_string())
            s.quit()
            print('email report has been sented out to:%s' % to_list)

            return True
        except Exception, e:
            print('Exception in sending out Email report. exception: \n' + str(e))

        return False

    # 将输出的log文件打包
    def make_targz(self,output_filename, source_dir):
        tar = tarfile.open(output_filename,"w:gz")
        for root,dir,files in os.walk(source_dir):
            root_ = os.path.relpath(root,start=source_dir)
            #tar.add(root,arcname=root_)
            for file in files:
                if file.split('.')[1] == "html":  # 筛选html文件
                    full_path = os.path.join(root,file)
                    tar.add(full_path,arcname=os.path.join(root_,file))
        tar.close()


if __name__ == '__main__':
    s = Sender()
    # s.send_sms('test')
    recieve = u"leoli@easemob.com"
#     recieve = ['leoli@easemob.com','260553619@qq.com']
#     recieve = []
    s.sendReportMail('测试用例集：【Kefuapi-Test.Tool.Tools-Case】- -> 测试用例：【发送邮件】状态为FAIL', '1 != 2', recieve,'C:\Users\leo\git\kefu-auto-test\kefuapi-test\log\emailreport.html')
