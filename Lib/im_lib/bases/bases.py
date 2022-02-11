import os
import yaml
from os.path import dirname,abspath
class Data_bases():

    def config(self):
        """获取配置全部数据"""
        file_path = os.path.join(abspath(dirname(abspath(dirname(__file__)))), "config.yaml")
        with open(file_path, encoding="utf-8") as f:
            data = yaml.safe_load(f)
            return data

    def appium_server(self):
        """获取appium服务地址"""
        return self.config()["appium_server"]

    def get_connect_config(self,name):
        """根据传入的名称去配置文件的connect_config下找连接配置"""
        return self.config()["connect_config"][name]

    def get_service_config(self,name):
        """获取im服务器配置"""
        return self.config()["im_service_configs"][name]

    def get_im_demo_version(self):
        """获取yaml文件的im_demo号"""
        return self.config()["test_im_version"]

if __name__ == '__main__':
    print()
