FROM python:2.7.15

MAINTAINER "leoli" <leoli@easemob.com>

LABEL name="Docker image for KEFU-AUTOTEST Robot Framework https://github.com/easemob/kefu-auto-test"

#=========================================
# Install robotframework and library.
#=========================================

ADD kefuapi-test kefuapi-test

RUN pip install -U pandas==0.22.0 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install -U robotframework===3.0.2
RUN pip install -U requests==2.18.4
RUN pip install -U robotframework-requests==0.4.5
RUN pip install -U robotframework-excellibrary==0.0.2

ENTRYPOINT ["robot"]