# -*- coding=utf-8 -*-
import hashlib
import hmac
import base64
import datetime

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


if __name__ == '__main__':
    vdate_str = '2017-12-14'
    print Get_Week(vdate_str)
    print Get_Last_Month()

