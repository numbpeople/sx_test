#!/bin/bash

curdir=`cd $(dirname $0) && pwd`

#该处设置测试报告接收的邮件地址，例如：EMAIL_RECEIVE=leoli@easemob.com
EMAIL_RECEIVE=

pybot --listener $curdir/lib/MyListener.py:$EMAIL_RECEIVE --include debugChat --exclude tool --exclude ui --exclude appui --exclude org $curdir
