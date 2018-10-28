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

#     def start_suite(self, name, attrs):
#         self.outfile.write('<tr>\n')
#         self.outfile.write('<td colspan="1"><b>'+bytes(attrs['longname'])+'</b></td>\n')
#         self.outfile.write('</tr>\n')

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
        if str(passcount) == "0.0":
            percent = "0.00%"
        else:
            percent = "%.2f%%" % (passcount / totalcount*100)
        self.write_table(self.total_count,self.pass_count,self.fail_count,percent)
        self.outfile.close()

        # 处理接收人邮件账号
        email_receive=self.get_email(self.receive)
        print 'email_receive value is: '+email_receive

        # 获取汇总报告的文件名称和当前路径
        collectionLogName=os.path.basename(self.outpath)
        collectionLogDirPath=os.path.dirname(self.outpath)

        # 调用robotmetrics脚本
        metricsPath=metricspath.replace("\\", "/")
        metricsPy = metricsPath + '/robotmetrics.py ' + '-inputpath ' + collectionLogDirPath + '  -receiver '+ email_receive + ' -collectionLogName ' + collectionLogName
        print 'robotmetrics dir log: '+metricsPy
        os.system("python " + metricsPy)

        # 发送html的邮件
        s = Sender()
        htmlf=open(self.outpath,'r')
        htmlcont=htmlf.read()
        s.sendReportMail('客服项目自动化测试结果', htmlcont, self.receive,self.outpath)
        htmlf.close()

        #删除本地日志输入文件夹
        print 'start del log folder'
        self.del_folder(collectionLogDirPath)
        print 'end del log folder'

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
        <link rel="shortcut icon" href="https://png.icons8.com/windows/50/000000/bot.png" type="image/x-icon" />
        <link rel="stylesheet" type="text/css" href="http://netdna.bootstrapcdn.com/bootstrap/3.0.3/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="http://cdn.datatables.net/plug-ins/28e7751dbec/integration/bootstrap/3/dataTables.bootstrap.css">

        <script type="text/javascript" language="javascript" src="http://code.jquery.com/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="http://cdn.datatables.net/1.10-dev/js/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="http://cdn.datatables.net/plug-ins/28e7751dbec/integration/bootstrap/3/dataTables.bootstrap.js"></script>

        <script src="http://lijipeng.top/rest/autotest/script.js" type="text/javascript">
        </script>
        <script src="http://kefu.easemob.com/webim/easemob.js" type="text/javascript">
        </script>
        """

        self.outfile.write(js+'\n')
        self.outfile.write('</head>\n')

        # 样式
        self.write_style()

        self.outfile.write('<body>\n')

        # 顶部添加导航栏
        self.write_layui()

        self.outfile.write('<tbody>\n')
        self.outfile.write('<table id="example" class="display" class="layui-table" cellspacing="0" cellpadding="4" border="1" align="left" style="table-layout: fixed;word-break: break-word;width: 100%;">\n')

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
        self.outfile.write('<td><b>客服环境地址</b></td>\n')
        self.outfile.write('<td><b>登录账号</b></td>\n')
        self.outfile.write('<td><b>登录密码</b></td>\n')
        self.outfile.write('<td><b>登录状态</b></td>\n')
        self.outfile.write('</tr>\n')
        self.outfile.write('<tr>\n')
        self.outfile.write('<td>'+bytes(url)+'</td>\n')
        self.outfile.write('<td>'+bytes(username)+'</td>\n')
        self.outfile.write('<td>'+bytes(password)+'</td>\n')
        self.outfile.write('<td>'+bytes(status)+'</td>\n')
        self.outfile.write('</tr>\n')
        
        self.outfile.write('<tr bgcolor="#F3F3F3">\n')
        self.outfile.write('<td><b>用例总数</b></td>\n')
        self.outfile.write('<td><b>通过</b></td>\n')
        self.outfile.write('<td><b>不通过</b></td>\n')
        self.outfile.write('<td><b>通过率</b></td>\n')
        self.outfile.write('</tr>\n')
        self.outfile.write('<tr>\n')
        self.outfile.write('<td><b><span style="color:black">'+bytes(total_count)+'</span></b></td>\n')
        self.outfile.write('<td><b><span style="color:#66CC00">'+bytes(passcount)+'</span></b></td>\n')
        self.outfile.write('<td><b><span style="color:#FF3333">'+bytes(failcount)+'</span></b></td>\n')
        self.outfile.write('<td><b><span style="color:black">'+bytes(passpercent)+'</span></b></td>\n')
        self.outfile.write('</tr>\n')
        
        self.outfile.write('<tr bgcolor="#F3F3F3">\n')
        self.outfile.write('<td><b>用例名称</b></td>\n')
        self.outfile.write('<td><b>用例描述</b></td>\n')
        self.outfile.write('<td><b>用例状态</b></td>\n')
        self.outfile.write('<td><b>错误描述</b></td>\n')
        self.outfile.write('</tr>\n')
        self.outfile.write('</thead>\n')
        self.outfile.write('</tbody>\n')
        self.outfile.write('</table>')
        self.outfile.write('<hr size="2" width="100%" align="center" />\n')
        
#         self.write_cebianlan()
        
        dataTable = """
            <script>
                $(document).ready(function() {
                    $('#example').dataTable( {
                        "fixedHeader": true,
                        "aLengthMenu": [
                            [5,10, 15, 20, -1],
                            ['每页5条', '每页10条', '每页15条', '每页20条', "全部数据"] // change per page values here
                        ],
                        "oLanguage": {
                            "oAria":{
                                "sSortAscending": " - click/return to sort ascending",
                                "sSortDescending": " - click/return to sort descending"
                            },
                            "sLengthMenu": "显示 _MENU_ 记录", 
                            "sZeroRecords": "对不起，查询不到任何相关数据", 
                            "sEmptyTable":"未有相关数据",
                            "sLoadingRecords":"正在加载数据-请等待...",
                            "sInfo": "当前显示 _START_ 到 _END_ 条，共 _TOTAL_ 条记录。", 
                            "sInfoEmpty": "当前显示0到0条，共0条记录", 
                            "sInfoFiltered": "（总共为 _MAX_ 条记录）", 
                            "sProcessing": "<img src='${pageContext.request.contextPath }/image/loading.gif'/> 正在加载数据...", 
                            "sSearch": "模糊查询：", 
                            "sUrl": "", //多语言配置文件，可将oLanguage的设置放在一个txt文件中，例：Javascript/datatable/dtCH.txt 
                            "oPaginate": { 
                                "sFirst": "第一页", 
                                "sPrevious": " 上一页 ", 
                                "sNext": " 下一页 ", 
                                "sLast": " 最后一页 "
                            } 
                        }, //多语言配置
                    
                } );
            } );
            </script> 
            <script type="text/javascript">
                // For demo to fit into DataTables site builder...
                $('#example')
                        .removeClass( 'display' )
                        .addClass('table table-striped table-bordered');
            </script>
        
        """
        
        self.outfile.write(dataTable+'\n')
        
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
        logname = "log.html"
        
        # 获取用例测试状态
        testCaseStatus = attrs['status']

        # 增加用例名称
        self.outfile.write("<td><a href="+logname+"#"+attrs['id']+" target='_blank'  style='text-decoration: underline;color: blue;'>"+name+"</a></td>\n")
        
        # 增加用例测试操作步骤
        doc = attrs['doc']
        doc = doc.encode("utf-8")
        if testCaseStatus != 'PASS':
            if ("【" in doc):
                doc = doc.replace('【','<br>【')
                doc = doc.replace('- Step','<br> &nbsp;&nbsp; - Step')
                self.outfile.write('<td><span style="font-size:10px">'+doc+'</span></td>\n')
        else:
            self.outfile.write('<td><span style="font-size:10px">测试用例通过，忽略用例描述</span></td>\n')
        
        # 增加用例执行通过状态
        if testCaseStatus == 'PASS':
            self.outfile.write('<td><b><span style="color:#66CC00">'+attrs['status']+'</span></b></td>\n')
        else:
            self.outfile.write('<td><b><span style="color:#FF3333">'+attrs['status']+'</span></b></td>\n')
        
        # 增加用例错误描述
        message = attrs['message']
        self.outfile.write('<td><span style="font-size:10px;color:#FF3333;display:block;word-wrap:break-word;">'+message+'</span></td>\n')

#         # 增加用例执行时间
#         elapsedtime = self.msformat(attrs['elapsedtime'])
#         self.outfile.write('<td>'+elapsedtime+'</td>\n')
#         self.outfile.write('</tr>\n')

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
        '''
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

            self.outfile.write('<td colspan="1"><span style="font-size:10px;color:#FF3333;display:block;word-wrap:break-word;">'+message+'</span></td>\n')
            self.outfile.write('<td colspan="1"><span style="font-size:10px;color:#FF3333"></span></td>\n')
            self.outfile.write('</tr>\n')
        '''
    
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

    def write_layui(self):
        layui = """
            <ul class="layui-nav" lay-filter="" style="position: relative;padding: 0 20px;background-color: #393D49;color: #fff;border-radius: 2px;font-size: 0;box-sizing: border-box;text-align: center;">
              <li class="layui-nav-item"><a href="http://c1.private.easemob.com/pages/viewpage.action?pageId=3848227" target="_blank">使用文档</a></li>
              <li class="layui-nav-item"><a href="http://c1.private.easemob.com/pages/viewpage.action?pageId=3848256" target="_blank">常见错误</a></li>
              <li class="layui-nav-item im-biz"><a href="javascript:;">在线客服</a></li>
              <li class="layui-nav-item"><a href="http://wpa.qq.com/msgrd?v=3&amp;uin=260553619&amp;site=qq&amp;menu=yes" target="_blank">在线QQ</a></li>
            </ul>
            <script>
            //注意：导航 依赖 element 模块，否则无法进行功能性操作
            layui.use('element', function(){
              var element = layui.element;
              
              //…
            });
            </script>
        
        """
        
        self.outfile.write(layui+'\n')

    def write_style(self):
        style = """
            <style>
        .layui-nav {
            position: relative;
            padding: 0 20px;
            background-color: #393D49;
            color: #fff;
            border-radius: 2px;
            font-size: 0;
            box-sizing: border-box
        }
        
        .layui-nav * {
            font-size: 14px
        }
        
        .layui-nav .layui-nav-item {
            position: relative;
            display: inline-block;
            *display: inline;
            *zoom:1;vertical-align: middle;
            line-height: 60px
        }
        
        .layui-nav .layui-nav-item a {
            display: block;
            padding: 0 20px;
            color: #fff;
            color: rgba(255,255,255,.7);
            transition: all .3s;
            -webkit-transition: all .3s
        }
        
        .layui-nav .layui-this:after,.layui-nav-bar,.layui-nav-tree .layui-nav-itemed:after {
            position: absolute;
            left: 0;
            top: 0;
            width: 0;
            height: 5px;
            background-color: #5FB878;
            transition: all .2s;
            -webkit-transition: all .2s
        }
        
        .layui-nav-bar {
            z-index: 1000
        }
        
        .layui-nav .layui-nav-item a:hover,.layui-nav .layui-this a {
            color: #fff
        }
        
        .layui-nav .layui-this:after {
            content: '';
            top: auto;
            bottom: 0;
            width: 100%
        }
        
        .layui-nav-img {
            width: 30px;
            height: 30px;
            margin-right: 10px;
            border-radius: 50%
        }
        
        .layui-nav .layui-nav-more {
            content: '';
            width: 0;
            height: 0;
            border-style: solid dashed dashed;
            border-color: #fff transparent transparent;
            overflow: hidden;
            cursor: pointer;
            transition: all .2s;
            -webkit-transition: all .2s;
            position: absolute;
            top: 50%;
            right: 3px;
            margin-top: -3px;
            border-width: 6px;
            border-top-color: rgba(255,255,255,.7)
        }
        
        .layui-nav .layui-nav-mored,.layui-nav-itemed>a .layui-nav-more {
            margin-top: -9px;
            border-style: dashed dashed solid;
            border-color: transparent transparent #fff
        }

        .row {
            margin-right: 0px;
            margin-left: 0px;
        }
        </style>
        
        """
        
        self.outfile.write(style+'\n')
    
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

    def get_email(self,receiver):   
        # 判断参数为unicode类型，则转换为list
        if isinstance(receiver, unicode):
            to = receiver.encode('utf-8')
            to = receiver.split(",") 
        
        # 转化为['leoli@easemob.com', '260553619@qq.com'] 格式
        to_list = ['%s' % user for user in to]
        
        # 获取邮件名前缀
        num = []
        for username in to_list:
            list = username.split('@')
            num.append(list[0])
        return ','.join(num)

    def del_folder(self,path):
        #删除文件
        #path=find_folder_path(folderName)
        #给文件夹赋权限
        sysstr = platform.system()
        if(sysstr =="Windows"):
            print ("use windows system,del log folder")
            os.chmod(path, stat.S_IWRITE)
        #删除文件夹
        print ("start use shutil.rmtree() to del folder: " + path)
        shutil.rmtree(path)
        print ("end use shutil.rmtree() to del folder" + path)

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
    