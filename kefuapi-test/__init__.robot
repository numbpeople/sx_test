*** Settings ***
Suite Setup       Run Keywords    Setup Init Data
...               AND    log    kefuapi测试用机 执行开始
Force Tags        base
Library           json
Library           requests
Library           Collections
Library           RequestsLibrary
Library           String
Library           calendar
Library           uuid
Resource          commons/CollectionData/Base_Collection.robot
