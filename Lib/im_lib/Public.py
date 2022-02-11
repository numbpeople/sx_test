
from android_bases_page.android_home_page import Android_login_page,Android_service_config,Android_registered_page
from android_bases_page.android_session_page import Android_session_page
from appium.webdriver.webdriver import WebDriver


class Public(
    Android_login_page,
    Android_registered_page,
    Android_service_config
):

    def connect_appium_method(self,devices_config_name) -> WebDriver:
        """
        :param devices_config_name:设备配置名称
            作用:会根据传的name去配置文件里面找配置，连接appium启动应用
        :return: webdriver
        """
        return self.connect_appium(devices_config_name)

    def login_page(self, func_name: str, *args: str) -> None or str:
        """
        该函数是login page，login page所有操作可以通过该函数来完成
        :param func_name: 任意传入一个func_dict存在的键，可以通过键来调用对应函数
        :param args: 根据传的func_name 来给arge传参数，具体如下：
            get_im_version:
                作用: 获取im_demo版本号
                参数: 传入webdriver，返回测试的im_demo版本
            send_user_name:
                作用:
                    1.可以做输入用户名操作
                    2.可以做获取用户名输入框的属性操作
                参数:
                    1.传入webdriver和username是输入登陆用户名，返回None
                    2.传入webdriver返回用户名输入框的属性。
            send_password:
                作用:
                    1.可以做输入密码操作
                    2.可以做获取密码输入框的属性操作
                参数:
                    1.传入webdriver和password是输入登陆密码，返回None
                    1.传入webdriver返回密码输入框的属性。
            click_login_button:
                作用:
                    1.可以做点击登陆按钮操作
                    2.可以做获取登陆按钮属性操作
                参数:
                    1.传入webdriver和click是点击登陆按钮操作
                    2.传入webdriver和text是获取登陆按钮属性操作
            click_registered:
                作用:
                    1.可以做点击注册账号按钮操作
                    2.可以做获取注册属性操作
                参数:
                    1.传入webdriver和click是点击注册账号按钮操作
                    2.传入webdriver和text是获取注册属性操作
            click_config:
                作用:
                    1.可以做点击服务器配置按钮操作
                    2.可以做获取服务器配置按钮属性操作
                参数:
                    1.传入webdriver和click是点击服务器配置按钮操作
                    2.传入webdriver和text是获取服务器配置按钮属性操作
            android_login:
                作用: 组合登陆im_demo
                参数:需要传入参数如下
                    1. webdriver
                    2. 用户名
                    3. 密码

        :return:str or None
        """
        func_dict = {
            "get_im_version": self.android_get_im_version_method,
            "send_user_name":self.android_send_user_name_method,
            "send_password":self.android_send_password_method,
            "click_login_button":self.android_click_login_button_method,
            "click_registered":self.android_click_registered_method,
            "click_config":self.android_click_service_config_method,
            "android_login":self.android_login,
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"

    def user_registered_page(self):
        pass

    def service_config_page(self,func_name,*args):
        """
        该函数是连接服务器配置page 所有操作可以通过该函数来完成
        :param func_name: 任意传入一个func_dict存在的键，可以通过键来调用对应函数
        :param args: 根据传的func_name 来给arge传参数，具体如下：

            click_custom_service_switch:
                作用: 点击自定义服务器开关操作
                参数: 传WebDriver是做点击自定义服务器开关操作

            send_app_key:
                作用:
                    1.输入app_key操作
                    2.获取app_key输入框属性操作
                参数:
                    1.传WebDriver和app_key是做输入app_key操作
                    2.传WebDriver是做获取app_key输入框属性操作

            click_use_service_switch:
                作用: 是做点击specify server 开关操作
                参数: 传入WebDriver做点击specify server 开关操作

            send_im_service_host:
                作用:
                    1.输入im连接地址
                    2.获取im_server输入框属性操作
                参数:
                    1.传WebDriver和host是做输入host操作
                    2.传WebDriver是做获取im_server输入框属性操作

            send_port:
                作用:
                    1.输入端口操作
                    2.获取端口输入框属性操作
                参数:
                    1.传WebDriver和im_port是做输入im_port操作
                    2.传WebDriver是做获取im_port输入框属性操作



        :param func_name:
        :param args:
        :return:
        """

        func_dict = {
            "click_custom_service_switch": self.android_click_custom_service_switch_method,
            "send_app_key": self.android_send_appkey_method,
            "click_use_service_switch": self.android_click_use_service_switch_method,
            "send_im_service_host": self.android_send_im_service_host_method,
            "send_port": self.android_send_port_method,
            "send_rest_host": self.android_send_rest_host_method,
            "click_https_switch": self.android_click_https_switch_method,
            "reset_service_setupthe": self.android_reset_service_setupthe_method,
            "cancel_reset_service": self.android_cancel_reset_service_method,
            "confirm_reset_service": self.android_confirm_reset_service_method,
            "click_save_button": self.android_save_button_method,
            "service_config": self.android_service_config
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"



if __name__ == '__main__':
    a=Public()
    driver=a.connect_appium_method("vivo_01")
    # a.login_page("android_login",driver,"test1","1")
    b=Android_session_page()
    b.android_click_user_session(driver,"alone1")
    import time
    time.sleep(3)





