#coding=utf-8
#from selenium.webdriver.chrome.webdriver import WebDriver
from selenium.webdriver.common.action_chains import ActionChains
import time
import os
import json
import requests
from selenium import webdriver
import smtplib
from email.mime.text import MIMEText
from email.header import Header
import string

def sendEmail(data, rcvers = ["simon.fu@easemob.com","tianweiying@easemob.com"]):
    sender = "jalert@easemob.com"
    # rcver="#simon.fu@easemob.com, tianweiying@easemob.com"
    subject = "*rtc-test-fail-mail*"
    smtpserver = "smtp.exmail.qq.com"
    users = "jalert@easemob.com"
    pswd = "doxcgBigqGAsg89efWJk"
    text = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    msg = MIMEText(data + text + "音视频没接通,失败了,请查看。。。", "plain", "utf-8")
    msg["Subject"] = Header(subject, "utf-8")
    msg["to"] = ','.join(rcvers)
    msg["from"] = "rtc-test"

    smtp = smtplib.SMTP()
    smtp.connect(smtpserver)
    smtp.login(users, pswd)
    smtp.sendmail(sender, rcvers, msg.as_string())
    smtp.quit()


def start_webdriver():
    print "open url...."
    global dr
    dr = webdriver.Chrome("/Users/easemob/Downloads/chromedriver")  # 找chromedriver
    dr.implicitly_wait(15)
    dr.set_script_timeout(5)
    dr.set_page_load_timeout(5)
    #dr.get("https://localhost:9443/")
    dr.get("https://turn2.easemob.com/simonweb/peer-http/")
def check_audio_page():
    audio_page = dr.find_elements_by_id("localVideo")
    if len(audio_page)!=0:
        return True
    else:
        print "url open failed..."
        sendEmail(data="url open failed..")
        raise


def start():
    if check_audio_page() ==True:
        print "calling..."
        time.sleep(3)
        start = dr.find_element_by_id("joinButton")

        start.click()
        time.sleep(10)
        data = dr.find_elements_by_id("recvInfo")
        #print len(data)
        datas = str(data[0].text)
        #print datas
        if len(data) !=0 and len(datas)!=0:
            #print len(datas)
            print "call infromation:---->\n",datas
            print "*haha....call success!*"
        else:
            print "call fial..."
            datas= "call fail."
            sendEmail(datas)
            raise
        end = dr.find_element_by_id("exitButton")
        end.click()
        print "-call end!-"

def test_call():
    a=1
    i = "b"
    #i = raw_input("please inter the number of call:\n")
    #while a<=int(i):
    while a <= i:
        print "-----",a,"-----"
        start()
        a+=1
    dr.close()


start_webdriver()
test_call()

