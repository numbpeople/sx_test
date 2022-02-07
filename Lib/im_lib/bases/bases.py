import os
import yaml

class Data_bases():

    def config(self,path):
        """获取配置全部数据"""
        file_path = os.path.join(path, "config.yaml")
        with open(file_path, encoding="utf-8") as f:
            data = yaml.safe_load(f)
            return data

    def appium_server(self,path):
        """获取appium服务地址"""
        return self.config(path)["appium_server"]

    def get_connect_config(self,name,path):
        """根据传入的名称去配置文件的connect_config下找连接配置"""
        return self.config(path)["connect_config"][name]

