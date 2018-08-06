FROM alpine:latest

MAINTAINER "leoli" <leoli@easemob.com>

LABEL name="Docker image for KEFU-AUTOTEST Robot Framework https://github.com/easemob/kefu-auto-test"
LABEL usage=""

# Install Python Pip Robot framework , other library
RUN apk add bash py-pip && \
    pip install --upgrade pip && \
    pip install robotframework==3.0.2 && \
    pip install robotframework-requests==0.4.5 && \
    pip install requests==2.18.4 && \
    pip install robotframework-excellibrary==0.0.2 && \
    python --version

ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]