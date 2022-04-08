*** Settings ***
Documentation    记录我的页面元素
*** Variables ***
&{AndroidMyPageElement}    my_tab=//android.widget.FrameLayout[@content-desc="我"]/android.view.ViewGroup[2]/android.widget.TextView
...    seting=//android.view.ViewGroup[2]/android.view.ViewGroup[1]/android.view.ViewGroup
...    about=//android.view.ViewGroup[2]/android.view.ViewGroup[2]/android.view.ViewGroup
...    deve=//android.view.ViewGroup[2]/android.view.ViewGroup[3]/android.view.ViewGroup
...    user=//android.view.ViewGroup/android.view.ViewGroup[1]
...    title_my=//android.widget.RelativeLayout/android.widget.TextView

&{iOSMyPageElement}

