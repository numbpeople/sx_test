
from bases_page.home_page import Login_page, Service_config, Registered_page
from bases.app_bases import Android_Appium_bases


class Bases_Public_method(Android_Appium_bases):
    a_login_page = Login_page()
    a_registered_page = Registered_page()
    a_service_config = Service_config()

    # 登陆页面元素
    login_page_element = {
        "a_version_element" : a_login_page.android_version_element,  # 版本号元素
        "a_user_name_element" : a_login_page.android_user_name_element,  # 登陆用户名文本框元素
        "a_password_element" : a_login_page.android_password_element,  # 登陆密码文本框元素
        "a_android_login_button_element" : a_login_page.android_login_button_element,  # 登陆按钮元素
        "a_registered_element" : a_login_page.android_registered_element,  # 进去注册页面元素
        "a_service_config_element" : a_login_page.android_service_config_element,  # 进入配置连接服务器页面元素
    }

    # 注册页面元素
    registered_page_element = {
        "a_user_element":a_registered_page.android_registered_user_name_element,  # 注册用户名文本框元素
        "a_pwd_element":a_registered_page.android_registered_password_element,  # 注册密码文本框元素
        "a_con_pwd_element":a_registered_page.android_registered_confirm_password_element,  # 注册确认密码文本框元素
        "a_agreement_element":a_registered_page.android_registered_agreement_element,  # 注册同意服务条款元素
        "a_registered_button_element":a_registered_page.android_registered_button_element,  # 注册按钮元素
        "a_registered_return_element":a_registered_page.android_registered_return_element,  # 退出注册页面元素
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
        if self.all_page.get(page_name):
            if self.all_page[page_name].get(element_name):
                return self.judge_element(devices_name, self.all_page[page_name][element_name])
            else:
                return f"{page_name}里面没有你要的元素:{element_name},检查你传入page_name是否正确"
        else:
            return f"没有找到你要的:{page_name},检查你传入page_name是否正确"
