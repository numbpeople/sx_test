*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${AppExist}       {"error":"application_already_exists","timestamp":1552902733543,"duration":0,"error_description":"Application test already exists"}
${AppExistDiffEntity}    {"error":"application_already_exists","error_description":"Application %s already exists"}
${AppNew}         {"action":"new application for organization","entities":[{"uuid":"93de30c0-5a70-11e9-8143-b911e2a18df4","type":"application","name":"1104190221201050/6624330241","created":1554777517567,"modified":1554777517567,"organizationName":"1104190221201050","applicationName":"6624330241","allow_open_registration":true,"allow_app_force_notification":false,"registration_requires_email_confirmation":false,"registration_requires_admin_approval":false,"notify_admin_of_new_users":false,"app_status":"online","app_status_update_timestamp":1554777517475,"appDesc":"6624330241","productName":"6624330241"}],"data":{"%s/%s":"93de30c0-5a70-11e9-8143-b911e2a18df4"},"timestamp":1554777517475,"duration":191}
${AppNewDiffEntity}	    {"action":"new application for organization","entities":[{"type":"application","name":"%s/%s","organizationName":"%s","applicationName":"%s","allow_open_registration":true,"allow_app_force_notification":false,"registration_requires_email_confirmation":false,"registration_requires_admin_approval":false,"notify_admin_of_new_users":false,"app_status":"online","appDesc":"%s","productName":"%s"}]}
${GetAppList}     {"action":"get organization application list","params":{"page_num":["1"],"page_size":["5"]},"data":{},"timestamp":1554794315120,"duration":26,"count":5,"_total":7}
${GetAppListDiffEntity}    ${EMPTY}
${GetSpecificApp}    {"action":"get","application":"e2a6bac0-4d54-11e9-b80b-4b5efbf305f3","entities":[{"uuid":"e2a6bac0-4d54-11e9-b80b-4b5efbf305f3","type":"application","name":"ljp/8269772251","created":1553336258674,"modified":1553336258674,"organizationName":"ljp","applicationName":"8269772251","allow_open_registration":true,"allow_app_force_notification":false,"registration_requires_email_confirmation":false,"registration_requires_admin_approval":false,"notify_admin_of_new_users":false,"app_status":"online","app_status_update_timestamp":1553336258663,"appDesc":"8269772251","productName":"8269772251"}],"timestamp":1554865248316,"duration":7,"organization":"ljp","applicationName":"8269772251"}
${GetSpecificAppDiffEntity}    {"action":"get","application":"%s","entities":[{"uuid":"%s","type":"application","name":"%s","organizationName":"%s","applicationName":"%s","allow_open_registration":true,"allow_app_force_notification":false,"registration_requires_email_confirmation":false,"registration_requires_admin_approval":false,"notify_admin_of_new_users":false,"app_status":"online","appDesc":"%s","productName":"%s"}],"organization":"%s","applicationName":"%s"}
${AppNotFound}    {"error":"organization_application_not_found","timestamp":1570614968011,"duration":1,"error_description":"Could not find application for easemob-demo/invalidApp8756409771 from URI: management/organizations/easemob-demo/applications/invalidApp8756409771"}
${AppNotFoundDiffEntity}    {"error":"organization_application_not_found","error_description":"Could not find application for %s/%s from URI: management/organizations/%s/applications/%s"}
&{AppExistDictionary}    statusCode=400    reponseResult=${AppExist}
&{AppNewDictionary}    statusCode=200    reponseResult=${AppNew}
&{GetAppListDictionary}    statusCode=200    reponseResult=${GetAppList}
&{GetSpecificAppDictionary}    statusCode=200    reponseResult=${GetSpecificApp}
&{AppNotFoundDictionary}    statusCode=404    reponseResult=${AppNotFound}
