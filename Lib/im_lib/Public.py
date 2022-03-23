from bases_page.home_page import LoginPage, ServiceConfig, RegisteredPage
from bases_page.session_page import SessionPage, AddGroupOptionUser, AddUser, AddGroup
import time
from bases_page.session_page import Personal_material, Group_user_combination
from bases_page.my_page import MyPage

from bases.bases import Data_bases


class Public(
    LoginPage,
    RegisteredPage,
    ServiceConfig,
    SessionPage,
    AddGroupOptionUser,
    AddUser,
    AddGroup,
    MyPage
):

    def login_authorization_method(self, devices_name: str) -> None:
        """
        :作用 通过文本点击元素
        :param devices_name: 设备名称
        :usage: find_element_text(devices, ["使用时允许", "使用时允许", "使用时允许", "允许", "允许"])
        :return:None
        """
        for x in Data_bases().get_authorization():
            for element in Data_bases().get_authorization():
                el = ("xpath", f"//*[@text='{element}']")
                while True:
                    if self.judge_element(devices_name, el):
                        self.wait_find(devices_name, el).click()
                    else:
                        break

    def connect_appium_method(self, devices_config_name) -> None:
        """
        :param devices_config_name:设备配置名称
            作用:会根据传的name去配置文件里面找配置，连接appium启动应用
        :return: None
        """
        self.connect_appium(devices_config_name)

    def login_page(self, func_name: str, *args: str) -> None or str:
        """
        :作用 该函数是login page，login page所有操作可以通过该函数来完成
        :android元素:
        :param func_name: 任意传入一个func_dict存在的键，可以通过键来调用对应函数
        :param args: 根据传的func_name 来给arge传参数，具体如下：
            1. get_im_version:
                作用: 获取im_demo版本号
                参数: 传入platform 和 devices_name，返回测试的im_demo版本
            2. send_user_name:
                作用:
                    1.可以做输入用户名操作
                    2.可以做获取用户名输入框的属性操作
                参数:
                    1.传入platform和devices_name和username是输入登陆用户名，返回None
                    2.传入platform和devices_name返回用户名输入框的属性。
            3. send_password:
                作用:
                    1.可以做输入密码操作
                    2.可以做获取密码输入框的属性操作
                参数:
                    1.传入platform和devices_name和password是输入登陆密码，返回None
                    1.传入platform和devices_name返回密码输入框的属性。
            4. click_login_button:
                作用:
                    1.可以做点击登陆按钮操作
                    2.可以做获取登陆按钮属性操作
                参数:
                    1.传入platform和devices_name和click是点击登陆按钮操作
                    2.传入platform和devices_name和text是获取登陆按钮属性操作
            5. click_registered:
                作用:
                    1.可以做点击注册账号按钮操作
                    2.可以做获取注册属性操作
                参数:
                    1.传入platform和devices_name和click是点击注册账号按钮操作
                    2.传入platform和devices_name和text是获取注册属性操作
            6. click_config:
                作用:
                    1.可以做点击服务器配置按钮操作
                    2.可以做获取服务器配置按钮属性操作
                参数:
                    1.传入platform和devices_name和click是点击服务器配置按钮操作
                    2.传入platform和devices_name和text是获取服务器配置按钮属性操作
            7. login:
                作用: 组合登陆im_demo
                参数:需要传入参数如下
                    1. platform
                    2. devices_name
                    3. 用户名
                    4. 密码

        :return:str or None
        """
        func_dict = {
            "get_im_version": self.get_im_version_method,
            "send_user_name": self.send_user_name_method,
            "send_password": self.send_password_method,
            "click_login_button": self.click_login_button_method,
            "click_registered": self.click_registered_method,
            "click_config": self.click_service_config_method,
            "login": self.login,
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"

    def user_registered_page(self, func_name: str, *args: str) -> None or str:
        """
        :作用 该函数是注册页面，注册页面所有操作可以通过该函数来完成
        :param func_name: 任意传入一个func_dict存在的键，可以通过键来调用对应函数
        :param args: 根据传的func_name 来给arge传参数，具体如下：
            1. send_registered_user:
                作用:
                    1.可以做获取注册用户名输入框的属性操作
                    2.可以做输入用户名操作
                参数:
                    1.传入platform 和devices_name,是获取注册用户名输入框的属性操作
                    2.传入platform 和 devices_name 和 uusername，是做输入用户名操作
            2. send_registered_password:
                作用:
                    1.可以做获取密码输入框属性操作
                    2.可以做输入密码操作
                参数:
                    1.传入platform 和devices_name,是获取密码输入框属性操作
                    2.传入platform 和devices_name 和 password，是输入密码操作
            3. send_registered_confirm_password:
                作用:
                    1.可以做获取确认密码输入框属性操作
                    2.可以做输入确认密码操作
                参数:
                    1.传入platform 和devices_name,是获取确认密码输入框属性操作
                    2.传入platform 和devices_name 和 password，是输入确认密码操作
            4. click_agreement:
                作用:可以做点击同意服务条款
                参数:传入platform 和devices_name,是点击同意服务条款
            5. click_registered_button:
                作用:可以点击登陆按钮
                参数:传入platform 和devices_name,是点击登陆按钮
            6. click_return:
                作用:可以点返回
                参数:传入platform 和devices_name,是点击返回
            7. registered_user:
                作用:组合登陆
                参数:
                    1.platform
                    2.devices_name
                    3.username
                    4.password
                    5.confirm_password
        :return:None or str
        """
        func_dict = {
            "send_registered_user": self.registered_user_send_method,
            "send_registered_password": self.registered_password_send_method,
            "send_registered_confirm_password": self.registered_confirm_password_send_method,
            "click_agreement": self.registered_click_agreement_method,
            "click_registered_button": self.click_registered_button_method,
            "click_return": self.registered_return_method,
            "registered_user": self.registered_method,
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)
        else:
            return f"没有该函数{func_name}"

    def service_config_page(self, func_name, *args) -> str or None:
        """

        该函数是连接服务器配置page 所有操作可以通过该函数来完成
        :param func_name: 任意传入一个func_dict存在的键，可以通过键来调用对应函数
        :param args: 根据传的func_name 来给arge传参数，具体如下：

            1. click_custom_service_switch:
                作用: 点击自定义服务器开关操作
                参数: 传platform 和 devices_name是做点击自定义服务器开关操作

            2. send_app_key:
                作用:
                    1.输入app_key操作
                    2.获取app_key输入框属性操作
                参数:
                    1.传platform 和 devices_name和app_key是做输入app_key操作
                    2.传platform 和 devices_name是做获取app_key输入框属性操作

            3. click_use_service_switch:
                作用: 是做点击specify server 开关操作
                参数: 传入platform 和 devices_name做点击specify server 开关操作

            4. send_im_service_host:
                作用:
                    1.输入im连接地址
                    2.获取im_server输入框属性操作
                参数:
                    1.传platform 和 devices_name和host是做输入host操作
                    2.传platform 和 devices_name是做获取im_server输入框属性操作

            5. send_port:
                作用:
                    1.输入端口操作
                    2.获取端口输入框属性操作
                参数:
                    1.传platform 和 devices_name和im_port是做输入im_port操作
                    2.传platform 和 devices_name是做获取im_port输入框属性操作
            6. send_rest_host:
                作用:
                    1.输入rest服务器地址操作
                    2.获取rest服务器输入框属性
                参数:
                    1.传platform 和 devices_name和rest_host是做输入rest_host操作
                    2.传platform 和 devices_name是做获取rest_host输入框属性操作
            7. click_https_switch:
                作用:点击使用https开关
                参数:传platform 和 devices_name是做点击使用https开关
            8.reset_service_setupthe:
                作用:点击重置服务器设置按钮
                参数:传platform 和 devices_name是做点击重置服务器设置按钮
            9.cancel_reset_service:
                作用:点击取消重置配置按钮
                参数:传platform 和 devices_name是做点击取消重置配置按钮
            10.confirm_reset_service:
                作用:点击确认重置配置按钮
                参数:传platform 和 devices_name是做点击确认重置配置按钮
            11.click_save_button:
                作用:点击保存配置按钮
                参数:传platform 和 devices_name是做点击保存配置按钮
            12.service_config:
                作用:配置连接服务器
                参数:
                    1. platform
                    2.devices_name
                    3.env_name 传入hsb或者ebs
        :return: str or None
        """

        func_dict = {
            "click_custom_service_switch": self.click_custom_service_switch_method,
            "send_app_key": self.send_appkey_method,
            "click_use_service_switch": self.click_use_service_switch_method,
            "send_im_service_host": self.send_im_service_host_method,
            "send_port": self.send_port_method,
            "send_rest_host": self.send_rest_host_method,
            "click_https_switch": self.click_https_switch_method,
            "reset_service_setupthe": self.reset_service_setupthe_method,
            "cancel_reset_service": self.cancel_reset_service_method,
            "confirm_reset_service": self.confirm_reset_service_method,
            "click_save_button": self.save_button_method,
            "service_config": self.service_config
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"

    def session_page(self, func_name, *args) -> str or None:
        """
            1、click_session_button：
                作用：点击会话tab
            2、click_user_session
                作用：选择会话列表中某一个用户
            3、click_contacts_button
                作用：点击通讯录按钮
            4、click_my_button
                作用：点击我的按钮
            5、search
                作用：会话列表搜索用户
            6、click_more_button
                作用：点击会话中+按钮
            7、click_add_group_button
                作用：点击创建群组
            8、click_add_friend_button
                作用：点击新的好友
            以下为创建群组里方法
            9、search_member
                作用：搜索群组成员
            10、option_click_user
                作用：选择群组成员
            11、click_return_button
                作用：选择群组成员中返回
            12、click_done_button
                作用：点击完成按钮
            13、add_group_option_user
                作用：搜索并点击用户
        """
        func_dict = {
            "click_session_button": self.click_session_button_method,
            "click_user_session": self.click_user_session_method,
            "click_contacts_button": self.click_contacts_button_method,
            "click_my_button": self.click_my_button_method,
            "search": self.search_method,
            "click_more_button": self.click_more_button_method,
            "click_add_group_button": self.click_add_group_button_method,
            "click_add_friend_button": self.click_add_friend_button_method,
            "search_member": self.search_member_method,
            "option_click_user": self.option_click_user_method,
            "click_return_button": self.click_return_button_method,
            "click_done_button": self.click_done_button_method,
            "add_group_option_user": self.add_group_option_user_method,
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"

    def add_group(self, func_name, *args) -> str or None:
        """
            1、click_group_username
                作用：创建群组中填写群组名称
            2、send_group_send_username
                作用：填写群组名称
            3、click_determine_send_group_name
                作用：输入群聊名称后，点击完成
            4、click_group_introduction
                作用：点击群介绍
            5、send_group_introduction
                作用：输入群介绍
            6、click_group_introduction_return
                作用：点击群介绍返回按钮
            7、click_group_introduction_set
                作用：点击群组介绍保存按钮
            8、click_group_count
                作用：点击群组人数
            9、send_group_count
                作用：输入群组人数
            10、click_group_count_cancel
                作用：群组人数输入框，点击取消按钮
            11、click_group_count_determine
                作用：群组人数输入框，点击确定按钮
            12、click_group_whether_public_switch
                作用：点击是否公开群组开关
            13、click_group_whether_invitation_permissions_switch
                作用：点击群成员是否有邀请权限开关
            14、click_group_members
                作用：点击群组成员
         """
        func_dict = {
            "click_group_username": self.click_group_username_method,
            "send_group_send_username": self.send_group_send_username_method,
            "click_cancel_send_group_name": self.click_cancel_send_group_name_method,
            "click_determine_send_group_name": self.click_determine_send_group_name_method,
            "click_group_introduction": self.click_group_introduction_method,
            "send_group_introduction": self.send_group_introduction_method,
            "click_group_introduction_return": self.click_group_introduction_return_method,
            "click_group_introduction_set": self.click_group_introduction_set_method,
            "click_group_count": self.click_group_count_method,
            "send_group_count": self.send_group_count_method,
            "click_group_count_cancel": self.click_group_count_cancel_method,
            "click_group_count_determine": self.click_group_count_determine_method,
            "click_group_whether_public_switch": self.click_group_whether_public_switch_method,
            "click_group_whether_invitation_permissions_switch": self.click_group_whether_invitation_permissions_switch,
            "click_group_members": self.click_group_members_method
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"

    def add_user(self, func_name, *args) -> str or None:
        """
            1、add_search_user
                作用：输入要搜索的用户
            2、click_reset_search
                作用：点击重置按钮，仅适用于android
            3、click_cancel_button
                作用：点击取消按钮
            4、click_add_user_button
                作用：点击添加好友按钮
            5、click_user
                作用：点击用户查看个人资料
        """
        func_dict = {
            "add_search_user": self.add_search_user_method,
            "click_reset_search": self.click_reset_search_method,
            "click_cancel_button": self.click_cancel_button_method,
            "click_add_user_button": self.click_add_user_button,
            "click_user": self.click_user_method
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"

    def logout_page(self, func_name, *args) -> str or None:
        """
            1、logout：
                作用：登记退出
            2、config
                作用：设置
        """
        func_dict = {
            "logout": self.logout,
            "config": self.config
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"


if __name__ == '__main__':
    from Bases_Public_method import Bases_Public_method
    b = Bases_Public_method()
    devices = "oppo_sj001_devices"
    platform = "android"
    a=Public()
    driver=a.connect_appium_method(devices)
    print(b.element_judge_text(platform,devices,"通讯录"))

