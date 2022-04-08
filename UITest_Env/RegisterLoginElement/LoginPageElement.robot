*** Settings ***
Documentation    记录登录页面元素
*** Variables ***
&{Login}    version=    login_name=    login_pwd=    login_button=    service_config=    btn_register=
&{AndroidLoginXpath}    version=//android.widget.TextView[1]
...    login_name=//android.widget.EditText[1]
...    login_pwd=//android.widget.EditText[2]
...    login_button=//android.widget.Button
...    service_config=//*[@text='服务器配置']
...    btn_register=//android.view.ViewGroup/android.widget.TextView[2]
&{iOSLoginXpath}    version=//XCUIElementTypeStaticText[@name="V3.9.0"]
...    login_name=//XCUIElementTypeTextField
...    login_pwd=//XCUIElementTypeSecureTextField
...    login_button=//XCUIElementTypeStaticText[@name='登 录']
...    service_config=//XCUIElementTypeButton[@name='服务器配置']
...    btn_register=//XCUIElementTypeButton[@name='注册账号']
