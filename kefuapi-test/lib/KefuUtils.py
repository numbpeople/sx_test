# -*- coding=utf-8 -*-
import hashlib
import hmac
import base64
import datetime
import json
import os
import platform
import stat
import shutil

class JSON2Object:
   def __init__(self, d):
     self.__dict__ = d

def JsonLoadsObj(str):
    tobj = json.loads(str,object_hook=JSON2Object)
    return tobj

def JsonDumpsObj(obj):
    tstr = json.dumps(obj,default=lambda o: o.__dict__)
    return tstr

def GenerateRestSignature(secret, path, content,expires='-1',verb='POST'):
    m = hashlib.md5()
    m.update(content)

    msg = bytes(verb+"\n"+path+"\n"+expires+"\n"+m.hexdigest()).encode('utf-8')
    s = bytes(secret).encode('utf-8')

    return base64.b64encode(hmac.new(s, msg, digestmod=hashlib.sha256).digest())
   
def Get_Week(vdate_str):
    """
    对指定日期返回本周的开始与结束日期

    param:
    date:当前日期->'2017-12-14'

    return:
    返回结果元组('2017-12-10', '2017-12-16')
    """
    vdate = datetime.datetime.strptime(vdate_str, '%Y-%m-%d').date()
    dayscount = datetime.timedelta(days=vdate.isoweekday())
    dayfrom = vdate - dayscount
    dayto = vdate - dayscount + datetime.timedelta(days=6)

    return str(dayfrom),str(dayto)

def Get_Last_Month():
    """
    返回上月的开始与结束日期

    return:
    返回结果元组('2017-11-01', '2017-11-30')
    """

    #上一个月的第一天
    # lst_fist = datetime.date(datetime.date.today().year,datetime.date.today().month-1,1)
    lst_fist = (datetime.date.today().replace(day=1) - datetime.timedelta(1)).replace(day=1)

    #上一个月的最后一天
    lst_last = datetime.date(datetime.date.today().year,datetime.date.today().month,1)-datetime.timedelta(1)
    return str(lst_fist),str(lst_last)

def is_float(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

def del_files(path):
    print 'start del files in path:' + path
    ls = os.listdir(path)
    for i in ls:
        c_path = os.path.join(path, i)
#         c_path = r'%s' % c_path
#         c_path = c_path.encode('unicode-escape').decode('string_escape')  
        c_path = c_path.decode('utf-8').decode('utf-8') 
        c_path = c_path.replace('\\', '/')
        print c_path
        if os.path.isdir(c_path):
            del_file(c_path)
            print 'del_file' + c_path
            c_path.close()
        else:
            os.remove(c_path)
            print 'remove' + c_path
#             c_path.close()
    print 'finish del files in path:' + path

def mkdir(path):
    # 判断路径是否存在
    # 存在     True
    # 不存在   False
    isExists=os.path.exists(path)
 
    # 判断结果
    if not isExists:
        # 如果不存在则创建目录
        # 创建目录操作函数
        os.makedirs(path) 
        print path+' 创建成功'
        return True
    else:
        # 如果目录存在则不创建，并提示目录已存在
        print path+' 目录已存在'
        return False

def find_folder_path(path,folderName):
    sysstr = platform.system()
    print sysstr
#     if(sysstr =="Windows"):
#         print '使用了Windows系统执行测试用例'
#         path=os.path.abspath(os.path.dirname(path)+os.path.sep+".."+os.path.sep+"..")
#     else:
#         path=os.path.abspath(os.path.dirname(path)+os.path.sep+".."+os.path.sep+"..")
    #找到指定文件夹的路径值
    path=os.path.abspath(os.path.dirname(path)+os.path.sep+".."+os.path.sep+"..")
    path=path+'\\'+folderName
    path=path.replace("\\", "/")  
    #创建该文件夹,判断当前是否存在，不存在则创建
    mkdir(path)
    return path

def del_files(path):
    #删除文件
    #path=find_folder_path(folderName)
    #给文件夹赋权限
    sysstr = platform.system()
    print sysstr
    if(sysstr =="Windows"):
        print ("使用Windows自动化测试,把目录赋权限")
        os.chmod(path, stat.S_IWRITE)
    #删除文件夹
    shutil.rmtree(path)

if __name__ == '__main__':
    # vdate_str = '2017-12-14'
    # print Get_Week(vdate_str)
    # print Get_Last_Month()
    # print JsonLoads2Obj('{"listData":[1,2,3],"strData":"test python obj 2 json","i":{"tt":"111"}}').i.tt
#     a = 'leoli@easemob.com'
#     b = '1313.13'
#     c = "客服昵称"
#     d = 0.0
#     print is_float(d)
    mkdir('C:/Users/leo/git/kefu-auto-test/kefuapi-test/tempdata')
