*** Settings ***
Documentation    会话列表页面中系统通知元素
*** Variables ***
&{AndroidNotificationPageXpath}
...    systemnotification=//android.widget.TextView[@text="系统消息"]    #系统通知
...    green=//android.view.ViewGroup/android.view.ViewGroup/android.widget.Button[@text="同意"]
...    refused=//android.view.ViewGroup/android.view.ViewGroup/android.widget.Button[@text="拒绝"]
&{iOSNotificationPageXpath}
...    systemnotification=//XCUIElementTypeStaticText[@name="系统通知"]
...    green=//XCUIElementTypeButton[@name="同意"]
...    refused=//XCUIElementTypeStaticText[@name="拒绝"]