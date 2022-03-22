from bases.app_bases import Android_Appium_bases
from config import logging


class SessionPage(Android_Appium_bases):
    android_session_element = ("xpath", "//*[@text='会话']")
    android_contacts_element = ("xpath", "//*[@text='通讯录']")
    android_my_element = ("xpath", "//*[@text='我']")
    android_search_element = ("xpath", "//android.view.ViewGroup/android.widget.EditText")
    android_more_element = ("xpath", "//android.widget.ImageView[@content-desc='更多选项']")
    android_add_group_element = ("xpath", "//android.widget.TextView[@text='创建群组']")
    android_add_friend_element = ("xpath", "//*[@text='添加好友']")

    ios_session_element = ("xpath", "//XCUIElementTypeButton[@name='会话']")
    ios_contacts_element = ("xpath", "//XCUIElementTypeButton[@name='通讯录']")
    ios_my_element = ("xpath", "//XCUIElementTypeButton[@name='我']")
    ios_search_element = ("xpath", "//XCUIElementTypeTable/XCUIElementTypeOther")
    ios_more_element = ("xpath", "//XCUIElementTypeButton[@name='icon add']")
    ios_add_group_element = ("xpath", "//XCUIElementTypeStaticText[@name='创建群组']")
    ios_add_friend_element = ("xpath", "//XCUIElementTypeStaticText[@name='新的好友']")




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
            element = self.wait_find(devices_name, self.ios_session_element)
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
            element = self.wait_find(devices_name, self.android_contacts_element)
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
            element = self.wait_find(devices_name, self.android_my_element)
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
            element = self.ios_search_element
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
            element = self.wait_find(devices_name, self.ios_more_element)
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
            element = self.wait_find(devices_name, self.ios_add_group_element)
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
            element = self.wait_find(devices_name, self.ios_add_friend_element)
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
        user_node = ("xpath", f"//XCUIElementTypeStaticText[@name='{name}']")
        if str(platform).upper() == "ANDROID":
            element = self.wait_find(devices_name, el)
        elif str(platform).upper() == "IOS":
            element = self.wait_find(devices_name, user_node)
        else:
            return "platform错误，只能传入android或者ios设备"

        if options == "click":
            element.click()
        elif options == "text":
            return element.text
        else:
            return "只能传入click:点击,text:获取属性"


class AddGroupOptionUser(Android_Appium_bases):
    android_search_element = ("xpath", "//android.view.ViewGroup/android.widget.EditText")
    android_done_button_element = ("xpath", "//android.widget.RelativeLayout[2]/android.widget.TextView")
    android_return_button_element = ("xpath", "//android.widget.ImageButton[@content-desc='转到上一层级']")

    ios_search_element = ("xpath", "//XCUIElementTypeTable/XCUIElementTypeOther")
    ios_done_button_element = ("xpath", "//XCUIElementTypeButton[@name='完成( 0 )']")
    ios_return_button_element = ("xpath", "//XCUIElementTypeButton[@name='close gray']")

    def search_member_method(self, platform: str, devices_name: str, search_data: str = None) -> str or None:
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
            element = self.ios_search_element
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
            el = self.wait_find(devices_name, ("xpath", f"//XCUIElementTypeStaticText[@name='{user_name}']"))
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
            el = self.ios_return_button_element
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
            el = self.ios_done_button_element
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
        self.click_done_button_method(platform, devices_name)


class AddGroup(Android_Appium_bases):
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
    android_group_count_send_determine_element = ("xpath", "//android.widget.Button[2]")
    android_group_whether_public_element = ("xpath", "//android.view.ViewGroup[4]//android.widget.Switch")
    android_group_whether_invit_permissions_element = ("xpath", "//android.view.ViewGroup[5]//android.widget.Switch")
    android_grpup_members_element = ("xpath", "//*[@text='群主成员']")
    android_group_done_button_element = ("xpath", "//android.widget.RelativeLayout[2]/android.widget.TextView")

    ios_group_name_element = ("xpath", "/XCUIElementTypeCell[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_group_name_send_element = ("xpath", "//XCUIElementTypeOther/XCUIElementTypeTextField")
    ios_group_send_cancel_element = ("xpath", "//XCUIElementTypeButton[@name=\"back left black\"]")
    ios_group_send_determine_element = ("xpath", "//XCUIElementTypeButton[@name=\"完成\"]")
    ios_group_introduction_element = ("xpath", "//XCUIElementTypeCell[2]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_group_introduction_send_element = ("xpath", "//XCUIElementTypeOther/XCUIElementTypeTextView")
    ios_group_introduction_renturn_element = ("xpath", "//XCUIElementTypeButton[@name=\"back left black\"]")
    ios_group_introduction_set_element = ("xpath", "//XCUIElementTypeButton[@name=\"保存\"]")
    ios_group_count_element = ("xpath", "//XCUIElementTypeCell[4]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_group_count_send_element = ("xpath", "//XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther")
    ios_group_count_send_cancel_element = ("xpath", "//XCUIElementTypeButton[@name=\"取消\"]")
    ios_group_count_send_determine_element = ("xpath", "//XCUIElementTypeButton[@name=\"确定\"]")
    ios_group_whether_public_element = ("xpath", "//XCUIElementTypeSwitch[@name=\"是否公开群组\"]")
    ios_group_whether_invit_permissions_element = ("xpath", "//XCUIElementTypeSwitch[@name=\"群成员是否有邀请权限\"]")
    ios_grpup_members_element = ("xpath", "XCUIElementTypeCell[7]/XCUIElementTypeOther[1]/XCUIElementTypeOther")

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
            el = self.ios_group_name_send_element
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def send_group_username_method(self, platform: str, devices_name: str, group_name) -> str or None:
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
            el = self.ios_group_name_send_element
        else:
            return "platform错误，只能传入android或者ios设备"
        element = self.wait_find(devices_name, el)
        element.click()
        element.clear()
        element.send_keys(group_name)

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
            el = self.ios_group_send_cancel_element
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
            el = self.ios_group_send_determine_element
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
            el = self.ios_group_introduction_element
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
            el = self.ios_group_introduction_send_element
        else:
            return "platform错误，只能传入android或者ios设备"
        element = self.wait_find(devices_name, el)
        element.click()
        element.clear()
        element.send_keys(group_introduction)

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
            el = self.ios_group_introduction_renturn_element
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
            el = self.ios_group_introduction_set_element
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_count_method(self, platform: str, devices_name: str) -> str or None:
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
            el = self.ios_group_count_element
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
            el = self.ios_group_count_send_element
        else:
            return "platform错误，只能传入android或者ios设备"
        element = self.wait_find(devices_name, el)
        element.click()
        element.clear()
        element.send_keys(group_count)

    def click_group_count_cancel_method(self, platform: str, devices_name: str) -> str or None:
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
            el = self.ios_group_count_send_cancel_element
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_count_determine_method(self, platform: str, devices_name: str) -> str or None:
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
            el = self.ios_group_count_send_determine_element
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
            el = self.ios_group_whether_public_element
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_whether_invitation_permissions_switch(self, platform: str, devices_name: str) -> str or None:
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
            el = self.ios_group_whether_invit_permissions_element
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_members_method(self, platform: str, devices_name: str) -> str or None:
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
            el = self.ios_grpup_members_element
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def click_group_done_button_method(self, platform: str, devices_name: str) -> str or None:
        """
        :作用 点击完成按钮-创建群组
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :return: str or None
        """
        logging.info(f"操作设备:{platform} {devices_name},点击完成按钮-创建群组")
        el = None
        if str(platform).upper() == "ANDROID":
            el = self.android_group_done_button_element
        elif str(platform).upper() == "IOS":
            pass
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()

    def send_group_name_method(self, platform: str, devices_name: str, group_name: str) -> None or str:
        """
        :作用 输入群主名称-组合
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param group_name: 群主名称
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},输入群主名称:{group_name}")
        self.click_group_username_method(platform, devices_name)
        self.send_group_username_method(platform, devices_name, group_name)
        self.click_determine_send_group_name_method(platform, devices_name)

    def send_group_introduce_method(self, platform: str, devices_name: str, group_introduce: str) -> None or str:
        """
        :作用 输入简介名称-组合
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param group_introduce: 群主简介
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},输入简介名称-组合:{group_introduce}")
        self.click_group_introduction_method(platform, devices_name)
        self.send_group_introduction_method(platform, devices_name, group_introduce)
        self.click_group_introduction_set_method(platform, devices_name)

    def send_group_number_method(self, platform: str, devices_name: str, group_introduce: str) -> None or str:
        """
        :作用 修改群组最大人数-组合
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param group_introduce: 群主简介
        :return: None or str
        """
        logging.info(f"操作设备:{platform} {devices_name},修改群组最大人数-组合:{group_introduce}")
        self.click_group_conunt_method(platform, devices_name)
        self.send_group_count_method(platform, devices_name, group_introduce)
        self.click_group_conunt_determine_method(platform, devices_name)


class AddUser(Android_Appium_bases):
    android_search_element = ("xpath", "//*[@text='请输入用户ID']")
    android_reset_button_element = ("xpath", "//android.view.ViewGroup/android.widget.ImageButton")
    android_cancel_button_element = ("xpath", "//android.view.ViewGroup/android.widget.TextView")
    android_add_user_button_element = ("xpath", "//*[@text='添加好友']")

    ios_search_element = ("xpath", "//XCUIElementTypeOther/XCUIElementTypeTextField")
    ios_reset_button_element = ("xpath", "//android.view.ViewGroup/android.widget.ImageButton")
    ios_cancel_button_element = ("xpath", "//XCUIElementTypeStaticText[@name=\"取消\"]")
    ios_add_user_button_element = ("xpath", "//XCUIElementTypeStaticText[@name=\"添加好友\"]")

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
            el = self.ios_search_element
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
            el = self.ios_cancel_button_element
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
            el = self.ios_add_user_button_element
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
            el = ("xpath", "//XCUIElementTypeButton[@name=\"userData\"]")
        else:
            return "platform错误，只能传入android或者ios设备"
        self.wait_find(devices_name, el).click()


class Personal_material(Android_Appium_bases):
    android_user_name_element = ("xpath", "//android.widget.TextView[1]")
    android_add_user_element = ("xpath", "//android.widget.TextView[2]")
    android_return_element = ("xpath", "//android.widget.ImageButton[@content-desc='转到上一层级']")

    ios_user_name_element = ("xpath", "//XCUIElementTypeCell[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther")
    ios_add_user_element = ("xpath", "//XCUIElementTypeCell[2]/XCUIElementTypeOther/XCUIElementTypeOther")
    ios_return_element = ("xpath", "//XCUIElementTypeButton[@name=\"back left black\"]")

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



class Group_user_combination():
    session_page = SessionPage()
    add_group_option_user = AddGroupOptionUser()
    add_group = AddGroup()
    add_user = AddUser()

    def group_add_method(self, platform: str, devices_name: str, user_name: list, group_name: str,
                  group_introduce: str, group_number: str) -> None:
        """
        :作用 创建群
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param user_name: 群组要选择的用户
        :param group_name: 群组名称
        :param group_introduce: 群组简介
        :param group_number: 群组最大人数
        :return: None
        """
        logging.info(f"操作设备:{platform} {devices_name},创建群")
        self.session_page.click_more_button_method(platform, devices_name)
        self.session_page.click_add_group_button_method(platform, devices_name)
        self.add_group_option_user.add_group_option_user_method(platform, devices_name, user_name)
        self.add_group.send_group_name_method(platform, devices_name, group_name)
        self.add_group.send_group_introduce_method(platform, devices_name, group_introduce)
        self.add_group.send_group_number_method(platform, devices_name, group_number)
        self.add_group.click_group_whether_public_switch_method(platform, devices_name)
        self.add_group.click_group_whether_invit_permissions_switch_method(platform, devices_name)
        self.add_group.click_group_done_button_method(platform, devices_name)

    def add_user_chum_method(self, platform: str, devices_name: str, user_name: str, input_method_option: str) -> None:
        """
        :作用 添加好友
        :param platform: 设备类型 传入android或者ios
        :param devices_name: 设备名称
        :param user_name: 群组要选择的用户
        :param input_method_option: 输入法选项
            go：点击输入发 Go 按钮
            search：点击输入法搜索按钮
            done：点击输入法确认按钮
            previous：点击输入向前按钮；
        :return: None
        """
        logging.info(f"操作设备:{platform} {devices_name},创建群")
        self.session_page.click_more_button_method(platform, devices_name)
        self.session_page.click_add_friend_button_method(platform, devices_name)
        self.add_user.add_search_user_method(platform, devices_name,user_name)
        self.input_method_operation(devices_name, input_method_option)
        self.add_user.click_add_user_button(platform, devices_name)