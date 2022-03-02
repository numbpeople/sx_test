from bases.app_bases import IosAppiumBase
from appium.webdriver.webdriver import WebDriver


class CommunicationPage(IosAppiumBase):
    ios_new_user_list_element = ("xpath", "//XCUIElementTypeCell[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_group_element = ("xpath", "//XCUIElementTypeCell[2]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_chat_element = ("xpath", "//XCUIElementTypeCell[3]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_user_list_element = ("xpath", "//XCUIElementTypeCell[4]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_conversation_element = ("xpath", "//XCUIElementTypeButton[@name=\"会话\"]")
    ios_user_element = ("xpath", "//XCUIElementTypeButton[@name=\"通讯录\"]")
    ios_me_element = ("xpath", "//XCUIElementTypeButton[@name=\"我\"]")
    ios_conversation_title_element = ("xpath", "//XCUIElementTypeStaticText[@name=\"会话\"]")

    def click_new_user_list(self, driver: WebDriver):
        self.click_method(driver, "click", self.new_user_list_element)

    def click_group(self, driver: WebDriver):
        self.click_method(driver, "click", self.group_element)

    def click_chat(self, driver: WebDriver):
        self.click_method(driver, "click", self.chat_element)

    def get_user_list(self, driver: WebDriver):
        self.click_method(driver, "click", self.user_list_element)
