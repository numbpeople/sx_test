*** Settings ***
Documentation    记录我的页面元素
*** Variables ***
&{AndroidMyPageElement}    user=//android.view.ViewGroup/android.view.ViewGroup[1]    #头像、账号
...    title_my=//android.widget.RelativeLayout/android.widget.TextView    #顶部title 【我】
...    my_tab=//android.widget.FrameLayout[@content-desc="我"]/android.view.ViewGroup[2]/android.widget.TextView    #【我】tab页面
...    seting=//android.view.ViewGroup[2]/android.view.ViewGroup[1]/android.view.ViewGroup    #设置
...    about=//android.view.ViewGroup[2]/android.view.ViewGroup[2]/android.view.ViewGroup    #关于环信IM
...    deve=//android.view.ViewGroup[2]/android.view.ViewGroup[3]/android.view.ViewGroup    #开发者服务


&{iOSMyPageElement}

