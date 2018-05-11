# -*- coding=utf-8 -*-
import csv
import xlrd
import os,stat
import sys
import pandas as pd
reload(sys)
sys.setdefaultencoding("utf-8")

class ReadFile(object):
    def read_csv_file(self, filename):
        csv_dict = csv.DictReader(open(filename))
        return csv_dict

    def xls_to_csv(self, filename, wsheet):
        wb = xlrd.open_workbook(filename)
        sh = wb.sheet_by_name(wsheet)
        curr_dir = os.getcwd()
        csvfile = curr_dir + '\\kefuapi-test\\testdata\\tmp.csv'
        a = open(csvfile, 'wb')
        wr = csv.writer(a, quoting = csv.QUOTE_ALL)
        for rownum in xrange(sh.nrows):
            print rownum
            wr.writerow(sh.row_values(rownum))
        a.close()
        return csvfile
    
    def read_xls_file(self, filename, wsheet):
        cf = self.xls_to_csv(filename, wsheet)
        xls_data = self.read_csv_file(cf)
        return xls_data
    
    def csv_to_xls_pd(self,filename, wsheet,savefilename):
        """
        将csv文件转化成xls格式文件

        param:
        filename:文件地址，例如：C:/Users/leo/Desktop/accountInfo.csv
        wsheet：位于哪个工作表，例如：account
        savefilename：格式转化后保存的路径：C:/Users/leo/Desktop/accountInfo.xls

        """
        print 'transfer format start'
        csv = pd.read_csv(filename, encoding='GB2312')
        print 'read_csv end'
        csv.to_excel(savefilename, sheet_name=wsheet)
        print 'transfer format end'

    def xlsx_to_xls(self,filename,savefilename):
        """
        将xlsx文件转化为xls文件

        param:
        filename:文件地址，例如：C:/Users/leo/Desktop/accountInfo.xlsx
        wsheet：位于哪个工作表，例如：account
        savefilename：格式转化后保存的路径：C:/Users/leo/Desktop/accountInfo.xls

        """
        x = pd.read_excel(filename)
        x.to_excel(savefilename, index=False)
    
    def save_file(self,filename,result):
        """
        保存文件到本地目录

        param:
        filename:文件地址，例如：C:/Users/leo/Desktop/accountInfo.csv
        result：请求后的文本值

        """
        print "save file start"
        with open(filename, "wb") as code:
           code.write(result)
        code.close()
        print "save file end"

    def format_code(self,s):
        """
        保存文件到本地目录

        param:
        s:编码后的字符，例如：\xe4\xbc\x9a\xe8\xaf\x9dID

        """
        print "format_code start"
        s.decode('utf-8')
        str=(s.decode('utf-8'))
        print "format_code end"
        return  str

if __name__ == '__main__':
        a = ReadFile()
        print a.format_code('\xe4\xbc\x9a\xe8\xaf\x9d')