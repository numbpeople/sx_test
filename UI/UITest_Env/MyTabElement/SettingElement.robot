*** Settings ***
Documentation    记录我的-设置页面元素
*** Variables ***
&{AndroidSetingElement}    accounts_security=//android.view.ViewGroup[1]/android.view.ViewGroup/android.widget.TextView[1]    #设置中账号与安全
...    new_message=//android.view.ViewGroup[2]/android.view.ViewGroup/android.widget.TextView[1]    #设置中新消息提醒
...    general=//android.view.ViewGroup[3]/android.view.ViewGroup/android.widget.TextView[1]    #设置中通用
...    privacy=///android.view.ViewGroup[4]/android.view.ViewGroup/android.widget.TextView[1]    #设置中隐私
...    blacklist=//android.widget.TextView[@text="黑名单"]    #隐私中黑名单
...    blackname=//    #黑名单中的用户
...    logout=//android.view.ViewGroup/android.widget.Button    #设置中的退出登录

&{iOSSetingElement}    accounts_security=//android.view.ViewGroup[1]/android.view.ViewGroup/android.widget.TextView[1]    #设置中账号与安全
...    new_message=//android.view.ViewGroup[2]/android.view.ViewGroup/android.widget.TextView[1]    #设置中新消息提醒
...    general=//android.view.ViewGroup[3]/android.view.ViewGroup/android.widget.TextView[1]    #设置中通用
...    privacy=///android.view.ViewGroup[4]/android.view.ViewGroup/android.widget.TextView[1]    #设置中隐私
...    blacklist=//android.widget.TextView[@text="黑名单"]    #隐私中黑名单
...    blackname=//    #黑名单中的用户
...    logout=//android.view.ViewGroup/android.widget.Button    #设置中的退出登录