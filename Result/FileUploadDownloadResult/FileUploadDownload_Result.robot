*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${UploadMediaFile}    {"action":"post","application":"99f49ef0-7162-11e9-ae0b-11c720ce67e4","path":"/chatfiles","uri":"http://a1-hsb.easemob.com/1104190221201050/imautotest-8173933711/chatfiles","entities":[{"uuid":"9b0328c0-7162-11e9-bdc7-3967ef13048b","type":"chatfile"}],"timestamp":1557300393304,"duration":0,"organization":"1104190221201050","applicationName":"imautotest-8173933711"}
${UploadMediaFileDiffEntity}    {"action":"post","application":"%s","path":"/chatfiles","entities":[{"type":"chatfile"}],"organization":"%s","applicationName":"%s"}
${UploadMediaUnAuthenticate}    {"error":"unauthorized","exception":"EasemobSecurityException","timestamp":1557376513883,"duration":0,"error_description":"Unable to authenticate (OAuth)"}
${UploadMediaUnAuthenticateDiffEntity}    {"error":"unauthorized","exception":"EasemobSecurityException","error_description":"Unable to authenticate (OAuth)"}
${DownloadMediaFile}    ${EMPTY}
${DownloadMediaFileDiffEntity}    ${EMPTY}
&{UploadMediaFileDictionary}    statusCode=200    reponseResult=${UploadMediaFile}
&{UploadMediaUnAuthenticateDictionary}    statusCode=200    reponseResult=${UploadMediaUnAuthenticate}
&{DownloadMediaFileDictionary}    statusCode=200    reponseResult=${DownloadMediaFile}
