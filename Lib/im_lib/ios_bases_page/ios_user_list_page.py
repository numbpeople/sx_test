# 通讯录页
from bases.app_bases import IosAppiumBase
from appium.webdriver.webdriver import WebDriver


class UserListPage(IosAppiumBase):
    new_user_list_element = ("xpath", "//XCUIElementTypeCell[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    group_element = ("xpath", "//XCUIElementTypeCell[2]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    chat_element = ("xpath", "//XCUIElementTypeCell[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    user_list_element = ("xpath", "//XCUIElementTypeCell[4]/XCUIElementTypeOther[1]/XCUIElementTypeOther")

    def click_new_user_list(self, driver: WebDriver):
        self.click_method(driver, "click", self.new_user_list_element)

    def click_group(self, driver: WebDriver):
        self.click_method(driver, "click", self.group_element)

    def click_chat(self, driver: WebDriver):
        self.click_method(driver, "click", self.chat_element)

    def get_user_list(self, driver: WebDriver):
        self.click_method(driver, "click", self.user_list_element)
