
# Docker ��ͷ��Զ�������

## Ŀ��

- ʹ��Docker�����������Ա��ڿͷ���Ŀ�Զ��������ڲ�ͬϵͳ��������ͬ�Ŷӡ���ͬ��Ŀ����ʵʩ��������Լ����У�ִ����Ϻ󽫲����ñ��淢�͸�ִ����Ա���Դﵽһ���������뼶���С����ٶ�λ�����ռ�Ŀ��


## Docker����

#### 1. ����ִ��docker���еĽű����ϴ���������docker������
#### 2. ���ݱ���ͷ�ϵͳ������Ϣ��vi �� vim �޸�docker_start_easemob_registry.sh�ű��еĲ��������磺

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/53a70200-0b62-43d2-9d9e-c9dd07746f97aW1hZ2UucG5n)
#### 3. ����ű���ִ��sh ./docker_start_easemob_registry.sh�����һ��ִ�нű����ῴ�����½�ͼ��

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/0da9a2e4-6fce-4384-8a8d-d145f291d9d5aW1hZ2UucG5n)
#### 4.������ɺ󣬻��Զ�ִ�в����������������½�ͼ��

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/85fb8f47-08e4-47d6-abe1-32be736ce0d6aW1hZ2UucG5n)

#### 5.��������ִ����Ϻ󣬻���ű������õ�EMAIL_RECEIVE�����ַ��һ����Ա����ʼ���Ϣ���������½�ͼ��
![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/c6e981e6-77e4-45a4-9eba-c4e3ab5538a7aW1hZ2UucG5n)

#### 6.����dockerִ�пͷ��Զ��������
![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/c6e981e6-77e4-45a4-9eba-c4e3ab5538a7aW1hZ2UucG5n)



### �ر�ע�⣺

- ##### ����˽�л�����֧��������ֻ�����������ԣ�����ܳ����ʼ����Ͳ��������Ϊ�˱���������������ڽű�����VOLUME_REPORT������
- ##### �ò������壺docker�������ϣ���docker_start_easemob_registry.sh �ű���ͬĿ¼�£����Զ������ļ��У����Ա����ͬ�������ļ����£������Լ��������Ա��档

![image](http://kefu.easemob.com/v1/Tenant/634/MediaFiles/530fe08a-a389-40b5-808b-887bde88858baW1hZ2UucG5n)



## �ű��������� 

- #### ִ��docker_start_easemob_registry.sh�ű��У��������壺


|��������|����ֵ|��������|����|����|
| ---- | --- | --- | --- | --- |
|EMAIL_RECEIVE|leoli@easemob.com,zhukai@easemob.com|���ղ��Ա���������˺ţ���������˺�ʹ�ö��Ÿ���|��|��|
|KEFUURL|http://sandbox.kefu.easemob.com|�ͷ���¼��ַ|Linux��Macϵͳ����Э�飬����//sandbox.kefu.easemob.com|��|
|USERNAME|lijipeng_1@qq.com|�ͷ��ɵ�¼����ϯ�����˺�|��|��|
|PASSWORD|llijipeng123|�ͷ���¼�˺ŵ�����|��|��|
|STATUS|Online|�ͷ���¼״̬|��|��|
|INCLUED_TAG|debugChat|ִ��������Tag��ǩ���ƣ������ǩʹ�ö��Ÿ���|����Ҫȫ��ִ�����������Բ���дֵ|��|
|EXCLUED_TAG|org,tool,ui,appui|��ִ��������Tag��ǩ����|����Ҫȫ��ִ�����������ĸ�ֵ��Ҫ��д��Ҫ�޸�|��|
|VOLUME_REPORT|autotest_report|��dockerִ�е��������Ϲ��ع��ڵ��ļ��У����ִ�в��������ı���|��|��|
|EMAIL_FILENAME|emailreport.html|���ղ��Ա���HTML�ļ����ƣ�����ʹ��Ӣ�ģ���ʱ��֧��html��ʽ|���Ҳ�����ʹ��report.html��log.html�����磺emailreport.html|��|
|MESSAGEGATEWAY|im|�ÿͽ��з���Ϣʱ��ѡȡ����Ϣ������Դ��im��ʹ��IM��rest�ӿڷ�����Ϣ��secondGateway��ʹ�ÿͷ��ĵڶ�ͨ���ӿڷ�����Ϣ|��|��|
|ORGNAME|sipsoft|ʹ���⻧�����еĹ�������Ϣ��orgNameΪ�����µ���֯����|��|��|
|APPNAME|sandbox|ʹ���⻧�����еĹ�������Ϣ��appNameΪ�����µ�Ӧ������|��|��|
|SERVICEEASEMOBIMNUMBER|117497|ʹ���⻧�����еĹ�������Ϣ��serviceEaseMobIMNumberΪ������IM�����|��|��|
|RESTDOMAIN|a1.esemob.com|ʹ���⻧�����еĹ�������Ϣ��restDomainΪappkey������Ⱥrest��ַ|��|��|

