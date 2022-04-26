*** Settings ***
Documentation    会话列表页面中系统通知元素
*** Variables ***
${num}
&{AndroidNotificationPageXpath}
...    systemnotification=//android.widget.TextView[@text="系统消息"]    #系统通知
...    green=//android.view.ViewGroup[${num}]/android.view.ViewGroup/android.widget.Button[@text="同意"]    #系统通知中同意按钮
...    count_green_button=//android.view.ViewGroup/android.widget.Button[@text="同意"]
...    refused=//android.view.ViewGroup[${num}]/android.view.ViewGroup/android.widget.Button[@text="拒绝"]    #系统通知中拒绝按钮
...    count_refused_button=///android.view.ViewGroup/android.widget.Button[@text="拒绝"]
...    back_button=//android.widget.ImageButton[@content-desc="转到上一层级"]    #左上角返回按钮
&{iOSNotificationPageXpath}
...    systemnotification=//XCUIElementTypeStaticText[@name="系统通知"]
...    green=//XCUIElementTypeButton[@name="同意"]
...    refused=//XCUIElementTypeStaticText[@name="拒绝"]