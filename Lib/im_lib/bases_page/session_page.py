from bases.app_bases import Android_Appium_bases
from bases.bases import Data_bases
from appium.webdriver.webdriver import WebDriver
from appium import webdriver

from config import logging


class session_page(Android_Appium_bases):
    android_session_element = ("xpath", "//*[@text='会话']")
    android_contacts_element = ("xpath", "//*[@text='通讯录']")
    android_my_element = ("xpath", "//*[@text='我']")
    android_search_element = ("xpath", "//android.view.ViewGroup/android.widget.EditText")
    android_more_element = ("xpath", "//android.widget.ImageView[@content-desc='更多选项']")
    android_add_group_element = ("xpath", "//android.widget.TextView[@text='创建群组']")
    android_add_friend_element = ("xpath", "//*[@text='添加好友']")

    def click_session_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :点击会话按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击会话按钮")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_session_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"

        element.click()

    def click_contacts_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击通讯录按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击通讯录按钮")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_contacts_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element.click()

    def click_my_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击我按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击我按钮")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_my_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element.click()

    def search_method(self, platform: str, devices_name: str, search_data: str = None) -> str or None:
        """
        :作用 搜索用户
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param search_data: 搜索的用户名
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},搜索用户:{search_data}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_search_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"

        if search_data:
            self.send_keys(devices_name, search_data, element)
        else:
            return self.get_text(devices_name, element)

    def click_more_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击 +
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击 + ")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_more_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element.click()

    def click_add_group_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击添加群组
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击创建群组按钮")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_add_group_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element.click()

    def click_add_friend_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击添加好友
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击创添加好友")
        element = None
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, self.android_add_friend_element)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element.click()

    def click_user_session_method(self, platform: str, devices_name: str,
                                  name: str, options: str = "click") -> str or None:
        """
        :作用 点击会话操作
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param name: 需要进入的用户名
        :param options:  传入click是点击，传入text是获取属性
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击会话操作")
        element = None
        el = ("xpath", f"//*[@text='{name}']")
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, el)
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "只能传入click:点击,text:获取属性"


class Add_group_option_user(Android_Appium_bases):
    android_search_element = ("xpath", "//android.view.ViewGroup/android.widget.EditText")
    android_done_button_element = ("xpath", "//android.widget.RelativeLayout[2]/android.widget.TextView")
    android_return_button_element = ("xpath", "//android.widget.ImageButton[@content-desc='转到上一层级']")

    def search_method(self, platform: str, devices_name: str, search_data: str = None) -> str or None:
        """
        :作用 搜索用户
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param search_data: 搜索的用户名
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},添加群主搜索用户:{search_data}")
        element = None

        if str(platform).upper() == "ANDROID":
            element = self.android_search_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"

        if search_data:
            self.send_keys(devices_name, search_data, element)
        else:
            return self.get_text(devices_name, element)

    def option_click_user_method(self, platform: str, devices_name: str, user_name: str) -> str or None:
        """
        :作用 搜索用户
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param user_name: 需要点击的user_name
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},创建群组选择用户:{user_name} ")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.wait_find(devices_name, ("xpath", f"//android.widget.TextView[@text='{user_name}']"))
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        el.click()

    def click_return_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击 <-(返回)按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击返回按钮")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_return_button_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_done_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击完成按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击完成按钮")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_done_button_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def add_group_option_user_method(self, platform: str, devices_name: str, user: list):
        """
        :作用 搜索并点击用户
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param user: 需要点击的user_name
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},搜索用户:{user}")
        for user_name in user:
            self.search_method(platform, devices_name, user_name)
            self.option_click_user_method(platform, devices_name, user_name)


class Add_user(Android_Appium_bases):
    android_search_element = ("xpath", "//*[@text='请输入用户ID']")
    android_reset_button_element = ("xpath", "//android.view.ViewGroup/android.widget.ImageButton")
    android_cancel_button_element = ("xpath", "//android.view.ViewGroup/android.widget.TextView")

    def add_search_user_method(self, platform: str, devices_name: str, search_user) -> None or str:
        """
        :作用 搜索要添加的用户
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param search_user: 需要添加的用户名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},搜索用户:{search_user}")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_search_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.send_keys(devices_name, search_user, el)

    def click_reset_search_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击重置搜索文本框
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击重置搜索框按钮")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_reset_button_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name,el).click()

    def click_cancel_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击取消按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击取消按钮")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_cancel_button_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()