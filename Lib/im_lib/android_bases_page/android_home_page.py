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

    def android_get_im_version_method(self,driver : WebDriver) -> str:
        """调用该方法返回一个im的版本号"""
        logging.info("获取im版本号")
        return self.wait_find(driver,self.android_version_element).text

    def android_send_user_name_method(self,driver: WebDriver, user: str = None) -> str or None:
        """
        :param driver:  WebDriver
        :param user: 用户名
        :return: None or text
        """
        logging.info(f"输入username:{user}")
        element = self.wait_find(driver, self.android_user_name_element)
        if user:
            element.click()
            element.clear()
            element.send_keys(user)
            self.tap(driver,[(322, 134)])
        elif not user:
            return element.text

    def android_send_password_method(self,driver: WebDriver, password: str = None) -> str or None:
        """
        :param driver: WebDriver
        :param password: 密码
        :return: None or text
        """
        logging.info(f"输入password:{password}")
        element = self.wait_find(driver, self.android_password_element)
        if password:
            element.click()
            element.clear()
            element.send_keys(password)
            self.tap(driver,[(322, 134)])
        elif not password:
            return element.text

    def android_click_login_button_method(self,driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: Webdriver
        :param options: 默认click:点击, text: 返回登陆按钮的属性
        :return: None or text
        """
        logging.info("点击登陆按钮")
        element = self.wait_find(driver,self.android_login_button_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def android_click_registered_method(self,driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        logging.info("点击注册账号")
        element = self.wait_find(driver,self.android_registered_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def android_click_service_config_method(self,driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        logging.info("点击服务器配置")
        element = self.wait_find(driver,self.android_service_config_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def android_login(self,driver: WebDriver, username: str, password: str) -> None:
        """
        :param version: IM 版本号
        :param driver: WebDriver
        :param username: 用户名
        :param password: 密码
        :return: None
        """
        logging.info("登陆im")
        data = Data_bases()
        expect_version = data.get_im_demo_version()
        practical_version = self.android_get_im_version_method(driver)
        assert  expect_version == practical_version , f"版本号错误,预期是{expect_version},实际结果是{practical_version}"
        self.android_send_user_name_method(driver,username)
        self.android_send_password_method(driver, password)
        self.android_click_login_button_method(driver)


class Android_registered_page(Android_Appium_bases):

    android_registered_user_name_element = ("xpath","//android.widget.EditText[1]")
    android_registered_password_element = ("xpath","//android.widget.EditText[2]")
    android_registered_confirm_password_element = ("xpath","//android.widget.EditText[3]")
    android_registered_agreement_element = ("xpath","//android.view.ViewGroup/android.widget.CheckBox")
    android_registered_button_element = ("xpath","//android.widget.Button")
    android_registered_return_element = ("xpath", '//android.widget.ImageButton[@content-desc="转到上一层级"]')

    def android_registered_user_send_method(self,driver: WebDriver, user: str = None) -> str or None:
        """
        :param driver:  WebDriver
        :param user: 用户名
        :return: None or text
        """
        logging.info(f"输入username:{user}")
        element = self.wait_find(driver, self.android_registered_user_name_element)
        if user:
            element.click()
            element.clear()
            element.send_keys(user)
            self.tap(driver, [(322, 134)])
        elif not user:
            return element.text

    def android_registered_password_send_method(self,driver: WebDriver, password: str = None) -> str or None:
        """
        :param password: 密码
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"输入password:{password}")
        element = self.wait_find(driver, self.android_registered_password_element)
        if password:
            element.click()
            element.clear()
            element.send_keys(password)
            self.tap(driver, [(322, 134)])
        elif not password:
            return element.text

    def android_registered_confirm_password_send_method(self,driver: WebDriver, password: str = None) -> str or None:
        """
        :param password: 密码
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"输入确认密码:{password}")
        element = self.wait_find(driver, self.android_registered_confirm_password_element)
        if password:
            element.click()
            element.clear()
            element.send_keys(password)
            self.tap(driver, [(322, 134)])
        elif not password:
            return element.text

    def android_registered_click_agreement_method(self,driver: WebDriver) -> str or None:
        """
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"点击同意服务条款")
        element = self.wait_find(driver, self.android_registered_agreement_element)
        element.click()

    def android_click_registered_button_method(self,driver: WebDriver) -> None:
        """
        :param driver:  WebDriver
        :return: None
        """
        logging.info("点击注册按钮")
        self.wait_find(driver, self.android_registered_button_element).click()

    def android_registered_return_method(self,driver: WebDriver) -> str or None:
        """
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"点击返回")
        element = self.wait_find(driver, self.android_registered_return_element)
        element.click()

    def android_registered_method(self,driver: WebDriver, user: str, pwd: str, confirm_pwd: str) -> None:
        """
        :param driver: WebDriver
        :param user: 用户名
        :param pwd: 密码
        :param confirm_pwd: 确认密码
        :return: None
        """
        logging.info(f"注册用户:用户名:{user},密码{pwd},确认密码:{confirm_pwd}")
        self.android_registered_user_send_method(driver,user)
        self.android_registered_password_send_method(driver,pwd)
        self.android_registered_confirm_password_send_method(driver,confirm_pwd)


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

    def android_click_custom_service_switch_method(self,driver: WebDriver) -> None:
        """
        :param driver: WebDriver
        :return: None
        """
        logging.info("点击自定义服务器开关")
        self.wait_find(driver, self.android_custom_service_switch_element).click()

    def android_send_appkey_method(self,driver: WebDriver, app_key : str) -> str or None:
        """
        :param driver: WebDriver
        :param app_key: appkey
        :return: str or None
        """
        logging.info(f"输入apppkey:{app_key}")
        element = self.wait_find(driver, self.android_appkey_element)
        if app_key:
            element.click()
            element.clear()
            element.send_keys(app_key)
            self.tap(driver, [(322, 134)])
        elif not app_key:
            return element.text

    def android_click_use_service_switch_method(self,driver: WebDriver) -> None:
        """
        :param driver: WebDriver
        :return: None
        """
        logging.info("点击specify server 开关")
        self.wait_find(driver, self.android_use_service_switch_element).click()

    def android_send_im_service_host_method(self,driver: WebDriver, im_host : str) -> str or None:
        """
        :param driver: WebDriver
        :param im_host: im_host
        :return: str or None
        """
        logging.info(f"输入im server地址:{im_host}")
        element = self.wait_find(driver, self.android_im_service_host_element)
        if im_host:
            element.click()
            element.clear()
            element.send_keys(im_host)
            self.tap(driver, [(322, 134)])
        elif not im_host:
            return element.text

    def android_send_port_method(self, driver: WebDriver, port: str) -> str or None:
        """
        :param driver: WebDriver
        :param port: port
        :return: str or None
        """
        logging.info(f"输入端口:{port}")
        element = self.wait_find(driver, self.android_port_element)
        if port:
            element.click()
            element.clear()
            element.send_keys(port)
            self.tap(driver, [(322, 134)])
        elif not port:
            return element.text

    def android_send_rest_host_method(self, driver: WebDriver, rest_host: str) -> str or None:
        """
        :param driver: WebDriver
        :param rest_host: rest_host
        :return: str or None
        """
        logging.info(f"输入rest server地址:{rest_host}")
        element = self.wait_find(driver, self.android_rest_service_host_element)
        if rest_host:
            element.click()
            element.clear()
            element.send_keys(rest_host)
            self.tap(driver, [(322, 134)])
        elif not rest_host:
            return element.text

    def android_click_https_switch_method(self, driver: WebDriver) -> None:
        """
        :param driver: WebDriver
        :return: None
        """
        logging.info("输入https only 开关")
        self.wait_find(driver, self.android_https_switch_element).click()

    def android_reset_service_setupthe_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info("点击重置配置按钮")
        element = self.wait_find(driver,self.android_reset_service_setupthe_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_cancel_reset_service_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info("点击取消重置配置按钮")
        element = self.wait_find(driver,self.android_cancel_reset_service_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_confirm_reset_service_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info("点击确认重置配置按钮")
        element = self.wait_find(driver,self.android_confirm_reset_service_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_save_button_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info("点击保存配置按钮}")
        element = self.wait_find(driver,self.android_save_button_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def android_service_config(self, driver: WebDriver, env_name: str) -> None:
        """
        :param driver: WebDriver
        :param env_name: 测试的环境hsb、ebs
        :return: None
        """
        logging.info("配置连地址")
        data = Data_bases()
        service_config_data = data.get_service_config(env_name)

        if not self.is_selected(driver,self.android_custom_service_switch_element):
            self.android_click_custom_service_switch_method(driver)
        self.android_send_appkey_method(driver,service_config_data["appkey"])
        self.return_method(driver)
        if service_config_data["dns"]:
            pass
        elif not service_config_data["dns"]:
            self.android_click_use_service_switch_method(driver)
            self.android_send_im_service_host_method(driver,service_config_data["im_host"])
            self.android_send_port_method(driver,service_config_data["port"])
            self.android_send_rest_host_method(driver,service_config_data["rest_host"])
            if not service_config_data["https"]:
                if self.is_selected(driver,self.android_https_switch_element):
                    self.android_click_https_switch_method(driver)
            elif service_config_data["https"]:
                if not self.is_selected(driver,self.android_https_switch_element):
                    self.android_click_https_switch_method(driver)
        self.android_save_button_method(driver,"click")











