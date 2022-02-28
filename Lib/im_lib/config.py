import os
import logging
from os.path import dirname,abspath,join

basedir = os.path.join(abspath(dirname(__file__)))
print(basedir)

logging.basicConfig(level=logging.INFO ,
                    format="[%(asctime)s] %(levelname)s [%(filename)s:%(lineno)d] %(funcName)s: %(message)s",
                    datefmt="%Y/%m/%d %H:%M:%S",
                    handlers=[
                        logging.StreamHandler(),#将日志输出到终端
                        logging.FileHandler(join(basedir,'logs','log.txt'),encoding='utf-8')
                    ])



