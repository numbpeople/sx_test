import time
from android_bases_page.android_home_page import Android_login_page,Android_service_config,Android_registered_page
from android_bases_page.android_session_page import Android_session_page
from Bases_Public_method import Bases_Public_method

class Public(
    Android_login_page,
    Android_registered_page,
    Android_service_config
):

    def connect_appium_method(self,devices_config_name) -> None:
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
            1. a_get_im_version:
                作用: 获取im_demo版本号
                参数: 传入devices_name，返回测试的im_demo版本
            2. a_send_user_name:
                作用:
                    1.可以做输入用户名操作
                    2.可以做获取用户名输入框的属性操作
                参数:
                    1.传入devices_name和username是输入登陆用户名，返回None
                    2.传入devices_name返回用户名输入框的属性。
            3. a_send_password:
                作用:
                    1.可以做输入密码操作
                    2.可以做获取密码输入框的属性操作
                参数:
                    1.传入devices_name和password是输入登陆密码，返回None
                    1.传入devices_name返回密码输入框的属性。
            4. a_click_login_button:
                作用:
                    1.可以做点击登陆按钮操作
                    2.可以做获取登陆按钮属性操作
                参数:
                    1.传入devices_name和click是点击登陆按钮操作
                    2.传入devices_name和text是获取登陆按钮属性操作
            5. a_click_registered:
                作用:
                    1.可以做点击注册账号按钮操作
                    2.可以做获取注册属性操作
                参数:
                    1.传入devices_name和click是点击注册账号按钮操作
                    2.传入devices_name和text是获取注册属性操作
            6. a_click_config:
                作用:
                    1.可以做点击服务器配置按钮操作
                    2.可以做获取服务器配置按钮属性操作
                参数:
                    1.传入devices_name和click是点击服务器配置按钮操作
                    2.传入devices_name和text是获取服务器配置按钮属性操作
            7. a_android_login:
                作用: 组合登陆im_demo
                参数:需要传入参数如下
                    1. devices_name
                    2. 用户名
                    3. 密码

        :return:str or None
        """
        func_dict = {
            "a_get_im_version": self.android_get_im_version_method,
            "a_send_user_name":self.android_send_user_name_method,
            "a_send_password":self.android_send_password_method,
            "a_click_login_button":self.android_click_login_button_method,
            "a_click_registered":self.android_click_registered_method,
            "a_click_config":self.android_click_service_config_method,
            "a_android_login":self.android_login,
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)

        else:
            return f"没有该函数{func_name}"

    def user_registered_page(self,func_name: str, *args: str) -> None or str:
        """
        :作用 该函数是注册页面，注册页面所有操作可以通过该函数来完成
        :android元素:
            1.android_registered_user_name_element = ("xpath","//android.widget.EditText[1]") # 注册用户输入框元素
            2.android_registered_password_element = ("xpath","//android.widget.EditText[2]") # 密码元素
            3.android_registered_confirm_password_element = ("xpath","//android.widget.EditText[3]") # 确认密码元素
            4.android_registered_agreement_element = (
                                            "xpath",
                                            "//android.view.ViewGroup/android.widget.CheckBox") # 同意服务条款元素
            5.android_registered_button_element = ("xpath","//android.widget.Button") # 注册按钮元素
            6.android_registered_return_element = ("xpath", '//android.widget.ImageButton[@content-desc="转到上一层级"]')

        :param func_name: 任意传入一个func_dict存在的键，可以通过键来调用对应函数
        :param args: 根据传的func_name 来给arge传参数，具体如下：
            1. asend_registered_user:
                作用:
                    1.可以做获取注册用户名输入框的属性操作
                    2.可以做输入用户名操作
                参数:
                    1.传入devices_name,是获取注册用户名输入框的属性操作
                    2.传入devices_name 和 uusername，是做输入用户名操作
            2. send_registered_password:
                作用:
                    1.可以做获取密码输入框属性操作
                    2.可以做输入密码操作
                参数:
                    1.传入devices_name,是获取密码输入框属性操作
                    2.传入devices_name 和 password，是输入密码操作
            3. send_registered_confirm_password:
                作用:
                    1.可以做获取确认密码输入框属性操作
                    2.可以做输入确认密码操作
                参数:
                    1.传入devices_name,是获取确认密码输入框属性操作
                    2.传入devices_name 和 password，是输入确认密码操作
            4. click_agreement:
                作用:可以做点击同意服务条款
                参数:传入devices_name,是点击同意服务条款
            5. click_registered_button:
                作用:可以点击登陆按钮
                参数:传入devices_name,是点击登陆按钮
            6. click_return:
                作用:可以点返回
                参数:传入devices_name,是点击返回
            7. registered_user:
                作用:组合登陆
                参数:
                    1.devices_name
                    2.username
                    3.password
                    4.confirm_password
        :return:None or str
        """
        func_dict = {
            "send_registered_user": self.android_registered_user_send_method,
            "send_registered_password": self.android_registered_password_send_method,
            "send_registered_confirm_password": self.android_registered_confirm_password_send_method,
            "click_agreement": self.android_registered_click_agreement_method,
            "click_registered_button": self.android_click_registered_button_method,
            "click_return": self.android_registered_return_method,
            "registered_user": self.android_registered_method,
        }
        if func_dict.get(func_name):
            func = func_dict.get(func_name)
            return func(*args)
        else:
            return f"没有该函数{func_name}"

    def service_config_page(self,func_name,*args) -> str or None:
        """

        该函数是连接服务器配置page 所有操作可以通过该函数来完成
        :param func_name: 任意传入一个func_dict存在的键，可以通过键来调用对应函数
        :param args: 根据传的func_name 来给arge传参数，具体如下：

            1. click_custom_service_switch:
                作用: 点击自定义服务器开关操作
                参数: 传devices_name是做点击自定义服务器开关操作

            2. send_app_key:
                作用:
                    1.输入app_key操作
                    2.获取app_key输入框属性操作
                参数:
                    1.传devices_name和app_key是做输入app_key操作
                    2.传devices_name是做获取app_key输入框属性操作

            3. click_use_service_switch:
                作用: 是做点击specify server 开关操作
                参数: 传入devices_name做点击specify server 开关操作

            4. send_im_service_host:
                作用:
                    1.输入im连接地址
                    2.获取im_server输入框属性操作
                参数:
                    1.传devices_name和host是做输入host操作
                    2.传devices_name是做获取im_server输入框属性操作

            5. send_port:
                作用:
                    1.输入端口操作
                    2.获取端口输入框属性操作
                参数:
                    1.传devices_name和im_port是做输入im_port操作
                    2.传devices_name是做获取im_port输入框属性操作
            6. send_rest_host:
                作用:
                    1.输入rest服务器地址操作
                    2.获取rest服务器输入框属性
                参数:
                    1.传devices_name和rest_host是做输入rest_host操作
                    2.传devices_name是做获取rest_host输入框属性操作
            7. click_https_switch:
                作用:点击使用https开关
                参数:传devices_name是做点击使用https开关
            8.reset_service_setupthe:
                作用:点击重置服务器设置按钮
                参数:传devices_name是做点击重置服务器设置按钮
            9.cancel_reset_service:
                作用:点击取消重置配置按钮
                参数:传devices_name是做点击取消重置配置按钮
            10.confirm_reset_service:
                作用:点击确认重置配置按钮
                参数:传devices_name是做点击确认重置配置按钮
            11.click_save_button:
                作用:点击保存配置按钮
                参数:传devices_name是做点击保存配置按钮
            12.service_config:
                作用:配置连接服务器
                参数:
                    1.devices_name
                    2.env_name 传入hsb或者ebs
        :return: str or None
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
    driver=a.connect_appium_method("oppo_sj001_devices")
    print(Bases_Public_method().element_judge("oppo_sj001_devices","login_page_element","a_version_element"))







