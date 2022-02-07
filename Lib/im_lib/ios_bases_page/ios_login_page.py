# # 登陆页面
# import logging
#
# from bases.app_bases import Android_Appium_bases
#
# class Ios_login_page(Android_Appium_bases):
#
#     ios_version_element = ("xpath","//XCUIElementTypeStaticText")
#     ios_user_name_element = ("xpath","//XCUIElementTypeTextField")
#     ios_password_element = ("xpath","//XCUIElementTypeSecureTextField")
#     ios_login_button_element = ("xpath","//XCUIElementTypeStaticText[@name='登 录']")
#     ios_registered_element = ("xpath","//XCUIElementTypeButton[@name='注册账号']")
#     ios_service_config_element = ("xpath","//XCUIElementTypeButton[@name='服务器配置']")
#
#     def ios_get_ios_version_method(self,max_time=10, interva_time=1):
#         """:return IM首页版本号"""
#         logging.debug("获取版本号")
#         return self.wait_find(self.ios_version_element,max_time=max_time,interva_time=interva_time).text
#
#     def ios_send_keys_user_name_method(self,date,max_time=10, interva_time=1):
#         """
#         :param date: 要登陆的用户名，例如：test1
#         :param max_time: 最大重试定位时间，单位秒
#         :param max_time: 重试定位时间间隔，单位秒
#         :return None
#         """
#         logging.debug(f"输入用户名，用户名是:{date}")
#         self.wait_find(self.ios_user_name_element,max_time=max_time,interva_time=interva_time).send_keys(date)
