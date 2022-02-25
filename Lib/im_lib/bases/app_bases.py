from os.path import join
import random
import time
from appium import webdriver
from appium.webdriver.webdriver import WebDriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as ES
from .bases import Data_bases
from config import logging


class Android_Appium_bases():

    data = Data_bases()
    driver:webdriver.Remote = {}
    def connect_appium(self, connetc_config_name) -> None:
        """
        :param connetc_config_name: 设备名称，根据传入的设备名称去config.yaml文件找对应的配置，启动手机
        :return: None
        """
        logging.info("连接appium,连接设备是:{}".format(connetc_config_name))
        cpas = self.data.get_connect_config(name=connetc_config_name)
        driver =webdriver.Remote(self.data.appium_server(), cpas)
        self.driver[connetc_config_name] = driver

    def judge_element(self, devices_name: str, element: str) -> True or False:
        """
        :作用 判断元素是否存在
        :param devices_name: 设备名称
        :param element:  元素
        :return: True or False
        """
        if str(self.my_element(devices_name,element)) == "None":
            return False
        else:
            return True


    def my_element(self, devices_name: str, element) :
        """
        :作用 定位器
        :param devices_name: 设备名称
        :param element: 传入一个元组定位元素，例如：("xpath","//XCUIElementTypeTextField")
        :return: 实例
        """
        logging.info(f"操作的设备:{devices_name},定位元素:{element}")
        try:
            return self.driver[devices_name].find_element(*element)

        except:
            pass

    def wait_find(self, devices_name: str, element):
        """
            :作用 显示等待
            :param devices_name: 设备名称
            :param element: 调用该函数时传入需要定位的元素，元组形式传入,例如：("xpath","//XCUIElementTypeTextField")
        """
        logging.info(f"操作的设备是:{devices_name},通过显示等待定位{element}")
        config_data = self.data.config()
        try:
            return WebDriverWait(self.driver[devices_name],config_data["positioning_out_time"],
                                 config_data["interva_time"]).until(ES.presence_of_element_located(element))
        except:

            id = random.randint(10000, 99999)
            logging.error(f"定位元素失败,定位的元素是：{element},图片id是：{id}")
            self.screenshots(devices_name=devices_name,
                             screenshots_name=str(id) + '-定位失败' + str(time.strftime("-%F-%H-%M-%S") + ".png"))
            raise

    def screenshots(self, devices_name: str, screenshots_name=str(time.strftime("%F-%H-%M-%S")) + ".png") ->None :
        """
        :作用 截图
        :param devices_name: 设备名称
        :param screenshots_name: 截图保存名称,默认当前时间：2022-01-23-22-02-47.png,如果使用自定义名称传入name 例如：test.png
        """
        logging.info(f"操作设备:{devices_name},截图:{screenshots_name}")
        self.driver[devices_name].save_screenshot(join(self.data.config()["error_screenshots_path"], screenshots_name))

    def is_enabled(self, devices_name: str, element) -> True or False:
        """
        :作用 判断该元素是否可用
        :param devices_name: 设备名称
        :param element:传入一个元组定位元素,判断该元素是否可用，例如：("xpath","//XCUIElementTypeTextField")
        :return True or Flase
        """
        logging.info(f"操作设备:{devices_name},判断改元素是否可用:{element}")
        print('erer',self.driver[devices_name].page_source)
        return self.my_element(devices_name=devices_name, element=element)

    def is_selected(self, devices_name: str, element) -> True or False:
        """
        :作用 判断该元素是否被选中
        :param devices_name: 设备名称
        :param element:传入一个元组定位元素,判断该元素是否被选中，例如：("xpath","//XCUIElementTypeTextField")
        :return True or Flase
        """
        logging.info(f"操作设备:{devices_name},判断改元素是否被选中:{element}")
        return self.my_element(devices_name=devices_name, element=element).is_selected()

    def is_displayed(self, devices_name: str, element) -> True or False:
        """
        :作用 判断该元素是否显示
        :param devices_name: 设备名称
        :param element:传入一个元组定位元素,判断该元素是否显示，例如：("xpath","//XCUIElementTypeTextField")
        :return True or Flase
        """
        logging.info(f"操作设备:{devices_name},判断改元素是否被选中:{element}")
        return self.my_element(devices_name=devices_name, element=element).is_displayed()

    def return_method(self, devices_name: str) -> None:
        """

        :param devices_name: 设备名称
        :return: None
        """
        logging.info(f"操作设备:{devices_name},返回")
        self.driver[devices_name].back()

    def tap(self, devices_name:str, positions: list, duration: int = None) -> None:
        """
        :作用 触摸
        :param devices_name: 设备名称
        :param positions: 传入一个[(x,y)],z最多五个元祖
        :param duration: 单位是毫秒，不传轻触
        :return:None
        """
        logging.info(f"操作设备:{devices_name},触摸位置x/y:{positions},长按条件:{duration}")
        self.driver[devices_name].tap(positions, duration)

    def send_keys(self,devices_name,text,element) -> None:
        """
        :param devices_name: 设备名称
        :param text: 输入的文本
        :param element: 元素
        :return:None
        """
        logging.info(f"操作设备:{devices_name},向:{element}元素输入:{text}")
        el = self.wait_find(devices_name,element)
        el.click()
        el.clear()
        el.send_keys(text)
        self.tap(devices_name,[(322, 134)])

    def get_text(self,devices_name,element) -> str:
        """
        :param devices_name: 设备名称
        :return: str
        """
        logging.info(f"操作设备:{devices_name},获取:{element}元素文本")
        return self.wait_find(devices_name, element).text

    def quit(self,devices_name) -> None:
        """
        :作用 结束并退出
        :param devices_name: 设备名称
        :return: None
        """
        self.driver[devices_name].quit()
        del self.driver[devices_name]


class IosAppiumBase(Android_Appium_bases):
    def click_method(self, driver: WebDriver, method_type, xpath_selector) -> str or None:
        """根据method_type区分是点击事件还是获取文本信息"""
        element = self.wait_find(driver, xpath_selector)
        if method_type == "click":
            element.click()
        elif method_type == "text":
            return self.text
        else:
            return f"不支持该事件${method_type}"

    def find_element(self, driver: WebDriver, element):
        try:
            return driver.find_element(*element)
        except:
            print("没找到该元素")
