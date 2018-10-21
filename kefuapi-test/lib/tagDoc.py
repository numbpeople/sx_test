#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
    该脚本为自动生成客服自动化测试用例集、测试用例、测试标签等信息

执行前注意
    1、output.xml为报告执行完毕后的文件地址：C:/Users/leo/Desktop/output.xml
    2、在TestMetrics类，visit_test方法中，可以看到获取测试用例详细信息
    3、main中open地址为生成报告的地址：C:/Users/leo/Desktop/tag.html

"""

import sys
reload(sys)
sys.setdefaultencoding("utf-8")
# Test Metrics Code: (save following snippet as python file and execute)
from robot.api import ExecutionResult,ResultVisitor

result = ExecutionResult('C:/Users/leo/Desktop/output.xml')
result.configure(stat_config={'suite_stat_level': 2,
                              'tag_stat_combine': 'tagANDanother'})


class TagTable(object):
    def __init__(self,outfile):
        self.outfile = outfile
    
    def write_tag_data(self):
        # 创建报告
        self.write_head() 
        result.visit(TestMetrics(outfile))
    
    def write_head(self):
        self.outfile.write('<html>\n')
        self.outfile.write('<head>\n')
        self.outfile.write('<title>客服自动化标签</title>\n')
        self.outfile.write('<meta charset="UTF-8" />\n')
        self.outfile.write('<link rel="icon" type="image/x-icon" href="data:image/x-icon;base64,AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAAAIAAAAAAAAAAAAAEAAAAAAAAAAAAAAAJEBoACtnfgA5cYYAERsiAEx2lAAbKkQAcazBACZCVwAcM1cAK0ucAAMDBQAnQncASG+FABkoVQAyWmgA6f8SgvH/Ij99+GLyIinyJfn/Yi//KSLzUy9iZogpIld3/4JVVTkid7vyUjNVNVJEAGOZ6Z7pXwAABpmZkRiLAAAGiJZpmGAAAEEt3SXdxAAATC7o/u3EAAC8MRZpjasAAAY1VVVTYAAABKqqqqpAAAAADKqq4AAAAAAAv4sAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMADAADgAwAA4AcAAOAHAADgBwAAwAcAAOAHAADgDwAA8A8AAPg/AAD+fwAA">\n')
        self.outfile.write('</head>\n')
        self.outfile.write('<div style="width:100%;float:left">\n')
        self.outfile.write('<table cellspacing="0" cellpadding="4" border="1" align="left" style="table-layout: fixed;word-break: break-word;">\n')
        
        self.outfile.write('<tr>\n')
        self.outfile.write('<td style="text-align:center" colspan="4"><h2>客服自动化测试标签</h2></td>\n')
        self.outfile.write('</tr>\n')

        self.outfile.write('<tr>\n')
        self.outfile.write('<td><h3>测试用例集/测试用例名称</h3></td>\n')
        self.outfile.write('<td><h3>标签名称</h3></td>\n')
        self.outfile.write('</tr>\n')

    def write_table(self):
        self.outfile.write('</table>')
        self.outfile.write('</div>\n')
        self.outfile.write('</html> \n')

class TestMetrics(ResultVisitor):
    def __init__(self,outfile):
        self.outfile = outfile

    def visit_test(self,test):
        print "Test Suite: " + str(test.parent) 
        print "Test Name: " + str(test.name) 
        print "Test Status: " + str(test.status)
        print "Test Starttime: " + str(test.starttime)
        print "Test Endtime: " + " " + str(test.endtime)
        print "Test Elapsedtime (Sec): " + " " + str(test.elapsedtime/float(1000))
        print "Test Tags: " + " " + str(test.tags)

        self.outfile.write('<tr>\n')
        self.outfile.write('<td colspan="4"><b>'+'测试用例集: '+'</b>'+str(test.parent)+'</td>\n')
        self.outfile.write('</tr>\n')

        self.outfile.write('<tr>\n')
        self.outfile.write('<td>'+str(test.name)+'</td>\n')
        self.outfile.write('<td>'+str(test.tags)+'</td>\n')
        self.outfile.write('</tr>\n')


if __name__ == "__main__":
    outfile = open('C:/Users/leo/Desktop/tag.html', 'w')
    s=TagTable(outfile)
    s.write_tag_data()
    s.write_table()
        
