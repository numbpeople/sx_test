
from bases_page.home_page import LoginPage, ServiceConfig, RegisteredPage
from bases_page.session_page import SessionPage, AddGroup, AddUser
from bases.app_bases import Android_Appium_bases
from config import logging


class Bases_Public_method(Android_Appium_bases):
    a_login_page = LoginPage()
    a_registered_page = RegisteredPage()
    a_service_config = ServiceConfig()
    session_page = SessionPage()

    # 登陆页面元素
    login_page_element = {
        "a_version_element" : a_login_page.android_version_element,  # 版本号元素
        "a_user_name_element" : a_login_page.android_user_name_element,  # 登陆用户名文本框元素
        "a_password_element" : a_login_page.android_password_element,  # 登陆密码文本框元素
        "a_android_login_button_element" : a_login_page.android_login_button_element,  # 登陆按钮元素
        "a_registered_element" : a_login_page.android_registered_element,  # 进去注册页面元素
        "a_service_config_element" : a_login_page.android_service_config_element,  # 进入配置连接服务器页面元素

        "i_version_element": a_login_page.ios_version_element, #版本号
        "i_user_name_element": a_login_page.ios_user_name_element, # 用户名
        "i_password_element": a_login_page.ios_password_element, # 密码
        "i_login_button_element": a_login_page.ios_login_button_element, # 登陆
        "i_registered_element": a_login_page.ios_registered_element, # 注册
        "i_service_config_element": a_login_page.ios_service_config_element # 服务器信息配置
    }

    # 注册页面元素
    registered_page_element = {
        "a_user_element":a_registered_page.android_registered_user_name_element,  # 注册用户名文本框元素
        "a_pwd_element":a_registered_page.android_registered_password_element,  # 注册密码文本框元素
        "a_con_pwd_element":a_registered_page.android_registered_confirm_password_element,  # 注册确认密码文本框元素
        "a_agreement_element":a_registered_page.android_registered_agreement_element,  # 注册同意服务条款元素
        "a_registered_button_element":a_registered_page.android_registered_button_element,  # 注册按钮元素
        "a_registered_return_element":a_registered_page.android_registered_return_element,  # 退出注册页面元素

        "i_registered_user_name_element": a_registered_page.ios_registered_user_name_element,
        "i_registered_password_element": a_registered_page.ios_registered_password_element,
        "i_registered_confirm_password_element": a_registered_page.ios_registered_confirm_password_element,
        "i_registered_agreement_element": a_registered_page.ios_registered_agreement_element,
        "i_registered_button_element": a_registered_page.ios_registered_button_element,
        "i_registered_return_element": a_registered_page.ios_registered_return_element

    }

    # 会话页面
    session_page = {
        "a_session_element": session_page.android_session_element,
        "a_contacts_element": session_page.android_contacts_element,
        "a_my_element": session_page.android_my_element,
        "a_search_element": session_page.android_search_element,
        "a_more_element": session_page.android_more_element,
        "a_add_group_element": session_page.android_add_group_element,
        "_add_friend_element": session_page.android_add_friend_element,
        "i_session_element": session_page.ios_session_element,
        "i_contacts_element": session_page.ios_contacts_element,
        "i_my_element": session_page.ios_my_element,
        "i_search_element": session_page.ios_search_element,
        "i_more_element": session_page.ios_more_element,
        "i_add_group_element": session_page.ios_add_group_element,
        "i_add_friend_element": session_page.ios_add_friend_element
    }

    # 创建群组
    add_group = {

    }

    # 新的好友
    add_user = {

    }

    # 服务器配置页面
    service_config_page_element = {
        "a_service_switch_element": a_service_config.android_custom_service_switch_element,  # 配置 自定义的服务器元素
        "a_appkey_element": a_service_config.android_appkey_element,  # 配置 appkey文本框元素
        "a_use_service_switch_element": a_service_config.android_use_service_switch_element,  # 配置 私有服务器开关元素
        "a_im_host_element": a_service_config.android_im_service_host_element,  # 配置 im服务器地址文本框元素
        "a_port_element": a_service_config.android_port_element,  # 配置 端口号框元素
        "a_rest_service_host_element": a_service_config.android_rest_service_host_element,  # 配置 rest服务器地址文本框元素
        "a_https_switch_element": a_service_config.android_https_switch_element,  # 配置 https开关元素
        "a_reset_service_element": a_service_config.android_reset_service_setupthe_element,  # 配置 重置按钮元素
        "a_cancel_reset_service_element": a_service_config.android_cancel_reset_service_element,  # 配置 取消重置按钮元素
        "a_confirm_reset_service_element": a_service_config.android_confirm_reset_service_element,  # 配置 确认重置按钮元素
        "a_save_button_element": a_service_config.android_save_button_element,  # 保存配置按钮

        "i_service_switch_element": a_service_config.ios_service_switch_element,
        "i_app_key": a_service_config.ios_app_key_element,
        "i_apns_cert_name": a_service_config.ios_apns_cert_name_element,
        "i_specify_server": a_service_config.ios_specify_server_element,
        "i_im_server": a_service_config.ios_im_server_element,
        "i_im_port": a_service_config.ios_im_port_element,
        "i_rest_server": a_service_config.ios_rest_server_element,
        "i_https_only": a_service_config.ios_https_only_element,
        "i_save_button": a_service_config.ios_save_button_element

    }

    all_page = {
        "login_page_element":login_page_element,
        "registered_page_element":registered_page_element,
        "service_config_page_element":service_config_page_element
    }

    def public_is_displayed(self, devices_name: str, page_name: str, element_name: str) -> True or False:
        """
        :作用 判断该元素是否显示
        :param devices_name: 设备名称
        :param page_name: 页面名称，会根据传入的值去找对应字典page
        :param element_name:传入元素名称，会去对应的page_name里面找对应的元素
        :return True or Flase
        """
        logging.info(f"操作设备:{devices_name},判断元素是否存在,page_name:{page_name},element_name:{element_name}")
        if self.all_page.get(page_name):
            if self.all_page[page_name].get(element_name):
                return self.is_displayed(devices_name, self.all_page[page_name][element_name])
            else:
                return f"{page_name}里面没有你要的元素:{element_name},检查你传入page_name是否正确"
        else:
            return f"没有找到你要的:{page_name},检查你传入page_name是否正确"

    def public_is_selected(self, devices_name: str, page_name: str, element_name: str) -> True or False:
        """
        :作用 判断该元素是否被选中
        :param devices_name: 设备名称
        :param page_name: 页面名称，会根据传入的值去找对应字典page
        :param element_name:传入元素名称，会去对应的page_name里面找对应的元素
        :return True or Flase
        """
        logging.info(f"操作设备:{devices_name},判断该元素是否被选中,page_name:{page_name},element_name:{element_name}")
        if self.all_page.get(page_name):
            if self.all_page[page_name].get(element_name):
                return self.is_selected(devices_name, self.all_page[page_name][element_name])
            else:
                return f"{page_name}里面没有你要的元素:{element_name},检查你传入page_name是否正确"
        else:
            return f"没有找到你要的:{page_name},检查你传入page_name是否正确"

    def public_is_enabled(self,  devices_name: str, page_name: str, element_name: str) -> True or False:
        """
        :作用 判断该元素是否可用
        :param devices_name: 设备名称
        :param page_name: 页面名称，会根据传入的值去找对应字典page
        :param element_name:传入元素名称，会去对应的page_name里面找对应的元素
        :return True or Flase
        """
        logging.info(f"操作设备:{devices_name},判断该元素是否可用,page_name:{page_name},element_name:{element_name}")
        if self.all_page.get(page_name):
            if self.all_page[page_name].get(element_name):
                return self.is_displayed(devices_name, self.all_page[page_name][element_name])
            else:
                return f"{page_name}里面没有你要的元素:{element_name},检查你传入page_name是否正确"
        else:
            return f"没有找到你要的:{page_name},检查你传入page_name是否正确"

    def element_judge(self, devices_name: str, page_name: str, element_name: str) -> True or False:
        """
        :作用 判断元素是否存在
        :param devices_name: 设备名称
        :param page_name: 页面名称，会根据传入的值去找对应字典page
        :param element_name:传入元素名称，会去对应的page_name里面找对应的元素
        :return: True or False
        """
        logging.info(f"操作设备:{devices_name},判断元素是否存在,page_name:{page_name},element_name:{element_name}")
        if self.all_page.get(page_name):
            if self.all_page[page_name].get(element_name):
                return self.judge_element(devices_name, self.all_page[page_name][element_name])
            else:
                return f"{page_name}里面没有你要的元素:{element_name},检查你传入page_name是否正确"
        else:
            return f"没有找到你要的:{page_name},检查你传入page_name是否正确"

    def element_judge_text(self, devices_name: str,  text_name: str) -> True or False:
        """
        :作用 通过文本判断元素是否存在
        :param devices_name: 设备名称
        :param text_name:传入文本
        :return: True or False
        """
        logging.info(f"操作设备:{devices_name},判断元素是否存在,text_name:{text_name}")
        return self.judge_element(devices_name, ("xpath", f"//*[@text='{text_name}']"))


    def public_app_background(self,devices_name: str, seconds: int):
        """
        :作用 将app放到后台
        :param devices_name: 设备名称
        :param seconds: 放到后台的时间，单位秒
        :return: None
        """
        logging.info(f"操作设备:{devices_name},将app放到后台{seconds}秒")
        self.app_background(devices_name, int(seconds))

    def public_is_app_installed(self, devices_name: str, app_id: str) -> bool:
        """
        :作用 判断app是否安装
        :param devices_name: 设备名称
        :param app_id: appID
        :return: bool
        """
        logging.info(f"操作设备:{devices_name},判断{app_id}应用是否安装")
        return self.is_app_installed(devices_name, app_id)

    def public_get_window_size(self, devices_name: str):
        """
        :作用 获取当前窗口的宽度和高度
        :param devices_name: 设备名称
        :return: dict
        """
        logging.info(f"操作设备:{devices_name},获取当前窗口的宽度和高度")
        return self.get_window_size(devices_name)

    def public_swipe(self, devices_name: str, start_x: int, start_y: int, end_x: int, end_y: int,
                     duration: int = 0) -> None:
        """
        :作用 滑动
        :param devices_name: 设备名称
        :param start_x: 开始的x坐标
        :param start_y: 开始的y坐标
        :param end_x: 结束的x坐标
        :param end_y: 结束的y坐标
        :param duration: 滑动时间
        :return: None
        """
        logging.info(f"操作设备:{devices_name},滑动,开始x坐标:{start_x},开始y坐标:{start_y},"
                     f"结束x坐标:{end_x},结束y坐标:{end_y}")
        self.swipe(devices_name, start_x, start_y, end_x, end_y, duration)

    def public_quit(self, devices_name: str) -> None:
        """
        :作用 结束并退出
        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{devices_name},结束并且退出")
        self.quit(devices_name)

    def public_start_activity(self, devices_name: str, activity: str) -> None:
        """
        作用 跳转指定页面
        :param devices_name: 设备名称
        :param activity: 页面ID
        :return: None
        """
        logging.info(f"操作设备:{devices_name},跳转到登陆页面:{activity}")
        self.start_activity(devices_name)

    def public_get_activity(self, devices_name: str) -> str:
        """
        :作用 获取activity
        :param devices_name: 设备名称
        :return: str
        """
        logging.info(f"操作设备:{devices_name},获取activity")
        return self.get_activity(devices_name)

    def public_input_method_operation(self, devices_name: str, options: str) -> None:
        """
       :作用 输入法操作
       :param devices_name: 设备名称
       :param options：
            go：点击输入发 Go 按钮
            search：点击输入法搜索按钮
            done：点击输入法确认按钮
            previous：点击输入向前按钮；
       :return: None
       """
        logging.info(f"操作设备:{devices_name},点击{options}按钮")
        self.input_method_operation(devices_name, options)

    def public_get_text(self,devices_name: str, text: str) -> str:
        """
       :作用 获取元素文本
       :param devices_name: 设备名称
       :param text: 定位元素文本
       :return: str
       """
        logging.info(f"操作设备:{devices_name},获取{text}文本")
        return self.xpath_text_positioning(devices_name, text).text