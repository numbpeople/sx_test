FROM python:2.7.15

MAINTAINER "leoli" <leoli@easemob.com>

LABEL name="Docker image for KEFU-AUTOTEST Robot Framework https://github.com/easemob/kefu-auto-test"

#=========================================
# 添加客服自动化项目到容器中
#=========================================
ADD kefuapi-test kefuapi-test

#=========================================
# 同步容器中的时区与宿主机一致
#=========================================
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& echo 'Asia/Shanghai' >/etc/timezone

#=========================================
# 安装 robotframework、依赖第三方库
#=========================================

RUN pip install -U pandas==0.22.0 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install -U robotframework===3.0.2
RUN pip install -U requests==2.18.4
RUN pip install -U robotframework-requests==0.4.5
RUN pip install -U robotframework-excellibrary==0.0.2
RUN pip install -U beautifulsoup4==4.4.1

ENTRYPOINT ["robot"]