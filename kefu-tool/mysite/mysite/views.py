"""
WSGI config for HelloDjango project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/1.10/howto/deployment/wsgi/
"""

from django.http import HttpResponse
import time
from django.http import HttpResponse
from django.http import HttpRequest
from django.shortcuts import render_to_response
from django.shortcuts import render
import settings
from django.conf import settings
from django.core.mail import EmailMultiAlternatives
import json


KEFU_CALLBACK_ALL = []
CALLBACK_ALL = []

def hello(request):
    return HttpResponse("Hello world ! ")

def love(request):
    return HttpResponse("<h1>YOU LOVE ME</h1>")

def kefu_callback(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        print data
        eventName = json.dumps(data['event'])
        timestamp = json.dumps(data['timestamp'])
        payload = json.dumps(data['payload'])
        dataNew = json.dumps(data)

        KEFU_CALLBACK_ALL.append({"teststep":[len(KEFU_CALLBACK_ALL)+1 ,eventName,payload,timestamp,dataNew, getFormatedTimeStr(time.time())]})
        return HttpResponse('ok', content_type='text/html')
    else:
        if len(KEFU_CALLBACK_ALL)==0:
            """
            KEFU_CALLBACK_ALL.append({"teststep":[0, {'topic':'test'}, 0,0,0, getFormatedTimeStr(time.time())]})
            """
        return render_to_response('teststeps.html',
        {'alldata':list(reversed(KEFU_CALLBACK_ALL))})

def callback(request):
    if request.method == 'POST':
        data = request.body
        print data
        CALLBACK_ALL.append({"teststep":data})
        return HttpResponse('ok', content_type='text/html')
    else:
        return HttpResponse(CALLBACK_ALL, content_type='text/html')

def hello(request):
    path = request.path
    host = request.get_host()
    full_path = request.get_full_path()
    ua = request.META['HTTP_USER_AGENT']
    print path
    return HttpResponse("response \n\tua:%s\n\thost:%s full_path:%s" %(ua,host,full_path))

    context = {}
    context['hello'] = 'Hello World!'
    return render(request, 'hello.html', context)

def index(request):
    return render(request,'ECShopH5.html')

def add(request):
    a = request.GET['a']
    b = request.GET['b']
    print(a,b)
    a = int(a)
    b = int(b)
    return HttpResponse(str(a+b))

def getFormatedTimeStr(itime):
    itime=int(float(itime))
    return time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(itime))

def sendMail(request):

    title = request.POST['title']
    body = request.POST['body']
    from_email = settings.DEFAULT_FROM_EMAIL
    msg = EmailMultiAlternatives(title, body, from_email, ['leoli@easemob.com'])
    msg.content_subtype = "html"
    msg.send()
    return HttpResponse('ok', content_type='text/html')

def visitorCallback(request):
    method = request.method
    print method

    callback = {'callName':'Leoli'}

    return HttpResponse(json.dumps(callback), content_type="application/json")

def webimplugin(request):
    return render(request,'send-extend-message.html')