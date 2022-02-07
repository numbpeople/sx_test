from os.path import join
import random
import time
from appium import webdriver
from appium.webdriver.webdriver import WebDriver
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as ES
from .bases import Data_bases
import logging
from os.path import dirname,abspath


class Android_Appium_bases():

    data =  Data_bases()


    def connect_appium(self,connetc_config_name,path=None):
        logging.debug("连接appium")
        if not path:
            self.config_path= abspath(dirname(abspath(dirname(__file__))))
        else:
            self.config_path=path
        cpas = self.data.get_connect_config(path=self.config_path,name=connetc_config_name)

        return webdriver.Remote(self.data.appium_server(self.config_path),cpas)



    def my_element(self, driver: WebDriver, element):
        """
        :user 定位器
        :param element: 传入一个元组定位元素，例如：("xpath","//XCUIElementTypeTextField")
        :return: 实例
        """
        logging.debug(f"定位元素:{element}")
        try:
            return driver.find_element(*element)
        except:
            pass

    def wait_find(self,driver: WebDriver, element):
        """
            :param driver:
            :user 显示等待
            :param element: 调用该函数时传入需要定位的元素，元组形式传入,例如：("xpath","//XCUIElementTypeTextField")
            :param max_time: 调用该函数时传入需要循环定位的最大时间,默认是10s,int类型
            :param interva_time: 调用该函数时传入循环定位的间隔时间，默认1s循环一次，int类型
        """
        logging.info(f"通过显示等待定位{element}")
        config_data = self.data.config(self.config_path)
        try:
            return WebDriverWait(driver,
                                 config_data["positioning_out_time"],
                                 config_data["interva_time"]
                                 ).until(ES.presence_of_element_located(element))


        except:
            pass
            id = random.randint(10000, 99999)
            logging.error(f"定位元素失败,定位的元素是：{element},图片id是：{id}")
            self.screenshots(driver=driver,screenshots_name=str(id)+'-定位失败'+str(time.strftime("-%F-%H-%M-%S")+".png"))
            raise

    def screenshots(self, driver: webdriver, screenshots_name=str(time.strftime("%F-%H-%M-%S")) + ".png"):
        """
        :param screenshots_name: 截图保存名称,默认当前时间：2022-01-23-22-02-47.png,如果使用自定义名称传入name 例如：test.png
        """
        driver.save_screenshot(join(self.data.config(self.config_path)["error_screenshots_path"],screenshots_name))

    def is_enabled(self, driver: webdriver, element):
        """
        :param element:传入一个元组定位元素,判断该元素是否可用，例如：("xpath","//XCUIElementTypeTextField")
        :return True or Flase
        """
        logging.debug(f"判断改元素是否可用:{element}")
        return self.my_element(driver=driver,element=element).is_enabled()

    def is_selected(self, driver: webdriver.Remote, element):
        """
        :param element:传入一个元组定位元素,判断该元素是否被选中，例如：("xpath","//XCUIElementTypeTextField")
        :return True or Flase
        """
        logging.debug(f"判断改元素是否被选中:{element}")
        return self.my_element(driver=driver,element=element).is_selected()

    def is_displayed(self, driver: webdriver.Remote, element):
        """
        :param element:传入一个元组定位元素,判断该元素是否显示，例如：("xpath","//XCUIElementTypeTextField")
        :return True or Flase
        """
        logging.debug(f"判断改元素是否被选中:{element}")
        return self.my_element(driver=driver,element=element).is_displayed()


class Ios_appium_base():
    pass