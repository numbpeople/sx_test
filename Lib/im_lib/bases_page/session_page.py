from bases.app_bases import Android_Appium_bases
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
        :作用 勾选用户
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


class Add_group(Android_Appium_bases):
    android_group_name_element = ("xpath", "//*[@text='请输入群组名称']")
    android_group_name_send_element = ("xpath", "//android.widget.RelativeLayout/android.widget.EditText")
    android_group_send_cancel_element = ("xpath", "//android.view.ViewGroup/android.widget.Button[1]")
    android_group_send_determine_element = ("xpath", "//android.view.ViewGroup/android.widget.Button[2]")
    android_group_introduction_element = ("xpath", "//*[@text='请输入群组简介']")
    android_group_introduction_send_element = ("xpath", "//*[@text='请输入群组简介']")
    android_group_introduction_renturn_element = ("xpath", "//android.widget.ImageView")
    android_group_introduction_set_element = ("xpath", "//*[@text='保存']")
    android_group_count_element = ("xpath", "//*[@text='群组人数']")
    android_group_count_send_element = ("xpath", "//android.widget.RelativeLayout/android.widget.EditText")
    android_group_count_send_cancel_element = ("xpath", "//*[@text='取消']")
    android_group_count_send_determine_element = ("xpath", "//*[@text='确认']")
    android_group_whether_public_element = ("xpath", "//android.view.ViewGroup[4]//android.widget.Switch")
    android_group_whether_invit_permissions_element = ("xpath", "//android.view.ViewGroup[5]//android.widget.Switch")
    android_grpup_members_element = ("xpath", "//*[@text='群主成员']")

    def click_group_username_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击创建群组-进入输入群组名称
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击创建群组-进入输入群组名称")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_name_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def send_group_send_username_method(self, platform: str, devices_name: str, group_name) -> str or None:
        """
        :作用 输入群组名称
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param group_name: 输入的群主名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},输入群组名称:{group_name}")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_name_send_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element = self.wait_find(devices_name, el)
        element.click()
        element.clear()
        element.sned_keys(group_name)

    def click_cancel_send_group_name_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击取消按钮-取消输入群组名称
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击取消按钮-取消输入群组名称")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_send_cancel_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_determine_send_group_name_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击确定按钮-确定输入群组名称
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击确定按钮-确定输入群组名称")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_send_determine_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_introduction_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击简介-进入简介输入
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击简介-进入简介输入")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_introduction_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def send_group_introduction_method(self, platform: str, devices_name: str, group_introduction) -> str or None:
        """
        :作用 输入群组简介
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param group_introduction: 输入的群主名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},输入群组简介:{group_introduction}")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_introduction_send_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element = self.wait_find(devices_name, el)
        element.click()
        element.clear()
        element.sned_keys(group_introduction)

    def click_group_introduction_return_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击返回按钮-退出简介输入
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击返回按钮-退出简介输入")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_introduction_renturn_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_introduction_set_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击保存按钮-保存输入的群组简介
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击保存按钮-保存输入的群组简介")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_introduction_set_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_conunt_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击群组人数-进入群组人数更改
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击群组人数-进入群组人数更改")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_count_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def send_group_count_method(self, platform: str, devices_name: str, group_count) -> str or None:
        """
        :作用 输入群组人数
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param group_count: 输入群组人数
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},输入群组简介:{group_count}")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_count_send_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        element = self.wait_find(devices_name, el)
        element.click()
        element.clear()
        element.sned_keys(group_count)

    def click_group_conunt_cancel_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击取消按钮-取消群组人数更改
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击取消按钮-取消群组人数更改")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_count_send_cancel_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_conunt_determine_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击确定按钮-确定群组人数更改
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击确定按钮-确定群组人数更改")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_count_send_determine_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_whether_public_switch_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击是否公开群组开关
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击是否公开群组开关")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_whether_public_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_whether_invit_permissions_switch_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击群成员是否有邀请权限
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击群成员是否有邀请权限")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_whether_invit_permissions_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_grpup_members_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击群成员-进入群成员列表
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击群成员-进入群成员列表")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_grpup_members_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()


class Add_user(Android_Appium_bases):
    android_search_element = ("xpath", "//*[@text='请输入用户ID']")
    android_reset_button_element = ("xpath", "//android.view.ViewGroup/android.widget.ImageButton")
    android_cancel_button_element = ("xpath", "//android.view.ViewGroup/android.widget.TextView")
    android_add_user_button_element = ("xpath", "//*[@text='添加好友']")

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
        element = self.wait_find(devices_name, el)
        element.click()
        element.clear()
        element.send_keys(search_user)

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
        self.wait_find(devices_name, el).click()

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

    def click_add_user_button(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击添加好友按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击添加好友按钮")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_add_user_button_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_user_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击用户进入个人质料
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击user 进入个人质料")
        el = None
        if str(platform).upper() == "ANDROID":
            el = ("xpath", "//*[@resource-id='com.hyphenate.easeim:id/iv_search_user_icon']")
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()


class Personal_material(Android_Appium_bases):
    android_user_name_element = ("xpath", "//android.widget.TextView[1]")
    android_add_user_element = ("xpath", "//android.widget.TextView[2]")
    android_return_element = ("xpath", "//android.widget.ImageButton[@content-desc='转到上一层级']")

    def get_user_name_text_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 获取用户名
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},获取用户名")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_user_name_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        return self.wait_find(devices_name, el).text

    def click_add_user_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击添加到通讯录按钮
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击添加到通讯录按钮")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_add_user_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_return_button_method(self, platform: str, devices_name: str) -> None or str:
        """
        :作用 点击返回方法
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},点击返回方法")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_return_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()
