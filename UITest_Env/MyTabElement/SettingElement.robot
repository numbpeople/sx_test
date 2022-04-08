*** Settings ***
Documentation    记录我的-设置页面元素
...    
*** Variables ***
&{AndroidSetingElement}    accounts_security=//android.view.ViewGroup[1]/android.view.ViewGroup/android.widget.TextView[1]
...    new_message=//android.view.ViewGroup[2]/android.view.ViewGroup/android.widget.TextView[1]
...    general=//android.view.ViewGroup[3]/android.view.ViewGroup/android.widget.TextView[1]
...    privacy=///android.view.ViewGroup[4]/android.view.ViewGroup/android.widget.TextView[1]
...    logout=//android.view.ViewGroup/android.widget.Button
&{iOSSetingElement}