from bases.app_bases import Android_Appium_bases
from config import logging


class MyPage(Android_Appium_bases):
    android_config_element = ("xpath", "")
    android_logout_element = ("xpath", "")
    ios_config_element = ("xpath", "//XCUIElementTypeCell[2]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_logout_element = ("xpath", "//XCUIElementTypeCell[5]/XCUIElementTypeOther[1]/XCUIElementTypeOther")

    def config(self, platform: str, devices_name: str) -> None:
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_config_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_config_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()

    def logout(self, platform: str, devices_name: str) -> None:
        logging.info(f"操作设备:{platform} {devices_name}, 点击退出")
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_logout_element)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, self.ios_logout_element)
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()
