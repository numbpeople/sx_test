*** Settings ***
Documentation    记录服务配置页面元素
*** Variables ***
&{ServerConfig}    custom_service_switch=    appkey_element=    use_service_switch=
...    im_server=    port=    rest_service=    https_switch=
...    reset_service=    cancel_reset_service=
...    confirm_reset_service=    save_button=
&{AndroidXpath}    custom_service_switch=//android.widget.Switch[1]
...    appkey_element=//android.widget.EditText[1]
...    use_service_switch_element= //android.widget.Switch[2]
...    im_server=//android.widget.EditText[2]
...    im_port=//android.widget.EditText[3]
...    rest_service=//android.widget.EditText[4]
...    https_switch=//android.view.ViewGroup/android.widget.Switch[3]
...    reset_service=//android.widget.Button[1]
...    cancel_reset_service=//android.widget.Button[1]
...    confirm_reset_service=//android.widget.Button[2]
...    save_button=//android.widget.Button[2]
&{iOSXpath}    custom_service_switch=//XCUIElementTypeSwitch
...    appkey_element=//XCUIElementTypeCell[1]/XCUIElementTypeTextField
...    apns_cert_name=//XCUIElementTypeCell[2]/XCUIElementTypeTextField
...    use_service_switch_element=//XCUIElementTypeSwitch[@name='Specify Server:']
...    im_server=//XCUIElementTypeCell[4]/XCUIElementTypeTextField
...    im_port=//XCUIElementTypeCell[5]/XCUIElementTypeTextField
...    rest_service=//XCUIElementTypeCell[6]/XCUIElementTypeTextField
...    https_switch=//XCUIElementTypeSwitch[@name="Https Only:"]
...    save_button=//XCUIElementTypeCell[8]/XCUIElementTypeOther[1]