#coding=utf-8
#from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.action_chains import ActionChains
import time
import os
import json
import requests
from selenium import webdriver
from selenium.webdriver.common.keys import Keys #keys提供键盘操作

#启动driver
def start_webdriver():
    global dr
    dr = webdriver.Chrome("/Users/TWY-/Downloads/chromedriver")  # 找chromedriver
    dr.implicitly_wait(15)
    dr.set_script_timeout(5)
    dr.set_page_load_timeout(5)
    global dr1
    dr1 = webdriver.Chrome("/Users/TWY-/Downloads/chromedriver")
    dr1.implicitly_wait(15)
    dr1.set_script_timeout(5)
    dr1.set_page_load_timeout(5)
#打开kefu webim界面
def open_chrome_login_kefu_webim(url):
    print "打开kefu_webim浏览器。。。"
    dr.get(url)
    dr.add_cookie({'name': 'root34641', 'value': 'webim-visitor-BY3KTG4TY24PVCCJ9CE9'})
    dr.get(url)

#打开kefu界面
def open_chrome_login_kefu(url):
    print "打开kefu浏览器。。。"
    login_url= "http://kefu.easemob.com/login"
    body = {'username': 'tianwy@easemob.com','password':'111111','status':'Online'}
    login = requests.post(url=login_url,data=body)

    if login.status_code == 200:
        session = json.loads(login.text)
        token = session["token"]["value"]
    dr1.get("https://kefu.easemob.com")
    dr1.add_cookie({'name': 'SESSION', 'value': token})
    dr1.add_cookie({'name': 'tenantId', 'value': '34641'})
    dr1.add_cookie({'name': 'userId', 'value': '6b575ac0-9735-4b3e-be77-e5db78e73268'})
    dr1.get(url)
    #time.sleep(3)
        #open_chrome_login_kefu("https://kefu.easemob.com/mo/agent/webapp/center/wait")
            # dr.quit()#关闭浏览器
        # alert = dr.switch_to_alert()
        # print alert.text
        # alert.accept
#kefu webim 呼起视频
def kefu_webim_call():
    print "kefu webim calling。。。"
    time.sleep(3)
    video_button = dr.find_element_by_css_selector("#EasemobKefuWebim #em-widgetSend .em-video-invite")
    video_button.click()

    time.sleep(5)
    send_video = dr.find_elements_by_xpath("//span[@class='btn-confirm']")
    webim_call=len(send_video)
    if webim_call >=1:
        send_video[0].click()
        #time.sleep(5)
        return True
    else:
        return False
#kefu webim 接听视频
def appept_kefu_webim_call():
    print "kefu webim 接受来电,,"
    accept= dr.find_elements_by_xpath("//i[@class='btn-accept-call icon-answer']")
    webim_call= len(accept)
    if webim_call >=1:
        accept[0].click()
        return True
    else:
        return False

#kefu接听视频
def kefu_call():
    print "kefu 接受来电..."

    video = dr1.find_elements_by_xpath("//span[@class='icon icon-color']")
    video[0].click()
    accept = dr1.find_elements_by_xpath("//span[@class='ui-cmp-btn white border accept']")
    kefu_call=len(accept)
    if kefu_call >=1:
        accept[0].click()
        return True
    else:
        return False
#视频通了之后,客服 webIm 挂断视频
def hangUP_kefu_webim_call():
    calling = dr.find_elements_by_xpath("//div[@class='status']/p[@class='prompt']")
    if len(calling)==1:
        print "-----> call状态:",calling[0].text,"\n***哈哈,视频通啦........"
        time.sleep(5)
        end = dr.find_elements_by_xpath("//div[@class='toolbar-dial']/i[@class='btn-end-call icon-decline']")
        if len(end)>=1:
            end[0].click()
            print "结束通话"
            return True
    else:
        print "pelase recall!!!"
        return False

#kefu 关掉视频窗口
def close_kefu_call_page():
    video = dr1.find_elements_by_xpath("//span[@class='icon icon-color']")
    if len(video)==1:
        video[0].click()
        print "kefu call page close.."
        return True
    else:
        print "no call page"
        return False

#多次呼叫视频
def call(url1,url2):
    print "----test:kefu call----"
    start_webdriver()
    open_chrome_login_kefu(url2)
    open_chrome_login_kefu_webim(url1)
    a = 1
    while a <= 2:
        print "*********循环次数:",a,"***********"
        if kefu_webim_call()==True:
            time.sleep(1)
            if kefu_call()==True:
                time.sleep(1)
                if appept_kefu_webim_call()==True:
                    time.sleep(1)
                    if hangUP_kefu_webim_call()==True:
                        time.sleep(1)
                        close_kefu_call_page()
        a+=1
    dr.quit()
    print "关闭kefu webIM浏览器"
    dr1.quit()
    print "关闭kefu 浏览器"
    print "-----test over!------"



########################## 执行case:

# start_webdriver()
# open_chrome_login_kefu("https://kefu.easemob.com/mo/agent/webapp/sessions/chat")
# open_chrome_login_kefu_webim("https://kefu.easemob.com/webim/im.html?tenantId=34641")
# kefu_webim_call()
# kefu_call()
# appept_kefu_webim_call()
# hangUP_kefu_webim_call()


call("https://kefu.easemob.com/webim/im.html?tenantId=34641","https://kefu.easemob.com/mo/agent/webapp/center/wait")




