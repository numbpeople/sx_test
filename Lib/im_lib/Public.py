
from android_bases_page.android_home_page import Android_login_page




class Public(Android_login_page):


    def connect_appium_method(self,devices_config_name):
        return self.connect_appium(devices_config_name)

    def login_page(self,func_name,*args):
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


if __name__ == '__main__':
    a=Public()
    driver=a.connect_appium_method("oppo_sj001_devices")
    a.login_page("android_login",driver,"test1","1","V3.8.9.1")





