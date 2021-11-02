*** Settings ***
Resource          ../BaseResullt.robot

*** Variables ***
${GetUserAttributeCapacity}    {"timestamp":1635503625053,"data":501,"duration":48}
${GetUserAttributeCapacityDiffEntity}    {"data":%s}
&{GetUserAttributeCapacityDictionary}    statusCode=200    reponseResult=${GetUserAttributeCapacity}

${GetUserAttribute}    {"timestamp":1635503625053,"data":501,"duration":48}
${GetUserAttributeDiffEntity}    {"data":%s}
&{GetUserAttributeDictionary}    statusCode=200    reponseResult=${GetUserAttribute}

${AddUserAttribute}    {"timestamp":1635507412848,"data":{"%s":"%s"},"duration":93}
${AddUserAttributeDiffEntity}    {"data":{"%s":"%s"}}
&{AddUserAttributeDictionary}    statusCode=200    reponseResult=${AddUserAttribute}

${DeleteUserAttribute}    {"timestamp":1635503625053,"data":{},"duration":48}
${DeleteUserAttributeDiffEntity}    {"data":%s}
&{DeleteUserAttributeDictionary}    statusCode=200    reponseResult=${DeleteUserAttribute}

${GetMoreEmptyUserAttribute}    {"timestamp":1635770515189,"data":{"%s":{},"%s":{},"%s":{}},"duration":14}
${GetMoreEmptyUserAttributeDiffEntity}    {"data":{"%s":{},"%s":{},"%s":{}}}
&{GetMoreEmptyUserAttributeDictionary}    statusCode=200    reponseResult=${GetMoreEmptyUserAttribute}

${GetMoreUserAttribute}    {"timestamp":1635773354764,"data":{"%s":{"%s":"%s"},"%s":{},"%s":{}},"duration":30}
${GetMoreUserAttributeDiffEntity}    {"data":{"%s":{"%s":"%s"},"%s":{},"%s":{}}}
&{GetMoreUserAttributeDictionary}    statusCode=200    reponseResult=${GetMoreUserAttribute}

${NoneToken}    
${NoneTokenDiffEntity}    
&{NoneTokenDictionary}    statusCode=400    reponseResult=${NoneToken}

${NoneContentType}    
${NoneContentTypeDiffEntity}    
&{NoneContentTypeDictionary}    statusCode=415    reponseResult=${NoneContentType}

${UnsupportedMediaType}
${UnsupportedMediaTypeDiffEntity}
&{UnsupportedMediaTypeDictionary}    statusCode=415    reponseResult=${UnsupportedMediaType}

${ErrorToken}    {"timestamp":1635827114291,"desc":"unauthorized","duration":0}
${ErrorTokenDiffEntity}    {"desc":"Unauthorized"}
${ErrorTokenDiffEntity1}    {"desc":"unauthorized"}
&{ErrorTokeneDictionary}    statusCode=401    reponseResult=${ErrorToken}