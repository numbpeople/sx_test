#!/usr/bin/python
#-*-coding:utf-8 -*-
from selenium import webdriver

class WebdriverUtils:
        #web模式
    def create_headlesschrome_options(self,windowsize='1920,1080'):
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--headless')
        chrome_options.add_argument('--disable-gpu')
        chrome_options.add_argument('--window-size='+windowsize)
        return chrome_options

        #H5模式
    def create_app_headlesschrome_options(self,deviceName='iPhone 5/SE'):
        devname={'deviceName':deviceName}
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--headless')
        chrome_options.add_argument('--disable-gpu')
        chrome_options.add_experimental_option('mobileEmulation',devname)
        return chrome_options

