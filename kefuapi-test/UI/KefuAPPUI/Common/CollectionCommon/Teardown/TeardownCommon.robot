*** Settings ***
Resource          ../../BaseCommon.robot
Resource          ../../../Variable.robot
Resource          ../../../../../commons/CollectionData/Base_Collection.robot
Library           requests
Library           AppiumLibrary
Library           RequestsLibrary
Library           Collections
Library           os
Library           String

*** Keywords ***
Teardown Data Base
    Teardown Data    #清除创建了的坐席、技能组、关联等信息
