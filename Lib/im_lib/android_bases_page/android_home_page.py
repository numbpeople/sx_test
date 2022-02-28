from bases.app_bases import Android_Appium_bases
from bases.bases import Data_bases
from appium.webdriver.webdriver import WebDriver
import logging


class Android_login_page(Android_Appium_bases):

    android_version_element = ("xpath", "//android.widget.TextView[1]")
    android_user_name_element = ("xpath", "//android.widget.EditText[1]")
    android_password_element = ("xpath", "//android.widget.EditText[2]")
    android_login_button_element = ("xpath", "//android.widget.Button")
    android_registered_element = ("xpath", "//android.widget.TextView[2]]")
    android_service_config_element = ("xpath", "//android.widget.TextView[3]")

    def android_get_im_version_method(self,devices_name:str) -> str:
        """调用该方法返回一个im的版本号"""
        logging.info(f"操作设备:{devices_name},获取im版本号")
        return self.wait_find(devices_name,self.android_version_element).text

    def android_send_user_name_method(self,devices_name:str, user: str = None) -> str or None:
        """
        :作用 输入用户名
        :param devices_name: 设备名称
        :param user: 用户名
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},输入username:{user}")
        if user:
            self.send_keys(devices_name,user,self.android_user_name_element)
        elif not user:
            return self.get_text(devices_name,self.android_user_name_element)

    def android_send_password_method(self,devices_name:str, password: str = None) -> str or None:
        """
        :作用 输入密码
        :param devices_name: 设备名称
        :param password: 密码
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},输入password:{password}")
        if password:
            self.send_keys(devices_name,password,self.android_password_element)
        elif not password:
            return self.get_text(devices_name,self.android_password_element)

    def android_click_login_button_method(self,devices_name:str, options: str = "click") -> str or None:
        """
        :作用 点击登陆按钮
        :param devices_name: 设备名称
        :param options: 默认click:点击, text: 返回登陆按钮的属性
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},点击登陆按钮")
        element = self.wait_find(devices_name,self.android_login_button_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def android_click_registered_method(self,devices_name:str, options: str = "click") -> str or None:
        """
        :作用 点击注册账号
        :param devices_name: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        logging.info(f"操作设备:{devices_name},点击注册账号")
        element = self.wait_find(devices_name,self.android_registered_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def android_click_service_config_method(self,devices_name:str, options: str = "click") -> str or None:
        """
        :作用 获取登陆按钮属性
        :param devices_name: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        logging.info(f"设备名称:{devices_name},点击服务器配置")
        element = self.wait_find(devices_name,self.android_service_config_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def android_login(self,devices_name:str, username: str, password: str) -> None:
        """
        :作用 登陆
        :param devices_name: 设备名称
        :param username: 用户名
        :param password: 密码
        :return: None
        """
        logging.info(f"操作设备:{devices_name},开始登陆im")
        data = Data_bases()
        expect_version = data.get_im_demo_version()
        practical_version = self.android_get_im_version_method(devices_name)
        if self.judge_element(devices_name,self.android_user_name_element):
            assert expect_version == practical_version , f"版本号错误,预期是{expect_version},实际结果是{practical_version}"
            self.android_send_user_name_method(devices_name,username)
            self.android_send_password_method(devices_name, password)
            self.android_click_login_button_method(devices_name)
        else:
            pass


class Android_registered_page(Android_Appium_bases):

    android_registered_user_name_element = ("xpath","//android.widget.EditText[1]")
    android_registered_password_element = ("xpath","//android.widget.EditText[2]")
    android_registered_confirm_password_element = ("xpath","//android.widget.EditText[3]")
    android_registered_agreement_element = ("xpath","//android.view.ViewGroup/android.widget.CheckBox")
    android_registered_button_element = ("xpath","//android.widget.Button")
    android_registered_return_element = ("xpath", '//android.widget.ImageButton[@content-desc="转到上一层级"]')

    def android_registered_user_send_method(self,devices_name:str, user: str = None) -> str or None:
        """
        :作用 输入注册用户名
        :param devices_name:  设备名称
        :param user: 用户名
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},输入注册username:{user}")
        if user:
            self.send_keys(devices_name,user,self.android_registered_user_name_element)
        elif not user:
            return self.get_text(devices_name,self.android_registered_user_name_element)

    def android_registered_password_send_method(self,devices_name:str, password: str = None) -> str or None:
        """
        :作用 输入注册密码
        :param password: 密码
        :param devices_name: 设备名称
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},输入注册password:{password}")
        if password:
            self.send_keys(devices_name,password,self.android_registered_password_element)
        elif not password:
            return self.get_text(devices_name,self.android_registered_password_element)

    def android_registered_confirm_password_send_method(self,devices_name:str, password: str = None) -> str or None:
        """
        :作用 输入注册确认密码
        :param password: 密码
        :param devices_name:  WebDriver
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},输入注册确认密码:{password}")
        if password:
            self.send_keys(devices_name,password,self.android_registered_confirm_password_element)
        elif not password:
            return self.get_text(devices_name,self.android_registered_confirm_password_element)

    def android_registered_click_agreement_method(self,devices_name:str) -> str or None:
        """
        :作用 点击同意服务条款
        :param devices_name:  设备名称
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},点击同意服务条款")
        self.wait_find(devices_name, self.android_registered_agreement_element).click()

    def android_click_registered_button_method(self,devices_name:str) -> None:
        """
        :作用 点击注册按钮
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{devices_name},点击注册按钮")
        self.wait_find(devices_name, self.android_registered_button_element).click()

    def android_registered_return_method(self,devices_name:str) -> str or None:
        """
        :作用 点击返回
        :param devices_name:  设备名称
        :return: None or text
        """
        logging.info(f"操作设备:{devices_name},点击返回")
        self.wait_find(devices_name, self.android_registered_return_element).click()

    def android_registered_method(self,devices_name:str, user: str, pwd: str, confirm_pwd: str) -> None:
        """
        :作用 注册用户
        :param devices_name: 设备名称
        :param user: 用户名
        :param pwd: 密码
        :param confirm_pwd: 确认密码
        :return: None
        """
        logging.info(f"操作设备:{devices_name},注册用户:用户名:{user},密码{pwd},确认密码:{confirm_pwd}")
        self.android_registered_user_send_method(devices_name,user)
        self.android_registered_password_send_method(devices_name,pwd)
        self.android_registered_confirm_password_send_method(devices_name,confirm_pwd)


class Android_service_config(Android_Appium_bases):

    android_custom_service_switch_element = ("xpath","//android.widget.Switch[1]")
    android_appkey_element = ("xpath","//android.widget.EditText[1]")
    android_use_service_switch_element = ("xpath","//android.widget.Switch[2]")
    android_im_service_host_element = ("xpath","//android.widget.EditText[2]")
    android_port_element = ("xpath","//android.widget.EditText[3]")
    android_rest_service_host_element = ("xpath","//android.widget.EditText[4]")
    android_https_switch_element = ("xpath","//android.view.ViewGroup/android.widget.Switch[3]")
    android_reset_service_setupthe_element = ("xpath","//android.widget.Button[1]")
    android_cancel_reset_service_element = ("xpath", "//android.widget.Button[1]")
    android_confirm_reset_service_element = ("xpath", "//android.widget.Button[2]")
    android_save_button_element = ("xpath","//android.widget.Button[2]")

    def android_click_custom_service_switch_method(self,devices_name: str) -> None:
        """
        :作用 点击自定义的服务器
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{devices_name},点击自定义服务器开关")
        self.wait_find(devices_name, self.android_custom_service_switch_element).click()

    def android_send_appkey_method(self,devices_name:str, app_key : str) -> str or None:
        """
        :作用 输入appkey
        :param devices_name: 设备名称
        :param app_key: appkey
        :return: str or None
        """
        logging.info(f"操作设备:{devices_name},输入apppkey:{app_key}")
        if app_key:
            self.send_keys(devices_name,app_key,self.android_appkey_element)
        elif not app_key:
            return self.get_text(devices_name,self.android_appkey_element)

    def android_click_use_service_switch_method(self,devices_name:str) -> None:
        """
        :作用 点击使用私有服务器开关
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{devices_name},点击使用是有服务器开关")
        self.wait_find(devices_name, self.android_use_service_switch_element).click()

    def android_send_im_service_host_method(self,devices_name:str, im_host : str) -> str or None:
        """
        :作用 输入im服务器地址
        :param devices_name: 设备名称
        :param im_host: im_host
        :return: str or None
        """
        logging.info(f"操作设备:{devices_name},输入im服务器地址:{im_host}")
        if im_host:
            self.send_keys(devices_name,im_host,self.android_im_service_host_element)
        elif not im_host:
            return self.get_text(devices_name,self.android_im_service_host_element)

    def android_send_port_method(self, devices_name:str, port: str) -> str or None:
        """
        :作用 输入端口号
        :param devices_name: 设备名称
        :param port: port
        :return: str or None
        """
        logging.info(f"操作设备:{devices_name},输入端口:{port}")
        if port:
            self.send_keys(devices_name,port,self.android_port_element)
        elif not port:
            return self.get_text(devices_name,self.android_port_element)

    def android_send_rest_host_method(self, devices_name:str, rest_host: str) -> str or None:
        """
        :作用 输入rest服务器地址
        :param devices_name: 设备名称
        :param rest_host: rest_host
        :return: str or None
        """
        logging.info(f"操作设备:{devices_name},输入rest服务器地址:{rest_host}")
        if rest_host:
            self.send_keys(devices_name,rest_host,self.android_rest_service_host_element)
        elif not rest_host:
            return self.get_text(devices_name,self.android_rest_service_host_element)

    def android_click_https_switch_method(self, devices_name:str) -> None:
        """
        :作用 点击使用https开关
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{devices_name},点击使用https开关")
        self.wait_find(devices_name, self.android_https_switch_element).click()

    def android_reset_service_setupthe_method(self, devices_name:str, options: str = "click") -> str or None:
        """
        :作用 点击重置服务器设置按钮
        :param devices_name: 设备名称
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{devices_name},点击重置配置按钮")
        element = self.wait_find(devices_name,self.android_reset_service_setupthe_element)
        if options == "click":
            element.click()
        elif options == "text":
            return self.get_text(devices_name,self.android_reset_service_setupthe_element)
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_cancel_reset_service_method(self, devices_name:str, options: str = "click") -> str or None:
        """
        :作用 点击取消重置配置按钮
        :param devices_name: 设备名称
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{devices_name},点击取消重置配置按钮")
        element = self.wait_find(devices_name,self.android_cancel_reset_service_element)
        if options == "click":
            element.click()
        elif options == "text":
            return self.get_text(devices_name,self.android_cancel_reset_service_element)
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_confirm_reset_service_method(self, devices_name:str, options: str = "click") -> str or None:
        """
        :作用 点击确认重置配置按钮
        :param devices_name: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{devices_name},点击确认重置配置按钮")
        element = self.wait_find(devices_name,self.android_confirm_reset_service_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_save_button_method(self, devices_name:str, options: str = "click") -> str or None:
        """
        :作用 点击保存配置按钮
        :param devices_name: 设备名称
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info(f"操作设备:{devices_name},点击保存配置按钮")
        element = self.wait_find(devices_name,self.android_save_button_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_service_config(self, devices_name:str, env_name: str) -> None:
        """
        :作用 配置连接服务器
        :param devices_name: 设备名称
        :param env_name: 测试的环境hsb、ebs
        :return: None
        """
        logging.info(f"操作设备:{devices_name},开始配置连接服务器")
        data = Data_bases()
        service_config_data = data.get_service_config(env_name)

        if not self.is_selected(devices_name,self.android_custom_service_switch_element):
            self.android_click_custom_service_switch_method(devices_name)
        self.android_send_appkey_method(devices_name,service_config_data["appkey"])
        self.return_method(devices_name)
        if service_config_data["dns"]:
            pass
        elif not service_config_data["dns"]:
            self.android_click_use_service_switch_method(devices_name)
            self.android_send_im_service_host_method(devices_name,service_config_data["im_host"])
            self.return_method(devices_name)
            self.android_send_port_method(devices_name,service_config_data["port"])
            self.return_method(devices_name)
            self.android_send_rest_host_method(devices_name,service_config_data["rest_host"])
            self.return_method(devices_name)
            if not service_config_data["https"]:
                if self.is_selected(devices_name,self.android_https_switch_element):
                    self.android_click_https_switch_method(devices_name)
            elif service_config_data["https"]:
                if not self.is_selected(devices_name,self.android_https_switch_element):
                    self.android_click_https_switch_method(devices_name)
        self.android_save_button_method(devices_name,"click")









