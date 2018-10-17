#!/usr/bin/python
#-*-coding:utf-8 -*-

__author__ = 'leo'

from os.path import dirname
import os.path
import tempfile
import os, sys,inspect
import platform
import stat
import shutil

path = dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
path = os.path.abspath(path + '/SendReport')
metricspath = os.path.abspath(path + '../../')
parentpath = os.path.abspath(path + '../../../')
sys.path.append(os.path.realpath(path))
reload(sys)
sys.setdefaultencoding('utf-8')

from Sender import Sender


class MyListener(object):
    ROBOT_LISTENER_API_VERSION = 2

    def __init__(self,receive=[],outpath='reportLog\emailreport.html',url='',username='',password='',status=''):
        # 打开并创建文件，写入html数据
        self.ROBOT_LIBRARY_LISTENER = self
        self.outpath = outpath
        self.pass_count = 0
        self.fail_count = 0
        self.skip_count = 0
        self.error_count = 0
        self.total_count = 0
        self.receive = receive
        self.url = url
        self.username = username
        self.password = password
        self.status = status
        
        # 创建报告、填写报告路径
        self.before_start_table(self.outpath,'emailreport.html')
        
        # 拼接AgentRes文件路径
        self.agentRes = parentpath + '\AgentRes.robot'
        self.papath=self.agentRes.replace("\\", "/")
        
        print 'self.receive: %s' % self.receive

    def end_test(self, name, attrs):
        if attrs['status'] == 'PASS':
            self.pass_count = self.pass_count + 1
        else:
            self.fail_count = self.fail_count + 1
        self.total_count = self.total_count + 1

        self.write_testcase(name, attrs)

    def start_suite(self, name, attrs):
        self.outfile.write('<tr>\n')
        self.outfile.write('<td colspan="4"><b>'+bytes(attrs['longname'])+'</b></td>\n')
        self.outfile.write('</tr>\n')

    # def start_test(self, name, attrs):

    # def end_suite(self, name, attrs):
    #     message = attrs['message']
    #     if message != '':
    #         self.outfile.write('<tr>\n')
    #         self.outfile.write('<td colspan="4"><b>'+bytes(attrs['longname'])+'</b></td>\n')
    #         self.outfile.write('</tr>\n')
    #         self.outfile.write('<tr>\n')
    #         self.outfile.write('<td ><b><span style="font-size:10px;color:#FF3333">错误描述:</span></b></td>\n')
    #         self.outfile.write('<td colspan="1"><span style="font-size:10px;color:#FF3333">'+message+'</span></td>\n')
    #         self.outfile.write('</tr>\n')

    def close(self):
        # 用例总数和通过总数
        totalcount = float(self.total_count)
        passcount = float(self.pass_count)
        # 通过率
        percent = "0.0"
        print passcount
        if str(passcount) == "0.0":
            percent = "0.00%"
        else:
            percent = "%.2f%%" % (passcount / totalcount*100)
        self.write_table(self.total_count,self.pass_count,self.fail_count,percent)
        self.outfile.close()
        
        # 获取汇总报告的文件名称和当前路径
        collectionLogName=os.path.basename(self.outpath)
        collectionLogDirPath=os.path.dirname(self.outpath)
        # 调用robotmetrics脚本
        metricsPath=metricspath.replace("\\", "/")
        metricsPy = metricsPath + '/robotmetrics.py ' + '-inputpath ' + collectionLogDirPath + '  -receiver '+ self.receive + ' -collectionLogName ' + collectionLogName
        print metricsPy
        os.system("python " + metricsPy)
        
        # 发送html的邮件
        s = Sender()
        htmlf=open(self.outpath,'r')
        htmlcont=htmlf.read()
        s.sendReportMail('客服项目自动化测试结果', htmlcont, self.receive,self.outpath)

    def before_start_table(self,outpath,reportname):
        # 拼接emailreport报告路径
        print 'report before value: %s' % outpath
        if os.path.isdir(outpath):
            outpath = outpath + '\\' + reportname
            outpath=outpath.replace("\\", "/")
            print 'isdir: %s'  %outpath
        else:
            outpath = os.path.abspath(outpath)
            print 'absolute outpath: %s'  %outpath
            outpath=outpath.replace("\\", "/")
            print 'report after value: %s'  %outpath
         
        # 定义将输出报告
        self.outpath = outpath
        # 给文件夹赋权限
#         self.chmod_file(self.outpath)

        # 预先删除目录下所有的html格式的文件
        self.del_report_file(outpath)
        
        # 创建报告
        self.outfile = open(self.outpath, 'w')
        self.outfile.write('<html>\n')
        self.outfile.write('<head>\n')
        self.outfile.write('<title>客服项目自动化</title>\n')
        self.outfile.write('<meta charset="UTF-8" />\n')
        
        js = """
        <link rel="stylesheet" type="text/css" href="http://lijipeng.top/rest/autotest/main.css">
        <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
        <script type="text/javascript" src="http://lijipeng.top/rest/js/jquery-1.12.1.min.js"></script>
        <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
        <script type="text/javascript" src="http://lijipeng.top/rest/js/bootstrap.js"></script>
        <script type="text/javascript" src="http://lijipeng.top/rest/autotest/script.js"></script>
        <script type="text/javascript" src='http://kefu.easemob.com/webim/easemob.js'></script>
        <script type="text/javascript" src="http://lijipeng.top/rest/autotest/hp.js" ></script>
        
        """
        
        self.outfile.write(js+'\n')
        self.outfile.write('</head>\n')
        self.outfile.write('<div style="width:100%;float:left">\n')
        self.outfile.write('<table cellspacing="0" cellpadding="4" border="1" align="left" style="table-layout: fixed;word-break: break-word;">\n')

    def write_table(self,total_count,passcount,failcount,passpercent):
        # 获取登录地址
        url=self.url
        if ':' not in url:
            url = 'http:' + url
        
        # 获取登录客服信息
        username=self.username
        password=self.password
        status=self.status
        
        self.outfile.write('<thead>\n')
        self.outfile.write('<tr bgcolor="chartreuse">\n')
        self.outfile.write('<td style="text-align:center" colspan="4"><b>如若查看详细日志，请手动下载附件到本地，打开metrics.html文件</b></td>\n')
        self.outfile.write('</tr>\n')
        
        self.outfile.write('<tr bgcolor="#F3F3F3">\n')
        self.outfile.write('<td style="text-align:center" colspan="4"><b>客服自动化测试汇总报告</b></td>\n')
        self.outfile.write('</tr>\n')
        
        self.outfile.write('<tr bgcolor="#F3F3F3">\n')
        self.outfile.write('<td style="width:80px"><b>客服环境地址</b></td>\n')
        self.outfile.write('<td style="width:80px"><b>登录账号</b></td>\n')
        self.outfile.write('<td style="width:60px"><b>登录密码</b></td>\n')
        self.outfile.write('<td style="width:60px"><b>登录状态</b></td>\n')
        self.outfile.write('</tr>\n')
        self.outfile.write('<tr>\n')
        self.outfile.write('<td>'+bytes(url)+'</td>\n')
        self.outfile.write('<td>'+bytes(username)+'</span></td>\n')
        self.outfile.write('<td>'+bytes(password)+'</span></td>\n')
        self.outfile.write('<td>'+bytes(status)+'</span></td>\n')
        self.outfile.write('</tr>\n')
        
        self.outfile.write('<tr bgcolor="#F3F3F3">\n')
        self.outfile.write('<td style="width:80px"><b>用例总数</b></td>\n')
        self.outfile.write('<td><b>通过</b></td>\n')
        self.outfile.write('<td style="width:60px"><b>不通过</b></td>\n')
        self.outfile.write('<td style="width:100px"><b>通过率</b></td>\n')
        self.outfile.write('</tr>\n')
        self.outfile.write('<tr>\n')
        self.outfile.write('<td>'+bytes(total_count)+'</td>\n')
        self.outfile.write('<td><b><span style="color:#66CC00">'+bytes(passcount)+'</span></b></td>\n')
        self.outfile.write('<td><b><span style="color:#FF3333">'+bytes(failcount)+'</span></b></td>\n')
        self.outfile.write('<td>'+bytes(passpercent)+'</td>\n')
        self.outfile.write('</tr>\n')
        
        self.outfile.write('<tr bgcolor="#F3F3F3">\n')
        self.outfile.write('<td><b>用例名称</b></td>\n')
        self.outfile.write('<td><b>用例描述</b></td>\n')
        self.outfile.write('<td><b>用例状态</b></td>\n')
        self.outfile.write('<td><b>耗时</b></td>\n')
        self.outfile.write('</tr>\n')
        self.outfile.write('</table>')
        self.outfile.write('<hr size="2" width="100%" align="center" />\n')
        self.outfile.write('</div>\n')
        
#         self.write_cebianlan()
        
        self.outfile.write('</body>\n')
        self.outfile.write('</html> \n')

    def testcase_info(self,name, attrs):
        self.outfile.write("name - %s  " % name)
        self.outfile.write("<br>")
        self.outfile.write("id - %s  " % attrs['id'])
        self.outfile.write("<br>")
        self.outfile.write("longname - %s " % attrs['longname'])
        self.outfile.write("<br>")
        self.outfile.write("doc - %s " % attrs['doc'])
        self.outfile.write("<br>")
        self.outfile.write("critical - %s " % attrs['critical'])
        self.outfile.write("<br>")
        self.outfile.write("starttime - %s " % attrs['starttime'])
        self.outfile.write("<br>")
        self.outfile.write("endtime - %s " %  attrs['endtime'])
        self.outfile.write("<br>")
        self.outfile.write("elapsedtime - %s " % attrs['elapsedtime'])
        self.outfile.write("<br>")
        self.outfile.write("status - %s " % attrs['status'])
        self.outfile.write("<br>")
        self.outfile.write("message - %s " % attrs['message'])
        self.outfile.write("<br>")

    def write_testcase(self,name, attrs):
        self.outfile.write('<tr>\n')
        self.outfile.write('<td colspan="2">'+name+'</td>\n')
        if attrs['status'] == 'PASS':
            self.outfile.write('<td><b><span style="color:#66CC00">'+attrs['status']+'</span></b></td>\n')
        else:
            self.outfile.write('<td><b><span style="color:#FF3333">'+attrs['status']+'</span></b></td>\n')
        elapsedtime = self.msformat(attrs['elapsedtime'])
        self.outfile.write('<td>'+elapsedtime+'</td>\n')
        self.outfile.write('</tr>\n')

        # message = attrs['message']
        # if message != '':
        #     self.outfile.write('<tr>\n')
        #     self.outfile.write('<td ><b><span style="font-size:10px;color:#FF3333">错误描述:</span></b></td>\n')
        #
        #     doc = attrs['doc']
        #     doc = doc.encode("utf-8")
        #     if "【" in doc:
        #         doc = doc.replace('【','<br>【')
        #         doc = doc.replace('- Step','<br> &nbsp;&nbsp; - Step')
        #         self.outfile.write('<td colspan="1"><span style="font-size:10px">'+doc+'</span></td>\n')
        #     else:
        #         self.outfile.write('<td colspan="1"><span style="font-size:10px">'+doc+'</span></td>\n')
        #
        #     self.outfile.write('<td colspan="1"><span style="font-size:10px;color:#FF3333">'+message+'</span></td>\n')
        #     self.outfile.write('</tr>\n')
        #     self.outfile.write('</tbody>\n')

        message = attrs['message']
        if message != '':
            self.outfile.write('<tr>\n')
            self.outfile.write('<td colspan="2"><b><span style="font-size:10px;color:#FF3333">用例步骤:</span></b></td>\n')
            self.outfile.write('<td colspan="2"><b><span style="font-size:10px;color:#FF3333">错误描述:</span></b></td>\n')
            self.outfile.write('</tr>\n')
            self.outfile.write('<tr>\n')

            doc = attrs['doc']
            doc = doc.encode("utf-8")
            if "【" in doc:
                doc = doc.replace('【','<br>【')
                doc = doc.replace('- Step','<br> &nbsp;&nbsp; - Step')
                self.outfile.write('<td colspan="2"><span style="font-size:10px">'+doc+'</span></td>\n')
            else:
                self.outfile.write('<td colspan="2"><span style="font-size:10px">'+doc+'</span></td>\n')

            self.outfile.write('<td colspan="1"><span style="font-size:10px;color:#FF3333;width:200px;display:block;word-wrap:break-word;">'+message+'</span></td>\n')
            self.outfile.write('<td colspan="1"><span style="font-size:10px;color:#FF3333"></span></td>\n')
            self.outfile.write('</tr>\n')
            self.outfile.write('</tbody>\n')
    
    def write_cebianlan(self):
        cebianlan = """
        <ul class="cbl" >
            <li><a href="http://wpa.qq.com/msgrd?v=3&uin=260553619&site=qq&menu=yes">
                <div class="icon d1"><i class="i1"></i><span class="title">在线QQ</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="#">
                <div class="icon d2"><i class="i2"></i><span class="title">18612390240</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="http://c1.private.easemob.com/pages/viewpage.action?pageId=3847479" target='_blank'">
                <div class="icon"><i class="i3"></i><span class="title">配置文档</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="javascript:;" class="im-biz">
                <div class="icon d5"><i class="i5"></i><span class="title">在线客服</span></div>
            </a></li>
            <i class="clearfix"></i>
            <li><a href="javascript:;" class="back-top" id="back-top">
                <div class="icon d4"><i class="i6"></i><span class="title">回到顶部</span></div>
            </a></li>
        
        </ul>
        
        """
        
        self.outfile.write(cebianlan+'\n')
    
    def get_agentRes(self,papath,line):
        """
        获取文件中定义的变量以及变量值
    
        return:
        返回该变量的字典内容
        """
        # 打开并读取文件的内容
        htmlf1=open(papath,'r')
        htmlcont1=htmlf1.readlines()
        AdminUser = htmlcont1[line-1]
        adminUser = AdminUser.split()
        
        # 获取每行第一个变量内容，例如：${kefuurl}
        var_key = adminUser[0:1][0]
        # 创建字典，并将获取的内容存入字典
        adminuserDic = {}
        # 判断变量名是变量
        if '$' in var_key:
            var_key = var_key[2:]
            var_key = var_key[:-1]
            var_value = adminUser[1]
            adminuserDic[var_key] = var_value
        
        # 判断变量名是字典
        if '&' in var_key:
            # 获取列表长度
            size = len(adminUser)
            adminUserList = adminUser[1:size]
            for username in adminUserList:
                index = username.split('=')
                key = index[0]
                value = index[1]
                adminuserDic[key] = value
        return adminuserDic

    def msformat(self,iItv):
        """
        将秒数间隔转换秒+毫秒
    
        return:
        返回例如：0秒091毫秒
        """
        # 将秒数间隔转换秒+毫秒
        if type(iItv)==type(1):
            iItv = float(iItv)
            s = iItv/1000 #
            s = str(s)
            l=s.split('.')
            s=l[0]
            ms=l[1]
            if s == 0:
                return ms+'毫秒'
            return s +"秒"+ms+'毫秒'
        else:
            return "[InModuleError]:itv2time(iItv) invalid argument type"

    def chmod_file(self,outpath):
        """
        将文件赋予可操作权限
        """
        #给文件夹赋权限
        sysstr = platform.system()
        if(sysstr =="Windows"):
            os.chmod(outpath, stat.S_IWRITE)

    def del_report_file(self,output):
        """
        当前目录下所有html文件
        """
        if os.path.isdir(output):
            dirs = os.listdir(output)
            for i in dirs:               # 循环读取路径下的文件并筛选输出
                if os.path.splitext(i)[1] == ".html":  # 筛选html文件
                    print papath + '/' + i              # 输出所有的html文件
                    path = papath + '/' + i              # 输出所有的html文件
                    #删除文件夹
                    self.chmod_file(path)
                    os.remove(path)    #删除文件
                    print 'del_report_file,isdir:%s' % path
    
        if os.path.isfile(output):
            parent = os.path.abspath(output + '../..')
            dirs = os.listdir(parent)
            for i in dirs:               # 循环读取路径下的文件并筛选输出
                if os.path.splitext(i)[1] == ".html":  # 筛选html文件
                    path = parent + '\\' + i    # 输出所有的html文件
                    path=path.replace("\\", "/")
                    #删除文件夹
                    self.chmod_file(path)
                    os.remove(path)    #删除文件
                    print 'del_report_file,isfile:%s' % path


if __name__ == "__main__":
#     a = float(18)
#     b = float(14)
#     c = b / a
#     d = "%.2f%%" % (b / a*100)
#     print d
#         papath = 'C:/Users/leo/git/kefu-auto-test/kefuapi-test'
#         s = MyListener([],'C:/Users/leo/git/kefu-auto-test/kefuapi-test')
#         s.close()
#         # 获取登录地址
#         kefuurl = s.get_agentRes(papath, 2)
#         print kefuurl
#         print kefuurl['kefuurl']
#         # 获取登录账号信息
#         agent = s.get_agentRes(papath, 4)
#         print agent
#         print agent['username']
#         print s.msformat(1996)
#         s.del_report_file(papath)
        
        url = "https://sandbox.kefu.easemob.com"
        
        if ':' not in url:
            url = 'http:' + url
        
        print url
    