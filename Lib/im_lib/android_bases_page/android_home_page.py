from bases.app_bases import Android_Appium_bases
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

    def android_login(self,driver: WebDriver, username: str, password: str, version: str) -> None:
        """
        :param version: IM 版本号
        :param driver: WebDriver
        :param username: 用户名
        :param password: 密码
        :return: None
        """
        assert version == self.android_get_im_version_method(driver)
        self.android_send_user_name_method(driver,username)
        driver.keyevent(4)
        self.android_send_password_method(driver, password)
        driver.keyevent(4)
        self.android_click_login_button_method(driver)


class Android_registered_page(Android_Appium_bases):

    android_registered_user_name_element = ("xpath","//android.widget.EditText[1]")
    android_registered_password_element = ("xpath","//android.widget.EditText[2]")
    android_registered_confirm_password_element = ("xpath","//android.widget.EditText[3]")
    android_registered_agreement_element = ("xpath","//android.view.ViewGroup/android.widget.CheckBox")
    android_registered_button_element = ("xpath","//android.widget.Button")

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
        elif not password:
            return element.text

    def android_registered_click_agreement_method(self,driver: WebDriver) -> str or None:
        """
        :param driver:  WebDriver
        :return: None or text
        """
        logging.info(f"点击同意服务条款")
        element = self.wait_find(driver, self.android_registered_confirm_password_element)
        element.click()









