from bases.app_bases import Android_Appium_bases
from bases.bases import Data_bases
from appium.webdriver.webdriver import WebDriver
from appium import webdriver


class Android_session_page(Android_Appium_bases):

    android_session_element = ("xpath","//android.widget.FrameLayout[@content-desc='会话']/android.view.ViewGroup[1]")
    android_com_element = ("xpath","//android.widget.FrameLayout[@content-desc='通讯录']/android.view.ViewGroup[1]")
    android_my_element = ("xpath","//android.widget.FrameLayout[@content-desc='我']/android.view.ViewGroup[1]")
    android_search_element = ("xpath","//android.view.ViewGroup/android.widget.EditText")
    android_more = ("xpath","//android.widget.ImageView[@content-desc='更多选项']")
    android_add_group = ("xpath","//android.widget.TextView[@text='创建群组']")
    android_add_friend = ("xpath","//android.widget.TextView")

    def io(self,devices_name):
        self.wait_find(devices_name,self.android_more).click()
        self.wait_find(devices_name,self.android_add_group).click()



    def android_click_session_button_method(self, driver: WebDriver, data: str) -> str or None:
        """
        :param driver: WebDriver
        :param data: 传数据是搜索 不传数据是获取元素
        :return: str or None
        """
        element = self.wait_find(driver,self.android_session_element)
        if data:
            element.click()
            element.clear()
            element.send_keys()


    def android_click_user_session(self, driver: WebDriver, name: str, options: str = "click") -> str or None:
        """

        :param driver: WebDriver
        :param name: 需要进入的用户名
        :param options:  传入click是点击，传入text是获取属性
        :return: str or None
        """
        element = self.wait_find(driver,("xpath",f"//android.widget.TextView[1][@text='{name}']"))
        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "只能传入click:点击,text:获取属性"

