# 首页
from bases.app_bases import IosAppiumBase
from appium.webdriver.webdriver import WebDriver


class MainPage(IosAppiumBase):
    conversation_element = ("xpath", "//XCUIElementTypeButton[@name=\"会话\"]")
    user_element = ("xpath", "//XCUIElementTypeButton[@name=\"通讯录\"]")
    me_element = ("xpath", "//XCUIElementTypeButton[@name=\"我\"]")
    conversation_title_element = ("xpath", "//XCUIElementTypeStaticText[@name=\"会话\"]")

    def conversation_click(self, driver: WebDriver):
        """点击会话tab"""
        self.click_method(driver, "click", self.conversation_element)

    def user_click(self, driver: WebDriver):
        """点击通讯录tab"""
        self.click_method(driver, "click", self.user_element)

    def me_click(self, driver: WebDriver):
        """点击我tab"""
        self.click_method(driver, "click", self.me_element)

    def check_is_login(self, driver: WebDriver):
        """通过检查首页是否有【会话】标题，确认是否登陆"""
        self.find_element(driver, self.conversation_element)