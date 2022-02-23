# 登陆页面
from appium.webdriver.webdriver import WebDriver
from config import logging
from bases.app_bases import IosAppiumBase
from selenium.webdriver.remote.webelement import WebElement
from bases.bases import Data_bases


class LoginPage(IosAppiumBase):
    version_element = ("xpath", "//XCUIElementTypeStaticText1")
    user_name_element = ("xpath", "//XCUIElementTypeTextField")
    password_element = ("xpath", "//XCUIElementTypeSecureTextField")
    login_button_element = ("xpath", "//XCUIElementTypeStaticText[@name='登 录']")
    registered_element = ("xpath", "//XCUIElementTypeButton[@name='注册账号']")
    service_config_element = ("xpath", "//XCUIElementTypeButton[@name='服务器配置']")


    def get_version_method(self, driver: WebDriver):
        """:return IM首页版本号"""
        logging.debug("获取版本号")
        return self.wait_find(driver, self.version_element).text

    def send_user_name_method(self, driver: WebDriver, date):
        """
        :param date: 要登陆的用户名，例如：test1
        :param max_time: 最大重试定位时间，单位秒
        :param max_time: 重试定位时间间隔，单位秒
        :return None
        """
        logging.debug(f"输入用户名，用户名是:{date}")
        self.wait_find(driver, self.user_name_element).send_keys(date)

    def send_password_method(self, driver: WebDriver, password: str = None) -> str or None:
        """
        :param driver: WebDriver
        :param password: 密码
        :return: None or text
        """
        logging.info(f"输入password:{password}")
        element = self.wait_find(driver, self.password_element)
        if password:
            element.click()
            element.clear()
            element.send_keys(password)
        elif not password:
            return element.text

    def click_login_button_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: Webdriver
        :param options: 默认click:点击, text: 返回登陆按钮的属性
        :return: None or text
        """
        logging.info("点击登陆按钮")
        element = self.wait_find(driver, self.login_button_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def click_registered_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        logging.info("点击注册账号")
        element = self.wait_find(driver, self.registered_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def click_service_config_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: Webdriver
        :param options: 默认clicj:点击, text: 返回登陆按钮的属性
        :return: text
        """
        element = self.wait_find(driver, self.service_config_element)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "options字段错误，只能传入:text click"

    def login(self, driver: WebDriver, username: str, password: str, version: str) -> None:
        """
        :param version: IM 版本号
        :param driver: WebDriver
        :param username: 用户名
        :param password: 密码
        :return: None
        """
        assert version == self.get_version_method(driver)
        self.send_user_name_method(driver, username)
        self.send_password_method(driver, password)
        self.click_login_button_method(driver)


class RegisteredPage(IosAppiumBase):
    registered_user_name_element = ("xpath", "//XCUIElementTypeTextField")
    registered_password_element = ("xpath", "//XCUIElementTypeSecureTextField[1]")
    registered_confirm_password_element = ("xpath", "//XCUIElementTypeSecureTextField[2]")
    registered_agreement_element = ("xpath", "//XCUIElementTypeButton[@name=\"unAgreeProtocol\"]")
    registered_button_element = ("xpath", "//XCUIElementTypeButton")
    registered_return_element = ("xpath", '//XCUIElementTypeButton[@name="back left"]')

    def registered_user_send_method(self, driver: WebDriver, user: str = None) -> str or None:
        """
        :param driver:  WebDriver
        :param user: 用户名
        :return: None or text
        """
        logging.info(f"输入username:{user}")
        element: WebElement = self.wait_find(driver, self.registered_user_name_element)
        if user:
            # element.click()
            element.click()
            # element.clear()
            element.clear()
            element.send_keys(user)
        elif not user:
            return element.text

    def registered_password_send_method(self, driver: WebDriver, password: str = None) -> str or None:
        """
        :param password: 密码
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"输入password:{password}")
        element = self.wait_find(driver, self.registered_password_element)
        if password:
            element.click()
            element.clear()
            element.send_keys(password)
        elif not password:
            return element.text

    def registered_confirm_password_send_method(self, driver: WebDriver, password: str = None) -> str or None:
        """
        :param password: 密码
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"输入确认密码:{password}")
        element = self.wait_find(driver, self.registered_confirm_password_element)
        if password:
            element.click()
            element.clear()
            element.send_keys(password)
        elif not password:
            return element.text

    def registered_click_agreement_method(self, driver: WebDriver) -> str or None:
        """
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"点击同意服务条款")
        element = self.wait_find(driver, self.registered_agreement_element)
        element.click()

    def click_registered_button_method(self, driver: WebDriver) -> None:
        """
        :param driver:  WebDriver
        :return: None
        """
        logging.info("点击注册按钮")
        self.wait_find(driver, self.registered_button_element).click()

    def registered_return_method(self, driver: WebDriver) -> str or None:
        """
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"点击返回")
        element = self.wait_find(driver, self.registered_return_element)
        element.click()

    def registered_method(self, driver: WebDriver, user: str, pwd: str, confirm_pwd: str) -> None:
        """
        :param driver: WebDriver
        :param user: 用户名
        :param pwd: 密码
        :param confirm_pwd: 确认密码
        :return: None
        """
        logging.info(f"注册用户:用户名:{user},密码{pwd},确认密码:{confirm_pwd}")
        self.registered_user_send_method(driver, user)
        self.registered_password_send_method(driver, pwd)
        self.registered_confirm_password_send_method(driver, confirm_pwd)
        self.registered_click_agreement_method(driver)
        # self.click_registered_button_method(driver)


class ServiceInfo(IosAppiumBase):
    service_switch_element = ("xpath", "//XCUIElementTypeSwitch")
    app_key = ("xpath", "//XCUIElementTypeCell[1]/XCUIElementTypeTextField")
    apns_cert_name = ("xpath", "//XCUIElementTypeCell[2]/XCUIElementTypeTextField")
    specify_server = ("xpath", "//XCUIElementTypeSwitch[@name='Specify Server:']")
    im_server = ("xpath", "//XCUIElementTypeCell[4]/XCUIElementTypeTextField")
    im_port = ("xpath", "//XCUIElementTypeCell[5]/XCUIElementTypeTextField")
    rest_server = ("xpath", "//XCUIElementTypeCell[6]/XCUIElementTypeTextField")
    https_only = ("xpath", "//XCUIElementTypeSwitch[@name='Https Only:']")
    save_button = ("xpath", "//XCUIElementTypeCell[8]/XCUIElementTypeOther[1]")

    def click_custom_service_switch_method(self, driver: WebDriver) -> None:
        logging.info("点击自定义服务器开关")
        element: WebElement = self.wait_find(driver, self.service_switch_element)
        element.click()

    def send_appkey_method(self, driver: WebDriver, app_key: str) -> str or None:
        """
        :param driver: WebDriver
        :param app_key: appkey
        :return: str or None
        """
        logging.info("输入appkey:{app_key}")
        element = self.wait_find(driver, self.app_key)
        if app_key:
            element.click()
            element.clear()
            element.send_keys(app_key)
            self.tap(driver, [(322, 134)])
        elif not app_key:
            return element.text

    def click_specify_server(self, driver: WebDriver) -> None:
        """
        :param driver: WebDriver
        :return: None
        """
        logging.info("点击specify server 开关")
        self.wait_find(driver, self.specify_server).click()

    def send_im_service_host_method(self, driver: WebDriver, im_host: str) -> str or None:
        """
        :param driver: WebDriver
        :param im_host: im_host
        :return: str or None
        """
        logging.info(f"输入im server地址:{im_host}")
        element = self.wait_find(driver, self.im_server)
        if im_host:
            element.click()
            element.clear()
            element.send_keys(im_host)
            self.tap(driver, [(322, 134)])
        elif not im_host:
            return element.text

    def send_port_method(self, driver: WebDriver, port: str) -> str or None:
        """
        :param driver: WebDriver
        :param port: port
        :return: str or None
        """
        logging.info(f"输入端口:{port}")
        element = self.wait_find(driver, self.im_port)
        if port:
            element.click()
            element.clear()
            element.send_keys(port)
            self.tap(driver, [(322, 134)])
        elif not port:
            return element.text

    def send_rest_host_method(self, driver: WebDriver, rest_host: str) -> str or None:
        """
        :param driver: WebDriver
        :param rest_host: rest_host
        :return: str or None
        """
        logging.info(f"输入rest server地址:{rest_host}")
        element = self.wait_find(driver, self.rest_server)
        if rest_host:
            element.click()
            element.clear()
            element.send_keys(rest_host)
            self.tap(driver, [(322, 134)])
        elif not rest_host:
            return element.text

    def click_https_switch_method(self, driver: WebDriver) -> None:
        """
        :param driver: WebDriver
        :return: None
        """
        logging.info("输入https only 开关")
        self.wait_find(driver, self.https_only).click()

    def reset_service_setupthe_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info("点击重置配置按钮")
        element = self.wait_find(driver, self.save_button)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def save_button_method(self, driver: WebDriver, options: str = "click") -> str or None:
        """
        :param driver: WebDriver
        :param options:  默认是click:点击，text:获取属性
        :return: None or str
        """
        logging.info("点击保存配置按钮}")
        element = self.wait_find(driver, self.save_button)
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return f"options 错误,只能传入 click:点击,text:获取属性"

    def service_config(self, driver: WebDriver, env_name: str) -> None:
        """
        :param driver: WebDriver
        :param env_name: 测试的环境hsb、ebs
        :return: None
        """
        logging.info("配置连地址")
        data = Data_bases()
        service_config_data = data.get_service_config(env_name)

        if not self.is_selected(driver, self.service_switch_element):
            self.click_custom_service_switch_method(driver)
        self.send_appkey_method(driver, service_config_data["appkey"])
        self.return_method(driver)
        if service_config_data["dns"]:
            pass
        elif not service_config_data["dns"]:
            self.click_specify_server(driver)
            self.send_im_service_host_method(driver, service_config_data["im_host"])
            self.send_port_method(driver, service_config_data["port"])
            self.send_rest_host_method(driver, service_config_data["rest_host"])
            if not service_config_data["https"]:
                if self.is_selected(driver, self.https_only):
                    self.click_https_switch_method(driver)
            elif service_config_data["https"]:
                if not self.is_selected(driver, self.https_only):
                    self.click_https_switch_method(driver)
        self.save_button_method(driver, "click")


if __name__ == '__main__':
    a = LoginPage()
    b = ServiceInfo()
    c = RegisteredPage()
    driver = a.connect_appium('helen_iphone')
    # a.click_service_config_method(driver)
    # b.service_config(driver, 'helen_config')
    # aa = b.click_custom_service_switch_method(driver)
    # print(aa)
    a.click_registered_method(driver)
    c.registered_method(driver, "tst", "123456", "123456")
