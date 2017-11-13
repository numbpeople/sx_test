*** Variables ***
${AgentStatusDistJson}    {"status":"OK","entities":[{"offline":27,"hidden":0,"leave":0,"busy":0,"online":1}],"totalElements":1}
&{AgentStatusDistEntities}    offline=    hidden=    leave=    busy=    online=
${AgentLoadJson}    {"status":"OK","entity":{"processingSessionCount":0,"tenantId":11927,"totalMaxServiceSessionCount":2}}
&{AgentLoadEntities}    processingSessionCount    totalMaxServiceSessionCount
${WaitCountJson}    {"status":"OK","entities":[{"max":0,"value":[{"1510198620000":0},{"1510198680000":0},{"1510198740000":0},{"1510198800000":0},{"1510198860000":0},{"1510198920000":0},{"1510198980000":0},{"1510199040000":0},{"1510199100000":0},{"1510199160000":0},{"1510199220000":0},{"1510199280000":0},{"1510199340000":0},{"1510199400000":0},{"1510199460000":0},{"1510199520000":0},{"1510199580000":0},{"1510199640000":0},{"1510199700000":0},{"1510199760000":0},{"1510199820000":0},{"1510199880000":0},{"1510199940000":0},{"1510200000000":0},{"1510200060000":0},{"1510200120000":0},{"1510200180000":0},{"1510200240000":0},{"1510200300000":0},{"1510200360000":0}],"key":"wait"}],"totalElements":1}
&{WaitCountEntities}    max    current
${SessionTotalJson}    {"status":"OK","entities":[{"cnt_csc":0.0,"se_1":0,"cnt_sc":0.0,"se_0":0,"key":"total"}],"totalElements":1}
&{SessionTotalEntities}
