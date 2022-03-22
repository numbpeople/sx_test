from bases.app_bases import Android_Appium_bases, IosAppiumBases
from bases.bases import Data_bases
from appium.webdriver.webdriver import WebDriver
import logging


class LoginPage(Android_Appium_bases):
    android_version_element = ("xpath", "//android.widget.TextView[1]")
    android_user_name_element = ("xpath", "//android.widget.EditText[1]")
    android_password_element = ("xpath", "//android.widget.EditText[2]")
    android_login_button_element = ("xpath", "//android.widget.Button")
    android_registered_element = ("xpath", "//*[@text='注册账号']")
    android_service_config_element = ("xpath", "//*[@text='服务器配置']")

    ios_version_element = ("xpath", "//XCUIElementTypeStaticText[@name=\"V3.9.0\"]")
    ios_user_name_element = ("xpath", "//XCUIElementTypeTextField")
    ios_password_element = ("xpath", "//XCUIElementTypeSecureTextField")
    ios_login_button_element = ("xpath", "//XCUIElementTypeStaticText[@name='登 录']")
    ios_registered_element = ("xpath", "//XCUIElementTypeButton[@name='注册账号']")
    ios_service_config_element = ("xpath", "//XCUIElementTypeButton[@name='服务器配置']")

    def get_im_version_method(self, platform: str, devices_name: str) -> str:
        """调用该方法返回一个im的版本号"""
        logging.info(f"操作设备:{platform} {devices_name},获取im版本号")
        if str(platform).upper() == "ANDROID":
            return self.wait_find(devices_name, self.android_version_element).text
        elif str(platform).upper() == "IOS":
            return self.wait_find(devices_name, self.ios_version_element).text
        else:
            return "platform错误，只能传入android 或者 ios设备"

    def send_user_name_method(self, platform: str, devices_name: str, user: str = None) -> str or None:
        """
        :作用 输入用户名
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param user: 用户名
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},输入username:{user}")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.android_user_name_element
        elif str(platform).upper() == "IOS":
            element = self.ios_user_name_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if user:
            self.send_keys(devices_name, user, element)
        elif not user:
            return self.get_text(devices_name, element)

    def send_password_method(self, platform: str, devices_name: str, password: str = None) -> str or None:
        """
        :作用 输入密码
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param password: 密码
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},输入password:{password}")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.android_password_element
        elif str(platform).upper() == "IOS":
            element = self.ios_password_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if password:
            self.send_keys(devices_name, password, element)
        elif not password:
            return self.get_text(devices_name, element)

    def click_login_button_method(self, platform: str, devices_name: str, options: str = "click") -> str or None:
        """
        :作用 点击登陆按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param options: 默认click:点击, text: 返回登陆按钮的属性
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},点击登陆按钮")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_login_button_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_login_button_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def click_registered_method(self, platform: str, devices_name: str, options: str = "click") -> str or None:
        """
        :作用 点击注册账号
        :param platform: 设备类型 传入android或者ios
        :param devices_name: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        logging.info(f"操作设备:{platform} {devices_name},点击注册账号")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_registered_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_registered_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def click_service_config_method(self, platform: str, devices_name: str, options: str = "click") -> str or None:
        """
        :作用 获取登陆按钮属性
        :param platform: 设备类型 传入android或者ios
        :param devices_name: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        logging.info(f"设备名称:{platform} {devices_name},点击服务器配置")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_service_config_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_service_config_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def login(self, platform: str, devices_name: str, username: str, password: str) -> None or str:
        """
        :作用 登陆
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param username: 用户名
        :param password: 密码
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},开始登陆im")
        data = Data_bases()
        expect_version = data.get_im_demo_version()
        practical_version = self.get_im_version_method(platform, devices_name)
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.android_user_name_element

        elif str(platform).upper() == "IOS":
            element = self.ios_user_name_element
        else:
            return "platform错误，只能传入android或者ios设备"

        assert expect_version == practical_version, f"版本号错误,预期是{expect_version},实际结果是{practical_version}"
        self.send_user_name_method(platform, devices_name, username)
        self.send_password_method(platform, devices_name, password)
        self.click_login_button_method(platform, devices_name)


class RegisteredPage(Android_Appium_bases, IosAppiumBases):
    android_registered_user_name_element = ("xpath", "//android.widget.EditText[1]")
    android_registered_password_element = ("xpath", "//android.widget.EditText[2]")
    android_registered_confirm_password_element = ("xpath", "//android.widget.EditText[3]")
    android_registered_agreement_element = ("xpath", "//android.view.ViewGroup/android.widget.CheckBox")
    android_registered_button_element = ("xpath", "//android.widget.Button")
    android_registered_return_element = ("xpath", '//android.widget.ImageButton[@content-desc="转到上一层级"]')

    ios_registered_user_name_element = ("xpath", "//XCUIElementTypeTextField")
    ios_registered_password_element = ("xpath", "//XCUIElementTypeSecureTextField[1]")
    ios_registered_confirm_password_element = ("xpath", "//XCUIElementTypeSecureTextField[2]")
    ios_registered_agreement_element = ("xpath", "//XCUIElementTypeButton[@name=\"unAgreeProtocol\"]")
    ios_registered_button_element = ("xpath", "(//XCUIElementTypeStaticText[@name=\"注册账号\"])[2]")
    ios_registered_return_element = ("xpath", '//XCUIElementTypeButton[@name="back left"]')

    def registered_user_send_method(self, platform: str, devices_name: str, user: str = None) -> str or None:
        """
        :作用 输入注册用户名
        :param platform: 设备类型 传入android或者ios
        :param devices_name:  设备名称
        :param user: 用户名
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},输入注册username:{user}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_registered_user_name_element
            if user:
                self.send_keys(devices_name, user, element)
                self.tap(devices_name, [(407, 407)])
            elif not user:
                return self.get_text(devices_name, element)
        elif str(platform).upper() == "IOS":
            element = self.ios_registered_user_name_element
            if user:
                self.input_keys(devices_name, user, element)
                self.tap(devices_name, [(407, 407)])
            elif not user:
                return self.get_text(devices_name, element)
        else:
            return "platform错误，只能传入android或者ios设备"

    def registered_password_send_method(self, platform: str, devices_name: str, password: str = None) -> str or None:
        """
        :作用 输入注册密码
        :param platform: 设备类型 传入android或者ios
        :param password: 密码
        :param devices_name: 设备名称
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},输入注册password:{password}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_registered_password_element
        elif str(platform).upper() == "IOS":
            element = self.ios_registered_password_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if password:
            self.send_keys(devices_name, password, element)
            self.tap(devices_name, [(407, 407)])
        elif not password:
            return self.get_text(devices_name, element)

    def registered_confirm_password_send_method(self, platform: str, devices_name: str,
                                                password: str = None) -> str or None:
        """
        :作用 输入注册确认密码
        :param platform: 设备类型 传入android或者ios
        :param password: 密码
        :param devices_name:  WebDriver
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},输入注册确认密码:{password}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_registered_confirm_password_element
        elif str(platform).upper() == "IOS":
            element = self.ios_registered_confirm_password_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if password:
            self.send_keys(devices_name, password, element)
            self.tap(devices_name, [(407, 407)])
        elif not password:
            return self.get_text(devices_name, element)

    def registered_click_agreement_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击同意服务条款
        :param platform: 设备类型 传入android或者ios
        :param devices_name:  设备名称
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},点击同意服务条款")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_registered_agreement_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_registered_agreement_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()

    def click_registered_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击注册按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{devices_name},点击注册按钮")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_registered_button_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_registered_button_element)
        else:
            return "platform错误，只能传入android或者ios设备"
        element.click()

    def registered_return_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击返回
        :param platform: 设备类型 传入android或者ios
        :param devices_name:  设备名称
        :return: None or text
        """
        logging.info(f"操作设备:{platform} {devices_name},点击返回")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_registered_return_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_registered_return_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()

    def registered_method(self, platform: str, devices_name: str, user: str, pwd: str, confirm_pwd: str) -> None:
        """
        :作用 注册用户
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param user: 用户名
        :param pwd: 密码
        :param confirm_pwd: 确认密码
        :return: None
        """
        logging.info(f"操作设备:{platform} {devices_name},注册用户:用户名:{user},密码{pwd},确认密码:{confirm_pwd}")
        self.registered_user_send_method(platform, devices_name, user)
        self.registered_password_send_method(platform, devices_name, pwd)
        self.registered_confirm_password_send_method(platform, devices_name, confirm_pwd)
        self.registered_click_agreement_method(platform, devices_name)
        self.click_registered_button_method(platform, devices_name)


class ServiceConfig(Android_Appium_bases):
    android_custom_service_switch_element = ("xpath", "//android.widget.Switch[1]")
    android_appkey_element = ("xpath", "//android.widget.EditText[1]")
    android_use_service_switch_element = ("xpath", "//android.widget.Switch[2]")
    android_im_service_host_element = ("xpath", "//android.widget.EditText[2]")
    android_port_element = ("xpath", "//android.widget.EditText[3]")
    android_rest_service_host_element = ("xpath", "//android.widget.EditText[4]")
    android_https_switch_element = ("xpath", "//android.view.ViewGroup/android.widget.Switch[3]")
    android_reset_service_setupthe_element = ("xpath", "//android.widget.Button[1]")
    android_cancel_reset_service_element = ("xpath", "//android.widget.Button[1]")
    android_confirm_reset_service_element = ("xpath", "//android.widget.Button[2]")
    android_save_button_element = ("xpath", "//android.widget.Button[2]")

    ios_service_switch_element = ("xpath", "//XCUIElementTypeSwitch")
    ios_app_key_element = ("xpath", "//XCUIElementTypeCell[1]/XCUIElementTypeTextField")
    ios_apns_cert_name_element = ("xpath", "//XCUIElementTypeCell[2]/XCUIElementTypeTextField")
    ios_specify_server_element = ("xpath", "//XCUIElementTypeSwitch[@name='Specify Server:']")
    ios_im_server_element = ("xpath", "//XCUIElementTypeCell[4]/XCUIElementTypeTextField")
    ios_im_port_element = ("xpath", "//XCUIElementTypeCell[5]/XCUIElementTypeTextField")
    ios_rest_server_element = ("xpath", "//XCUIElementTypeCell[6]/XCUIElementTypeTextField")
    ios_https_only_element = ("xpath", "//XCUIElementTypeSwitch[@name='Https Only:']")
    ios_save_button_element = ("xpath", "//XCUIElementTypeCell[8]/XCUIElementTypeOther[1]")

    def click_custom_service_switch_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击自定义的服务器
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击自定义服务器开关")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_custom_service_switch_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_service_switch_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()

    def send_appkey_method(self, platform: str, devices_name: str, app_key: str) -> str or None:
        """
        :作用 输入app_key
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param app_key: app_key
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},输入apppkey:{app_key}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_appkey_element
        elif str(platform).upper() == "IOS":
            element = self.ios_app_key_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if app_key:
            self.send_keys(devices_name, app_key, element)
        elif not app_key:
            return self.get_text(devices_name, element)

    def click_use_service_switch_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击使用私有服务器开关
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{devices_name},点击使用是有服务器开关")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_use_service_switch_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_apns_cert_name_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()

    def send_im_service_host_method(self, platform: str, devices_name: str, im_host: str) -> str or None:
        """
        :作用 输入im服务器地址
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param im_host: im_host
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},输入im服务器地址:{im_host}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_im_service_host_element
        elif str(platform).upper() == "IOS":
            element = self.ios_im_server_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if im_host:
            self.send_keys(devices_name, im_host, element)
        elif not im_host:
            return self.get_text(devices_name, element)

    def send_port_method(self, platform: str, devices_name: str, port: str) -> str or None:
        """
        :作用 输入端口号
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param port: port
        :return: str or None
        """
        logging.info(f"操作设备:{devices_name},输入端口:{port}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_port_element
        elif str(platform).upper() == "IOS":
            element = self.ios_im_port_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if port:
            self.send_keys(devices_name, port, element)
        elif not port:
            return self.get_text(devices_name, element)

    def send_rest_host_method(self, platform: str, devices_name: str, rest_host: str) -> str or None:
        """
        :作用 输入rest服务器地址
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param rest_host: rest_host
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},输入rest服务器地址:{rest_host}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_rest_service_host_element
        elif str(platform).upper() == "IOS":
            element = self.ios_rest_server_element
        else:
            return "platform错误，只能传入android或者ios设备"

        if rest_host:
            self.send_keys(devices_name, rest_host, element)
        elif not rest_host:
            return self.get_text(devices_name, element)

    def click_https_switch_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击使用https开关
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击使用https开关")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_https_switch_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_https_only)
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()

    def reset_service_setupthe_method(self, platform: str, devices_name: str, options: str = "click") -> str or None:
        """
        :作用 点击重置服务器设置按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击重置配置按钮")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_reset_service_setupthe_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"

        element = self.wait_find(devices_name, element)
        if options == "click":
            element.click()
        elif options == "text":
            return self.get_text(devices_name, element)
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def cancel_reset_service_method(self, platform: str, devices_name: str, options: str = "click") -> str or None:
        """
        :作用 点击取消重置配置按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击取消重置配置按钮")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_cancel_reset_service_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def confirm_reset_service_method(self, platform: str, devices_name: str, options: str = "click") -> str or None:
        """
        :作用 点击确认重置配置按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击确认重置配置按钮")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_confirm_reset_service_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def save_button_method(self, platform: str, devices_name: str, options: str = "click") -> str or None:
        """
        :作用 点击保存配置按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击保存配置按钮")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_save_button_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_save_button_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def service_config(self, platform: str, devices_name: str, env_name: str) -> None:
        """
        :作用 配置连接服务器
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param env_name: 测试的环境hsb、ebs
        :return: None
        """
        logging.info(f"操作设备:{platform} {devices_name},开始配置连接服务器")
        data = Data_bases()
        custom_service_switch = None
        https_switch_element = None
        service_config_data = data.get_service_config(env_name)

        if str(platform).upper() == "ANDROID":
            custom_service_switch = self.android_custom_service_switch_element
            https_switch_element = self.android_https_switch_element
        elif str(platform).upper() == "IOS":
            custom_service_switch = self.ios_service_switch_element
            https_switch_element = self.ios_https_only_element

        if not self.is_selected(devices_name, custom_service_switch):
            self.click_custom_service_switch_method(platform, devices_name)
        self.send_appkey_method(platform, devices_name, service_config_data["appkey"])
        self.return_method(devices_name)
        if service_config_data["dns"]:
            pass
        elif not service_config_data["dns"]:
            self.click_use_service_switch_method(platform, devices_name)
            self.send_im_service_host_method(platform, devices_name, service_config_data["im_host"])
            self.return_method(devices_name)
            self.send_port_method(platform, devices_name, service_config_data["port"])
            self.return_method(devices_name)
            self.send_rest_host_method(platform, devices_name, service_config_data["rest_host"])
            self.return_method(devices_name)
            if not service_config_data["https"]:
                if self.is_selected(devices_name, https_switch_element):
                    self.click_https_switch_method(platform, devices_name)
            elif service_config_data["https"]:
                if not self.is_selected(devices_name, https_switch_element):
                    self.click_https_switch_method(platform, devices_name)
        self.save_button_method(platform, devices_name, "click")
